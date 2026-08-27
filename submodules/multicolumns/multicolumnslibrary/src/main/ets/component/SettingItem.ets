/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

@Component
export struct MainItem {
  itemDesc: Resource = $r('app.string.nonSense');
  src: Resource = $r('app.media.icon');
  isUserItem: boolean = false;
  itemStatusDesc: Resource = $r('app.string.nonSense');

  build() {
    Row() {
      Image(this.src)
        .width($r('app.float.image_size_32'))
        .aspectRatio(1)
      if (this.isUserItem) {
        Column() {
          Text($r('app.string.userInfo'))
            .fontSize($r('sys.float.Body_L'))
            .fontWeight(FontWeight.Medium)
          Text($r('app.string.aboutUserInfo'))
            .fontSize($r('sys.float.Body_M'))
            .fontWeight(FontWeight.Regular)
            .opacity(0.6)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }.alignItems(HorizontalAlign.Start).margin({ left: $r('sys.float.padding_level6') }).flexShrink(1)
      } else {
        Text(this.itemDesc)
          .fontSize($r('sys.float.Body_L'))
          .lineHeight($r('app.float.line_height_22'))
          .fontWeight(FontWeight.Medium)
          .fontFamily('HarmonyHeiTi')
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .align(Alignment.Start)
          .margin({ left: $r('sys.float.padding_level8') })
      }

      Blank()
      Image($r('app.media.ic_settings_arrow'))
        .width($r('app.float.right_icon_width'))
        .height($r('app.float.button_height_small'))
        .fillColor($r('sys.color.ohos_id_color_fourth'))
        .margin({ left: $r('sys.float.padding_level2') })
    }.padding({ left: $r('sys.float.padding_level6'), right: $r('sys.float.padding_level6') })
    .height($r('app.float.item_height'))
    .borderRadius($r('sys.float.corner_radius_level10'))
    .width('100%')
  }
}

@Component
export struct SubItem {
  itemDesc: Resource = $r('app.string.nonSense');
  src: Resource = $r('app.media.icon');
  isShowButton: boolean = false;
  isShowRightArrow: boolean = false;
  itemStatusDesc: Resource = $r('app.string.nonSense');
  content: Resource = $r('app.string.nonSense');
  isLinkAddress: boolean = false;

  build() {
    Row() {
      Column() {
        Text(this.itemDesc)
          .fontSize($r('sys.float.Body_L'))
          .lineHeight($r('app.float.line_height_22'))
          .fontWeight(FontWeight.Medium)
          .fontFamily('HarmonyHeiTi')
          .fontColor(this.isLinkAddress ? $r('sys.color.brand') : $r('sys.color.font_primary'))
          .align(Alignment.Start)
        if (this.content) {
          Text(this.content)
            .fontWeight(FontWeight.Regular)
            .fontSize($r('sys.float.Body_M'))
            .fontColor($r('sys.color.font_tertiary'))
            .margin({ top: $r('sys.float.padding_level1') })
        }
      }.alignItems(HorizontalAlign.Start)

      Blank()

      if (this.isShowButton) {
        Toggle({ type: ToggleType.Switch, isOn: true })
          .id('ToggleSwitch')
          .width($r('app.float.setting_toggle_width'))
          .height($r('app.float.setting_toggle_height'))
          .selectedColor($r('sys.color.brand'))
      } else if (this.isShowRightArrow) {
        if (this.itemStatusDesc) {
          Text(this.itemStatusDesc)
            .fontWeight(FontWeight.Regular)
            .fontSize($r('sys.float.Body_M'))
        }
        Image($r('app.media.ic_settings_arrow'))
          .width($r('app.float.right_icon_width'))
          .height($r('app.float.button_height_small'))
          .fillColor($r('sys.color.ohos_id_color_fourth'))
          .margin({
            left: $r('sys.float.padding_level2')
          })
      } else {
        Image(this.src)
          .width($r('app.float.button_height_small'))
          .height($r('app.float.button_height_small'))
          .fillColor($r('sys.color.ohos_id_color_primary'))
      }
    }
    .height($r('app.float.item_height'))
    .borderRadius($r('sys.float.corner_radius_level10'))
    .width('100%')
    .padding({ left: $r('sys.float.padding_level6'), right: $r('sys.float.padding_level6') })
  }
}