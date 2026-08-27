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
import Logger from '../../../common/util/Logger';
import { AudioItem } from '../viewModel/AudioItem';

const TAG = 'AudioPlayItem'

@Component
export struct AudioPlayItem {
  @ObjectLink audioItem: AudioItem;
  @State text: string | Resource = $r('app.string.focus_mode_share');
  @State @Watch('focusModeChange') focusMode: audio.InterruptMode = this.audioItem.focusMode;

  aboutToDisappear(): void {
    Logger.info(TAG, 'onPageHide')
    this.audioItem.isPlaying = false;
    this.audioItem.audioRenderController?.mediaPause();
  }

  focusModeChange() {
    if (this.focusMode === audio.InterruptMode.SHARE_MODE) {
      this.text = $r('app.string.focus_mode_share')
    } else {
      this.text = $r('app.string.focus_mode_independent')
    }
    this.audioItem.audioRenderController?.setInterruptMode(this.focusMode);
    if (this.audioItem.isPlaying) {
      this.audioItem.audioRenderController?.mediaPause();
      this.audioItem.audioRenderController?.mediaPlay();
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Stack() {
        Image(this.audioItem.img)
          .width('100%')
          .height('100%')
          .borderRadius(16)

        Button({ stateEffect: true }) {
          Image(this.audioItem.isPlaying ? $r('app.media.pause') : $r('app.media.play_fill'))
            .width(24)
        }
        .height($r('app.float.size_56'))
        .borderRadius(56)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .aspectRatio(1)
        .onClick(() => {
          this.audioItem.isPlaying = !this.audioItem.isPlaying;
          if (this.audioItem.isPlaying) {
            this.audioItem.audioRenderController?.mediaPlay();
          } else {
            this.audioItem.audioRenderController?.mediaPause();
          }
        })

        Stack({ alignContent: Alignment.TopEnd }) {
          Row() {
            Select([{ value: $r('app.string.focus_mode_share') },
              { value: $r('app.string.focus_mode_independent') }])
              .menuAlign(MenuAlignType.END)
              .selected(this.focusMode)
              .value(this.text)
              .onSelect((index) => {
                if (index === audio.InterruptMode.SHARE_MODE) {
                  this.focusMode = audio.InterruptMode.SHARE_MODE;
                }
                if (index === audio.InterruptMode.INDEPENDENT_MODE) {
                  this.focusMode = audio.InterruptMode.INDEPENDENT_MODE;
                }
              })
              .optionHeight(104)
              .optionWidth(224)
              .backgroundColor($r('sys.color.comp_background_tertiary'))
          }.padding(5)
        }

        .hitTestBehavior(HitTestMode.Transparent)
        .width('100%')
        .height('100%')
      }
      .height(200)
      .width('100%')
    }
  }
}