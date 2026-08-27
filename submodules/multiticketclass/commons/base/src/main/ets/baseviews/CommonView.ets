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

import { WindowInfo } from '../utils/WindowUtil';
import { BreakpointType } from '../utils/BreakpointType';
import { KEY_MAIN_WINDOW_INFO } from '../utils/AppConstants';

@Builder
export function WordBackgroundComm(text: ResourceStr, textFontColor: ResourceColor,
  textBackgroundColor: ResourceColor) {
  Row() {
    Text(text)
      .fontSize(10)
      .fontColor(textFontColor)
  }
  .width(12)
  .height(12)
  .borderRadius(2)
  .alignItems(VerticalAlign.Center)
  .justifyContent(FlexAlign.Center)
  .backgroundColor(textBackgroundColor)
  .margin({
    right: 4
  })
}

@Builder
export function UniversalIcon(iconBackgroundColor: ResourceColor, icon: Resource,
  fontSize: ResourceColor = $r('sys.float.Title_L')) {
  Button({ type: ButtonType.Circle }) {
    SymbolGlyph(icon)
      .fontColor([$r('sys.color.icon_primary')])
      .fontSize(fontSize)
  }
  .height(46)
  .aspectRatio(1)
  .backgroundColor(iconBackgroundColor)
}

@Builder
export function TitleIcon(icon?: Resource, title?: Resource) {
  Column() {
    SymbolGlyph(icon)
      .fontColor([$r('sys.color.icon_primary')])
      .fontSize(24)
    Text(title)
      .fontSize(10)
      .lineHeight(13)
      .fontColor($r('sys.color.font_secondary'))
      .margin({
        top: 4
      })
  }
  .width(40)
  .height(42)
  .justifyContent(FlexAlign.Center)
  .alignItems(HorizontalAlign.Center)
}

@Component
export struct CommSlide {
  @StorageLink(KEY_MAIN_WINDOW_INFO) mainWindowInfo: WindowInfo = new WindowInfo();
  @State tabIndexSelected: number = 0;
  @Prop commSlideData: ResourceStr[];

  build() {
    // [Start tab_sliding_area]
    List({
      space: new BreakpointType(46, 46, 90, 150, 150).getValue(this.mainWindowInfo.widthBp)
    }) {
      ForEach(this.commSlideData, (item: string, index: number) => {
        ListItem() {
          Column() {
            Text(item)
            // [StartExclude tab_sliding_area]
              .fontSize(16)
              .fontWeight(this.tabIndexSelected === index ? 700 : 400)
              .fontColor(this.tabIndexSelected === index ? $r('sys.color.font_primary') : $r('sys.color.font_secondary'))
              .height(21)
              .focusable(true)
              .groupDefaultFocus(index === 0)
            // [EndExclude tab_sliding_area]
          }
        }
        .margin({
          top: 9,
          right: this.commSlideData.length === index + 1 ?
            new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp) : 0,
          left: index === 0 ? new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp) : 0,
        })
        .border({
          width: {
            bottom: this.tabIndexSelected === index ? 2 : 0
          },
          color: {
            bottom: this.tabIndexSelected === index ? $r('sys.color.brand') : ''
          },
          style: {
            bottom: BorderStyle.Solid
          }
        })
        .onClick(() => {
          this.tabIndexSelected = index;
        })
      }, (item: string, index: number) => (index + item).toString())
    }
    .scrollBar(BarState.Off)
    .listDirection(Axis.Horizontal)
    .height('100%')
    .width('100%')
    // [End tab_sliding_area]
  }
}
