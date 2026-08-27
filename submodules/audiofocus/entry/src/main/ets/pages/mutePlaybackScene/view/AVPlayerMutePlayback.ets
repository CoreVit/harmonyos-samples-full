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

import { avSession } from '@kit.AVSessionKit';
import { AVSessionController } from '../../../common/util/AVSessionController';
import { AvPlayerController } from '../../../common/util/AVPlayerController';
import { VideoData } from '../../shortVideoScene/model/VideoData';
import { VideoDataType, CommonConstants } from '../../../common/constants/CommonConstants';

const TAG = '[AVPlayerMutePlayback]';

@Builder
export function AVPlayerMutePlaybackPageBuilder() {
  AVPlayerMutePlaybackPage()
}

@Component
export struct AVPlayerMutePlaybackPage {
  @StorageLink(CommonConstants.KEY_IS_W) isW: boolean = false;
  @StorageLink(CommonConstants.KEY_IS_L) isL: boolean = false;
  private videoUrl: string = 'video.mp4';
  private avPlayerController: AvPlayerController = new AvPlayerController();
  private avSessionController: AVSessionController = new AVSessionController();
  private xComponentController: XComponentController = new XComponentController();
  @State isMuted: boolean = false;

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
      Stack({ alignContent: Alignment.TopEnd }) {
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

        // [Start video_muted_button]
        /**
         * Video Muted Button
         */
        Button() {
          Image(this.isMuted ? $r('app.media.ic_video_speaker_slash') : $r('app.media.ic_video_speaker'))
            .width(30)
            .height(30)
        }
        .type(ButtonType.Normal)
        .width(30)
        .height(30)
        .borderRadius(20)
        .backgroundColor('rgba(0, 0, 0, 0)')
        .fontColor(Color.White)
        .onClick(() => {
          this.isMuted = !this.isMuted;
          this.avPlayerController.videoMuted(this.isMuted);
        })
        .margin({ top: 6, right: 6 })

        // [End video_muted_button]
      }
      .backgroundColor($r('app.color.normal_background_color'))
      .width('100%')
      .height(this.isL ? 410 : this.isW ? 346 : 242)
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .title($r('app.string.av_player_mute_playback'))
  }
}