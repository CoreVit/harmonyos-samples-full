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
import { second2Time } from '../utils/TimeConvert';
import { AVPlayerController } from '../controller/AVPlayerController';
import { BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/Constants';

@Component
export struct AVPlayerControllerView {
  @Link avPlayerController: AVPlayerController;
  @StorageLink(CommonConstants.KEY_PREFIX + 'currentBreakpoint') curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(CommonConstants.KEY_PREFIX + 'naviIndicatorHeight') naviIndicatorHeight: number = 0;
  @Link currentTime: number;
  @Link durationTime: number;
  @Link isPlaying: boolean;
  @Link isShowAVPlayerController: boolean;
  @Link avPlayerControllerTimeID: number;

  aboutToDisappear(): void {
    clearTimeout(this.avPlayerControllerTimeID);
  }

  /**
   * Displays the video playback control component
   */
  private showAVPlayerController() {
    this.isShowAVPlayerController = true;
    clearTimeout(this.avPlayerControllerTimeID);
    this.avPlayerControllerTimeID = setTimeout(() => {
      this.isShowAVPlayerController = false;
    }, 2000);
  }

  private async slideOnChange(value: number, mode: SliderChangeMode) {
    if (!this.avPlayerController) {
      return;
    }
    switch (mode) {
      case SliderChangeMode.Begin:
        this.avPlayerController.isSliderAction = true;
        break;
      case SliderChangeMode.End:
        this.avPlayerController.isSliderAction = false;
        await this.avPlayerController.avPlayerSeek(value, media.SeekMode.SEEK_CLOSEST);
        this.avPlayerController.setAVPlayerPlaying();
        this.showAVPlayerController();
        break;
      default:
        break;
    }
  }

  build() {
    Row() {
      SymbolGlyph(this.isPlaying ? $r('sys.symbol.pause_fill') : $r('sys.symbol.play_fill'))
        .fontSize(24)
        .fontColor([$r('sys.color.icon_on_primary')])
        .width(24)
        .height(24)
        .margin({
          right: $r('sys.float.padding_level8')
        })
        .onClick(() => {
          if (!this.avPlayerController) {
            return;
          }
          if (this.isPlaying) {
            this.avPlayerController.setAVPlayerPause();
          } else {
            this.avPlayerController.setAVPlayerPlaying();
          }
          this.showAVPlayerController();
        })
      Text(second2Time(this.currentTime))
        .width(36)
        .lineHeight(12)
        .fontSize(12)
        .fontColor($r('sys.color.font_on_primary'))
      Slider({
        value: this.currentTime,
        step: 0.1,
        min: 0,
        max: this.durationTime,
      })
        .layoutWeight(1)
        .onChange((value: number, mode: SliderChangeMode) => {
          this.slideOnChange(value, mode);
        })
      Text(second2Time(this.durationTime))
        .width(36)
        .fontSize(12)
        .lineHeight(12)
        .fontColor($r('sys.color.font_on_primary'))
    }
    .width('100%')
    .padding({
      bottom: this.curBp === BreakpointTypeEnum.LG || this.curBp === BreakpointTypeEnum.XL ? this.naviIndicatorHeight :
        'auto'
    })
  }
}