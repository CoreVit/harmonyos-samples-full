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

@ComponentV2
export struct PensionCard {
  @Param radius?: number = 20;

  build() {
    Column() {
      Row() {
        Text($r('app.string.personal_pension'))
          .fontSize(16)
          .lineHeight(26)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.black90'))
      }
      .width('100%')

      Row() {
        Text() {
          Span($r('app.string.max_monthly_receive'))
          Span($r('app.string.pension_money'))
        }
        .fontSize(13)
        .fontColor($r('app.color.black60'))
      }
      .width('100%')
      .margin({ top: 4 })

      Row() {
        Text($r('app.string.buy_now'))
          .fontSize(14)
          .fontColor($r('app.color.multi_color_08'))
          .fontWeight(500)
        SymbolGlyph($r('sys.symbol.chevron_right'))
          .fontSize(16)
          .fontColor([$r('app.color.multi_color_08')])
      }
      .width('100%')
      .margin({ top: 8 })

      Image($r('app.media.pension_person'))
        .width(100)
        .height(88)
        .position({
          right: 4,
          top: 8,
        })
    }
    .padding({
      top: 12,
      bottom: 12,
      left: 16,
      right: 16
    })
    .backgroundImage($r('app.media.pension_bg'))
    .backgroundImageSize(ImageSize.FILL)
    .borderRadius(this.radius)
    .height(116)
  }
}