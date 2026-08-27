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
import { BreakpointType, WindowInfo, ShareIndex } from '@stock/base'
import { StockMarketViewModel } from '../viewmodels/StockMarketViewModel'

@Component
export struct StockMarketList {
  mainWindowInfo: WindowInfo = new WindowInfo()
  isRecommended: boolean = true
  private viewModel: StockMarketViewModel = new StockMarketViewModel()

  aboutToAppear(): void {
    this.viewModel.loadShareIndexData()
  }

  @Builder
  ShareIndexBuilder(info: ShareIndex, index: number) {
    Column() {
      Text(info.title)
        .lineHeight(16)
        .fontSize(12)
        .fontWeight(FontWeight.Regular)
      Column() {
        Text(info.index)
          .lineHeight(21)
          .fontSize(16)
          .fontColor(index % 2 === 0 ? '#FA4337' : '#1DB775')
          .fontWeight(FontWeight.Bold)
        Text(info.priceLimit)
          .lineHeight(10)
          .fontSize(10)
          .fontColor(index % 2 === 0 ? '#FA4337' : '#1DB775')
          .fontWeight(FontWeight.Medium)
      }
      .height(32)
    }
    .width(this.isRecommended ? new BreakpointType(78, 78, 101, 96, 96).getValue(this.mainWindowInfo.widthBp) : 69)
    .height(73)
    .borderRadius(8)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      top: 10,
      bottom: 12
    })
  }

  build() {
    // [Start stock_list_area]
    // List of stock indices
    Row() {
      List({
        space: new BreakpointType(4, 4, 14, 16, 16).getValue(this.mainWindowInfo.widthBp),
        initialIndex: 0
      }) {
        ForEach(this.viewModel.shareIndexList, (item: ShareIndex, index: number) => {
          ListItem() {
            this.ShareIndexBuilder(item, index)
          }
          .margin({
            left: index === 0 ? (!this.isRecommended ? 16 :
              new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp)) : 0
          })
        }, (item: ShareIndex, index: number) => (item.priceLimit + index).toString())
      }
      // [StartExclude stock_list_area]
      .height(73)
      .width('100%')
      .scrollBar(BarState.Off)
      .listDirection(Axis.Horizontal)
      .layoutWeight(1)

      // [EndExclude stock_list_area]

      if (this.isRecommended) {
        // Fixed Area.
        Row() {
          // [StartExclude stock_list_area]
          Column() {
            Text($r('app.string.stock_company'))
              .lineHeight(16)
              .fontSize(12)
              .fontColor('#FA4337')
              .fontWeight(FontWeight.Medium)
              .padding({
                bottom: 8
              })
            Column() {
              Text($r('app.string.stock_text_start'))
                .maxLines(1)
                .fontSize(10)
                .fontColor('#FA4337')
                .margin({
                  bottom: 2
                })
              Text($r('app.string.stock_text_end'))
                .fontSize(10)
                .fontColor('#FA4337')
                .maxLines(1)
            }
            .height(32)
          }
          .justifyContent(FlexAlign.SpaceBetween)

          SymbolGlyph($r('sys.symbol.chevron_right'))
            .fontColor(['#FA4337'])
            .fontSize(20)
            .margin({
              bottom: 40,
              left: new BreakpointType(4, 4, 12, 18, 18).getValue(this.mainWindowInfo.widthBp)
            })
          // [EndExclude stock_list_area]
        }
        .width(new BreakpointType(78, 78, 101, 96, 96).getValue(this.mainWindowInfo.widthBp))
        // [StartExclude stock_list_area]
        .height(73)
        .justifyContent(FlexAlign.Center)
        .borderRadius(8)
        .linearGradient({
          direction: GradientDirection.Bottom,
          repeating: true,
          colors: [
            [$r('app.color.gradient_start_color'), 0],
            [$r('app.color.gradient_mid1_color'), 0.5],
            [$r('app.color.gradient_mid2_color'), 0.7],
            [$r('app.color.gradient_end_color'), 1]
          ]
        })
        // [EndExclude stock_list_area]
        .margin({
          right: new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp)
        })
      }

    }
    // [End stock_list_area]
    .width('100%')
    .height(71)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
  }
}
