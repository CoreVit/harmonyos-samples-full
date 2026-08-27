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

import { audio } from '@kit.AudioKit';
import { avSession } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { AudioRenderController } from '../../../common/util/AudioRenderController';
import { AVSessionController } from '../../../common/util/AVSessionController';
import Logger from '../../../common/util/Logger';
import { CommonConstants } from '../../../common/constants/CommonConstants';

const TAG = '[AudioScene]'

@Builder
export function AudioScenePageBuilder() {
  AudioScenePage()
}

@Component
export struct AudioScenePage {
  @StorageLink(CommonConstants.KEY_AUDIO_IS_PLAYING) @Watch('playingStateChange') isPlaying: boolean = false;
  private audioUrl: string = 'audio.pcm';
  private audioRenderController: AudioRenderController = new AudioRenderController();
  private avSessionController: AVSessionController = new AVSessionController();
  private audioSessionManager: audio.AudioSessionManager = audio.getAudioManager().getSessionManager();

  aboutToAppear() {
    this.initAVResource();
  }

  aboutToDisappear(): void {
    this.releaseAVResource();
  }

  onPageHide(): void {
    this.avSessionController.startContinuousTask();
  }

  onPageShow(): void {
    this.avSessionController.stopContinuousTask();
  }

  async initAVResource(): Promise<void> {
    // Create an instance of AudioRenderer and set the audio stream type to STREAM_USAGE_MUSIC
    await this.audioRenderController.createAndInitAudioRender(this.avSessionController,
      this.audioUrl, audio.StreamUsage.STREAM_USAGE_MUSIC);
    await this.avSessionController.registerSessionListener(this.audioRenderController);
  }

  async releaseAVResource(): Promise<void> {
    if (this.audioRenderController) {
      await this.audioRenderController.releaseAudioRender(this.audioUrl);
    }
    if (this.avSessionController) {
      await this.avSessionController.avSessionRelease();
    }
    // Deactivate an audio session
    this.audioSessionManager.deactivateAudioSession().then(() => {
      Logger.info('deactivateAudioSession SUCCESS');
    }).catch((error: BusinessError) => {
      Logger.error(TAG, `deactivateAudioSession failed,code is ${error.code},message is ${error.message}}`);
    });
    // The play icon reverts to pause
    AppStorage.setOrCreate(CommonConstants.KEY_AUDIO_IS_PLAYING, false);
  }

  playingStateChange(): void {
    if (this.isPlaying) {
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
      this.audioRenderController.mediaPlay();
    } else {
      this.audioRenderController.mediaPause();
      // Deactivate an audio session
      this.audioSessionManager.deactivateAudioSession().then(() => {
        Logger.info('deactivateAudioSession SUCCESS');
      }).catch((error: BusinessError) => {
        Logger.error(TAG, `deactivateAudioSession failed,code is ${error.code},message is ${error.message}}`);
      });
    }
    AppStorage.setOrCreate(CommonConstants.KEY_AUDIO_IS_PLAYING, this.isPlaying);
  }

  build() {
    NavDestination() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Stack({alignContent:Alignment.TopStart}) {
          Stack() {
            Image($r('app.media.ic_avatar13'))
              .width('100%')
              .borderRadius(16)

            Button({ stateEffect: true }) {
              Image(this.isPlaying ? $r('app.media.pause') : $r('app.media.play_fill'))
                .width(24)
            }
            .height($r('app.float.size_56'))
            .aspectRatio(1)
            .borderRadius(56)
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .onClick(() => {
              this.isPlaying = !this.isPlaying;
            })
          }
        }
        .margin({ left: $r('app.float.size_16'), right: $r('app.float.size_16') })
      }
      .width('100%')
      .height('100%')
      .backgroundImageSize(ImageSize.Cover)
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .title($r('app.string.audio_scene_button'))
  }
}