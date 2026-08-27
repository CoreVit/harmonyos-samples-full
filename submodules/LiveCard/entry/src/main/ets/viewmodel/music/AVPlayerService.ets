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

import { media } from '@kit.MediaKit';
import { common } from '@kit.AbilityKit';
import type { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '../../utils/Logger';
import { AudioPlayerState } from '../../model/music/MusicData';
import { resourceManager } from '@kit.LocalizationKit';

const TAG = 'AVPlayerService';

export class PlayerStateData {
  public state: AudioPlayerState = AudioPlayerState.IDLE;
  public isPrepared: boolean = false;
  public currentTime: number = 0;
  public duration: number = 0;
}

export class AVPlayerService {
  private static instance: AVPlayerService | undefined;
  private context: common.UIAbilityContext | undefined = undefined;
  private avPlayer?: media.AVPlayer;

  private state: AudioPlayerState = AudioPlayerState.IDLE;
  private isPrepared: boolean = false;
  private isFirstLoadAsset: boolean = true;

  private stateChangeCallback?: (state: PlayerStateData) => void;
  private timeUpdateCallback?: (currentTime: number, duration: number) => void;
  private errorCallback?: (error: BusinessError) => void;
  private seekDoneCallback?: (seekTime: number) => void;

  private avPlayerSeekDoneCall = (seekDoneTime: number): void => {
    Logger.info(TAG, `avPlayerSeekDoneCall seek succeeded, seek time is ${seekDoneTime}`);
    if (this.seekDoneCallback) {
      this.seekDoneCallback(seekDoneTime);
    }
  };

  private avPlayerErrorCall = (error: BusinessError): void => {
    Logger.error(TAG, `avPlayerErrorCall error, code is ${error.code}, message is ${error.message}`);
    this.state = AudioPlayerState.ERROR;
    if (this.errorCallback) {
      this.errorCallback(error);
    }
    this.reset();
  };

  private avPlayerTimeUpdateCall = (updateTime: number): void => {
    if (this.timeUpdateCallback) {
      this.timeUpdateCallback(updateTime, this.getDuration());
    }
  };
  private avPlayerStateChangeCall = (state: string): void => {
    Logger.info(TAG, `avPlayerStateChangeCall state: ${state}`);

    switch (state) {
      case 'idle':
        this.state = AudioPlayerState.IDLE;
        this.isPrepared = false;
        this.notifyStateChange();
        break;
      case 'initialized':
        this.state = AudioPlayerState.INITIALIZED;
        this.notifyStateChange();
        this.prepare();
        break;
      case 'prepared':
        this.state = AudioPlayerState.PREPARED;
        this.isPrepared = true;
        this.notifyStateChange();
        break;
      case 'playing':
        if (this.isFirstLoadAsset) {
          this.isFirstLoadAsset = false;
        }
        this.state = AudioPlayerState.PLAY;
        this.notifyStateChange();
        break;
      case 'paused':
        this.state = AudioPlayerState.PAUSE;
        this.notifyStateChange();
        break;
      case 'completed':
        this.state = AudioPlayerState.COMPLETED;
        this.notifyStateChange();
        break;
      case 'stopped':
        this.state = AudioPlayerState.STOP;
        this.notifyStateChange();
        this.reset();
        break;
      case 'error':
        this.state = AudioPlayerState.ERROR;
        this.notifyStateChange();
        break;
      case 'released':
        this.state = AudioPlayerState.RELEASED;
        this.notifyStateChange();
        break;
      default:
        this.state = AudioPlayerState.UNKNOWN;
        this.notifyStateChange();
        break;
    }
  };

  public static getInstance(): AVPlayerService {
    if (!AVPlayerService.instance) {
      AVPlayerService.instance = new AVPlayerService();
    }
    return AVPlayerService.instance;
  }

  public static resetInstance(): void {
    AVPlayerService.instance = undefined;
  }

  public setContext(context: common.UIAbilityContext): void {
    this.context = context;
  }

  public setStateChangeCallback(callback: (state: PlayerStateData) => void): void {
    this.stateChangeCallback = callback;
  }

  public setTimeUpdateCallback(callback: (currentTime: number, duration: number) => void): void {
    this.timeUpdateCallback = callback;
  }

  public setErrorCallback(callback: (error: BusinessError) => void): void {
    this.errorCallback = callback;
  }

  public setSeekDoneCallback(callback: (seekTime: number) => void): void {
    this.seekDoneCallback = callback;
  }

  public async initialize(url: resourceManager.RawFileDescriptor | undefined): Promise<void> {
    Logger.info(TAG, 'initialize');

    if (!this.context) {
      Logger.error(TAG, 'context is undefined');
      return;
    }

    try {
      if (!this.avPlayer) {
        this.avPlayer = await media.createAVPlayer();
      }
      this.setAVPlayerCallback();
      this.loadAssetByFd(url);
      Logger.info(TAG, 'initialize success');
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `initialize error, code: ${err.code}, message: ${err.message}`);
    }
  }

  private setAVPlayerCallback(): void {
    if (this.avPlayer) {
      this.avPlayer.on('seekDone', this.avPlayerSeekDoneCall);
      this.avPlayer.on('error', this.avPlayerErrorCall);
      this.avPlayer.on('timeUpdate', this.avPlayerTimeUpdateCall);
      this.avPlayer.on('stateChange', this.avPlayerStateChangeCall);
    }
  }

  loadAssetByFd(url: resourceManager.RawFileDescriptor | undefined): void {
    if (url === undefined) {
      return;
    }
    if (url && this.avPlayer) {
      let avFileDescriptor: media.AVFileDescriptor = {
        fd: url.fd,
        offset: url.offset,
        length: url.length
      };
      this.avPlayer.fdSrc = avFileDescriptor;
      Logger.info(TAG, 'loadAssetByFd success');
    }
  }

  public play(): void {
    if (!this.isPrepared) {
      this.prepare();
      return;
    }

    if (this.avPlayer) {
      this.avPlayer.play()
        .then(() => {
          Logger.info(TAG, 'AVPlayer play successfully');
        })
        .catch((error: BusinessError) => {
          Logger.error(TAG, `AVPlayer play failed, code: ${error.code}, message: ${error.message}`);
        });
    }
  }

  public pause(): void {
    if (this.isPrepared && this.state === AudioPlayerState.PLAY && this.avPlayer) {
      this.avPlayer.pause()
        .then(() => {
          Logger.info(TAG, 'AVPlayer pause successfully');
        })
        .catch((error: BusinessError) => {
          Logger.error(TAG, `AVPlayer pause failed, code: ${error.code}, message: ${error.message}`);
        });
    }
  }

  public seek(ms: number): void {
    if (this.isPrepared && this.state !== AudioPlayerState.ERROR && this.avPlayer) {
      let seekMode = this.getCurrentTime() < ms ? 0 : 1;
      let realTime = ms <= 0 ? 0 : ms >= this.getDuration() ? this.getDuration() : ms;
      this.avPlayer.seek(realTime, seekMode);
    }
  }

  public async stop(): Promise<void> {
    if (this.isPrepared && this.avPlayer) {
      this.state = AudioPlayerState.PAUSE;
      try {
        await this.avPlayer.stop();
        Logger.info(TAG, 'AVPlayer stop succeeded');
      } catch (error) {
        Logger.error(TAG, 'AVPlayer stop error: ' + error);
      }
    }
  }

  private reset(): void {
    if (this.avPlayer) {
      this.avPlayer.reset()
        .then(() => {
          Logger.info(TAG, 'AVPlayer reset successfully');
        })
        .catch((error: BusinessError) => {
          Logger.error(TAG, `AVPlayer reset failed, code: ${error.code}, message: ${error.message}`);
        });
    }
  }

  private prepare(): void {
    if (this.avPlayer) {
      this.avPlayer.prepare()
        .then(() => {
          Logger.info(TAG, 'AVPlayer prepare successfully');
        })
        .catch((error: BusinessError) => {
          Logger.error(TAG, `AVPlayer prepare failed, code: ${error.code}, message: ${error.message}`);
        });
    }
  }

  public async release(): Promise<void> {
    if (this.avPlayer) {
      try {
        this.removeAVPlayerCallback();
        await this.avPlayer.release();
        this.state = AudioPlayerState.RELEASED;
        this.notifyStateChange();
        Logger.info(TAG, 'AVPlayer release successfully');
      } catch (error) {
        Logger.error(TAG, 'AVPlayer release error: ' + error);
      } finally {
        this.avPlayer = undefined;
      }
    }
  }

  private removeAVPlayerCallback(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.off('seekDone');
        this.avPlayer.off('error');
        this.avPlayer.off('timeUpdate');
        this.avPlayer.off('stateChange');
      } catch (err) {
        Logger.error(TAG, `removeAVPlayerCallback err: ${err.code}, ${err.message}`);
      }
    }
  }

  public getCurrentTime(): number {
    if (this.isPrepared && this.avPlayer) {
      return this.avPlayer.currentTime;
    }
    return 0;
  }

  public getDuration(): number {
    if (this.isPrepared && this.avPlayer) {
      return this.avPlayer.duration;
    }
    return 0;
  }

  public getState(): AudioPlayerState {
    return this.state;
  }

  public isPlayerPrepared(): boolean {
    return this.isPrepared;
  }

  private notifyStateChange(): void {
    if (this.stateChangeCallback) {
      let data = new PlayerStateData();
      data.state = this.state;
      data.isPrepared = this.isPrepared;
      data.currentTime = this.getCurrentTime();
      data.duration = this.getDuration();
      this.stateChangeCallback(data);
    }
  }

  public getAvPlayer(): media.AVPlayer | undefined {
    return this.avPlayer;
  }
}