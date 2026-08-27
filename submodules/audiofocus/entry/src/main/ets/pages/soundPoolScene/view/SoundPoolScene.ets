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
import { audio } from '@kit.AudioKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { display } from '@kit.ArkUI';
import Logger from '../../../common/util/Logger';
import { CommonConstants } from '../../../common/constants/CommonConstants';

const TAG = '[SoundPoolScene]';

@Builder
export function SoundPoolScenePageBuilder() {
  SoundPoolScenePage()
}

@Component
export struct SoundPoolScenePage {
  private soundPool: media.SoundPool | undefined = undefined;
  private soundId: number = 0;
  private streamId: number = 0;
  private timerId: number = 0;
  private audioSessionManager: audio.AudioSessionManager = audio.getAudioManager().getSessionManager();
  @State isHalfFolded: boolean = false;
  @StorageLink(CommonConstants.KEY_CURRENT_BREAK_POINT) curBp: string = '';
  @State isPadding: boolean = false;
  onFoldStatusChange: (foldStatus: display.FoldStatus) => void = (foldStatus: display.FoldStatus) => {
    if (foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED && this.curBp === 'sm') {
      this.isHalfFolded = true;
    } else if (foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED) {
      this.isHalfFolded = false;
    }
  }

  async aboutToAppear(): Promise<void> {
    this.create();
    try {
      if (display.isFoldable()) {
        try {
          display.on('foldStatusChange', this.onFoldStatusChange);
          let foldStatus = display.getFoldStatus();
          if (foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED && this.curBp === 'sm') {
            this.isHalfFolded = true;
          }
        } catch (error) {
          let err = error as BusinessError;
          Logger.error('foldStatusChange Failed',
            `Code: ${err.code}, message: ${err.message}`);
        }
      }
    } catch (error) {
      let err = error as BusinessError;
      Logger.error('Get isFoldable Failed',
        `Code: ${err.code}, message: ${err.message}`);
    }
    if(this.curBp === 'xl' || this.curBp === 'lg'){
      this.isPadding = true;
    }
  }

  async aboutToDisappear() {
    this.release();
  }

  async create() {
    try {
      // The parameter 'usage' in audioRenderInfo takes the values of STREAM_USAGE_UNKNOWN,
      // STREAM_USAGE_MUSIC, and STREAM_USAGE_MOVIE.
      // When STREAM_USAGE_AUDIOBOOK is used,
      // the SoundPool plays short sounds in the mixing mode and will not interrupt the playback of other audio.
      let audioRendererInfo: audio.AudioRendererInfo = {
        // The type of audio stream used: Music. Configure according to the business scenario and refer to StreamUsage.
        usage: audio.StreamUsage.STREAM_USAGE_MUSIC,
        rendererFlags: 1 // Audio renderer logo.
      }
      // Create an instance of soundPool.
      this.soundPool = await media.createSoundPool(14, audioRendererInfo);
      // Register for monitoring.
      this.loadCallback();
      this.finishPlayCallback();
      this.setErrorCallback();

      // Load audio resources.
      let context = this.getUIContext().getHostContext();
      let fileDescriptor = await context!.resourceManager.getRawFd('test.ogg');
      this.soundId = await this.soundPool!.load(fileDescriptor.fd, fileDescriptor.offset, fileDescriptor.length);
      Logger.info(TAG, `load soundPool soundId: ${this.soundId}`)
    } catch (e) {
      Logger.error(TAG, 'createSoundPool error: ' + e);
    }
  }

  async loadCallback() {
    // Loading completion callback.
    this.soundPool!.on('loadComplete', (soundId_: number) => {
      this.soundId = soundId_;
      Logger.info(TAG, 'loadComplete soundId: ' + soundId_);
    })
  }

  // Set the playback completion listening
  async finishPlayCallback() {
    this.soundPool!.on('playFinished', () => {
      Logger.info(TAG, 'receive play finished message');
      // It can be played again next time.
      if (AppStorage.get(CommonConstants.KEY_AUDIO_CONCURRENCY_MODE) as audio.AudioConcurrencyMode ===
      audio.AudioConcurrencyMode.CONCURRENCY_PAUSE_OTHERS) {
        // Deactivate an audio session
        this.audioSessionManager.deactivateAudioSession().then(() => {
          Logger.info('deactivateAudioSession SUCCESS');
        }).catch((error: BusinessError) => {
          Logger.error(TAG, `deactivateAudioSession failed,code is ${error.code},message is ${error.message}}`);
        });
      }
    })
  }

  // Set error type listening.
  async setErrorCallback() {
    this.soundPool!.on('error', (error: BusinessError) => {
      Logger.error(TAG, 'error happened,message is :' + error.code);
      Logger.error(TAG, 'error happened,message is :' + error.message);
    })
  }

  async PlaySoundPool() {
    clearTimeout(this.timerId);
    this.timerId = setTimeout(async ()=>{
      // Deactivate an audio session
      this.audioSessionManager.deactivateAudioSession().then(() => {
        Logger.info('deactivateAudioSession SUCCESS');
      }).catch((error: BusinessError) => {
        Logger.error(TAG, `deactivateAudioSession failed,code is ${error.code},message is ${error.message}}`);
      });
    },3000)
    // Set the audio concurrency mode
    let strategy: audio.AudioSessionStrategy = {
      concurrencyMode: AppStorage.get(CommonConstants.KEY_AUDIO_CONCURRENCY_MODE) as audio.AudioConcurrencyMode
    };
    // Activate the audio session
    this.audioSessionManager.activateAudioSession(strategy).then(() => {
      Logger.info('activateAudioSession SUCCESS');
    }).catch((error: BusinessError) => {
      Logger.error(TAG, `activateAudioSession failed,code is ${error.code},message is ${error.message}}`);
    });
    let playParameters: media.PlayParameters = {
      loop: 1, // Loop once, that is, play twice.
      rate: 1, // Play at 1x speed.
      leftVolume: 0.5, // The value range is 0.0-1.0.
      rightVolume: 0.5, // The value range is 0.0-1.0。
      priority: 0, // Lowest priority.
    };
    // Start playing. Here, 'play' can also have the playback parameter 'PlayParameters'.
    // Please perform the 'play' operation only after the audio resource is fully loaded, that is,
    // after receiving the 'loadComplete' callback.
    this.soundPool!.play(this.soundId, playParameters, (error, streamID: number) => {
      if (error) {
        Logger.error(TAG, `play sound Error: errCode is ${error.code}, errMessage is ${error.message}`)
      } else {
        this.streamId = streamID;
        Logger.info(TAG, 'play success soundid:' + this.streamId);
      }
    });

    try {
      // Set the number of loop plays.
      await this.soundPool!.setLoop(this.streamId, 4);
      // Set the priority of the corresponding stream.
      await this.soundPool!.setPriority(this.streamId, 1);
      // Set the volume.
      await this.soundPool!.setVolume(this.streamId, 0.5, 0.5);
    } catch (error) {
      Logger.error(TAG, `Faild: errCode is ${error.code}, errMessage is ${error.message}`)
    } // Play it three times.
  }

  async release() {
    try {
      // Terminate the playback of the specified stream.
      await this.soundPool!.stop(this.streamId);
      // Uninstall audio resources.
      await this.soundPool!.unload(this.soundId);
      // Turn off the monitoring.
      this.setOffCallback();
      // Release SoundPool.
      await this.soundPool!.release();
    } catch (error) {
      Logger.error(TAG, `Faild: errCode is ${error.code}, errMessage is ${error.message}`)
    }
    // Deactivate an audio session
    this.audioSessionManager.deactivateAudioSession().then(() => {
      Logger.info('deactivateAudioSession SUCCESS');
    }).catch((error: BusinessError) => {
      Logger.error(TAG, `deactivateAudioSession failed,code is ${error.code},message is ${error.message}}`);
    });
  }

  async setOffCallback() {
    this.soundPool!.off('loadComplete');
    this.soundPool!.off('playFinished');
    this.soundPool!.off('error');
  }

  build() {
    NavDestination() {
      Column() {
        Button($r('app.string.play'))
          .onClick(() => {
            this.PlaySoundPool();
          })
          .type(ButtonType.ROUNDED_RECTANGLE)
          .fontColor($r('sys.color.font_emphasize'))
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .fontWeight(FontWeight.Medium)
          .constraintSize({ maxWidth: 448 })
          .width('100%')
      }
      .padding({ left: 16, right: 16, bottom: this.isHalfFolded ? 16 : this.isPadding ? 16 : 0 })
      .justifyContent(FlexAlign.End)
      .width('100%')
      .height('100%')
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .title($r('app.string.sound_pool_button'))
  }
}