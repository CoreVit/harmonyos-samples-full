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

import { FeatureInfo } from '../model/ProductModel';
import { FeatureViewModel } from '../viewmodel/FeatureViewModel';

@ComponentV2
export struct FeatureCard {
  @Param radius: number = 16;
  private readonly viewModel: FeatureViewModel = new FeatureViewModel();

  build() {
    Column() {
      Row() {
        Text($r('app.string.financial_detail_feature_section_title'))
          .fontSize(20)
          .lineHeight(27)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.font_primary'))
      }
      .width('100%')
      .margin({ bottom: 12 })

      GridRow({
        gutter: { x: 48, y: 24 }, columns: { sm: 1, md: 2 }, breakpoints: {
          reference: BreakpointsReference.ComponentSize
        }
      }) {
        ForEach(this.viewModel.getFeatureList(), (item: FeatureInfo) => {
          GridCol() {
            this.FeatureItem(item.title, item.desc)
          }
        }, (_: FeatureInfo, index: number) => `${index}`)
      }
      .alignItems(ItemAlign.Center)
    }
    .width('100%')
    .padding(24)
    .backgroundColor($r('app.color.background_fourth'))
    .borderRadius(this.radius)
  }

  @Builder
  FeatureItem(title: ResourceStr, desc: ResourceStr) {
    Row({ space: 16 }) {
      Button({ type: ButtonType.Circle }) {
        SymbolGlyph($r('sys.symbol.heart_house_fill'))
          .fontSize(24)
          .fontColor([$r('app.color.icon_on_primary')])
      }
      .backgroundColor(Color.Transparent)
      .height(40)
      .width(40)
      .linearGradient({
        direction: GradientDirection.LeftBottom,
        colors: [[$r('app.color.brand30'), 0.0], [$r('app.color.brand'), 1.0]]
      })

      Column() {
        Text(title)
          .fontSize(20)
          .lineHeight(27)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.font_primary'))
        Text(desc)
          .fontSize(16)
          .lineHeight(21)
          .fontColor($r('app.color.font_secondary'))
          .margin({ top: 8 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .padding({
      top: 16
    })
  }
}