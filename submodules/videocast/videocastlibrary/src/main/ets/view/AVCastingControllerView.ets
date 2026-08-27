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

import { avSession } from '@kit.AVSessionKit';
import { media } from '@kit.MediaKit';
import { titleComponent } from '../common/component/BindSheetTitleComponent';
import { CommonConstants } from '../common/constants/CommonConstants';
import { millisecond2Time } from '../common/utils/TimeConvert';
import { SpeedChoose } from './CommonView';
import { AVCastController } from '../controller/AVCastController';

@Component
export struct AVCastingControllerView {
  @StorageLink(CommonConstants.KEY_PREFIX + 'Breakpoint') currentWidthBreakpoint: string = 'sm';
  @StorageLink(CommonConstants.KEY_PREFIX + 'AvCastController') @Watch('avCastPlayerControllerChange') avCastPlayerController?:
    AVCastController = undefined;
  @Prop isShowPlaying: boolean = true;
  @Link durationTime: number;
  @StorageLink(CommonConstants.KEY_PREFIX + 'CastSpeed') speedChoosen: number = 1.0;
  @State isSpeedSheetShow: boolean = false;
  @State currentTime: number = 0;
  @State isPlaying: boolean = true;

  @Builder
  speedChooseBuilder() {
    SpeedChoose({
      speedChoosen: this.speedChoosen,
      isSpeedSheetShow: this.isSpeedSheetShow,
      onChange: (speedChoosen: number) => {
        this.speedChooseChange(speedChoosen);
      }
    });
  }

  avCastPlayerControllerChange() {
    if (this.avCastPlayerController) {
      this.currentTime = this.avCastPlayerController.elapsedTime;
      this.isPlaying = Boolean(this.avCastPlayerController.state === avSession.PlaybackState.PLAYBACK_STATE_PLAY);
    }
  }

  speedChooseChange(speedChoosen: number) {
    if (!this.avCastPlayerController) {
      return;
    }
    switch (speedChoosen) {
      case 2.0:
        this.avCastPlayerController.setAVCastSpeed(media.PlaybackSpeed.SPEED_FORWARD_2_00_X);
        break;
      case 1.75:
        this.avCastPlayerController.setAVCastSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_75_X);
        break;
      case 1.5:
        this.avCastPlayerController.setAVCastSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_50_X);
        break;
      case 1.25:
        this.avCastPlayerController.setAVCastSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_25_X);
        break;
      case 1.0:
        this.avCastPlayerController.setAVCastSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_00_X);
        break;
      case 0.75:
        this.avCastPlayerController.setAVCastSpeed(media.PlaybackSpeed.SPEED_FORWARD_0_75_X);
        break;
      case 0.5:
        this.avCastPlayerController.setAVCastSpeed(media.PlaybackSpeed.SPEED_FORWARD_0_50_X);
        break;
      default:
        break
    }
  }

  async slideOnChange(value: number, mode: SliderChangeMode) {
    if (!this.avCastPlayerController) {
      return;
    }
    switch (mode) {
      case SliderChangeMode.Begin:
        this.avCastPlayerController.setAVCastPause();
        break;
      case SliderChangeMode.Moving:
        this.avCastPlayerController.setAVCastPause();
        break;
      case SliderChangeMode.Click:
        await this.avCastPlayerController.setAVCastSeek(value);
        await this.avCastPlayerController.setAVCastPlay();
        break;
      case SliderChangeMode.End:
        await this.avCastPlayerController.setAVCastSeek(value);
        this.avCastPlayerController.setAVCastPlay();
        break;
      default:
        break;
    }
  }

  onDidBuild(): void {
    this.avCastPlayerControllerChange();
  }

  @Builder
  titleBuilder() {
    Column() {
      titleComponent({
        title: $r('app.string.speed'), callback: () => {
          this.isSpeedSheetShow = false
        }
      })
    }
    .width('100%')
    .height(56)
  }

  build() {
    Row() {
      SymbolGlyph(this.isPlaying ? $r('sys.symbol.pause_fill') : $r('sys.symbol.play_fill'))
        .fontSize(24)
        .fontColor([Color.White])
        .width(24)
        .height(24)
        .margin({
          right: 8
        })
        .onClick(() => {
          if (!this.avCastPlayerController) {
            return;
          }
          if (this.isPlaying) {
            this.avCastPlayerController.setAVCastPause();
          } else {
            this.avCastPlayerController.setAVCastPlay();
          }
        })
        .visibility(this.isShowPlaying ? Visibility.Visible : Visibility.None)
      Text(millisecond2Time(this.currentTime))
        .fontSize(12)
        .fontColor(Color.White)
        .margin({
          right: 12
        })
      Slider({
        value: this.currentTime,
        step: 0.1,
        min: 0,
        max: this.durationTime,
      })
        .layoutWeight(1)
        .margin({
          right: 12
        })
        .onChange((value: number, mode: SliderChangeMode) => {
          this.slideOnChange(value, mode)
        })
      Text(millisecond2Time(this.durationTime))
        .fontSize(12)
        .fontColor(Color.White)
        .margin({
          right: 12
        })
      Text($r('app.string.speed'))
        .fontSize(14)
        .fontColor(Color.White)
        .onClick(() => {
          this.isSpeedSheetShow = true;
        })
        .bindSheet($$this.isSpeedSheetShow, this.speedChooseBuilder(), {
          showClose: false,
          height: SheetSize.FIT_CONTENT,
          preferType: SheetType.CENTER,
          title: this.titleBuilder,
          backgroundColor: $r('sys.color.comp_background_primary')
        })
    }
    .width('100%')
    .margin({
      bottom: 4
    })
  }
}