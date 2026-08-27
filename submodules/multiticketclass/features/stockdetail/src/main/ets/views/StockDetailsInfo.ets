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
import { BreakpointType, WindowInfo, StockForm, StockInForm, KEY_MAIN_WINDOW_INFO } from '@stock/base';
import { StockInFormList } from './StockInFormList';
import { StockDetailViewModel } from '../viewmodels/StockDetailViewModel';


@Component
export struct StockDetailsInfo {
  @StorageLink(KEY_MAIN_WINDOW_INFO) mainWindowInfo: WindowInfo = new WindowInfo();
  @Consume('isExpand') isExpand: boolean;
  private viewModel: StockDetailViewModel = new StockDetailViewModel();
  @Prop stockInForm: StockForm | undefined = undefined;

  aboutToAppear(): void {
    this.viewModel.loadData();
  }

  build() {
    Column() {
      Row() {
        if (this.stockInForm) {
          Text(`${this.stockInForm.latestPrice / 100}`)
            .fontSize(30)
            .height(30)
            .fontColor($r('app.color.price_rise_color'))
            .fontWeight(FontWeight.Medium)
            .margin({
              right: 11.5
            })
          Text(`${this.stockInForm.highsAndLows}  ${this.stockInForm.priceLimit}`)
            .fontSize(14)
            .height(19)
            .fontColor($r('app.color.price_rise_color'))
            .fontWeight(FontWeight.Medium)
        }
      }
      .width('100%')
      .height(48)
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Bottom)
      .backgroundColor($r('app.color.card_background_color'))
      .padding({
        top: 9,
        right: new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp),
        bottom: 9,
        left: new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp)
      })

      // [Start market_quote_data_area]
      Row() {
        Column() {
          GridRow({
            columns: 12,
            direction: GridRowDirection.Row
          }) {
            ForEach(this.viewModel.stockInFormList, (item: StockInForm, index: number) => {
              GridCol({
                span: {
                  xs: 6,
                  sm: 6,
                  md: 4,
                  lg: 3
                }
              }) {
                StockInFormList({ item: item, index: index })
              }
            }, (item: StockInForm, index: number) => (item.items[0]?.title?.toString() ?? '') + index)
          }
          .width('100%')

          SymbolGlyph(this.isExpand ? $r('sys.symbol.chevron_up') : $r('sys.symbol.chevron_down'))
            .fontColor([$r('sys.color.icon_primary')])
            .fontSize(16)
            .onClick(() => {
              this.isExpand = !this.isExpand;
            })
            // [StartExclude market_quote_data_area]
            .padding({
              bottom: 4
            })
          // [EndExclude market_quote_data_area]
        }
        // [StartExclude market_quote_data_area]
        .width('100%')
        .backgroundColor($r('app.color.card_background_color'))

        // [EndExclude market_quote_data_area]
      }

      // [End market_quote_data_area]
    }
  }
}