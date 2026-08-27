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

import { common, wantAgent } from '@kit.AbilityKit';
import { avSession } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { resourceManager } from '@kit.LocalizationKit';
import { KeyConstants } from '../common/constants/KeyConstants';
import Logger from '../common/utils/Logger';
import { PreferencesUtil } from '../common/utils/PreferencesUtil';
import { MusicPlayMode } from '../songdatacontroller/PlayerData';
import { SongItem } from '../songdatacontroller/SongData';
import { AudioRendererController } from './AudioRendererController';
import { MediaTools } from './MediaTools';

const TAG: string = '[AVSessionController]';

export class AVSessionController {
  private context: common.UIAbilityContext | undefined = undefined;
  private avSession: avSession.AVSession | undefined = undefined;
  private songList: SongItem[] = [];
  private musicIndex: number | undefined = undefined;
  private audioRendererController: AudioRendererController | undefined = undefined;
  private playCall: () => void = async () => {
    Logger.info(TAG, `on play , do play task`);
    if (!this.audioRendererController) {
      Logger.error(TAG, 'audioRendererController is undefined in playCall');
      return;
    }
    try {
      if (this.getFirst()) {
        await this.audioRendererController.play();
      } else {
        await this.audioRendererController.start();
      }
    } catch (error) {
      Logger.error(TAG, `audioRendererController invoke try: code: ${error.code}, message: ${error.message}`);
    }
  }

  constructor() {
    const list: SongItem[] | undefined = AppStorage.get(KeyConstants.KEY_SONG_LIST);
    if (list) {
      this.songList = list;
    }
    this.initAVSession();
  }

  public static getInstance(): AVSessionController {
    let avSessionController: AVSessionController | undefined = AppStorage.get(KeyConstants.KEY_AV_SESSION_CONTROLLER);
    if (!avSessionController) {
      avSessionController = new AVSessionController();
      AppStorage.setOrCreate<AVSessionController>(KeyConstants.KEY_AV_SESSION_CONTROLLER, avSessionController);
    }
    return avSessionController;
  }

  public async setAVMetadata() {
    this.musicIndex = AppStorage.get(KeyConstants.KEY_SELECT_INDEX);
    Logger.info(TAG, 'current musicIndex is:' + this.musicIndex);
    if (this.musicIndex === undefined) {
      this.musicIndex = 0;
    }
    try {
      if (this.context) {
        const mediaImage =
          await MediaTools.getPixelMapFromResource(this.songList[this.musicIndex].label as resourceManager.Resource);
        Logger.info(TAG, 'getPixelMapFromResource success.');
        const metadata: avSession.AVMetadata = {
          assetId: `${this.musicIndex}`,
          title: this.songList[this.musicIndex].title,
          artist: this.songList[this.musicIndex].singer,
          mediaImage: mediaImage,
          duration: this.getDuration(),
        };
        const lrc = await MediaTools.getLrcFromRawFile(this.songList[this.musicIndex].lyric);
        if (lrc) {
          metadata.lyric = lrc;
        }
        if (this.avSession) {
          await this.avSession.setAVMetadata(metadata);
          mediaImage?.release();
          Logger.info(TAG, 'SetAVMetadata successfully');
        }
      }
    } catch (error) {
      Logger.error(TAG, `SetAVMetadata try: code: ${error.code}, message: ${error.message}`);
    }
  }

  async setListenerForMesFromController() {
    if (!this.avSession) {
      return;
    }
    try {
      this.avSession.on('play', this.playCall);
      this.avSession.on('pause', this.pauseCall);
      this.avSession.on('playNext', this.playNextCall);
      this.avSession.on('playPrevious', this.playPreviousCall);
      this.avSession.on('seek', this.seekCall);
      this.avSession.on('setLoopMode', this.setLoopModeCall);
      this.avSession.on('toggleFavorite', this.toggleFavoriteCall);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG,
        `setListenerForMesFromController failed: cause the code ${err.code}, the message is ${err.message}`);
    }
  }

  public setPlayModeToAVSession() {
    if (!this.audioRendererController) {
      Logger.error(TAG, 'audioRendererController is undefined in setPlayModeToAVSession');
      return;
    }
    const currentPlayMode: MusicPlayMode = this.audioRendererController.getPlayMode();
    let avSessionLoopMode: avSession.LoopMode | undefined = undefined;
    switch (currentPlayMode) {
      case MusicPlayMode.SINGLE_CYCLE:
        avSessionLoopMode = avSession.LoopMode.LOOP_MODE_SINGLE;
        break;
      case MusicPlayMode.ORDER:
        avSessionLoopMode = avSession.LoopMode.LOOP_MODE_SEQUENCE;
        break;
      case MusicPlayMode.RANDOM:
        avSessionLoopMode = avSession.LoopMode.LOOP_MODE_SHUFFLE;
        break;
      default:
        break;
    }
    if (avSessionLoopMode !== undefined) {
      this.setLoopModeState(avSessionLoopMode).catch((error: BusinessError) => {
        Logger.error(TAG, `setLoopModeState failed: code: ${error.code}, message: ${error.message}`);
      })
    }
  }

  public setProgressState(ms: number) {
    if (this.avSession) {
      this.avSession.setAVPlaybackState({
        position: {
          elapsedTime: ms,
          updateTime: new Date().getTime()
        }
      }, (err: BusinessError) => {
        if (err) {
          Logger.error(TAG, `SetAVPlaybackState BusinessError: code: ${err.code}, message: ${err.message}`);
        } else {
          Logger.info(TAG, 'SetAVPlaybackState successfully');
        }
      });
    }
  }

  public setPlayState(isPlay: boolean) {
    if (this.avSession) {
      this.avSession.setAVPlaybackState({
        state: isPlay ? avSession.PlaybackState.PLAYBACK_STATE_PLAY : avSession.PlaybackState.PLAYBACK_STATE_PAUSE,
      }, (err: BusinessError) => {
        if (err) {
          Logger.error(TAG, `SetAVPlaybackState BusinessError: code: ${err.code}, message: ${err.message}`);
        } else {
          Logger.info(TAG, 'SetAVPlaybackState successfully');
        }
      });
    }
  }

  public async updateFavoriteState(assetId: string, isFavorite: boolean = false) {
    if (!this.context) {
      return;
    }
    try {
      const favoriteIds: string[] = await PreferencesUtil.getInstance().getFormIds(this.context);
      if (favoriteIds.includes(assetId)) {
        await PreferencesUtil.getInstance().removeFormId(this.context, assetId);
        isFavorite = false;
      } else {
        await PreferencesUtil.getInstance().addFormId(this.context, assetId);
        isFavorite = true;
      }
      AppStorage.setOrCreate(KeyConstants.KEY_IS_FAVORITE, isFavorite);
      this.setFavoriteState(isFavorite);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG,
        `operate FormId or setFavoriteState failed: cause the code ${err.code}, the message is ${err.message}`);
    }
  }

  public async getAndUpdateFavoriteState(assetId: string) {
    let isFavorite = false;
    if (!this.context) {
      return;
    }
    try {
      const favoriteListIds: string[] = await PreferencesUtil.getInstance().getFormIds(this.context);
      if (favoriteListIds.includes(assetId)) {
        isFavorite = true;
      } else {
        isFavorite = false;
      }
      AppStorage.setOrCreate(KeyConstants.KEY_IS_FAVORITE, isFavorite);
      this.setFavoriteState(isFavorite);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG,
        `getFormIds or setFavoriteState failed: cause the code ${err.code}, the message is ${err.message}`);
    }
  }

  public async setLoopModeState(avSessionLoopMode: avSession.LoopMode) {
    if (this.avSession) {
      this.avSession.setAVPlaybackState({ loopMode: avSessionLoopMode }, (err: BusinessError) => {
        if (err) {
          Logger.error(TAG, `SetAVPlaybackState BusinessError: code: ${err.code}, message: ${err.message}`);
        } else {
          Logger.info(TAG, 'SetAVPlaybackState successfully');
        }
      });
    }
  }

  async unregisterSessionListener() {
    if (!this.avSession) {
      return;
    }
    try {
      this.avSession.off('play');
      this.avSession.off('pause');
      this.avSession.off('playNext');
      this.avSession.off('playPrevious');
      this.avSession.off('setLoopMode');
      this.avSession.off('seek');
      this.avSession.off('toggleFavorite');
      this.avSession.destroy().catch((error: BusinessError) => {
        Logger.error(TAG, `avSession destroy failed: cause the code ${error.code}, the message is ${error.message}`);
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `unregisterSessionListener failed: cause the code ${err.code}, the message is ${err.message}`);
    }
  }

  private async initAVSession() {
    this.context = AppStorage.get(KeyConstants.KEY_ABILITY_CONTEXT);
    if (!this.context) {
      Logger.info(TAG, `session create failed : conext is undefined`);
      return;
    }
    this.audioRendererController = AppStorage.get(KeyConstants.KEY_AUDIO_RENDER_CONTROLLER);
    if (!this.audioRendererController) {
      Logger.info(TAG, `session create failed : audioRendererController is undefined`);
      return;
    }
    try {
      this.avSession = await avSession.createAVSession(this.context, 'PLAY_AUDIO', 'audio');
      await this.avSession.activate();
      Logger.info(TAG, `session create successed.`);
      await this.setAVMetadata();
      await this.setLaunchAbility();
      await this.setListenerForMesFromController();
      if (this.musicIndex !== undefined) {
        this.getAndUpdateFavoriteState(this.musicIndex.toString());
      }
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `init AVSession failed: cause the code ${err.code}, the message is ${err.message}`);
    }
  }

  private async setLaunchAbility() {
    if (!this.context) {
      return;
    }
    const wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          bundleName: this.context.abilityInfo.bundleName,
          abilityName: this.context.abilityInfo.name
        }
      ],
      actionType: wantAgent.OperationType.START_ABILITIES,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    };
    try {
      const agent = await wantAgent.getWantAgent(wantAgentInfo);
      if (this.avSession) {
        this.avSession.setLaunchAbility(agent).catch((error: BusinessError) => {
          Logger.error(TAG, `setLaunchAbility failed: cause the code ${error.code}, the message is ${error.message}`);
        });
      }
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `avSession setLaunchAbility failed: cause the code ${err.code}, the message is ${err.message}`);
    }
  }

  private getDuration() {
    const duration: number | undefined = AppStorage.get(KeyConstants.KEY_TOTAL_MS_TIME);
    if (!duration) {
      Logger.error(TAG, 'get duration failed');
      return;
    }
    return duration;
  }

  private getFirst(): boolean | undefined {
    if (!this.audioRendererController) {
      return;
    }
    return this.audioRendererController.getFirst();
  }

  private pauseCall: () => void = () => {
    Logger.info(TAG, `on pause , do pause task`);
    if (!this.audioRendererController) {
      Logger.error(TAG, 'audioRendererController is undefined in pauseCall');
      return;
    }
    this.audioRendererController.pause().catch((error: BusinessError) => {
      Logger.error(TAG,
        `audioRendererController pause failed: cause the code ${error.code}, the message is ${error.message}`);
    });
  }
  private playNextCall: () => void = () => {
    Logger.info(TAG, `on playNext , do playNext task`);
    if (!this.audioRendererController) {
      Logger.error(TAG, 'audioRendererController is undefined in playNextCall');
      return;
    }
    this.audioRendererController.playNext().catch((error: BusinessError) => {
      Logger.error(TAG,
        `audioRendererController playNext failed: cause the code ${error.code}, the message is ${error.message}`);
    });
  }
  private playPreviousCall: () => void = () => {
    Logger.info(TAG, `on playPrevious , do playPrevious task`);
    if (!this.audioRendererController) {
      Logger.error(TAG, 'audioRendererController is undefined in playPreviousCall')
      return;
    }
    this.audioRendererController.playPrevious().catch((error: BusinessError) => {
      Logger.error(TAG,
        `audioRendererController playPrevious failed: cause the code ${error.code}, the message is ${error.message}`);
    });
  }
  private seekCall: (curMs: number) => void = (curMs: number) => {
    Logger.info(TAG, `on seek , do seek task`);
    if (!this.audioRendererController) {
      Logger.error(TAG, 'audioRendererController is undefined in seekCall');
      return;
    }
    this.audioRendererController.seek(curMs);
  }
  private setLoopModeCall: (loopMode: avSession.LoopMode) => void = (loopMode: avSession.LoopMode) => {
    Logger.info(TAG, `on loopMode , do loopMode task`);
    if (!this.audioRendererController) {
      Logger.error(TAG, 'audioRendererController is undefined in setLoopModeCall');
      return;
    }
    switch (loopMode) {
      case avSession.LoopMode.LOOP_MODE_SINGLE:
        this.audioRendererController.setPlayModel(MusicPlayMode.ORDER);
        break;
      case avSession.LoopMode.LOOP_MODE_SEQUENCE:
        this.audioRendererController.setPlayModel(MusicPlayMode.RANDOM);
        break;
      case avSession.LoopMode.LOOP_MODE_SHUFFLE:
        this.audioRendererController.setPlayModel(MusicPlayMode.SINGLE_CYCLE);
        break;
      default:
        break;
    }
    this.setPlayModeToAVSession();
    this.setPlayModeToControlArea();
  }
  private toggleFavoriteCall: (assetId: string) => void = (assetId: string) => {
    Logger.info(TAG, `on toggleFavorite , do toggleFavorite task`);
    this.updateFavoriteState(assetId).catch((error: BusinessError) => {
      Logger.error(TAG, `updateFavoriteState failed: cause the code ${error.code}, the message is ${error.message}`);
    });
  }

  private setPlayModeToControlArea() {
    if (!this.audioRendererController) {
      Logger.error(TAG, 'audioRendererController is undefined in setPlayModeToAVSession');
      return;
    }
    const currentPlayMode: MusicPlayMode = this.audioRendererController.getPlayMode();
    AppStorage.setOrCreate(KeyConstants.KEY_PLAY_MODE, currentPlayMode);
  }

  private setFavoriteState(isFavorite: boolean) {
    if (this.avSession) {
      this.avSession.setAVPlaybackState({ isFavorite }, (err: BusinessError) => {
        if (err) {
          Logger.error(TAG, `SetAVPlaybackState BusinessError: code: ${err.code}, message: ${err.message}`);
        } else {
          Logger.info(TAG, 'SetAVPlaybackState successfully');
        }
      });
    }
  }
}