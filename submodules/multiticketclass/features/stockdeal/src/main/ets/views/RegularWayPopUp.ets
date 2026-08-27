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

import { CounterComponent, CounterType } from '@kit.ArkUI';
import { WindowInfo, BreakpointType, UniversalIcon, KEY_MAIN_WINDOW_INFO, KEY_SHARES_HELD_NUMBER } from '@stock/base';

@Component
export struct RegularWayPopUp {
  @StorageLink(KEY_MAIN_WINDOW_INFO) mainWindowInfo: WindowInfo = new WindowInfo();
  @StorageLink(KEY_SHARES_HELD_NUMBER) sharesHeldNumber: number = 0;
  @Consume('isFirstBulletBox') isFirstBulletBox: boolean;
  @Consume('popUpBoxIsShow') popUpBoxIsShow: boolean;
  @Consume('currentStockPrice') currentStockPrice: number;
  @Consume('purchaseQuantity') purchaseQuantity: number;
  @Consume('buyIsShow') buyIsShow: boolean;
  private scroller: Scroller = new Scroller();

  build() {
    Column() {
      Column({ space: 16 }) {
        Row() {
          Text($r('app.string.regular_way'))
            .fontSize(20)
            .fontColor($r('sys.color.font_primary'))
            .fontWeight(FontWeight.Bold)
          Row() {
            UniversalIcon($r('sys.color.comp_background_tertiary'), $r('sys.symbol.xmark'), $r('sys.float.Title_S'))
          }
          .onClick(() => {
            this.purchaseQuantity = 100;
            this.buyIsShow = false;
            this.popUpBoxIsShow = false;
            this.isFirstBulletBox = true;
          })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .height(60)

        Scroll(this.scroller) {
          Column({
            space: this.mainWindowInfo.isSmMdBreakpoint() ? 6 : 16
          }) {
            Row() {
              Text($r('app.string.Stock_name_code'))
              Text($r('app.string.shareholder_account'))
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)

            Row() {
              CounterComponent({
                options: {
                  type: CounterType.LIST,
                  numberOptions: {
                    label: $r('app.string.price'),
                    value: this.currentStockPrice,
                    step: 1,
                    onChange: (value: number) => {
                      this.currentStockPrice = value;
                    }
                  }
                }
              })
            }
            .width('100%')
            .height(48)
            .backgroundColor($r('app.color.input_background_color'))
            .borderRadius(16)

            Row() {
              Text() {
                Span($r('app.string.limit_down'))
                  .fontColor($r('app.color.limit_text_color'))
                Span(`${(this.currentStockPrice * (1 - 0.1)).toFixed(2)}`)
                  .fontColor($r('app.color.price_fall_color'))
                Span($r('app.string.raising_limit'))
                  .fontColor($r('app.color.limit_text_color'))
                Span(`${(this.currentStockPrice * (1 + 0.1)).toFixed(2)}`)
                  .fontColor($r('app.color.price_rise_color'))
              }
              .fontSize(11)
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)
            .padding({
              right: 8,
              left: 8
            })

            Row() {
              CounterComponent({
                options: {
                  type: CounterType.LIST,
                  numberOptions: {
                    label: $r('app.string.quantity'),
                    min: 0,
                    value: 100,
                    max: 100 * 1000,
                    step: 100,
                    onChange: (value: number) => {
                      this.purchaseQuantity = value;
                    }
                  }
                }
              })
            }
            .width('100%')
            .height(48)
            .backgroundColor($r('app.color.input_background_color'))
            .borderRadius(16)

            Row() {
              Text() {
                Span($r('app.string.already_held'))
                Span(` ${this.sharesHeldNumber} `).fontColor($r('sys.color.alert'))
                Span($r('app.string.stock'))
              }
              .fontSize(11)

              Text() {
                Span($r('app.string.buy_able'))
                Span(' 0 ').fontColor($r('sys.color.alert'))
                Span($r('app.string.stock'))
              }
              .fontSize(11)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({
              right: 8,
              bottom: this.mainWindowInfo.isSmMdBreakpoint() ? 6 : 0,
              left: 8
            })
          }
          .width('100%')
        }
        .scrollBar(BarState.Off)
      }

      Row() {
        Text($r('app.string.buy'))
          .fontSize(16)
          .fontColor($r('sys.color.font_on_primary'))
      }
      .width('100%')
      .height(40)
      .borderRadius(20)
      .backgroundColor($r('app.color.confirm_button_text_color'))
      .justifyContent(FlexAlign.Center)
      .padding({
        right: new BreakpointType(16, 16, 0, 0, 0).getValue(this.mainWindowInfo.widthBp),
        left: new BreakpointType(16, 16, 0, 0, 0).getValue(this.mainWindowInfo.widthBp)
      })
      .margin({
        bottom:
        this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_SM &&
          (this.mainWindowInfo.heightBp === HeightBreakpoint.HEIGHT_MD ||
            this.mainWindowInfo.heightBp === HeightBreakpoint.HEIGHT_SM) ? 80 : 10
      })
      .onClick(() => {
        if (this.purchaseQuantity > 0) {
          this.buyIsShow = true;
          this.isFirstBulletBox = false;
        }
      })
    }
    .justifyContent(this.mainWindowInfo.isSmMdBreakpoint() ? FlexAlign.Start : FlexAlign.SpaceBetween)
    .width('100%')
    .height('100%')
    .padding({
      top: 12,
      right: 16,
      bottom: this.mainWindowInfo.isSmMdBreakpoint() ? 0 : 32,
      left: 16
    })
  }
}