/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { promptAction, display } from '@kit.ArkUI';
import { CommonConstants } from '../common/constant/CommonConstants';
import Logger from '../utils/Logger';
import type { BreakpointType } from '../utils/MultiDeviceUtil';

const TAG: string = '[AlertDialog]';

@Builder
export function AlertDialogBuilder() {
  AlertDialog();
}

@Preview
@Component
struct AlertDialog {
  @StorageLink(CommonConstants.BREAKPOINT_KEY) currentBreakpoint: BreakpointType = 'sm';
  @State textResourceFiles: string[] = ['guide_step1', 'guide_step2', 'guide_step3', 'guide_step4'];

  build() {
    Column() {
      Text($r('app.string.usage_guide'))
        .fontSize($r(`sys.float.Title_S`))
        .fontWeight(FontWeight.Bold)
        .height(54)
        .width('100%')
        .textAlign(TextAlign.Center)

      this.buildGuideSteps();

      Row() {
        Text($r('app.string.got_it'))
          .fontColor($r('app.color.font_color_blue'))
          .fontWeight(FontWeight.Medium)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            let controller: promptAction.DialogController = this.getDialogController();
            if (controller !== undefined) {
              controller.close();
            }
          });
      }
      .height(56)
      .margin({ top: $r(`sys.float.padding_level4`), bottom: $r(`sys.float.padding_level4`) })
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r(`app.color.alter_dialog_bg_color`))
    .constraintSize({ maxWidth: this.getDialogMaxWidth() })
    .borderRadius(32)
  }

  getDialogMaxWidth(): number {
    try {
      const defaultDisplay = display.getDefaultDisplaySync();
      const screenWidthVp = defaultDisplay.width / defaultDisplay.densityPixels;
      const smWidth = screenWidthVp - 32;
      return Math.min(smWidth, 400);
    } catch (err) {
      Logger.error(TAG, `getDefaultDisplaySync`);
      return 400;
    }
  }

  @Builder
  buildGuideSteps() {
    Column() {
      ForEach(this.textResourceFiles, (resName: string, idx: number) => {
        this.buildStandardText(`app.string.${resName}`, idx);
      }, (resName: string) => resName);
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  buildStandardText(textResource: string, idx: number) {
    Row() {
      Text($r(textResource))
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .padding({
      left: $r('sys.float.padding_level16'),
      right: $r('sys.float.padding_level16')
    })
    .margin({
      bottom: idx < this.textResourceFiles.length - 1 ? 10 : 0
    })
  }
}