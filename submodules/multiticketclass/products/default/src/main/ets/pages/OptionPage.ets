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

import { BreakpointType, KEY_MAIN_WINDOW_INFO, WindowInfo } from '@stock/base';
import { StockTable } from '@stock/stockdetail';
import { StockMarketList } from '@stock/stockmarket';

@Component
export struct OptionPage {
  @StorageLink(KEY_MAIN_WINDOW_INFO) mainWindowInfo: WindowInfo = new WindowInfo();
  @Consume('pageInfos') pageInfos: NavPathStack;

  build() {
    Column() {
      // Self-Selected Stock Top Headline
      Row() {
        Text($r('app.string.self_select_stock'))
          .fontSize(24)
          .height(32)
          .fontWeight(700)
      }
      .width('100%')
      .height(56)
      .padding({
        right: new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp),
        left: new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp)
      })
      .visibility(this.mainWindowInfo.heightBp !== HeightBreakpoint.HEIGHT_LG &&
        this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_SM ? Visibility.None : Visibility.Visible)

      StockMarketList({ mainWindowInfo: this.mainWindowInfo })

      Blank()
        .width('100%')
        .height(1)
        .backgroundColor($r('sys.color.gray_01'))

      Column() {
        // [Start stock_toolbar_area]
        Row() {
          Column() {
            Text($r('app.string.all'))
            // [StartExclude stock_toolbar_area]
              .fontSize(16)
              .fontWeight(700)
              .fontColor($r('app.color.toolbar_selected_color'))
              .height(21)
              .focusable(true)
            // [EndExclude stock_toolbar_area]
          }
          .border({
            width: { bottom: 2 },
            color: { bottom: $r('app.color.toolbar_selected_color') },
            style: { bottom: BorderStyle.Solid }
          })

          Blank()
          Row() {
            SymbolGlyph($r('sys.symbol.rectangle_on_rectangle'))
            // [StartExclude stock_toolbar_area]
              .fontColor([$r('sys.color.icon_primary')])
              .fontSize(24)
              .margin({
                right: 24
              })
            // [EndExclude stock_toolbar_area]
            SymbolGlyph($r('sys.symbol.line_3_horizontal'))
            // [StartExclude stock_toolbar_area]
              .fontColor([$r('sys.color.icon_primary')])
              .fontSize(24)
            // [EndExclude stock_toolbar_area]
          }
        }
        .width('100%')
        .height(48)
        .alignItems(VerticalAlign.Center)
        .padding({
          right: new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp),
          left: new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp)
        })

        // [End stock_toolbar_area]
      }

      Column() {
        // Stock table list
        StockTable()
        // Add custom buttons
        Row() {
          Text($r('app.string.add_custom_options'))
            .fontSize(16)
            .fontColor($r('app.color.text_secondary_color'))
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .borderColor($r('app.color.border_color'))
        .borderWidth(1)
        .borderRadius(20)
        .width(240)
        .height(40)
        .margin({
          top: 24
        })
        .visibility(this.mainWindowInfo.heightBp !== HeightBreakpoint.HEIGHT_LG &&
          this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_SM ? Visibility.None : Visibility.Visible)
      }
      .margin({
        bottom: this.mainWindowInfo.heightBp !== HeightBreakpoint.HEIGHT_LG &&
          this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_SM ? 112 : 172
      })
    }
    .width('100%')
    .height('100%')
    .padding({
      top: this.mainWindowInfo.isSmMdBreakpoint() ? 16 :
        this.getUIContext().px2vp(this.mainWindowInfo.avoidSystem?.topRect.height)
    })
  }
}
