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

import { KEY_MAIN_WINDOW_INFO, WindowInfo } from '@stock/base';
import { StockDetailsPage, StockTable } from '@stock/stockdetail';
import { StockMarketList } from '@stock/stockmarket';

@Component
export struct OptionPage {
  @StorageLink(KEY_MAIN_WINDOW_INFO) mainWindowInfo: WindowInfo = new WindowInfo();
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack();
  @Provide('tabletMode') tabletMode: NavigationMode = NavigationMode.Split;

  @Builder
  pageMap(pageName: string): void {
    if (pageName === 'StockDetailsPage') {
      StockDetailsPage();
    }
  }

  aboutToAppear(): void {
    setTimeout(() => {
      this.pageInfos.replacePathByName('StockDetailsPage', { isPcStockTable: true }, true);
    }, 100);
  }

  build() {
    Navigation(this.pageInfos) {

      Column() {
        // Self-Selected Stock Top Headline
        Row() {
          Text($r('app.string.self_select_stock'))
            .fontSize(30)
            .height(56)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .height(56)
        .padding({
          right: 16,
          left: 16
        })

        StockMarketList({ mainWindowInfo: this.mainWindowInfo, isRecommended: false })

        Blank()
          .width('100%')
          .height(1)
          .backgroundColor($r('sys.color.gray_01'))

        Column() {
          Row() {
            Column() {
              Text($r('app.string.all'))
                .fontSize(16)
                .fontWeight(700)
                .fontColor($r('app.color.toolbar_selected_color'))
                .height(21)
            }
            .border({
              width: { bottom: 2 },
              color: { bottom: $r('app.color.toolbar_selected_color') },
              style: { bottom: BorderStyle.Solid }
            })

            Blank()
            Row() {
              SymbolGlyph($r('sys.symbol.rectangle_on_rectangle'))
                .fontColor([('sys.color.icon_primary')])
                .fontSize(24)
                .margin({ right: 24 })
              SymbolGlyph($r('sys.symbol.line_3_horizontal'))
                .fontColor([$r('sys.color.icon_primary')])
                .fontSize(24)
            }
          }
          .width('100%')
          .height(48)
          .alignItems(VerticalAlign.Center)
          .padding({
            right: 32,
            left: 32
          })
        }

        Column() {
          StockTable({ isPcStockTable: true })
          Row() {
            Text($r('app.string.add_custom_options'))
              .fontSize(16)
              .fontColor($r('app.color.text_secondary_color'))
          }
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .borderColor($r('app.color.border_color'))
          .borderWidth(1)
          .borderRadius(8)
          .width(226)
          .height(40)
          .margin({ top: 24 })
        }
        .margin({ bottom: 172 })
      }
      .width('100%')
      .height('100%')
      .padding({
        top: this.getUIContext().px2vp(this.mainWindowInfo.avoidSystem?.topRect?.height ?? 0) + 56
      })
    }
    .navDestination(this.pageMap)
    .navBarWidthRange([258, 258])
    .mode(this.tabletMode)
    .hideTitleBar(true)
    .hideToolBar(true)
    .height('100%')
  }
}
