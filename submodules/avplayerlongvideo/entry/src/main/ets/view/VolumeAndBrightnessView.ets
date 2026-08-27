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

import { AVVolumePanel } from '@kit.AudioKit';
import { KeyConstants } from '../common/constants/KeyConstants';
import { window } from '@kit.ArkUI';
import Logger from '../common/utils/Logger';

const TAG: string = '[VolumeAndBrightnessView]';

@Component
export struct VolumeAndBrightnessView {
  @Prop visible: boolean; // Whether to show slider/image
  @Link volume: number; // Set original video volume number
  @Link screenBrightness: number; // Screen luminance
  @StorageProp(KeyConstants.KEY_DEVICE_HEIGHT) screenHeight: number = 0; // Screen height
  @StorageProp(KeyConstants.KEY_IS_HALF_FOLDED) isHalfFolded: boolean = false;

  @Builder
  VolumePanel() {
    Column() {
      AVVolumePanel({
        volumeLevel: this.volume,
        volumeParameter: {
          position: {
            x: 150,
            y: Math.max(0, this.isHalfFolded ? this.screenHeight / 4 - 300 : this.screenHeight / 2 - 300)
          }
        }
      })
    }
    .width('50%')
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  BrightnessPanel() {
    // [Start SetScreenBrightnessSlider]
    Column() {
      Stack() {
        Slider({
          value: this.screenBrightness,
          min: 0,
          max: 1,
          step: 0.05,
          style: SliderStyle.NONE,
          direction: Axis.Vertical,
          reverse: true
        })
          .visibility(this.visible ? Visibility.Visible : Visibility.Hidden)
          .height(160)
          .selectedColor(Color.White)
          .trackColor(Color.Black)
          .trackThickness(40)
          .onChange(async (value: number) => {
            this.screenBrightness = value;
            let windowStage: window.WindowStage = AppStorage.get(KeyConstants.KEY_WINDOW_STAGE) as window.WindowStage;
            try {
              let mainWin: window.Window = windowStage.getMainWindowSync();
              await mainWin.setWindowBrightness(value);
            } catch (exception) {
              Logger.error(TAG, `getMainWindowSync failed: code: ${exception.code}, message: ${exception.message}`);
            }
          })

        Image($r('app.media.sun_max_fill'))
          .visibility(this.visible ? Visibility.Visible : Visibility.Hidden)
          .margin({ top: 120 })
          .width(20)
          .height(20)
      }
      .margin({
        top: 0,
        right: 0
      })
    }
    .width('50%')
    .alignItems(HorizontalAlign.End)
    .justifyContent(FlexAlign.Center)
    .padding({
      right: 30,
      bottom: 20
    })
    // [End SetScreenBrightnessSlider]
  }

  build() {
    Row() {
      this.VolumePanel()
      this.BrightnessPanel()
    }
    .height('100%')
    .width('100%')
  }
}