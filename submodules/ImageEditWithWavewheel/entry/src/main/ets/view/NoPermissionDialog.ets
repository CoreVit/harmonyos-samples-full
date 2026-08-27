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
export struct NoPermissionDialog {
  controller?: CustomDialogController;
  confirm: () => void = () => {
  };

  build() {
    Column() {
      Row() {
        Text($r('app.string.no_write_permission_title'))
          .fontColor('#000')
          .fontSize(20)
          .fontWeight(700);
      };

      Row() {
        Text($r('app.string.no_write_permission'))
          .textAlign(TextAlign.Center)
          .fontSize(16)
          .fontColor('rgba(0, 0, 0, 0.9)')
          .lineHeight('21vp');
      }
      .padding({ top: 20, bottom: 20 });

      Button($r('app.string.got_it'), { buttonStyle: ButtonStyleMode.TEXTUAL, role: ButtonRole.NORMAL })
        .width('100%')
        .height('40vp')
        .backgroundColor(Color.Transparent)
        .fontColor($r('app.color.font_color_blue'))
        .fontSize('16vp')
        .fontWeight(500)
        .onClick(() => {
          this.confirm();
          this.controller?.close();
        });
    }
    .width('328vp')
    .padding({
      left: 24,
      right: 24,
      top: 12,
      bottom: 12
    })
    .borderRadius(32)
    .backgroundColor(Color.White);
  }
};
