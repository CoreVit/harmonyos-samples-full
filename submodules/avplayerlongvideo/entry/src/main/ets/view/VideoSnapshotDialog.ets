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

import { image } from '@kit.ImageKit';
import { CommonConstants } from '../common/constants/CommonConstants';
import { KeyConstants } from '../common/constants/KeyConstants';

@CustomDialog
export struct VideoSnapshotDialog {
  private controller: CustomDialogController;
  @Link imgWidth: number;
  @Link imgHeight: number;
  @Link pixmap: image.PixelMap;
  onPreviousClick: () => void = () => {
  };
  onNextClick: () => void = () => {
  };
  @StorageProp(KeyConstants.KEY_IS_HALF_FOLDED) isHalfFolded: boolean = false;
  @StorageProp(KeyConstants.KEY_DEVICE_HEIGHT) screenHeight: number = 0; // Screen height

  build() {
    Row({ space: $r('app.float.size_16') }) {
      Column({ space: 12 }) {
        Image($r('app.media.previousFrame'))
          .width(45)
        Text($r('app.string.previousFrame'))
          .fontSize(14)
          .fontColor(Color.White)
      }
      .onClick(() => {
        this.onPreviousClick();
      })

      Image(this.pixmap)
        .width(this.imgWidth)
        .height(this.imgHeight)
        .visibility(Visibility.Visible)
        .onClick(() => {
          this.controller.close();
        })

      Column({ space: 12 }) {
        Image($r('app.media.nextFrame'))
          .width(45)
        Text($r('app.string.nextFrame'))
          .fontSize(14)
          .fontColor(Color.White)
      }
      .onClick(() => {
        this.onNextClick();
      })
    }
    .width(CommonConstants.WIDTH_FULL_PERCENT)
    .justifyContent(FlexAlign.Center)
    .zIndex(999)
    .margin({ top: this.isHalfFolded ? this.getUIContext().px2vp(this.screenHeight / 2) - 45 : 0 })
  }
}