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

@CustomDialog
export struct FoldedDialog {
  controller?: CustomDialogController;
  confirm: () => void = () => {
  };

  build() {
    Column() {
      Text($r('app.string.folded_tip'))
        .textAlign(TextAlign.Center)
        .fontSize(16)
        .fontColor('rgba(0, 0, 0, 0.9)')
        .lineHeight(21);

      Button($r('app.string.got_it'), { buttonStyle: ButtonStyleMode.TEXTUAL, role: ButtonRole.NORMAL })
        .fontColor('rgba(10,89,247,1)')
        .fontSize(16)
        .fontWeight(500)
        .margin({ top: 8 })
        .onClick(() => {
          this.confirm();
          this.controller?.close();
        });
    }
    .width(294)
    .height(130)
    .padding(24)
    .borderRadius(32)
    .backgroundColor('rgba(255, 255, 255, 0.9)')
    .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK, { colorMode: ThemeColorMode.LIGHT });
  }
}
