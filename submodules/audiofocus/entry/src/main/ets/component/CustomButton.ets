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

@Component
export struct CustomButton {
  buttonName: Resource | string = '';
  buttonOnClick: (event?: ClickEvent) => void = (): void => {
  };

  build() {
    Row() {
      Text(this.buttonName)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_primary'))
        .align(Alignment.Center)
        .height($r('app.float.size_40'))
      Image($r('app.media.chevron_right_gray'))
        .width(14)
        .height(14)
    }
    .onClick(this.buttonOnClick)
    .padding({
      left: 12,
      right: 12
    })
    .borderRadius(16)
    .backgroundColor($r('app.color.list_item_bg'))
    .width('100%')
    .height(56)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}