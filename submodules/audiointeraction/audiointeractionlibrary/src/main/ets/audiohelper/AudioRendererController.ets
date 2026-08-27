/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { common } from '@kit.AbilityKit';
import { audio } from '@kit.AudioKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo } from '@kit.CoreFileKit';
import { resourceManager } from '@kit.LocalizationKit';
import { KeyConstants } from '../common/constants/KeyConstants';
import Logger from '../common/utils/Logger';
import { PreferencesUtil } from '../common/utils/PreferencesUtil';
import { MusicPlayMode, Options, SECOND_BUFFER_WALK, SILENT_ID } from '../songdatacontroller/PlayerData';
import { SongItem } from '../songdatacontroller/SongData';
import SongItemBuilder from '../songdatacontroller/SongItemBuilder';
import { AVSessionController } from './AVSessionController';
import { BackgroundTaskTool } from './BackgroundTaskTool';
import { MediaTools } from './MediaTools';

const TAG: string = '[AudioRendererController]';

export class AudioRendererController {
  public audioRenderer?: audio.AudioRenderer;
  private context: common.UIAbilityContext | undefined = AppStorage.get(KeyConstants.KEY_ABILITY_CONTEXT);
  private songItemBuilder: SongItemBuilder = new SongItemBuilder();
  private playMode: MusicPlayMode = MusicPlayMode.ORDER;
  private isFirst: boolean = true;
  private musicIndex: number = 0;
  private songList: SongItem[] = [];
  private initOffset: number = 0;
  private currentOffset: number = 0;
  private bufferRead: number = 0;
  private bufferNeedRead: number = 0;
  private songRawFileDescriptor: resourceManager.RawFileDescriptor | undefined = undefined;
  private curMs: number = 0;
  private avSessionController: AVSessionController | undefined = undefined;

  constructor() {
    const list: SongItem[] | undefined = AppStorage.get(KeyConstants.KEY_SONG_LIST);
    if (list) {
      this.songList = list;
    }
    this.songItemBuilder = new SongItemBuilder();
    this.initAudioRenderer();
  }

  public static getInstance(): AudioRendererController {
    let audioRendererController: AudioRendererController | undefined =
      AppStorage.get(KeyConstants.KEY_AUDIO_RENDER_CONTROLLER);
    if (!audioRendererController) {
      audioRendererController = new AudioRendererController();
      AppStorage.setOrCreate<AudioRendererController>(KeyConstants.KEY_AUDIO_RENDER_CONTROLLER,
        audioRendererController);
    }
    return audioRendererController;
  }

  public async setSilentModeAndMixWithOthers(isSupportSilent: boolean = false) {
    if (!this.audioRenderer || !this.context) {
      return;
    }
    const audioManger = audio.getAudioManager();
    const audioSessionManager: audio.AudioSessionManager = audioManger.getSessionManager();
    const strategy: audio.AudioSessionStrategy = {
      concurrencyMode: audio.AudioConcurrencyMode.CONCURRENCY_PAUSE_OTHERS
    };
    try {
      const formIds: string[] = await PreferencesUtil.getInstance().getFormIds(this.context);
      if (isSupportSilent) {
        if (!formIds.includes(SILENT_ID)) {
          await PreferencesUtil.getInstance().addFormId(this.context, SILENT_ID);
        }
        this.audioRenderer.setSilentModeAndMixWithOthers(isSupportSilent);
        // After using AudioSession, the system sends INTERRUPT_INT-REUME to the previously interrupted audio stream.
        audioSessionManager.deactivateAudioSession().then(() => {
          Logger.info(TAG, 'deactivateAudioSession SUCCESS');
        }).catch((err: BusinessError) => {
          Logger.error(TAG, `ERROR. code: ${err.code}, message: ${err.message}`);
        });
      } else {
        // AudioSession needs to be activated first, and then unmute.
        audioSessionManager.activateAudioSession(strategy).then(() => {
          Logger.info(TAG, 'activateAudioSession SUCCESS');
        }).catch((err: BusinessError) => {
          Logger.error(TAG, `ERROR. code: ${err.code}, message: ${err.message}`);
        });
        if (formIds.includes(SILENT_ID)) {
          await PreferencesUtil.getInstance().removeFormId(this.context, SILENT_ID);
        }
        this.audioRenderer.setSilentModeAndMixWithOthers(isSupportSilent);
      }
      AppStorage.setOrCreate(KeyConstants.KEY_IS_SILENT_MODE, isSupportSilent);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG,
        `setSilentModeAndMixWithOthers failed: cause the code ${err.code}, the message is ${err.message}`);
    }
  }

  /**
   * Play music by index.
   *
   * @param musicIndex
   */
  async play(musicIndex: number = this.musicIndex) {
    if (!this.audioRenderer) {
      return;
    }
    if (musicIndex >= this.songList.length) {
      Logger.error(TAG, `current musicIndex ${musicIndex}`);
      return;
    }
    BackgroundTaskTool.startContinuousTask(this.context);
    try {
      await this.updateMusicIndex(musicIndex);
      if (this.isFirst) {
        this.isFirst = false;
        await this.loadSongAssent();
        await this.stop();
        await this.start();
      } else {
        await this.stop();
        this.updateIsPlay(false);
        await this.reset();
      }
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG,
        `audioRenderer on audioInterrupt failed: cause the code ${err.code}, the message is ${err.message}`);
    }
  }

  /**
   * Get whether the music is played for the first.
   *
   * @returns isFirst
   */
  public getFirst() {
    return this.isFirst;
  }

  /**
   * Set music play mode.
   *
   * @param playMode
   */
  public setPlayModel(playMode: MusicPlayMode) {
    this.playMode = playMode;
    if (!this.avSessionController) {
      return;
    }
    this.avSessionController.setPlayModeToAVSession();
    Logger.info(TAG, 'setPlayModel mode: ' + this.playMode);
  }

  /**
   * Get music play mode.
   *
   * @returns playMode.
   */
  public getPlayMode(): MusicPlayMode {
    return this.playMode;
  }

  /**
   * start music.
   */
  public async start() {
    if (this.audioRenderer) {
      try {
        await this.audioRenderer.start().catch((err: BusinessError) => {
          Logger.error(TAG, `start failed,code is ${err.code},message is ${err.message}}`);
        })
        this.updateIsPlay(true);
        BackgroundTaskTool.startContinuousTask(this.context);
        Logger.info(TAG, 'start success');
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        Logger.error(TAG, `start failed: cause the code ${err.code}, the message is ${err.message}`);
      }
    }
  }

  /**
   * Pause music.
   */
  public async pause() {
    if (this.audioRenderer) {
      try {
        await this.audioRenderer.pause().catch((err: BusinessError) => {
          Logger.error(TAG, `pause failed,code is ${err.code},message is ${err.message}}`);
        })
        this.updateIsPlay(false);
        Logger.info(TAG, 'pause success');
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        Logger.error(TAG, `pause failed: cause the code ${err.code}, the message is ${err.message}`);
      }
    }
  }

  /**
   * Seek play music.
   *
   * @param ms.
   */
  public seek(ms: number) {
    this.curMs = ms;
    AppStorage.setOrCreate(KeyConstants.KEY_PROGRESS, this.curMs);
    AppStorage.setOrCreate(KeyConstants.KEY_CURRENT_TIME, MediaTools.msToCountdownTime(this.curMs));
    if (!this.avSessionController) {
      return;
    }
    this.avSessionController.setProgressState(ms);
    this.currentOffset = this.initOffset + MediaTools.getOffsetFromTime(this.curMs);
  }

  public async playNext() {
    Logger.info(TAG, 'playNext Index:' + this.musicIndex + ', length-1:' + (this.songList.length - 1));
    if (!this.audioRenderer) {
      Logger.error(TAG, 'audioRenderer is undefined');
      return;
    }
    await this.stop();
    if (this.playMode === MusicPlayMode.SINGLE_CYCLE) {
      this.isFirst = false;
    } else {
      this.isFirst = true;
    }
    switch (this.playMode) {
      case MusicPlayMode.SINGLE_CYCLE:
        this.play(this.musicIndex);
        break;
      case MusicPlayMode.ORDER:
        if (this.musicIndex === this.songList.length - 1) {
          this.musicIndex = 0;
        } else {
          this.musicIndex += 1;
        }
        this.play(this.musicIndex);
        break;
      case MusicPlayMode.RANDOM:
        this.playRandom();
        break;
      default:
        break;
    }
  }

  /**
   * Play previous music.
   */
  public async playPrevious() {
    Logger.info(TAG, 'playPrevious Index:' + this.musicIndex + ', length-1:' + (this.songList.length - 1));
    if (!this.audioRenderer) {
      Logger.error(TAG, 'audioRenderer is undefined');
      return;
    }
    await this.stop();
    if (this.playMode === MusicPlayMode.SINGLE_CYCLE) {
      this.isFirst = false;
    } else {
      this.isFirst = true;
    }
    switch (this.playMode) {
      case MusicPlayMode.SINGLE_CYCLE:
        this.play(this.musicIndex);
        break;
      case MusicPlayMode.ORDER:
        if (this.musicIndex === 0) {
          this.musicIndex = this.songList.length - 1;
        } else {
          this.musicIndex -= 1;
        }
        this.play(this.musicIndex);
        break;
      case MusicPlayMode.RANDOM:
        this.playRandom();
        break;
      default:
        break;
    }
  }

  /**
   * Stop music
   */
  public async stop() {
    if (this.audioRenderer) {
      try {
        await this.audioRenderer.stop().catch((err: BusinessError) => {
          Logger.error(TAG, `stop failed,code is ${err.code},message is ${err.message}}`);
        })
        this.curMs = 0;
        this.updateIsPlay(false);
        this.audioRenderer.flush();
        AppStorage.setOrCreate(KeyConstants.KEY_CURRENT_TIME, '00:00');
        AppStorage.setOrCreate(KeyConstants.KEY_PROGRESS, 0);
        Logger.info(TAG, 'stop success');
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        Logger.error(TAG, `stop failed: cause the code ${err.code}, the message is ${err.message}`);
      }
    }
  }

  /**
   * release audioRenderer
   */
  public async release() {
    if (this.audioRenderer && this.context) {
      try {
        await this.audioRenderer.release().catch((err: BusinessError) => {
          Logger.error(TAG, `release failed,code is ${err.code},message is ${err.message}}`);
        })
        this.avSessionController?.unregisterSessionListener();
        BackgroundTaskTool.stopContinuousTask(this.context);
        this.songItemBuilder.release().catch(() => {
          Logger.error(TAG, 'SongItemBuilder release failed.');
        });
        this.audioRenderer.off('writeData');
        this.audioRenderer.off('audioInterrupt');
        this.audioRenderer.off('outputDeviceChangeWithInfo');
        Logger.info(TAG, 'release success');
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        Logger.error(TAG, `release failed: cause the code ${err.code}, the message is ${err.message}`);
      }
    }
  }

  private initAudioRenderer() {
    const audioStreamInfo: audio.AudioStreamInfo = {
      samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_48000,
      channels: audio.AudioChannel.CHANNEL_2,
      sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
      encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
    };

    const audioRendererInfo: audio.AudioRendererInfo = {
      usage: audio.StreamUsage.STREAM_USAGE_MUSIC,
      rendererFlags: 0
    };

    const audioRendererOptions: audio.AudioRendererOptions = {
      streamInfo: audioStreamInfo,
      rendererInfo: audioRendererInfo
    };

    audio.createAudioRenderer(audioRendererOptions, (err, data) => {
      if (err) {
        Logger.error(TAG, `Invoke createAudioRenderer failed, code is ${err.code}, message is ${err.message}`);
        return;
      } else {
        Logger.info(TAG, 'Invoke createAudioRenderer succeeded.');
        this.audioRenderer = data;
        this.setAudioRendererCallbacks();
      }
    });
  }

  private setAudioRendererCallbacks() {
    this.setAvSessionCallback();
    this.setWriteDataCallback();
    this.setInterruptCallback();
    this.setOutputDeviceChangeCallback();
    this.setSilentModeAndMixWithOthersFromPrefer().catch((err: BusinessError) => {
      Logger.error(TAG,
        `setSilentModeAndMixWithOthersFromPrefer failed: cause the code ${err.code}, the message is ${err.message}`);
    });
  }

  private setAvSessionCallback() {
    this.avSessionController = AVSessionController.getInstance();
    this.loadSongAssent().catch((err: BusinessError) => {
      Logger.error(TAG, `loadSongAssent failed: cause the code ${err.code}, the message is ${err.message}`);
    });
  }

  private setWriteDataCallback() {
    if (!this.audioRenderer) {
      Logger.error(TAG, 'writeData fail.audioRenderer is undefined');
      return;
    }
    const secondBufferWalk = SECOND_BUFFER_WALK;
    let bufferWalk = 0;
    let options: Options | undefined = undefined;
    try {
      this.audioRenderer.on('writeData', (buffer) => {
        try {
          if (!this.songRawFileDescriptor) {
            return;
          }
          options = {
            offset: this.currentOffset,
            length: buffer.byteLength
          };
          fileIo.readSync(this.songRawFileDescriptor.fd, buffer, options);
          this.currentOffset += buffer.byteLength;
          this.bufferRead = this.currentOffset - this.initOffset;
          bufferWalk += buffer.byteLength;
          Logger.info(TAG,
            `songRawFileDescriptor get successed` + 'bufferRead is ' + this.bufferRead + '///' + 'bufferNeedRead is ' +
            this.bufferNeedRead);
          if (this.bufferRead <= this.bufferNeedRead) {
            if (bufferWalk >= secondBufferWalk) { // 1s seek
              const curMs = MediaTools.getMsFromByteLength(this.bufferRead);
              this.seek(curMs);
              bufferWalk = 0;
            }
          } else {
            bufferWalk = 0;
            const curMs = MediaTools.getMsFromByteLength(this.songRawFileDescriptor.length);
            Logger.info(TAG, 'setWriteDataCallback CurMs succeed.');
            this.seek(curMs);
            this.playNext().catch((err: BusinessError) => {
              Logger.error(TAG, `playNext failed: cause the code ${err.code}, the message is ${err.message}`);
            });
          }
          Logger.info(TAG, 'writeData is calling. ');
        } catch (error) {
          Logger.error(TAG, `writeData failed. code: ${error.code}, message: ${error.message}`);
        }
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG,
        `audioRenderer on writeData failed: cause the code ${err.code}, the message is ${err.message}`);
    }
  }

  private setInterruptCallback() {
    if (!this.audioRenderer) {
      return;
    }
    try {
      this.audioRenderer.on('audioInterrupt', this.interruptCallback);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG,
        `audioRenderer on audioInterrupt failed: cause the code ${err.code}, the message is ${err.message}`);
    }
  }

  private interruptCallback: (interruptEvent: audio.InterruptEvent) => void =
    (interruptEvent: audio.InterruptEvent) => {
      if (interruptEvent.forceType === audio.InterruptForceType.INTERRUPT_FORCE) {
        switch (interruptEvent.hintType) {
          case audio.InterruptHint.INTERRUPT_HINT_PAUSE:
            this.updateIsPlay(false);
            break;
          case audio.InterruptHint.INTERRUPT_HINT_STOP:
            this.updateIsPlay(false);
            this.pause().catch((err: BusinessError) => {
              Logger.error(TAG, `pause failed: cause the code ${err.code}, the message is ${err.message}`);
            });
            break;
          case audio.InterruptHint.INTERRUPT_HINT_DUCK:
            break;
          case audio.InterruptHint.INTERRUPT_HINT_UNDUCK:
            break;
          default:
            break;
        }
      } else if (interruptEvent.forceType === audio.InterruptForceType.INTERRUPT_SHARE) {
        switch (interruptEvent.hintType) {
          case audio.InterruptHint.INTERRUPT_HINT_RESUME:
            this.start();
            break;
          default:
            break;
        }
      }
    }

  private setOutputDeviceChangeCallback() {
    if (!this.audioRenderer) {
      return;
    }
    try {
      this.audioRenderer.on('outputDeviceChangeWithInfo', this.outputDeviceChangeCallback);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG,
        `audioRenderer on outputDeviceChangeWithInfo failed: the code ${err.code}, the message is ${err.message}`);
    }
  }

  private outputDeviceChangeCallback: (deviceChangeInfo: audio.AudioStreamDeviceChangeInfo) => void =
    (deviceChangeInfo: audio.AudioStreamDeviceChangeInfo) => {
      if (deviceChangeInfo.changeReason === audio.AudioStreamDeviceChangeReason.REASON_OLD_DEVICE_UNAVAILABLE) {
        Logger.info(TAG, `Device change reason: ${deviceChangeInfo.changeReason}`);
        this.pause().catch((err: BusinessError) => {
          Logger.error(TAG, `pause failed: cause the code ${err.code}, the message is ${err.message}`);
        });
      }
    }

  private async setSilentModeAndMixWithOthersFromPrefer() {
    if (!this.audioRenderer || !this.context) {
      return;
    }
    try {
      const formIds: string[] = await PreferencesUtil.getInstance().getFormIds(this.context);
      let isSupportSilent = false;
      if (formIds.includes(SILENT_ID)) {
        isSupportSilent = true;
      } else {
        isSupportSilent = false;
      }
      AppStorage.setOrCreate(KeyConstants.KEY_IS_SILENT_MODE, isSupportSilent);
      this.audioRenderer.setSilentModeAndMixWithOthers(isSupportSilent);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `getFormIds failed: the code ${err.code}, the message is ${err.message}`);
    }
  }

  private async loadSongAssent() {
    try {
      await this.songItemBuilder.build(this.songList[this.musicIndex]);
      this.songRawFileDescriptor = this.songItemBuilder.getRawFileDescriptor()
      if (!this.songRawFileDescriptor) {
        Logger.error(TAG, `loadSongAssent faile : songRawFileDescriptor get failed`);
        return;
      }
      this.initOffset = this.songRawFileDescriptor.offset;
      this.currentOffset = this.initOffset;
      this.bufferNeedRead = this.songRawFileDescriptor.length;
      this.bufferRead = 0;
      AppStorage.setOrCreate(KeyConstants.KEY_TOTAL_TIME, MediaTools.msToCountdownTime(this.getDuration()));
      AppStorage.setOrCreate(KeyConstants.KEY_TOTAL_MS_TIME, this.getDuration());
      AppStorage.setOrCreate(KeyConstants.KEY_PROGRESS_MAX, this.getDuration());
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `SongItemBuilder build failed: the code ${err.code}, the message is ${err.message}`);
    }
  }

  private updateIsPlay(isPlay: boolean) {
    AppStorage.setOrCreate<boolean>(KeyConstants.KEY_IS_PLAY, isPlay);
    if (!this.avSessionController) {
      return;
    }
    this.avSessionController.setPlayState(isPlay);
  }

  private getDuration() {
    if (this.audioRenderer && this.songRawFileDescriptor) {
      AppStorage.setOrCreate(KeyConstants.KEY_TOTAL_BYTE_LEN, this.songRawFileDescriptor.length);
      return MediaTools.getMsFromByteLength(this.songRawFileDescriptor.length);
    }
    return 0;
  }

  private async playRandom() {
    try {
      const num = Math.round(Math.random() * (this.songList.length - 1));
      if (this.musicIndex === num) {
        await this.playRandom();
      } else {
        await this.updateMusicIndex(num);
        await this.play(num);
      }
      Logger.info(TAG, 'play Random:' + this.musicIndex);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `playRandom failed: the code ${err.code}, the message is ${err.message}`);
    }
  }

  private async reset() {
    try {
      Logger.info(TAG, 'reset()');
      if (this.audioRenderer) {
        this.isFirst = true;
        await this.play(this.musicIndex);
      }
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `play failed: the code ${err.code}, the message is ${err.message}`);
    }
  }

  private async updateMusicIndex(musicIndex: number) {
    Logger.info(TAG, 'updateMusicIndex ===> ' + musicIndex);
    AppStorage.setOrCreate(KeyConstants.KEY_SELECT_INDEX, musicIndex);
    if (this.musicIndex !== musicIndex) {
      this.musicIndex = musicIndex;
    }
    if (!this.avSessionController) {
      return;
    }
    Logger.info(TAG, 'this.session !== undefined ');
    try {
      await this.avSessionController.setAVMetadata();
      await this.avSessionController.getAndUpdateFavoriteState(this.musicIndex.toString());
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `avSessionController invoke failed: the code ${err.code}, the message is ${err.message}`);
    }
  }
}