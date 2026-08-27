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

@CustomDialog
export struct AntiPeepGuideDialog {
  controller: CustomDialogController = new CustomDialogController({ builder: AntiPeepGuideDialog() });
  title: ResourceStr = $r('app.string.anti_peep_not_enable_title');
  message: ResourceStr = $r('app.string.anti_peep_not_enable');

  build() {
    Column() {
      Text(this.title)
        .fontSize($r('sys.float.ohos_id_text_size_dialog_tittle'))
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.Center)
        .textContentAlign(TextContentAlign.CENTER)
        .margin({bottom: $r('sys.float.ohos_id_subtab_bottom_padding')})

      Text(this.message)
        .fontSize($r('sys.float.ohos_id_button_font_size'))
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .textAlign(TextAlign.Center)
        .margin({bottom: $r('sys.float.padding_level10')})

      Text($r('app.string.know_it'))
      .fontSize($r('sys.float.ohos_id_button_font_size'))
      .fontColor($r('sys.color.font_emphasize'))
      .fontWeight(FontWeight.Medium)
      .width('100%')
      .textAlign(TextAlign.Center)
      .stateStyles({
        pressed: { .scale({ x: 0.95, y: 0.95 }).opacity(0.7) },
        normal: { .scale({ x: 1, y: 1 }).opacity(1) }
      })
      .onClick(() => this.controller.close())

    }
    .padding($r('sys.float.padding_level12'))
    .width('100%')
  }
}
