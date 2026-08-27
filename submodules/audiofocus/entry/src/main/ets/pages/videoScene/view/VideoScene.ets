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

import { window } from '@kit.ArkUI';
import { AVSessionController } from '../../../common/util/AVSessionController';
import { AvPlayerController } from '../../../common/util/AVPlayerController';
import { VideoData } from '../../shortVideoScene/model/VideoData';
import { VideoDataType } from '../../../common/constants/CommonConstants';
import Logger from '../../../common/util/Logger';
import { CommonConstants } from '../../../common/constants/CommonConstants';

const TAG = '[VideoScene]'

@Builder
export function VideoScenePageBuilder() {
  VideoScenePage()
}

@Component
export struct VideoScenePage {
  @StorageLink(CommonConstants.KEY_IS_W) isW: boolean = false;
  @StorageLink(CommonConstants.KEY_IS_L) isL: boolean = false;
  private videoUrl: string = 'video.mp4';
  private avPlayerController: AvPlayerController = new AvPlayerController();
  private avSessionController: AVSessionController = new AVSessionController();
  private xComponentController: XComponentController = new XComponentController();
  windowStage: window.WindowStage = AppStorage.get(CommonConstants.KEY_WINDOW_STAGE) as window.WindowStage;
  // How to get the main window
  mainWin: window.Window = this.windowStage.getMainWindowSync();

  aboutToDisappear(): void {
    this.releaseAVResource();
  }

  async initAVResource() {
    let source: VideoData = {
      videoSrc: this.videoUrl,
      type: VideoDataType.RAW_FILE,
      name: $r('app.string.audio_demo_title'),
      description: '',
      caption: 'video.mp4',
      index: 0,
      seekTime: 0,
      head: $r('app.media.preview1')
    }
    await this.avPlayerController.initAVPlayer(source, this.xComponentController.getXComponentSurfaceId(),
      this.avSessionController)
    await this.avSessionController.registerSessionListener(this.avPlayerController);
  }

  async releaseAVResource() {
    if (this.avPlayerController) {
      await this.avPlayerController.videoRelease();
      this.avPlayerController.deactivateAudioSession();
    }
    if (this.avSessionController) {
      await this.avSessionController.avSessionRelease();
    }
  }

  build() {
    NavDestination() {
      Column() {
        // [Start video_click_resume]
        XComponent({
          id: 'VideoPlayer',
          type: XComponentType.SURFACE,
          controller: this.xComponentController
        })
          .onLoad(() => {
            this.initAVResource();
          })
          .width('100%')
          .height('100%')
        // [End video_click_resume]
      }
      .backgroundColor($r('app.color.normal_background_color'))
      .width('100%')
      .height(this.isL ? 'calc(100% - 16vp)' : this.isW ? '60%' : 220)
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .onHidden(() => {
      this.avPlayerController.mediaPause();
    })
    .onShown(() => {
      this.avPlayerController.mediaPlay();
    })
    .title($r('app.string.video_scene_button'))
  }
}

