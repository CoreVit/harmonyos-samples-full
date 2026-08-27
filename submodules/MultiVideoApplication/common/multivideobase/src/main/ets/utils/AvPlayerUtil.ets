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
import { common } from '@kit.AbilityKit';
import { resourceManager } from '@kit.LocalizationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from './Logger';
import { CommonConstants } from '../constants/CommonConstants';

const TAG = '[AvPlayerUtil]';

export class AvPlayerUtil {
  private static instance?: AvPlayerUtil;
  private avPlayer?: media.AVPlayer;
  private context: common.UIAbilityContext;
  private url: resourceManager.RawFileDescriptor | null = null;
  private sourceName: string = CommonConstants.PRODUCT_VIDEO_NAME;
  private hasFdSrc: boolean = false;
  private surfaceId: string = '';
  private sliderBegin: number = 0;
  private isMoving: boolean = false;
  private currentTime: string = '00:00:00';
  private updateTime: number = 0;
  private totalTime: string = '00:00:00';
  private progress: number = 0;
  private avplayerState: string = '';
  private stateChangeListeners: Set<() => void> = new Set();

  addStateChangeListener(listener: () => void): void {
    this.stateChangeListeners.add(listener);
  }

  removeStateChangeListener(listener: () => void): void {
    this.stateChangeListeners.delete(listener);
  }

  getCurrentTime(): string {
    return this.currentTime;
  }

  getUpdateTime(): number {
    return this.updateTime;
  }

  getTotalTime(): string {
    return this.totalTime;
  }

  getProgress(): number {
    return this.progress;
  }

  getAvplayerState(): string {
    return this.avplayerState;
  }

  private notifyStateChanged(): void {
    this.stateChangeListeners.forEach((listener: () => void) => {
      listener();
    });
  }

  private async closeRawFd() {
    if (!this.url) {
      return;
    }
    try {
      await this.context.resourceManager.closeRawFd(this.sourceName);
    } catch (error) {
      Logger.error(TAG, `closeRawFd failed, errCode = ${error.code}, errMessage = ${error.message}.`);
    } finally {
      this.url = null;
      this.hasFdSrc = false;
    }
  }

  private async reloadFdSrc(): Promise<void> {
    if (!this.avPlayer) {
      Logger.warn(TAG, `AvPlayer is undefined.`);
      return;
    }
    await this.closeRawFd();
    try {
      this.url = await this.context.resourceManager.getRawFd(this.sourceName);
      this.avPlayer.fdSrc = this.url;
      this.hasFdSrc = true;
    } catch (error) {
      Logger.error(TAG, `getRawFd failed, errCode = ${error.code}, errMessage = ${error.message}.`);
    }
  }
  private onError: (err: BusinessError) => void = (error: BusinessError) => {
    Logger.error(TAG, `Invoke avPlayer failed, errCode = ${error.code}, errMessage = ${error.message}.`);
    this.hasFdSrc = false;
    this.url = null;
    this.avPlayer?.reset().catch((error: BusinessError) => {
      Logger.error(TAG, `reset failed, errCode = ${error.code}, errMessage = ${error.message}.`);
    });
  };
  private onTimeUpdateFunction: (updateTime: number) => void = (updateTime: number) => {
    this.currentTime = this.formatTime(updateTime);
    this.updateTime = updateTime;
    if (this.avPlayer !== undefined) {
      if (this.avPlayer.duration !== 0) {
        this.progress = updateTime / this.avPlayer.duration * CommonConstants.PROGRESS_HUNDRED;
      } else {
        this.progress = 0;
      }
    }
    this.notifyStateChanged();
  };
  private onStateChange: (state: media.AVPlayerState) => void = async (state: media.AVPlayerState) => {
    if (!this.avPlayer) {
      Logger.warn(TAG, `AvPlayer is undefined.`);
      return;
    }
    switch (state) {
      case CommonConstants.AV_PLAYER_IDLE_STATE:
        try {
          if (!this.hasFdSrc || !this.url) {
            await this.reloadFdSrc();
          } else {
            Logger.info(TAG, `AVPlayer fdSrc already loaded, skip reload.`);
          }
          Logger.info(TAG, `AVPlayer state idle called.`);
        } catch (error) {
          Logger.error(TAG, `getRawFd failed, errCode = ${error.code}, errMessage = ${error.message}.`);
        }
        break;
      case CommonConstants.AV_PLAYER_INITIALIZED_STATE:
        Logger.info(TAG, `AVPlayer initialized called.`);
        this.avPlayer.surfaceId = this.surfaceId;
        this.avPlayer.prepare().catch((error: BusinessError) => {
          Logger.error(TAG, `prepare failed, errCode = ${error.code}, errMessage = ${error.message}.`);
          return this.avPlayer?.reset().catch((error: BusinessError) => {
            Logger.error(TAG, `reset failed, errCode = ${error.code}, errMessage = ${error.message}.`);
          });
        }).then(() => {
          Logger.info(TAG, `AVPlayer prepare succeeded.`);
        });
        break;
      case CommonConstants.AV_PLAYER_PREPARED_STATE:
        this.avPlayer.videoScaleType = media.VideoScaleType.VIDEO_SCALE_TYPE_FIT;
        Logger.info(TAG, `AVPlayer state prepared called.`);
        this.avPlayer.play().catch((error: BusinessError) => {
          Logger.error(TAG, `play failed, errCode = ${error.code}, errMessage = ${error.message}.`);
        });
        this.totalTime = this.formatTime(this.avPlayer.duration);
        this.notifyStateChanged();
        break;
      case CommonConstants.AV_PLAYER_PLAYING_STATE:
        Logger.info(TAG, `AVPlayer state playing called.`);
        this.avplayerState = this.avPlayer.state;
        this.notifyStateChanged();
        break;
      case CommonConstants.AV_PLAYER_PAUSED_STATE:
        Logger.info(TAG, `AVPlayer state paused called.`);
        this.avplayerState = this.avPlayer.state;
        this.notifyStateChanged();
        break;
      case CommonConstants.AV_PLAYER_COMPLETED_STATE:
        Logger.info(TAG, `AVPlayer state completed called.`);
        this.avplayerState = this.avPlayer.state;
        this.notifyStateChanged();
        this.avPlayer.stop().catch((error: BusinessError) => {
          Logger.error(TAG, `stop failed, errCode = ${error.code}, errMessage = ${error.message}.`);
        });
        break;
      case CommonConstants.AV_PLAYER_STOPPED_STATE:
        Logger.info(TAG, `AVPlayer state stopped called.`);
        break;
      case CommonConstants.AV_PLAYER_RELEASE_STATE:
        Logger.info(TAG, `AVPlayer state released called.`);
        break;
      case CommonConstants.AV_PLAYER_ERROR_STATE:
        Logger.error(TAG, `AVPlayer state error called.`);
        this.hasFdSrc = false;
        this.url = null;
        this.avPlayer?.reset().catch((error: BusinessError) => {
          Logger.error(TAG, `reset failed, errCode = ${error.code}, errMessage = ${error.message}.`);
        });
        break;
      default:
        Logger.info(TAG, `AVPlayer state unknown called.`);
        break;
    }
  };

  constructor(uiContext: UIContext) {
    this.context = uiContext.getHostContext() as common.UIAbilityContext;
  }

  static getInstance(uiContext: UIContext): AvPlayerUtil | undefined {
    if (!AvPlayerUtil.instance) {
      AvPlayerUtil.instance = new AvPlayerUtil(uiContext);
    } else {
      AvPlayerUtil.instance.context = uiContext.getHostContext() as common.UIAbilityContext;
    }
    return AvPlayerUtil.instance;
  }

  async createAvPlayer(surfaceId: string, sourceName: string): Promise<void> {
    if (!this.avPlayer || this.avPlayer.state === CommonConstants.AV_PLAYER_RELEASE_STATE) {
      try {
        await this.closeRawFd();
        this.avPlayer = await media.createAVPlayer();
        this.surfaceId = surfaceId;
        this.sourceName = sourceName || CommonConstants.PRODUCT_VIDEO_NAME;
        Logger.info(TAG, `Created AvPlayer successfully.`);
        await this.reloadFdSrc();
        this.setAVPlayerCallback();
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `createAVPlayer failed, errCode = ${err.code}, errMessage = ${err.message}.`);
      }

    } else {
      Logger.info(TAG, `AvPlayer has been created.`);
    }
  }

  setAVPlayerCallback(): void {
    if (!this.avPlayer) {
      Logger.warn(TAG, `Avplayer is undefined.`);
      return;
    }
    this.avPlayer.on('error', this.onError);
    this.onTimeUpdate();
    this.setStateChange();
  }

  onTimeUpdate(): void {
    if (!this.avPlayer) {
      Logger.warn(TAG, `Avplayer is undefined.`);
      return;
    }
    this.avPlayer.on('timeUpdate', this.onTimeUpdateFunction);
  }

  offTimeUpdate(): void {
    if (!this.avPlayer) {
      Logger.warn(TAG, `Avplayer is undefined.`);
      return;
    }
    try {
      this.avPlayer.off('timeUpdate');
    } catch (exception) {
      Logger.error(TAG, `Failed to off timeUpdate.`);
    }
  }

  setStateChange(): void {
    if (!this.avPlayer) {
      Logger.warn(TAG, `Avplayer is undefined.`);
      return;
    }
    this.avPlayer.on('stateChange', this.onStateChange);
  }

  release(): void {
    this.offTimeUpdate();
    if (this.avPlayer && this.avPlayer.state !== CommonConstants.AV_PLAYER_RELEASE_STATE) {
      try {
        this.avPlayer.off('error');
        this.avPlayer.off('stateChange');
      } catch (exception) {
        Logger.error(TAG, `Failed to off error or stateChange.`);
      }
      this.avPlayer.release().catch((error: BusinessError) => {
        Logger.error(TAG, `release failed, errCode = ${error.code}, errMessage = ${error.message}.`);
      });
      this.avPlayer = undefined;
      this.closeRawFd().catch((error: BusinessError) => {
        Logger.error(TAG, `closeRawFd failed, errCode = ${error.code}, errMessage = ${error.message}.`);
      });
      this.avplayerState = CommonConstants.AV_PLAYER_RELEASE_STATE;
      this.notifyStateChanged();
    } else {
      Logger.warn(TAG, `AvPlayer release failed.`);
    }
  }

  sliderChange(value: number, mode: SliderChangeMode): void {
    if (!this.avPlayer) {
      Logger.warn(TAG, `Avplayer is undefined.`);
      return;
    }
    let seekType: media.SeekMode = value > this.sliderBegin ? media.SeekMode.SEEK_PREV_SYNC :
      media.SeekMode.SEEK_NEXT_SYNC;
    switch (mode) {
      case SliderChangeMode.Begin:
        Logger.info(TAG, `AvPlayer SliderChangeMode Begin.`);
        this.sliderBegin = value;
        this.avPlayer.pause().catch((error: BusinessError) => {
          Logger.error(TAG, `pause failed, errCode = ${error.code}, errMessage = ${error.message}.`);
        });
        break;
      case SliderChangeMode.Moving:
        Logger.info(TAG, `AvPlayer SliderChangeMode Moving.`);
        this.isMoving = true;
        break;
      case SliderChangeMode.End:
        Logger.info(TAG, `AvPlayer SliderChangeMode End.`);
        if (this.isMoving) {
          this.avPlayer.seek(value / CommonConstants.PROGRESS_HUNDRED * this.avPlayer.duration, seekType);
          this.isMoving = false;
        }
        this.avPlayer.play().catch((error: BusinessError) => {
          Logger.error(TAG, `play failed, errCode = ${error.code}, errMessage = ${error.message}.`);
        });
        break;
      case SliderChangeMode.Click:
        Logger.info(TAG, `AvPlayer SliderChangeMode Click.`);
        this.avPlayer.seek(this.sliderBegin / CommonConstants.PROGRESS_HUNDRED * this.avPlayer.duration, seekType);
        break;
      default:
        break;
    }
  }

  playerStateControl(): void {
    if (!this.avPlayer) {
      Logger.warn(TAG, `Avplayer is undefined.`);
      return;
    }
    if (this.avPlayer.state === CommonConstants.AV_PLAYER_STOPPED_STATE) {
      this.avPlayer.prepare().catch((error: BusinessError) => {
        Logger.error(TAG, `prepare failed, errCode = ${error.code}, errMessage = ${error.message}.`);
      });
    } else if (this.avPlayer.state === CommonConstants.AV_PLAYER_PAUSED_STATE) {
      this.avPlayer.play().catch((error: BusinessError) => {
        Logger.error(TAG, `play failed, errCode = ${error.code}, errMessage = ${error.message}.`);
      });
    } else if (this.avPlayer.state === CommonConstants.AV_PLAYER_PLAYING_STATE) {
      this.avPlayer.pause().catch((error: BusinessError) => {
        Logger.error(TAG, `pause failed, errCode = ${error.code}, errMessage = ${error.message}.`);
      });
    }
  }

  fastForward(): void {
    if (!this.avPlayer) {
      Logger.warn(TAG, `Avplayer is undefined.`);
      return;
    }
    if (this.avPlayer.state === CommonConstants.AV_PLAYER_PLAYING_STATE || this.avPlayer.state ===
    CommonConstants.AV_PLAYER_PAUSED_STATE) {
      this.avPlayer.seek(this.avPlayer.currentTime + CommonConstants.SEEK_STEP_MILLISECONDS);
    }
  }

  rewind(): void {
    if (!this.avPlayer) {
      Logger.warn(TAG, `Avplayer is undefined.`);
      return;
    }
    if (this.avPlayer.state === CommonConstants.AV_PLAYER_PLAYING_STATE || this.avPlayer.state ===
    CommonConstants.AV_PLAYER_PAUSED_STATE) {
      this.avPlayer.seek(this.avPlayer.currentTime - CommonConstants.SEEK_STEP_MILLISECONDS);
    }
  }

  formatTime(duration: number): string {
    let totalSecond: number = Math.round(duration / CommonConstants.PROGRESS_THOUSAND);
    let hourNum: number = Math.floor(totalSecond / CommonConstants.SECOND_IN_HOUR);
    let minNum: number = Math.floor((totalSecond % CommonConstants.SECOND_IN_HOUR) / CommonConstants.SECOND_IN_MINUTE);
    let secNum: number = (totalSecond % CommonConstants.SECOND_IN_HOUR) % CommonConstants.SECOND_IN_MINUTE;
    return this.formatUnitTime(hourNum) + CommonConstants.COLON + this.formatUnitTime(minNum) + CommonConstants.COLON +
    this.formatUnitTime(secNum);
  }

  formatUnitTime(time: number): string {
    const normalizedTime: number = Math.max(CommonConstants.ZERO, Math.floor(time));
    if (normalizedTime < CommonConstants.TEN) {
      return CommonConstants.TIME_PREFIX.concat(normalizedTime.toString());
    }
    return normalizedTime.toString();
  }
}