/*
* Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { media } from '@kit.MediaKit';
import { audio } from '@kit.AudioKit';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { avSession } from '@kit.AVSessionKit';
import { AVPlayerState, CommonConstants, VideoDataType } from '../constants/CommonConstants';
import { VideoData } from '../../pages/shortVideoScene/model/VideoData';
import Logger from './Logger';
import { AVSessionController } from './AVSessionController';
import { MediaController } from './MediaController';

const TAG = 'AvPlayerController';
const CASE_ZERO = 0;
const CASE_ONE = 1;
const CASE_TWO = 2;
const CASE_THREE = 3;

@Observed
export class AvPlayerController implements MediaController {
  @Track public surfaceID: string = '';
  @Track public isPlaying: boolean = false;
  @Track public isReady: boolean = false;
  @Track public currentTime: number = 0;
  @Track public currentBufferTime: number = 0;
  @Track public isLoading: boolean = false;
  @Track public duration: number = 0;
  @Track public durationTime: number = 0;
  @Track public currentCaption: string = '';
  private avPlayer?: media.AVPlayer;
  private curSource?: VideoData;
  private context: common.UIAbilityContext | undefined = AppStorage.get(CommonConstants.KEY_CONTEXT);
  private seekTime?: number;
  private isMuted: boolean = false;
  private speedSelect: number = 0;
  private windowScaleSelect: number = 0;
  private audioSessionManager: audio.AudioSessionManager = audio.getAudioManager().getSessionManager();
  private avSessionController?: AVSessionController;
  public langFlag?: boolean | undefined = undefined;

  public async initAVPlayer(source: VideoData, surfaceId: string, avSessionController: AVSessionController) {
    this.avSessionController = avSessionController;
    if (!this.context) {
      Logger.info(TAG, 'initPlayer failed context not set');
      return;
    }
    if (!source) {
      Logger.info(TAG, 'initPlayer failed source not set');
      return;
    }
    this.curSource = source;
    Logger.info(TAG, `cursource is ${JSON.stringify(source)}`)
    if (source.seekTime) {
      this.seekTime = source.seekTime;
      Logger.info(TAG, `seekTime is ${this.seekTime}`);
    }
    if (source.isMuted !== undefined) {
      this.isMuted = source.isMuted;
    }
    this.surfaceID = surfaceId;
    try {
      Logger.info(TAG, 'avPlayer create success');
      this.avPlayer = await media.createAVPlayer();
      this.setAVPlayerCallback();
      Logger.info(TAG, 'initPlayer mediaPlay setAVPlayerCallback');
      if (!this.context) {
        Logger.info(TAG, `initPlayer failed context not set`);
        return;
      }
      this.setMediaSourceDate(this.avPlayer, this.curSource);
      if (this.curSource.caption) {
        let fileDescriptorSub = await this.context.resourceManager.getRawFd(this.curSource.caption);
        this.avPlayer.addSubtitleFromFd(fileDescriptorSub.fd, fileDescriptorSub.offset, fileDescriptorSub.length)
          .catch(() => {
            Logger.error(TAG, 'avPlayer addSubtitleFromFd fail');
          });
        Logger.info(TAG, 'initPlayer mediaPlay addSubtitleFromFd');
        this.context.resourceManager.closeRawFd(this.curSource.caption)
          .catch(() => {
            Logger.error(TAG, 'closeRawFd failed');
          });
      }
    } catch (error) {
      if (error.code !== null && error.message !== null) {
        Logger.error(TAG, `initPlayer: Failed. code: ${error.code} ;message: ${error.message}`);
      }
    }
    // [EndExclude create_instance]
  }

  private async setMediaSourceDate(avPlayer: media.AVPlayer, curSource: VideoData) {
    if (!this.context) {
      Logger.info(TAG, `initPlayer failed context not set`);
      return;
    }
    try {
      switch (curSource.type) {
        case VideoDataType.RAW_FILE:
          let fileDescriptor = await this.context.resourceManager.getRawFd(curSource.videoSrc);
          avPlayer.fdSrc = fileDescriptor;
          Logger.info(TAG, `initPlayer mediaPlay src : ${avPlayer.fdSrc}`);
          break;
        case VideoDataType.URL:
          avPlayer.url = curSource.videoSrc;
          Logger.info(TAG, `initPlayer mediaPlay url : ${avPlayer.url}`);
          break;
        case VideoDataType.RAW_M3U8_FILE:
          let m3u8Fd = await this.context.resourceManager.getRawFd(curSource.videoSrc);
          let fdUrl = 'fd://' + m3u8Fd.fd + '?offset=' + m3u8Fd.offset + '&size=' + m3u8Fd.length;
          let mediaSource = media.createMediaSourceWithUrl(fdUrl);
          mediaSource.setMimeType(media.AVMimeTypes.APPLICATION_M3U8);
          let playbackStrategy: media.PlaybackStrategy = { preferredBufferDuration: 20, showFirstFrameOnPrepare: true };
          await avPlayer.setMediaSource(mediaSource, playbackStrategy);
          Logger.info(TAG, `initPlayer mediaPlay fdUrl : ${fdUrl}`);
          break;
        default:
          break;
      }
    } catch (error) {
      if (error.code !== null && error.message !== null) {
        Logger.error(TAG, `initPlayer: Failed. code: ${error.code} ;message: ${error.message}`);
      }
    }
  }

  // [End create_instance]
  private setAVPlayerCallback() {
    if (!this.avPlayer) {
      return;
    }
    this.avPlayer.on('error', (error: BusinessError) => {
      Logger.error(TAG, `AVPlayer: Failed. code: ${error.code} ;message: ${error.message}`);
      this.avPlayer!.reset().catch((error: BusinessError) => {
        Logger.error(TAG,
          `reset failed, code is ${error.code}, message is ${error.message}`);
      });
    });
    // Listening function for reporting time
    this.avPlayer.on('startRenderFrame', () => {
      AppStorage.setOrCreate(CommonConstants.KEY_START_RENDER, true);
    });

    this.avPlayer.on('durationUpdate', (time: number) => {
      this.duration = time;
      AppStorage.setOrCreate(CommonConstants.KEY_DURATION_TIME, time);
    });
    this.avPlayer.on('timeUpdate', (time: number) => {
      this.currentTime = time;
      Logger.info(TAG, `timeUpdate currentTime is ${this.currentTime}`);
      AppStorage.setOrCreate(CommonConstants.KEY_CURRENT_TIME, time);
    });
    // The error callback function is triggered when an error occurs during avPlayer operations,
    // at which point the reset interface is called to initiate the reset process
    this.avPlayer.on('error', (error: BusinessError) => {
      if (!this.avPlayer) {
        return;
      }
      Logger.error(TAG, `Invoke avPlayer failed, code is ${error.code}, message is ${error.message}`);
      // resets the resources and triggers the idle state
      this.avPlayer.reset().catch((error: BusinessError) => {
        Logger.error(TAG,
          `reset failed, code is ${error.code}, message is ${error.message}`);
      });
    })
    // Subtitle mounting callback function
    this.avPlayer.on('subtitleUpdate', (info: media.SubtitleInfo) => {
      if (!!info) {
        let text: string = (!info.text) ? '' : info.text;
        let startTime: number = (!info.startTime) ? 0 : info.startTime;
        let duration: number = (!info.duration) ? 0 : info.duration;
        this.currentCaption = text;
        let eventData: emitter.EventData = {
          data: {
            'currentCaption': text
          }
        };
        emitter.emit(CommonConstants.SUBTITLE_UPDATE, eventData);
        Logger.info(TAG, `subtitleUpdate text:${text},startTime:${startTime},duration:${duration}`);
      } else {
        this.currentCaption = '';
        Logger.info(TAG, 'subtitleUpdate info is null');
      }
    });

    // Monitor the buffering status, buffering percentage,
    // and estimated playable time of buffered data for streaming media
    this.avPlayer.on('bufferingUpdate', (infoType: media.BufferingInfoType, value: number) => {
      Logger.info(TAG, ` bufferingUpdate, infoType is ${infoType}, value is ${value}.`);
      if (infoType === media.BufferingInfoType.BUFFERING_START) {
        this.isLoading = true;
      } else if (infoType === media.BufferingInfoType.BUFFERING_END) {
        this.isLoading = false;
      }
      if (this.durationTime === 0) {
        return;
      }
      if (infoType === media.BufferingInfoType.CACHED_DURATION && this.avPlayer) {
        this.currentBufferTime = Math.max(this.currentBufferTime, this.currentTime + value);
        Logger.info(TAG, `currentBufferTime: ${this.currentBufferTime}`);
      }
    });
    this.setInterruptCallback();
    this.setStateChangeCallback();
    this.setOutputDeviceChangeCallback();
  }

  private setInterruptCallback() {
    if (!this.avPlayer) {
      return;
    }
    this.avPlayer.on('audioInterrupt', async (interruptEvent: audio.InterruptEvent) => {
      // When an audio interruption event occurs, the `audioRenderer` receives the `interruptEvent` callback. Here,
      // handle it based on its content:
      // 1. Optional: Read the type of `interruptEvent.forceType` to determine if the system has already enforced
      // the corresponding action.
      //    Note: Under the default focus strategy, `INTERRUPT_HINT_RESUME` is of type `INTERRUPT_SHARE`, while all
      //    other hint types are of `INTERRUPT_FORCE`.Therefore, checking `forceType` may not be necessary.
      // 2. Required: Read the type of `interruptEvent.hintType` and perform the corresponding handling.
      if (interruptEvent.forceType === audio.InterruptForceType.INTERRUPT_FORCE) {
        // For the INTERRUPT_FORCE type: Audio-related processing has been performed by the system, and the
        // application needs to update its own state and make the corresponding adjustments.
        switch (interruptEvent.hintType) {
          case audio.InterruptHint.INTERRUPT_HINT_PAUSE:
            // This branch indicates that the system has paused the audio stream (temporarily lost focus).
            // To maintain consistency in state, the application should switch to the audio paused state.
            // Temporarily lost focus: After other audio streams release the audio focus, this audio stream
            // will receive a corresponding resume audio interruption event, at which point it can resume
            // playback on its own.
            this.mediaPause();
            break;
          case audio.InterruptHint.INTERRUPT_HINT_STOP:
            // This branch indicates that the system has stopped the audio stream (permanently lost focus).
            // To maintain consistency in state, the application should switch to the audio paused state.
            // Permanently lost focus: No further audio interruption events will be received. To resume
            // playback, user intervention is required.
            this.mediaPause();
            break;
          case audio.InterruptHint.INTERRUPT_HINT_DUCK:
            // This branch indicates that the system has reduced the audio volume (default to 20% of the normal volume).
            // To maintain consistency in state, the application should switch to the reduced volume playback state.
            // If the application does not accept reduced volume playback, it can choose an alternative handling method
            // here, such as pausing playback.
            break;
          case audio.InterruptHint.INTERRUPT_HINT_UNDUCK:
            // This branch indicates that the system has restored the audio volume to normal. To maintain
            // consistency in state, the application should switch to the normal volume playback state.
            break;
          default:
            break;
        }
      } else if (interruptEvent.forceType === audio.InterruptForceType.INTERRUPT_SHARE) {
        // For the INTERRUPT_SHARE type: The application can choose to perform related actions or ignore the
        // audio interruption event.
        switch (interruptEvent.hintType) {
          case audio.InterruptHint.INTERRUPT_HINT_RESUME:
            // This branch indicates that the audio stream, which was paused due to temporary loss of focus,
            // can now resume playing. It is recommended that the application resumes playback and switches
            // to the audio playback state.
            // If the application does not want to resume playback at this point, it can ignore this audio
            // interruption event and take no action.
            // Resume playback by explicitly calling `start()` here, and record the result of the `start()`
            // call in a flag variable `started`.
            this.mediaPlay();
            break;
          default:
            break;
        }
      }
    })
  }

  // [Start mode_volume]
  private setStateChangeCallback() {
    // [StartExclude mode_volume]
    if (!this.avPlayer) {
      return;
    }
    // [EndExclude mode_volume]
    // Callback function for state machine changes
    this.avPlayer.on('stateChange', async (state) => {
      // [StartExclude mode_volume]
      if (!this.avPlayer) {
        return;
      }
      // [EndExclude mode_volume]
      switch (state) {
        // [StartExclude mode_volume]
        case 'idle': // This state machine is triggered after the reset interface is successfully invoked.
          this.avPlayer.release().catch((error: BusinessError) => {
            Logger.error(TAG,
              `release failed, code is ${error.code}, message is ${error.message}`);
          });
          break;
        case 'initialized': // This status is reported after the playback source is set on the AVPlayer.
          // Set the display screen. This parameter is not required when the resource to be played is audio-only.
          this.avPlayer.surfaceId = this.surfaceID;
          Logger.info(TAG, `setAVPlayerCallback surfaceId : ${this.avPlayer.surfaceId}`);
          try {
            await this.avPlayer.setPlaybackStrategy({
              preferredBufferDuration: 20,
              showFirstFrameOnPrepare: true
            });
          } catch (error) {
            if (error.code !== null && error.message !== null) {
              Logger.error(TAG,
                `setPlaybackStrategy failed, code is ${error.code}, message is ${error.message}`);
            }
          }
          this.avPlayer.prepare().catch((error: BusinessError) => {
            Logger.error(TAG,
              `prepare failed, code is ${error.code}, message is ${error.message}`);
          });
          break;
        // [EndExclude mode_volume]
        case 'prepared': // This state machine is reported after the prepare interface is successfully invoked.
          // [StartExclude mode_volume]
          Logger.info(TAG, 'setAVPlayerCallback AVPlayer state prepared called.');
          this.isReady = true;
          this.durationTime = this.avPlayer.duration;
          this.currentTime = this.avPlayer.currentTime;
          Logger.info(TAG, `currentTime is ${this.currentTime} seekTime is ${this.seekTime}`);
          if (this.seekTime) {
            Logger.info(TAG, `prepared seekTime is ${this.seekTime}`)
            this.videoSeek(this.seekTime)
          }
          // [EndExclude mode_volume]
          let eventData: emitter.EventData = {
            data: {
              'percent': this.avPlayer.width / this.avPlayer.height
            }
          };
          emitter.emit(CommonConstants.AVPLAYER_PREPARED, eventData);

          this.setWindowScaleSelect();
          this.mediaPlay();
          this.setSpeedSelect();
          break;
        // [StartExclude mode_volume]
        case 'playing': // After the play interface is successfully invoked, the state machine is reported.
          Logger.info(TAG, 'setAVPlayerCallback AVPlayer state playing called.');
          this.isPlaying = true;
          let eventDataTrue: emitter.EventData = {
            data: {
              'flag': true
            }
          };
          let innerEventTrue: emitter.InnerEvent = {
            eventId: 2,
            priority: emitter.EventPriority.HIGH
          };
          emitter.emit(innerEventTrue, eventDataTrue);
          break;
        case 'completed': // This state machine is triggered to report when the playback ends.
          Logger.info(TAG, 'setAVPlayerCallback AVPlayer state completed called.');
          this.currentTime = 0;
          this.avPlayer.seek(0);
          this.mediaPlay();
          let eventDataFalse: emitter.EventData = {
            data: {
              'flag': false
            }
          };
          let innerEvent: emitter.InnerEvent = {
            eventId: 1,
            priority: emitter.EventPriority.HIGH
          };
          emitter.emit(innerEvent, eventDataFalse);
          break;
        default:
          Logger.info(TAG, 'setAVPlayerCallback AVPlayer state unknown called.');
          break;
        // [EndExclude mode_volume]
      }
    });
  }

  private setOutputDeviceChangeCallback() {
    if (!this.avPlayer) {
      return;
    }
    this.avPlayer.on('audioOutputDeviceChangeWithInfo', (data: audio.AudioStreamDeviceChangeInfo) => {
      if (data.changeReason === audio.AudioStreamDeviceChangeReason.REASON_OLD_DEVICE_UNAVAILABLE) {
        Logger.info(TAG, `Device break: ${data.changeReason}`);
        this.mediaPause();
      } else if (data.changeReason === audio.AudioStreamDeviceChangeReason.REASON_NEW_DEVICE_AVAILABLE) {
        Logger.info(TAG, `Device connect: ${data.changeReason}`);
      }
    });
  }

  // [Start activateAudioSession]
  async mediaPlay() {
    // [StartExclude activateAudioSession]
    Logger.info(TAG, 'into play');
    if (!this.avPlayer) {
      Logger.info(TAG, `this.avPlayer is undefined`);
      return;
    }
    Logger.info(TAG, `current state is ${this.avPlayer.state}`)
    if (this.avPlayer.state === 'playing') {
      return;
    }
    await this.videoMuted(this.isMuted);
    // [EndExclude activateAudioSession]
    await this.activateAudioSession();
    await this.avPlayer.play().catch((error: BusinessError) => {
      Logger.error(TAG,
        `play failed, code is ${error.code}, message is ${error.message}`);
    });
    // [StartExclude activateAudioSession]
    AppStorage.setOrCreate(CommonConstants.KEY_IS_PLAYING, true)
    this.isPlaying = true;
    let playbackState: avSession.AVPlaybackState = {
      state: avSession.PlaybackState.PLAYBACK_STATE_PLAY,
      loopMode: avSession.LoopMode.LOOP_MODE_SINGLE
    };
    try {
      await this.avSessionController?.session?.setAVPlaybackState(playbackState);
    } catch (error) {
      Logger.error(TAG, `setAVPlaybackState fail. code is ${error.code}, error message is ${error.message}`);
    }
    // [EndExclude activateAudioSession]
  }

  // [End activateAudioSession]

  // [Start deactivateAudioSession]
  async mediaPause() {
    if (this.avPlayer && this.avPlayer.state !== 'paused') {
      try {
        await this.avPlayer.pause().catch((error: BusinessError) => {
          Logger.error(TAG,
            `pause failed, code is ${error.code}, message is ${error.message}`);
        });
        // [StartExclude deactivateAudioSession]
        let playbackState: avSession.AVPlaybackState = {
          state: avSession.PlaybackState.PLAYBACK_STATE_PAUSE,
          loopMode: avSession.LoopMode.LOOP_MODE_SINGLE
        };
        try {
          await this.avSessionController?.session?.setAVPlaybackState(playbackState);
        } catch (error) {
          Logger.error(TAG, `setAVPlaybackState fail. code is ${error.code}, error message is ${error.message}`);
        }
        this.isPlaying = false;
        AppStorage.setOrCreate(CommonConstants.KEY_IS_PLAYING, this.isPlaying);
        // [EndExclude deactivateAudioSession]
        let isScrolling: boolean | undefined = AppStorage.get(CommonConstants.KEY_IS_SCROLLING);
        if (!isScrolling) {
          this.deactivateAudioSession();
          Logger.info(TAG, 'mediaPause success and deactivateAudioSession');
        }
        Logger.info(TAG, 'mediaPause');
      } catch (error) {
        if (error.code !== null && error.message !== null) {
          Logger.error(TAG, `mediaPause failed, code is ${error.code}, message is ${error.message}`);
        }
      }
    }
  }

  // [End deactivateAudioSession]

  // Toggle play/pause state
  async mediaStop() {
    if (this.avPlayer) {
      try {
        this.avPlayer.stop().catch((error: BusinessError) => {
          this.seekTime = 0;
          Logger.error(TAG,
            `pause failed, code is ${error.code}, message is ${error.message}`);
        });
        AppStorage.setOrCreate(CommonConstants.KEY_IS_PLAYING, false)
        let playbackState: avSession.AVPlaybackState = {
          state: avSession.PlaybackState.PLAYBACK_STATE_STOP,
          loopMode: avSession.LoopMode.LOOP_MODE_SINGLE
        };
        try {
          await this.avSessionController?.session?.setAVPlaybackState(playbackState);
        } catch (error) {
          Logger.error(TAG, `setAVPlaybackState fail. code is ${error.code}, error message is ${error.message}`);
        }
        this.isPlaying = false;
      } catch (error) {
        if (error.code !== null && error.message !== null) {
          Logger.error(TAG, `mediaStop failed, code is ${error.code}, message is ${error.message}`);
        }
      }
    }
  }

  async videoMuted(isMuted: boolean): Promise<void> {
    if (!this.avPlayer) {
      return;
    }
    try {
      this.isMuted = isMuted;
      Logger.info(TAG, `muted is ${this.isMuted}`);
      await this.avPlayer.setMediaMuted(media.MediaType.MEDIA_TYPE_AUD, isMuted);
    } catch (error) {
      if (error.code !== null && error.message !== null) {
        Logger.error(TAG, `videoMuted failed, code is ${error.code}, message is ${error.message}`);
      }
    }
  }

  getVideoState(): AVPlayerState {
    let status: AVPlayerState = AVPlayerState.UNDEFINED;
    if (this.avPlayer !== undefined) {
      switch (this.avPlayer.state) {
        case 'idle':
          status = AVPlayerState.IDLE;
          break;
        case 'initialized':
          status = AVPlayerState.INITIALIZED;
          break;
        case 'prepared':
          status = AVPlayerState.PREPARED;
          break;
        case 'playing':
          status = AVPlayerState.PLAYING;
          break;
        case 'paused':
          status = AVPlayerState.PAUSED;
          break;
        case 'completed':
          status = AVPlayerState.COMPLETED;
          break;
        case 'stopped':
          status = AVPlayerState.STOPPED;
          break;
        case 'released':
          status = AVPlayerState.RELEASED;
          break;
        case 'error':
          status = AVPlayerState.ERROR;
          break;
        default:
          status = AVPlayerState.UNDEFINED;
          break;
      }
    }
    return status;
  }

  videoSpeedChange(speedVal: number): void {
    if (!this.avPlayer) {
      return;
    }
    switch (speedVal) {
      case 0:
        this.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_00_X);
        break;
      case 1:
        this.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_25_X);
        break;
      case 2:
        this.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_75_X);
        break;
      case 3:
        this.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_2_00_X);
        break;
      default:
        break;
    }
  }

  videoSeek(seekTime: number): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.seek(seekTime, media.SeekMode.SEEK_CLOSEST);
      } catch (error) {
        if (error.code !== null && error.message !== null) {
          Logger.error(TAG, `videoSeek failed, code is ${error.code}, message is ${error.message}`);
        }
      }
    }
  }

  async videoReset(): Promise<void> {
    if (!this.avPlayer) {
      return;
    }
    try {
      await this.activateAudioSession();
      await this.avPlayer.reset();
    } catch (error) {
      if (error.code !== null && error.message !== null) {
        Logger.error(TAG, `videoReset failed, code is ${error.code}, message is ${error.message}`);
      }
    }
  }

  async videoRelease(): Promise<void> {
    if (!this.avPlayer) {
      return;
    }
    this.avPlayer.off('error');
    this.avPlayer.off('startRenderFrame');
    this.avPlayer.off('durationUpdate');
    this.avPlayer.off('timeUpdate');
    this.avPlayer.off('subtitleUpdate');
    this.avPlayer.off('bufferingUpdate');
    this.avPlayer.off('stateChange');
    this.avPlayer.off('audioInterrupt');
    this.avPlayer.off('audioOutputDeviceChangeWithInfo');
    this.avPlayer.release((err) => {
      if (!err) {
        Logger.info(TAG, 'videoRelease release success');
      } else {
        Logger.error(TAG, `videoRelease release filed, error message is = ${err.message}`);
      }
    });
  }

  getDurationTime(): number {
    return this.durationTime;
  }

  getCurrentTime(): number {
    return this.currentTime;
  }

  videoScaleFit(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.videoScaleType = media.VideoScaleType.VIDEO_SCALE_TYPE_FIT;
      } catch (error) {
        if (error.code !== null && error.message !== null) {
          Logger.error(TAG,
            `videoScaleFit failed, code is ${error.code}, message is ${error.message}`);
        }
      }
    }
  }

  videoScaleFitCrop(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.videoScaleType = media.VideoScaleType.VIDEO_SCALE_TYPE_FIT_CROP;
      } catch (error) {
        if (error.code !== null && error.message !== null) {
          Logger.error(TAG,
            `videoScaleFitCrop failed, code is ${error.code}, message is ${error.message}`);
        }
      }
    }
  }

  setWindowScaleSelect(): void {
    switch (this.windowScaleSelect) {
      case CASE_ZERO:
        this.videoScaleFit();
        break;
      case CASE_ONE:
        this.videoScaleFitCrop();
        break;
      default:
        break;
    }
  }

  setSpeedSelect(): void {
    switch (this.speedSelect) {
      case CASE_ZERO:
        this.videoSpeedChange(CASE_ZERO);
        break;
      case CASE_ONE:
        this.videoSpeedChange(CASE_ONE);
        break;
      case CASE_TWO:
        this.videoSpeedChange(CASE_TWO);
        break;
      case CASE_THREE:
        this.videoSpeedChange(CASE_THREE);
        break;
      default:
        break;
    }
  }

  deactivateAudioSession() {
    try {
      this.audioSessionManager.deactivateAudioSession().catch(() => {
        Logger.error('deactivateAudioSession fail');
      }).then(() => {
        Logger.info('deactivateAudioSession success');
      });
    } catch (error) {
      Logger.error(TAG, `deactivateAudioSession failed,code is ${error.code},message is ${error.message}}`);
    }
  }

  // [Start activateAudioSessions]
  async activateAudioSession() {
    try {
      this.audioSessionManager.setAudioSessionScene(audio.AudioSessionScene.AUDIO_SESSION_SCENE_MEDIA)
      let strategy: audio.AudioSessionStrategy = {
        concurrencyMode: this.isMuted ? audio.AudioConcurrencyMode.CONCURRENCY_MIX_WITH_OTHERS :
          AppStorage.get(CommonConstants.KEY_AUDIO_CONCURRENCY_MODE) as audio.AudioConcurrencyMode
      };
      await this.audioSessionManager.activateAudioSession(strategy).catch(() => {
        Logger.info('activateAudioSession failed');
      }).then(() => {
        Logger.info('activateAudioSession success');
      });
    } catch (error) {
      Logger.error(TAG, `activateAudioSession failed,code is ${error.code},message is ${error.message}`);
    }
  }

  // [End activateAudioSessions]

  async languageChange(languageSelect: number = 0): Promise<void> {
    if (this.avPlayer) {
      try {
        if (this.curSource && this.curSource.caption) {
          if (this.curSource.caption.slice(0, 2) === 'cn' && languageSelect === 0 ||
            this.curSource.caption.slice(0, 2) === 'en' && languageSelect === 1) {
            this.langFlag = false;
            return;
          } else {
            this.curSource.caption = this.curSource.caption.replace(/^../, languageSelect === 0 ? 'cn' : 'en');
            this.curSource.seekTime = this.avPlayer.currentTime;
            await this.avPlayer.reset();
            this.initAVPlayer(this.curSource, this.surfaceID, this.avSessionController!)
            this.langFlag = true;
          }
        }
      } catch (err) {
        Logger.error(TAG,
          `languageChange failed, code is ${err.code}, message is ${err.message}`);
      }
    }
  }
}