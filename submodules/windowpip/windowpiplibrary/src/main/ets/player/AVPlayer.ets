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
import { BusinessError } from '@kit.BasicServicesKit';
import { resourceManager } from '@kit.LocalizationKit';
import { media } from '@kit.MediaKit';
import Logger from '../utils/Logger';

const TAG: string = '[AVPlayer]';

export class AVPlayer {
  // It is used to distinguish between the player of the main interface and the player of the pip interface.
  public type: number = 0;
  private avPlayer?: media.AVPlayer;
  // The surfaceID is used to display the screen.
  private surfaceID: string;
  private jumpNext: boolean = false;
  private state: string = '';
  private playStatus: boolean = true;
  private context: Context;

  constructor(surfaceID: string, type: number, context: Context) {
    this.surfaceID = surfaceID;
    this.type = type;
    this.context = context;
  }

  updatePlayStatus(status: boolean): void {
    this.playStatus = status;
  }

  // Register the avplayer callback function.
  setAVPlayerCallback(): void {
    // Callback function for seek operation result.
    this.avPlayer?.on('seekDone', (seekDoneTime: number) => {
      Logger.info(TAG, `AVPlayer seek succeeded, seek time is ${seekDoneTime}`);
    });
    // error callback listens to the function.
    this.avPlayer?.on('error', (err: BusinessError) => {
      Logger.error(TAG, `Invoke avPlayer on failed, code is ${err.code}, message is ${err.message}`);
      // Call the RESET call to reset the resource to trigger the idle state.
      try {
        this.avPlayer?.reset();
        this.avPlayer?.play();
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        this.avPlayer?.release();
        Logger.error(TAG, `Invoke avPlayer reset or play failed, code is ${err.code}, message is ${err.message}`);
      }
    });
    // The callback function for state machine changes.
    this.avPlayer?.on('stateChange', async (state) => {
      if (!this.avPlayer) {
        return;
      }
      const context = this.context as common.UIAbilityContext;
      let fileDescriptor: resourceManager.RawFileDescriptor = null!;
      this.state = state;
      try {
        switch (state) {
          // After the RESET API is successfully called, the state machine is triggered.
          case 'idle':
            Logger.info(TAG, 'AVPlayer state idle called.');
            if (!this.jumpNext) {
              // Call the release operation to destroy the instance object.
              await this.avPlayer?.release();
            } else {
              context.resourceManager.closeRawFdSync('video.mp4');
              fileDescriptor = await context.resourceManager.getRawFd('video.mp4');
              this.avPlayer.fdSrc = fileDescriptor;
            }
            break;
          // After avplayer sets the playback source, this status is reported.
          case 'initialized':
            Logger.info(TAG, 'AVPlayer state initialized called.');
            // You don't need to set the display screen when the playback asset is audio-only.
            this.avPlayer.surfaceId = this.surfaceID;
            this.avPlayer.prepare().then(() => {
              Logger.info(TAG, 'AVPlayer prepare succeeded.');
            }).catch((err: BusinessError) => {
              Logger.error(TAG, `Invoke prepare failed, code is ${err.code}, message is ${err.message}`);
            });
            break;
          // After the prepare call is successful, the state machine is reported.
          case 'prepared':
            Logger.info(TAG, 'AVPlayer state prepared called.');
            // Call the playback API to start playback.
            if (this.playStatus) {
              await this.avPlayer.play();
            }
            break;
          // After the play is successfully invoked, the state machine is triggered.
          case 'playing':
            Logger.info(TAG, 'AVPlayer state playing called.');
            this.jumpNext = false;
            break;
          // After pause is successfully invoked, the state machine is triggered.
          case 'paused':
            Logger.info(TAG, 'AVPlayer state paused called.');
            break;
          // After the playback ends, the state machine is triggered.
          case 'completed':
            Logger.info(TAG, 'AVPlayer state completed called.');
            // Call the playback end API.
            this.playNext();
            break;
          // After the stop API is successfully called, the state machine is triggered.
          case 'stopped':
            Logger.info(TAG, 'AVPlayer state stopped called.');
            // Call the reset operation to initialize the avplayer state.
            await this.avPlayer.reset();
            break;
          case 'released':
            Logger.info(TAG, 'AVPlayer state released called.');
            await this.avPlayer.release();
            break;
          default:
            Logger.info(TAG, 'AVPlayer state unknown called.');
            break;
        }
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        Logger.error(TAG, `Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`);
      }
    });
  }

  /**
   * The following demo shows how to use the Resource Management API to obtain a media resource file packaged in HAP
   * and use the fdSrc attribute to play back.
   */
  async avPlayerFdSrc(): Promise<void> {
    const context = this.context as common.UIAbilityContext;
    let fileDescriptor: resourceManager.RawFileDescriptor = null!;
    try {
      // Create an avPlayer instance object.
      this.avPlayer = await media.createAVPlayer();
      // Create a callback function for state machine changes.
      this.setAVPlayerCallback();
      fileDescriptor = await context.resourceManager.getRawFd('video.mp4')
      // Assign a value to fdSrc to trigger an initialized state machine report.
      this.avPlayer.fdSrc = fileDescriptor;
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `create avplayer or getRawFd failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  async playNext(): Promise<void> {
    if (this.avPlayer === null) {
      return;
    }
    this.jumpNext = true;
    try {
      await this.avPlayer?.stop();
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  play(): void {
    if ((this.state === 'paused' || this.state === 'prepared') &&
      this.playStatus === true) {
      this.avPlayer?.play().catch((err: BusinessError) => {
        Logger.error(TAG, `Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`);
      });
    }
  }

  pause(): void {
    if (this.state === 'playing') {
      this.avPlayer?.pause().catch((err: BusinessError) => {
        Logger.error(TAG, `Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`);
      });
    }
  }

  stopAvPlayer(): void {
    if (!this.avPlayer) {
      return;
    }
    Promise.all([this.avPlayer.stop(), this.avPlayer.release()])
      .catch((err: BusinessError) => {
        Logger.error(TAG, `Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`);
      });
  }
}