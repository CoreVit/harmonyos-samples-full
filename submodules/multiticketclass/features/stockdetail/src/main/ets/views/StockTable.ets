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

import { WindowInfo, WordBackgroundComm, BreakpointType, StockForm, KEY_MAIN_WINDOW_INFO } from '@stock/base';
import { StockDetailViewModel } from '../viewmodels/StockDetailViewModel';

const COLUMN_WIDTH_SHORT: number = 90;
const COLUMN_WIDTH_LONG: number = 100;

@Component
export struct StockTable {
  @StorageLink(KEY_MAIN_WINDOW_INFO) mainWindowInfo: WindowInfo = new WindowInfo();
  @Consume('pageInfos') pageInfos: NavPathStack;
  @Consume('tabletMode') tabletMode: NavigationMode;
  private scroller: Scroller = new Scroller();
  private viewModel: StockDetailViewModel = new StockDetailViewModel();
  isPcStockTable = false

  aboutToAppear(): void {
    this.viewModel.loadData();
  }

  private getPriceColor(highsAndLows: number): Resource | string {
    return highsAndLows > 0 ? $r('app.color.price_rise_color') : $r('app.color.price_fall_color');
  }

  @Builder
  stockTextBuilder(value: string | Resource, width: number, color?: Resource | string): void {
    Text(value)
      .fontSize(14)
      .height(19)
      .width(width)
      .textAlign(TextAlign.End)
      .fontWeight(FontWeight.Medium)
      .fontColor(color)
  }

  @Builder
  StickyHeader(): void {
    if (this.isPcStockTable) {
      Row() {
        ForEach(this.viewModel.pcStockTitleList, (item: Resource, index: number) => {
          Row() {
            Text(item)
              .fontSize(12)
          }
          .justifyContent(index === 0 ? FlexAlign.Start : FlexAlign.End)

        }, (item: Resource, index: number) => item.toString() + index)
      }
      .width(200)
      .height(36)
      .backgroundColor($r('app.color.card_background_color'))
      .justifyContent(FlexAlign.SpaceBetween)
    } else {
      Row() {
        ForEach(this.viewModel.stockTitleList, (item: Resource, index: number) => {
          Row() {
            Text(item)
              .fontSize(12)
          }
          .justifyContent(index === 0 ? FlexAlign.Start : FlexAlign.End)
          .width(index === 1 || index === 2 || index === 3 ? COLUMN_WIDTH_SHORT : COLUMN_WIDTH_LONG)
          .padding({
            right: index === this.viewModel.stockTitleList.length - 1 ?
              (new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp)) : 0,
            left: index === 0 ? (new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp)) : 0
          })

        }, (item: Resource, index: number) => item.toString() + index)
      }
      .height(36)
      .backgroundColor($r('app.color.card_background_color'))
    }
  }

  @Builder
  StickItem(item: StockForm): void {
    Row() {
      Column() {
        Text(item.title)
        // [StartExclude stock_list_area]
          .minFontSize(8)
          .maxFontSize(16)
          .height(21)
          .width(64)
          .maxLines(1)

        Row() {
          Text(item.stockNumber)
            .fontSize(12)
            .height(16)
            .fontColor($r('sys.color.font_tertiary'))
            .textAlign(TextAlign.Start)
          WordBackgroundComm(item.plate, item.plateFontColor, item.plateBackgroundColor)
        }
        .width(64)
        .justifyContent(FlexAlign.SpaceBetween)

        // [EndExclude stock_list_area]
      }
      .alignItems(HorizontalAlign.Start)
      // [StartExclude stock_list_area]
      .width(COLUMN_WIDTH_LONG)
      .padding({
        left: new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp)
      })

      this.stockTextBuilder((item.latestPrice / 100).toString(), COLUMN_WIDTH_SHORT)
      this.stockTextBuilder(
        (item.highsAndLows > 0 ? '+' + item.highsAndLows : item.highsAndLows).toString(),
        COLUMN_WIDTH_SHORT,
        this.getPriceColor(item.highsAndLows)
      )
      this.stockTextBuilder(item.priceLimit, COLUMN_WIDTH_SHORT, this.getPriceColor(item.highsAndLows))
      this.stockTextBuilder(item.gross, COLUMN_WIDTH_LONG)
      this.stockTextBuilder(item.impressions, COLUMN_WIDTH_LONG, this.getPriceColor(item.highsAndLows))
      Text() {
        Span(item.volumeTransaction)
        Span($r('app.string.billion'))
      }
      .fontSize(14)
      .height(19)
      .width(COLUMN_WIDTH_LONG)
      .textAlign(TextAlign.End)
      .fontWeight(FontWeight.Medium)

      this.stockTextBuilder(item.amplitude, COLUMN_WIDTH_LONG)
      this.stockTextBuilder(item.changeHands, COLUMN_WIDTH_LONG)
      this.stockTextBuilder(item.peg.toString(), COLUMN_WIDTH_LONG)
      Text(item.pb.toString())
        .fontSize(14)
        .height(19)
        .width(COLUMN_WIDTH_LONG)
        .textAlign(TextAlign.End)
        .fontWeight(FontWeight.Medium)
        .padding({
          right: new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp)
        })
      // [EndExclude stock_list_area]
    }
  }

  @Builder
  PCStickItem(item: StockForm): void {
    Row() {
      Column() {
        Text(item.title)
        // [StartExclude stock_list_area]
          .minFontSize(8)
          .maxFontSize(16)
          .height(21)
          .width(64)
          .maxLines(1)

        Row() {
          Text(item.stockNumber)
            .fontSize(12)
            .height(16)
            .fontColor($r('sys.color.font_tertiary'))
            .textAlign(TextAlign.Start)
          WordBackgroundComm(item.plate, item.plateFontColor, item.plateBackgroundColor)
        }
        .width(64)
        .justifyContent(FlexAlign.SpaceBetween)

        // [EndExclude stock_list_area]
      }
      .alignItems(HorizontalAlign.Start)
      .width(COLUMN_WIDTH_LONG)

      Column() {
        Text(item.priceLimit)
          .fontSize(14)
          .height(19)
          .fontColor(this.getPriceColor(item.highsAndLows))
          .textAlign(TextAlign.End)
          .fontWeight(FontWeight.Medium)

        Text((item.latestPrice / 100).toString())
          .fontSize(14)
          .height(19)
          .textAlign(TextAlign.End)
          .fontWeight(FontWeight.Medium)

      }
      .alignItems(HorizontalAlign.End)
      .width(COLUMN_WIDTH_LONG)
      .padding({ left: 16 })
    }
  }

  build() {
    // [Start stock_list_area]
    Scroll(this.scroller) {
      List({ space: 20, initialIndex: 0 }) {
        ListItemGroup({ header: this.StickyHeader() }) {
          ForEach(this.viewModel.stockFormList, (item: StockForm) => {
            ListItem() {
              if (this.isPcStockTable) {
                this.PCStickItem(item)
              } else {
                this.StickItem(item)
              }
            }
            .height(56)
            .onClick(() => {
              this.pageInfos.replacePathByName('StockDetailsPage',
                { item: item, isPcStockTable: this.isPcStockTable }, true);
            })
          }, (item: StockForm, index: number) => (item.latestPrice + index).toString())
        }
        .backgroundColor($r('app.color.card_background_color'))
        .divider({ strokeWidth: 1 })
      }
      .height('100%')
      .scrollBar(BarState.Off)
      .sticky(StickyStyle.Header)
    }
    .scrollable(ScrollDirection.Horizontal) // Rolling direction: vertical
    .scrollBar(BarState.Off) // Permanent display of the scroll bar
    // [End stock_list_area]
  }
}