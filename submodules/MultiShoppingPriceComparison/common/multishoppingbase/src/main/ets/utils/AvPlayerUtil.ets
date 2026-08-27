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

import { media } from '@kit.MediaKit';
import { resourceManager } from '@kit.LocalizationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from './Logger';
import { abilityScopedAppStorageKey } from './AbilityStorageKey';

export class AvPlayerUtil {
  private avPlayer?: media.AVPlayer;
  private url: resourceManager.RawFileDescriptor | null = null;
  private playState: boolean = true;
  private surfaceId: string = '';
  private static readonly avPlayerUtilKey: string = 'MultiShoppingAvPlayerUtil';
  private static readonly liveVideoName: string = 'live.mp4';
  private onError: (err: BusinessError) => void = (err: BusinessError) => {
    Logger.error(`Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`);
    if (this.avPlayer === undefined) {
      Logger.error('AvPlayer is undefined');
      return;
    }
    this.avPlayer.reset();
  };
  private onStateChange: (state: media.AVPlayerState) => void;
  private uiContext: UIContext | undefined = undefined;

  constructor(uiContext: UIContext) {
    this.uiContext = uiContext;
    this.onStateChange = async (state: media.AVPlayerState) => {
      if (this.avPlayer === undefined) {
        Logger.error('AvPlayer is undefined');
        return;
      }
      switch (state) {
        case 'idle':
          this.url = await uiContext!.getHostContext()!.resourceManager.getRawFd(AvPlayerUtil.liveVideoName);
          this.avPlayer.fdSrc = this.url;
          Logger.info('AVPlayer state idle called.');
          break;
        case 'initialized':
          Logger.info('AVPlayer initialized called.');
          this.avPlayer.surfaceId = this.surfaceId;
          this.avPlayer.prepare().then(() => {
            Logger.info('AVPlayer prepare succeeded.');
          }, (err: BusinessError) => {
            Logger.error(`Invoke prepare failed, code is ${err.code}, message is ${err.message}`);
            if (this.avPlayer === undefined) {
              Logger.error('AvPlayer is undefined');
              return;
            }
            this.avPlayer.reset();
          });
          break;
        case 'prepared':
          this.avPlayer.videoScaleType = media.VideoScaleType.VIDEO_SCALE_TYPE_FIT;
          Logger.info('AVPlayer state prepared called.');
          this.avPlayer.play();
          break;
        case 'playing':
          Logger.info('AVPlayer state playing called.');
          this.playState = true;
          break;
        case 'paused':
          Logger.info('AVPlayer state paused called.');
          this.playState = false;
          break;
        case 'completed':
          Logger.info('AVPlayer state completed called.');
          this.playState = false;
          this.avPlayer.stop();
          break;
        case 'stopped':
          Logger.info('AVPlayer state stopped called.');
          break;
        case 'released':
          Logger.info('AVPlayer state released called.');
          break;
        case 'error':
          Logger.error('AVPlayer state error called.');
          break;
        default:
          Logger.info('AVPlayer state unknown called.');
          break;
      }
    };
  }

  static getAvPlayerUtil(uiContext: UIContext): AvPlayerUtil | undefined {
    const key = abilityScopedAppStorageKey(uiContext, AvPlayerUtil.avPlayerUtilKey);
    if (!AppStorage.get<AvPlayerUtil>(key)) {
      AppStorage.setOrCreate(key, new AvPlayerUtil(uiContext));
    }
    return AppStorage.get<AvPlayerUtil>(key);
  }

  async createAvPlayer(surfaceId: string): Promise<void> {
    try {
      const playerDead: boolean = this.avPlayer === undefined || this.avPlayer.state === 'released';
      if (!playerDead) {
        if (this.surfaceId === surfaceId) {
          Logger.info('AvPlayer has been created');
          return;
        }
        this.release();
        this.avPlayer = undefined;
      }
      this.surfaceId = surfaceId;
      this.avPlayer = await media.createAVPlayer();
      Logger.info('Created AvPlayer successfully.');
      this.url = await this.uiContext!.getHostContext()!.resourceManager.getRawFd(AvPlayerUtil.liveVideoName);
      this.avPlayer.fdSrc = this.url;
      this.setAVPlayerCallback();
    } catch (error) {
      Logger.error(`createAvPlayer catch error, code: ${error.code}, message: ${error.message}`);
    }
  }

  setAVPlayerCallback(): void {
    if (this.avPlayer === undefined) {
      Logger.error('AvPlayer is undefined');
      return;
    }
    this.avPlayer.on('error', this.onError);
    this.setStateChange();
  }

  setStateChange(): void {
    if (this.avPlayer === undefined) {
      Logger.error('AvPlayer is undefined');
      return;
    }
    this.avPlayer.on('stateChange', this.onStateChange);
  }

  release(): void {
    if (this.avPlayer !== undefined && this.avPlayer.state !== 'released') {
      try {
        this.avPlayer.off('error');
        this.avPlayer.off('stateChange');
        this.avPlayer.release();
      } catch (exception) {
        Logger.error('Failed to unregister the error and state callback. Code: ' + JSON.stringify(exception));
      }
    } else {
      Logger.info('AvPlayer release failed');
    }
  }

  playerStateControl(): void {
    try {
      if (this.avPlayer === undefined) {
        Logger.error('AvPlayer is undefined');
        return;
      }
      if (this.avPlayer.state === 'stopped') {
        this.avPlayer.prepare();
        return;
      }
      if (!this.playState) {
        this.avPlayer.play();
      } else {
        this.avPlayer.pause();
      }
    } catch (exception) {
      Logger.error('Failed to playerStateControl. Code: ' + JSON.stringify(exception));
    }
  }

  play(): void {
    try {
      if (this.avPlayer !== undefined && !this.playState) {
        this.avPlayer.play();
      } else {
        Logger.info('AvPlayer play failed');
      }
    } catch (exception) {
      Logger.error('Failed to play. Code: ' + JSON.stringify(exception));
    }
  }

  pause(): void {
    try {
      if (this.avPlayer !== undefined && this.playState) {
        this.avPlayer.pause();
      } else {
        Logger.info('AvPlayer pause failed');
      }
    } catch (exception) {
      Logger.error('Failed to pause. Code: ' + JSON.stringify(exception));
    }
  }
}
