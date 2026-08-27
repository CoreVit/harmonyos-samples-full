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
import { WindowInfo, BreakpointType, TransactionDetails, KEY_MAIN_WINDOW_INFO } from '@stock/base';
import { StockDetails } from './StockDealItem';
import { StockDealViewModel } from '../viewmodels/StockDealViewModel';

@Component
export struct StockDealDetails {
  @StorageLink(KEY_MAIN_WINDOW_INFO) mainWindowInfo: WindowInfo = new WindowInfo();
  private concludeDetailsScroller: Scroller = new Scroller();
  private viewModel: StockDealViewModel = new StockDealViewModel();

  aboutToAppear(): void {
    this.viewModel.loadData();
  }

  build() {
    Row() {
      Column({ space: 2 }) {
        Text($r('app.string.market_conditions'))
          .width('100%')
          .height(20)
          .fontColor($r('app.color.market_title_color'))
          .backgroundColor($r('app.color.market_background_color'))
          .fontSize(10)
          .textAlign(TextAlign.Center)
        ForEach(this.viewModel.sellSharesList, (item: TransactionDetails, index: number) => {
          Row() {
            StockDetails(item.title, item.price, item.amount, index + 1)
          }
          .padding({
            right: new BreakpointType(8.25, 8.25, 8.25, 9, 9).getValue(this.mainWindowInfo.widthBp),
            left: new BreakpointType(8.25, 8.25, 8.25, 9, 9).getValue(this.mainWindowInfo.widthBp)
          })
        }, (item: TransactionDetails, index: number) => (item.price + index).toString())
        Row() {
          Slider({
            value: 60,
            min: 0,
            max: 100,
            style: SliderStyle.NONE
          })
            .trackColor($r('app.color.price_fall_color'))
            .selectedColor($r('app.color.price_rise_color'))
        }
        .width('100%')
        .height(10)

        ForEach(this.viewModel.buySellSharesList, (item: TransactionDetails, index: number) => {
          Row() {
            StockDetails(item.title, item.price, item.amount, index + 1)
          }
          .padding({
            right: new BreakpointType(8.25, 8.25, 8.25, 9, 9).getValue(this.mainWindowInfo.widthBp),
            left: new BreakpointType(8.25, 8.25, 8.25, 9, 9).getValue(this.mainWindowInfo.widthBp)
          })
        }, (item: TransactionDetails, index: number) => (item.price + index).toString())

        Text($r('app.string.transaction_details'))
          .width('100%')
          .height(20)
          .backgroundColor($r('app.color.transaction_background_color'))
          .fontSize(10)
          .textAlign(TextAlign.Center)

        Scroll(this.concludeDetailsScroller) {
          Column() {
            ForEach(this.viewModel.submissionTimeList, (item: TransactionDetails, index: number) => {
              Row() {
                StockDetails(item.title, item.price, item.amount, index + 1, false)
              }
              .padding({
                top: 2,
                right: new BreakpointType(8.25, 8.25, 8.25, 9, 9).getValue(this.mainWindowInfo.widthBp),
                bottom: 2,
                left: new BreakpointType(8.25, 8.25, 8.25, 9, 9).getValue(this.mainWindowInfo.widthBp)
              })
            }, (item: TransactionDetails, index: number) => (item.price + index).toString())
          }
        }
        .height(new BreakpointType(70, 70, 70, 102, 102).getValue(this.mainWindowInfo.widthBp))
        .scrollBar(BarState.Off)
      }
      .height('100%')
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        top: 4,
        bottom: 12
      })
    }
    .width(new BreakpointType(103, 103, 103, 192, 192).getValue(this.mainWindowInfo.widthBp))
    .height('100%')
    .padding({
      left: 4
    })
  }
}