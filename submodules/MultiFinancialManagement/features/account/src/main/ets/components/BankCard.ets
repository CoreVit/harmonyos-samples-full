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

import { uiObserver } from '@kit.ArkUI';

@ComponentV2
export struct BankCard {
  @Env(SystemProperties.BREAK_POINT) breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Param radius?: number = 16;

  build() {
    Column() {
      Row() {
        Text($r('app.string.bank_card_balance'))
          .fontSize(16)
          .lineHeight(22)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.font_primary'))
        Blank()
        Text('05-24 14:26:25')
          .fontSize(14)
          .lineHeight(20)
          .fontColor($r('app.color.font_secondary'))
      }
      .width('100%')

      Row({ space: 8 }) {
        Text($r('app.string.bank_card_info'))
          .fontSize(14)
          .lineHeight(20)
          .fontColor($r('app.color.font_secondary'))
        SymbolGlyph($r('sys.symbol.eye'))
          .fontSize(16)
          .fontColor([$r('app.color.icon_secondary')])
      }
      .width('100%')
      .margin({ top: 4 })

      Row() {
        Text() {
          Span('￥')
            .fontSize(14)
            .lineHeight(20)
            .fontColor($r('app.color.font_secondary'))
          Span('205688.80')
        }
        .fontSize(24)
        .lineHeight(32)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.font_primary'))

        Blank()
        Button($r('app.string.view_details'))
          .fontSize(12)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.font_on_primary'))
          .constraintSize({
            minWidth: 72
          })
          .height(28)
          .padding({
            top: 6,
            bottom: 6,
            left: 8,
            right: 8
          })
          .backgroundColor($r('app.color.background_emphasize'))
          .borderRadius(this.radius === 8 ? 8 : '50%')
      }
      .width('100%')
      .margin({ top: 12 })
    }
    .padding({
      top: 12,
      bottom: 14,
      left: 16,
      right: 16
    })
    .backgroundColor($r('app.color.comp_background_list_card'))
    .borderRadius(this.radius)
    .height(116)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}