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
export struct UnsavedDialog {
  controller?: CustomDialogController;
  cancel: () => void = () => {
  };
  confirm: () => void = () => {
  };

  build() {
    Column() {
      Text($r('app.string.tip'))
        .fontSize(20)
        .fontWeight(700)
        .textAlign(TextAlign.Center)
        .width('100%')
        .lineHeight(27)

      Text($r('app.string.unsaved_confirm'))
        .fontSize(16)
        .lineHeight(21)
        .textAlign(TextAlign.Center)
        .width('100%')
        .margin({ top: 12, bottom: 24 });

      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
        Text($r('app.string.cancel'))
          .textAlign(TextAlign.Center)
          .flexGrow(1)
          .backgroundColor(Color.Transparent)
          .fontColor($r('app.color.font_color_blue'))
          .fontSize(16)
          .fontWeight(500)
          .onClick(() => {
            this.cancel();
            this.controller?.close();
          });
        Divider()
          .vertical(true)
          .strokeWidth('0.5vp')
          .height(24)
          .color('rgba(0, 0, 0, 0.05)')
          .margin({ left: 4, right: 4 });
        Text($r('app.string.do_not_save'))
          .textAlign(TextAlign.Center)
          .flexGrow(1)
          .backgroundColor(Color.Transparent)
          .fontColor($r('app.color.font_color_blue'))
          .fontSize(16)
          .fontWeight(500)
          .onClick(() => {
            this.confirm();
            this.controller?.close();
          });
      }
      .height('40vp');
    }
    .width('328vp')
    .padding(24)
    .borderRadius(32)
    .backgroundColor($r(`app.color.alter_dialog_bg_color`))
    .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK);
  }
}
