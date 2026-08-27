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

@Builder
export function SectionTitle(title: ResourceStr, color: ResourceStr, textAlign: TextAlign) {
  Text(title)
    .fontSize(16)
    .lineHeight(21)
    .padding({
      left: 16,
      right: 16
    })
    .fontWeight(FontWeight.Medium)
    .fontColor(color)
    .width('100%')
    .textAlign(textAlign)
}

@Builder
export function PrimaryTitleRow(title: ResourceStr, showIcon: boolean = true, amount?: ResourceStr) {
  Row() {
    PrimaryTitle(title)
    if (showIcon) {
      SymbolGlyph($r('sys.symbol.arrowtriangle_up_fill'))
        .fontSize(14)
        .fontColor([$r('app.color.icon_primary')])
        .margin({ left: 8 })
    }
    Blank()
    if (amount) {
      Text(amount)
        .fontSize(16)
        .lineHeight(21)
        .fontWeight(FontWeight.Medium)
        .margin({ right: 6 })
        .fontColor($r('app.color.font_primary'))
    }
    SymbolGlyph($r('sys.symbol.chevron_right'))
      .fontSize(24)
      .fontColor([$r('app.color.icon_tertiary')])
  }
  .width('100%')
  .height(48)
}

@Builder
export function PrimaryTitle(title: ResourceStr) {
  Text(title)
    .fontSize(16)
    .lineHeight(21)
    .fontWeight(FontWeight.Medium)
    .fontColor($r('app.color.font_primary'))
}

@Builder
export function ContentRow(text: ResourceStr, amount?: ResourceStr, extra?: ResourceStr) {
  Row() {
    ContextText(text)
    Blank().layoutWeight(1)
    if (amount) {
      Column({ space: 3 }) {
        PrimaryTitle(amount)
        if (extra) {
          TertiaryText(extra)
        }
      }
      .alignItems(HorizontalAlign.End)
    }
    SymbolGlyph($r('sys.symbol.chevron_right'))
      .fontSize(24)
      .fontColor([$r('app.color.icon_tertiary')])
      .margin({ left: 6 })
  }
  .layoutWeight(1)
  .constraintSize({
    maxHeight: 40
  })
}

@Builder
export function ContextText(text: ResourceStr) {
  Text(text)
    .fontSize(14)
    .lineHeight(19)
    .fontColor($r('app.color.font_primary'))
}

@Builder
export function TertiaryText(text: ResourceStr) {
  Text(text)
    .fontSize(12)
    .lineHeight(16)
    .fontColor($r('app.color.font_secondary'))
}

@Builder
export function AmountText(text: ResourceStr, marginBottom: number = 4) {
  Text(text)
    .fontSize(24)
    .lineHeight(32)
    .fontWeight(FontWeight.Medium)
    .textAlign(TextAlign.Start)
    .margin({ bottom: marginBottom })
    .fontColor($r('app.color.font_primary'))
}

@Builder
export function IncomeText(text: string) {
  Text(text)
    .fontSize(14)
    .lineHeight(19)
    .fontWeight(FontWeight.Medium)
    .fontColor(Number(text) > 0 ? $r('app.color.multi_color_08') : $r('app.color.multi_color_04'))
}

@Builder
export function ContentText(title: ResourceStr) {
  Text(title)
    .fontSize(12)
    .lineHeight(16)
    .fontColor($r('app.color.font_secondary'))
}