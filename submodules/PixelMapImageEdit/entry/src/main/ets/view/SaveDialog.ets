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
export struct SaveDialog {
  controller?: CustomDialogController;
  cancel: () => void = () => {
  };
  confirm: () => void = () => {
  };

  build() {
    Column() {
      Row() {
        Text($r('app.string.save_image'))
          .fontColor('#000')
          .fontSize(20)
          .fontWeight(700)
      }

      Row() {
        Text($r('app.string.confirm_save'))
          .textAlign(TextAlign.Center)
          .fontSize(16)
          .fontColor('rgba(0, 0, 0, 0.9)')
          .lineHeight('21vp')
      }
      .padding({ top: 20, bottom: 20 })

      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
        Text($r('app.string.cancel'))
          .textAlign(TextAlign.Center)
          .flexGrow(1)
          .backgroundColor(Color.Transparent)
          .fontColor('#0A59F7')
          .fontSize('16vp')
          .fontWeight(500)
          .onClick(() => {
            this.cancel();
          })
        Divider()
          .vertical(true)
          .strokeWidth('0.5vp')
          .height(24)
          .color('rgba(0, 0, 0, 0.05)')
          .margin({ left: 4, right: 4 })
        Text($r('app.string.save'))
          .textAlign(TextAlign.Center)
          .flexGrow(1)
          .backgroundColor(Color.Transparent)
          .fontColor('#0A59F7')
          .fontSize('16vp')
          .fontWeight(500)
          .onClick(() => {
            this.confirm();
          })
      }
    }
    .width('328vp')
    .padding({
      left: 24,
      right: 24,
      top: 12,
      bottom: 12
    })
    .borderRadius(32)
    .backgroundColor(Color.White)
  }
}
