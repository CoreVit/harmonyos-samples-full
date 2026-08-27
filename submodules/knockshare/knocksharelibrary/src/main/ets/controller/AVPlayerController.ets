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

import { BusinessError } from '@kit.BasicServicesKit';
import { media } from '@kit.MediaKit';
import { common } from '@kit.AbilityKit';
import Logger from '../utils/Logger';

const TAG = '[KnockShareSample]';

@Observed
export class AVPlayerController {
  // Video play state
  @Track public state: string = 'default';
  @Track public durationTime: number = 0;
  @Track public currentTime: number = 0;
  // Is user drag or click progress slider
  public isSliderAction: boolean = false;
  private avPlayer: media.AVPlayer;
  private surfaceID: string;
  private fileName: string = '';

  private constructor(avPlayer: media.AVPlayer, surfaceID: string) {
    this.surfaceID = surfaceID;
    this.avPlayer = avPlayer;
  }

  /**
   * Build an AVPlayerController
   * @param surfaceID surface id
   * @param resource Video resource.
   * @returns AVPlayerController object.
   */
  static async create(surfaceID: string, resource: string, context: common.UIAbilityContext) {
    if (surfaceID === '' || !resource || resource === '') {
      return;
    }
    try {
      const avPlayer = await media.createAVPlayer();
      let avPlayerController = new AVPlayerController(avPlayer, surfaceID);
      await avPlayerController.avPlayerLocal(resource, context);
      return avPlayerController;
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `AVPlayerController create failed, error code: ${err.code}, message: ${err.message}`);
      return undefined;
    }
  }

  /**
   * Register the callback function for AVPlayer.
   */
  private setAVPlayerCallback() {
    try {
      this.avPlayer.on('timeUpdate', (currentTime: number) => {
        if (!this.isSliderAction) {
          this.currentTime = currentTime;
        }
      })
      this.avPlayer.on('durationUpdate', (duration: number) => {
        this.durationTime = duration;
      })
      this.avPlayer.on('error', (err: BusinessError) => {
        Logger.error(TAG, `Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`);
        this.avPlayer.reset();
      });
      // State machine change callback function
      this.avPlayer.on('stateChange', async (state: string) => {
        this.state = state;
        switch (state) {
          case 'idle':
            Logger.info(TAG, 'AVPlayer state idle called.');
            break;
          case 'initialized':
            // Automatically call prepare after initialization.
            Logger.info(TAG, 'AVPlayer state initialized called.');
            this.avPlayer.surfaceId = this.surfaceID;
            this.avPlayer.prepare();
            break;
          case 'prepared':
            // Automatically start playing after the prepare call succeeds.
            Logger.info(TAG, 'AVPlayer state prepared called.');
            this.avPlayer.play();
            break;
          case 'playing':
            Logger.info(TAG, 'AVPlayer state playing called.');
            break;
          case 'paused':
            Logger.info(TAG, 'AVPlayer state paused called.');
            break;
          case 'completed':
            Logger.info(TAG, 'AVPlayer state completed called.');
            this.avPlayer.stop();
            break;
          case 'stopped':
            Logger.info(TAG, 'AVPlayer state stopped called.');
            this.avPlayer.reset();
            break;
          case 'released':
            Logger.info(TAG, 'AVPlayer state released called.');
            break;
          default:
            Logger.info(TAG, 'AVPlayer state unknown called.');
            break;
        }
      });
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `setAVPlayerCallback failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  /**
   * Configures AVPlayer for local file playback.
   * @param fileName The name/path of the local media file.
   */
  private async avPlayerLocal(fileName: string, context: common.UIAbilityContext) {
    if (fileName === '') {
      return;
    }
    try {
      this.fileName = fileName;
      this.setAVPlayerCallback();
      let fileDescriptor = await context.resourceManager.getRawFd(fileName);
      let avFileDescriptor: media.AVFileDescriptor =
        { fd: fileDescriptor.fd, offset: fileDescriptor.offset, length: fileDescriptor.length };
      this.avPlayer.fdSrc = avFileDescriptor;
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `AVPlayerController avPlayerLocal error, code: ${err.code}, message: ${err.message}`);
    }
  }

  /**
   * Seek in the video
   * @param timeMs seek time
   * @param mode seek mode
   */
  public async avPlayerSeek(timeMs: number, mode: media.SeekMode) {
    const validSeekStates = ['prepared', 'playing', 'paused', 'completed'];
    if (!validSeekStates.includes(this.state)) {
      Logger.info(TAG, `avPlayerSeek error,this state is ${this.state}`);
    } else {
      this.avPlayer.seek(timeMs, mode);
    }
  }

  public async setAVPlayerPlaying() {
    try {
      const validPlayingStates = ['prepared', 'paused', 'completed'];
      if (validPlayingStates.includes(this.state)) {
        await this.avPlayer.play();
      } else {
        Logger.error(TAG, `setAVPlayerPlaying error,this state is ${this.state}`);
      }
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `AVPlayerController avPlayerLocal, code: ${err.code}, message: ${err.message}}`);
    }
  }

  public async setAVPlayerPause() {
    try {
      if (this.state === 'playing') {
        await this.avPlayer.pause();
      }
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `AVPlayerController setAVPlayerPause error, code: ${err.code}, message: ${err.message}`);
    }
  }

  public async releasePlayer(context: common.UIAbilityContext) {
    try {
      if (this.fileName !== '') {
        context.resourceManager.closeRawFdSync(this.fileName);
        this.fileName = '';
      }
      Logger.info(TAG, 'releasePlayer success');
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `AVPlayerController close fd error, code: ${err.code}, message: ${err.message}`);
    } finally {
      this.avPlayer.off('timeUpdate');
      this.avPlayer.off('durationUpdate');
      this.avPlayer.off('error');
      this.avPlayer.off('stateChange');
      if (this.avPlayer) {
        try {
          await this.avPlayer.release();
        } catch (error) {
          const err = error as BusinessError;
          Logger.error(TAG, `AVPlayerController release error, code: ${err.code}, message: ${err.message}`);
        }
      }
    }
  }
}