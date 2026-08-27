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

import { AppStorageV2, uiObserver } from '@kit.ArkUI';
import { CommonConstants, WindowUtil } from 'financialbase';

@ComponentV2
export struct BuyPanel {
  @Param radius: Length[] = [16, 8, '50%'];
  @Param windowUtil: WindowUtil = AppStorageV2.connect(WindowUtil, CommonConstants.WINDOW_UTIL_KEY)!
  @Param @Require onClose: () => void
  @Env(SystemProperties.BREAK_POINT) breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo
  @Local buyAmount: string = ''
  @Consumer('navPathStack') navPathStack: NavPathStack = new NavPathStack();

  build() {
    Column() {
      this.titleBar()
      Stack({ alignContent: Alignment.Bottom }) {
        Scroll() {
          Column() {
            Text($r('app.string.financial_detail_product_name'))
              .fontSize(20)
              .lineHeight(27)
              .margin({
                top: 24,
                bottom: 16
              })
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.font_primary'))
              .width('100%')
              .textAlign(TextAlign.Start)

            this.BuyAmountCard()
            this.PaymentMethodCard()
            this.ProductSummaryCard()
          }
          .padding({
            bottom: 92
          })
          .width('100%')
        }
        .scrollBar(BarState.Off)
        .width('100%')
        .height('100%')
        .align(Alignment.Top)

        Button($r('app.string.financial_detail_sheet_confirm'))
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
          .height(40)
          .width('100%')
          .borderRadius(this.radius[2])
          .backgroundColor($r('app.color.brand'))
          .margin({
            bottom: this.windowUtil.mainWindowInfo.naviIndicatorHeight || 36
          })
          .onClick(() => {
            this.onClose()
          })
      }
      .width('100%')
      .layoutWeight(1)
    }
    .padding({
      left: 16,
      right: 16
    })
    .background($r('app.color.comp_background_tertiary'))
  }

  @Builder
  titleBar() {
    Row() {
      Text($r('app.string.financial_detail_timeline_buy_in'))
        .fontColor($r('app.color.font_primary'))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ left: 8 })
      Button() {
        SymbolGlyph($r('sys.symbol.xmark'))
          .fontColor([$r('app.color.font_primary')])
          .fontSize(18)
      }
      .height(40)
      .aspectRatio(1)
      .borderRadius(this.radius[2])
      .backgroundColor($r('app.color.comp_background_tertiary'))
      .onClick(() => {
        this.onClose()
      })
    }
    .height(56)
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  BuyAmountCard() {
    Column() {
      Row() {
        Text($r('app.string.financial_detail_buy_amount_title'))
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.font_primary'))
        Blank()
        Text($r('app.string.financial_detail_trading_rules'))
          .fontSize(14)
          .fontColor($r('app.color.font_emphasize'))
      }
      .width('100%')
      .height(40)

      Row() {
        Text('￥')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.font_primary'))
          .margin({ right: 8 })
        TextInput({ text: this.buyAmount, placeholder: $r('app.string.financial_detail_buy_amount_placeholder') })
          .fontSize(16)
          .type(InputType.Number)
          .placeholderColor($r('app.color.font_secondary'))
          .layoutWeight(1)
          .backgroundColor(Color.Transparent)
          .padding({ left: 0, right: 0 })
          .onChange((value: string) => {
            this.buyAmount = value
          })
      }
      .width('100%')
      .margin({ top: 16 })
      .border({ width: { bottom: 1 }, color: $r('app.color.comp_divider') })
      .padding({ bottom: 8 })

      Row({ space: 12 }) {
        this.QuickAmountButton('25000')
        this.QuickAmountButton('30000')
        this.QuickAmountButton('40000')
      }
      .width('100%')
      .margin({ top: 16 })

      Text($r('app.string.financial_detail_buy_amount_desc'))
        .fontSize(12)
        .lineHeight(16)
        .fontColor($r('app.color.font_secondary'))
        .margin({ top: 16 })
        .width('100%')
    }
    .padding(16)
    .backgroundColor($r('app.color.background_fourth'))
    .borderRadius(this.radius[0])
    .width('100%')
  }

  @Builder
  QuickAmountButton(amount: string) {
    Button(`￥${amount}`)
      .fontSize(14)
      .fontColor($r('app.color.font_primary'))
      .fontWeight(FontWeight.Normal)
      .backgroundColor(Color.Transparent)
      .layoutWeight(1)
      .height(32)
      .borderRadius(this.radius[0])
      .padding(0)
      .border({
        color: $r('app.color.container10'),
        width: 1
      })
      .onClick(() => {
        this.buyAmount = amount
      })
  }

  @Builder
  PaymentMethodCard() {
    Row() {
      Text($r('app.string.financial_detail_payment_method'))
        .fontSize(16)
        .fontColor($r('app.color.font_primary'))
      Blank()
      Text($r('app.string.financial_detail_payment_bank_card'))
        .fontSize(14)
        .width(88)
        .textAlign(TextAlign.End)
        .fontColor($r('app.color.font_secondary'))
        .margin({ right: 4 })
      SymbolGlyph($r('sys.symbol.arrowtriangle_down_fill'))
        .fontSize(16)
        .fontColor([$r('app.color.icon_secondary')])
    }
    .padding({
      left: 12,
      right: 12
    })
    .backgroundColor($r('app.color.background_fourth'))
    .borderRadius(this.radius[0])
    .margin({ top: 16 })
    .width('100%')
    .height(56)
  }

  @Builder
  ProductSummaryCard() {
    Column() {
      Text($r('app.string.financial_detail_product_summary'))
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.font_primary'))
        .width('100%')
        .margin({ bottom: 12 })

      Text($r('app.string.financial_detail_product_summary_tip'))
        .fontSize(12)
        .lineHeight(16)
        .fontColor($r('app.color.font_secondary'))
        .padding({
          top: 8,
          bottom: 8,
          left: 12,
          right: 12
        })
        .backgroundColor($r('app.color.brand10'))
        .borderRadius(this.radius[1])
        .width('100%')
        .margin({ bottom: 12 })

      Column({ space: 8 }) {
        this.SummaryListItem($r('app.string.financial_detail_summary_short_name'))
        this.SummaryListItem($r('app.string.financial_detail_summary_code'))
        this.SummaryListItem($r('app.string.financial_detail_summary_manager'))
        this.SummaryListItem($r('app.string.financial_detail_summary_custodian'))
        this.SummaryListItem($r('app.string.financial_detail_summary_date'))
        this.SummaryListItem($r('app.string.financial_detail_summary_type'))
        this.SummaryListItem($r('app.string.financial_detail_summary_currency'))
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .padding(16)
    .backgroundColor($r('app.color.background_fourth'))
    .borderRadius(this.radius[0])
    .margin({ top: 16 })
    .width('100%')
  }

  @Builder
  SummaryListItem(text: ResourceStr) {
    Row() {
      Circle({ width: 4, height: 4 })
        .fill($r('app.color.container15'))
        .margin({ right: 6 })
      Text(text)
        .fontSize(12)
        .lineHeight(16)
        .fontColor($r('app.color.font_secondary'))
        .layoutWeight(1)
    }
    .alignItems(VerticalAlign.Center)
    .width('100%')
  }
}