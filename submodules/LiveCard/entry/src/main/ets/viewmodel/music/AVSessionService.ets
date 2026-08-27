/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import type { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '../../utils/Logger';
import { SongItem } from '../../model/music/SongItem';
import { MediaTools } from '../../utils/MediaTools';
import { image } from '@kit.ImageKit';

const TAG = 'AVSessionService';

export class AVSessionService {
  private static instance: AVSessionService | undefined;
  private context: common.UIAbilityContext | undefined = undefined;
  private session?: avSession.AVSession;

  private onPlayCallback?: () => void;
  private onPauseCallback?: () => void;
  private onPlayNextCallback?: () => void;
  private onPlayPreviousCallback?: () => void;

  private avSessionPlayCall = (): void => {
    Logger.info(TAG, 'avSessionPlayCall on play');
    if (this.onPlayCallback) {
      this.onPlayCallback();
    }
  };

  private avSessionPauseCall = (): void => {
    Logger.info(TAG, 'avSessionPauseCall on pause');
    if (this.onPauseCallback) {
      this.onPauseCallback();
    }
  };

  private avSessionPlayNextCall = (): void => {
    Logger.info(TAG, 'avSessionPlayNextCall on playNext');
    if (this.onPlayNextCallback) {
      this.onPlayNextCallback();
    }
  };

  private avSessionPlayPreviousCall = (): void => {
    Logger.info(TAG, 'avSessionPlayPreviousCall on playPrevious');
    if (this.onPlayPreviousCallback) {
      this.onPlayPreviousCallback();
    }
  };

  public static getInstance(): AVSessionService {
    if (!AVSessionService.instance) {
      AVSessionService.instance = new AVSessionService();
    }
    return AVSessionService.instance;
  }

  public static resetInstance(): void {
    AVSessionService.instance = undefined;
  }

  public setContext(context: common.UIAbilityContext): void {
    this.context = context;
  }

  public setOnPlayCallback(callback: () => void): void {
    this.onPlayCallback = callback;
  }

  public setOnPauseCallback(callback: () => void): void {
    this.onPauseCallback = callback;
  }

  public setOnPlayNextCallback(callback: () => void): void {
    this.onPlayNextCallback = callback;
  }

  public setOnPlayPreviousCallback(callback: () => void): void {
    this.onPlayPreviousCallback = callback;
  }

  public async initialize(): Promise<void> {
    Logger.info(TAG, 'initialize');

    if (!this.context) {
      Logger.error(TAG, 'context is undefined');
      return;
    }

    try {
      this.session = await avSession.createAVSession(this.context, 'SESSION_NAME', 'audio');
      await this.session.activate();
      Logger.info(TAG, `session create done, sessionId: ${this.session.sessionId}`);

      this.setListenerForMesFromController();

      let wantAgentInfo: wantAgent.WantAgentInfo = {
        wants: [
          {
            bundleName: this.context.abilityInfo.bundleName,
            abilityName: this.context.abilityInfo.name,
          },
        ],
        actionType: wantAgent.OperationType.START_ABILITIES,
        requestCode: 0,
        wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG],
        extraInfos: {
          routeName: 'MusicPage',
        }
      };

      let agent = await wantAgent.getWantAgent(wantAgentInfo);
      if (this.session) {
        await this.session.setLaunchAbility(agent);
      }
      Logger.info(TAG, 'initialize success');
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `initialize err, code: ${error.code}, message: ${error.message}`);
    }
  }

  private setListenerForMesFromController(): void {
    if (this.session) {
      try {
        this.session.on('play', this.avSessionPlayCall);
        this.session.on('pause', this.avSessionPauseCall);
        this.session.on('playNext', this.avSessionPlayNextCall);
        this.session.on('playPrevious', this.avSessionPlayPreviousCall);
      } catch (err) {
        let error = err as BusinessError;
        Logger.error(TAG, `setListenerForMesFromController err, code: ${error.code}, message: ${error.message}`);
      }
    }
  }

  private unregisterSessionListener(): void {
    if (this.session) {
      try {
        this.session.off('play');
        this.session.off('pause');
        this.session.off('playNext');
        this.session.off('playPrevious');
      } catch (err) {
        let error = err as BusinessError;
        Logger.error(TAG, `unregisterSessionListener err, code: ${error.code}, message: ${error.message}`);
      }
    }
  }

  public async updatePlayState(isPlay: boolean, currentTime: number): Promise<void> {
    if (!this.session) {
      return;
    }

    try {
      let playbackState: avSession.AVPlaybackState = {
        state: isPlay ? avSession.PlaybackState.PLAYBACK_STATE_PLAY : avSession.PlaybackState.PLAYBACK_STATE_PAUSE,
        position: {
          elapsedTime: currentTime,
          updateTime: new Date().getTime(),
        },
      };

      await this.session.setAVPlaybackState(playbackState);
      Logger.info(TAG, 'updatePlayState successfully');
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `updatePlayState error, code: ${err.code}, message: ${err.message}`);
    }
  }

  public async updatePosition(currentTime: number): Promise<void> {
    if (!this.session) {
      return;
    }

    try {
      let playbackState: avSession.AVPlaybackState = {
        position: {
          elapsedTime: currentTime,
          updateTime: new Date().getTime(),
        },
      };

      await this.session.setAVPlaybackState(playbackState);
      Logger.info(TAG, 'updatePosition successfully');
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `updatePosition error, code: ${err.code}, message: ${err.message}`);
    }
  }

  public async setMetadata(songItem: SongItem, duration: number): Promise<void> {
    if (!this.session || !this.context) {
      return;
    }
    let mediaImage: image.PixelMap | undefined;
    try {
      mediaImage = await MediaTools.getPixelMapFromResource(this.context, songItem.label);

      let title = await this.getResourceStringName(songItem.title);
      let artist = await this.getResourceStringName(songItem.singer);

      let metadata: avSession.AVMetadata = {
        assetId: songItem.id,
        title: title,
        artist: artist,
        mediaImage: mediaImage,
        duration: duration,
      };

      await this.session.setAVMetadata(metadata);
      Logger.info(TAG, 'setMetadata successfully');
    } catch (error) {
      Logger.error(TAG, `setMetadata error: ${error.code}, message is ${error.message}`);
    } finally {
      if (mediaImage) {
        try {
          await mediaImage.release();
        } catch (e) {
          Logger.error(TAG, `mediaImage release error: ${e.code}, ${e.message}`);
        }

      }
    }
  }

  private async getResourceStringName(stringValue: string): Promise<string> {
    if (!this.context) {
      return stringValue;
    }

    const replaceName: string = stringValue.replace('app.string.', '');
    try {
      const value = await this.context.resourceManager.getStringByName(replaceName);
      return value;
    } catch (error) {
      Logger.error(TAG, `getResourceStringName error: ${error.code}, message is ${error.message}`);
      return stringValue;
    }
  }

  public async destroy(): Promise<void> {
    if (this.session) {
      this.unregisterSessionListener();
      try {
        await this.session.destroy();
        this.session = undefined;
        Logger.info(TAG, 'AVSession destroy successfully');
      } catch (error) {
        Logger.error(TAG, 'AVSession destroy error: ' + error);
      }
    }
  }
}