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

import { CommonConstants } from 'financialbase';
import { TagInfo } from '../model/ProductModel';
import { ProductViewModel } from '../viewmodel/ProductViewModel';

@ComponentV2
export struct ProductCard {
  @Param radius: number[] = [16, 12];
  @Param @Require widthBreakpoint: WidthBreakpoint;
  private readonly viewModel: ProductViewModel = new ProductViewModel();

  build() {
    Column() {
      Column() {
        Text($r('app.string.financial_detail_product_name'))
          .fontSize(20)
          .lineHeight(27)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.font_primary'))
          .width('100%')
          .margin({ bottom: 20 })
        Flex({
          direction: this.widthBreakpoint === WidthBreakpoint.WIDTH_SM ? FlexDirection.Column :
            FlexDirection.Row,
          justifyContent: FlexAlign.Start,
          alignItems: this.widthBreakpoint === WidthBreakpoint.WIDTH_SM ? ItemAlign.Start : ItemAlign.Center
        }) {
          Row({ space: 8 }) {
            this.MetaInfoText(CommonConstants.PRODUCT_CODE_TEMPLATE)
            this.MetaInfoText($r('app.string.financial_detail_sale_type'))
          }

          if (this.widthBreakpoint !== WidthBreakpoint.WIDTH_SM) {
            this.MetaInfoSeparator()
          }
          this.MetaInfoText($r('app.string.financial_detail_company_name'))
        }
        .width('100%')

        Row({ space: 12 }) {
          Column() {
            Text(CommonConstants.PRODUCT_RATE)
              .fontSize(24)
              .lineHeight(32)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.warning'))
            Text($r('app.string.financial_detail_income_since_inception'))
              .fontSize(16)
              .lineHeight(21)
              .fontColor($r('app.color.font_secondary'))
              .margin({ top: 4 })
          }
          .layoutWeight(1)
          .width('100%')
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text($r('app.string.financial_detail_product_term'))
              .fontSize(20)
              .lineHeight(32)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.font_primary'))
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            Text($r('app.string.financial_detail_investment_term'))
              .fontSize(16)
              .lineHeight(21)
              .fontColor($r('app.color.font_secondary'))
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ top: 4 })
          }
          .layoutWeight(1)
          .width('100%')
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .alignItems(VerticalAlign.Top)
        .margin({ top: 12 })

        Row({ space: 8 }) {
          ForEach(this.viewModel.getTagList(), (tag: TagInfo) => {
            this.TagChip(tag)
          }, (tag: TagInfo, index: number) => JSON.stringify(tag) + index)
        }
        .width('100%')
        .margin({ top: 16 })

        this.BenchmarkCard()
      }
      .width('100%')
    }
    .width('100%')
    .padding(CommonConstants.COMMON_PADDING[1].getValue(this.widthBreakpoint))
    .borderRadius(this.radius[0])
    .backgroundColor($r('app.color.background_fourth'))
  }

  @Builder
  MetaInfoText(content: ResourceStr) {
    Text(content)
      .fontSize(16)
      .lineHeight(21)
      .fontColor($r('app.color.font_secondary'))
  }

  @Builder
  BenchmarkCard() {
    Flex({
      direction: this.widthBreakpoint === WidthBreakpoint.WIDTH_SM ? FlexDirection.Column :
        FlexDirection.Row,
      justifyContent: this.widthBreakpoint === WidthBreakpoint.WIDTH_SM ? FlexAlign.Start :
        FlexAlign.SpaceBetween,
      alignItems: this.widthBreakpoint === WidthBreakpoint.WIDTH_SM ? ItemAlign.Start : ItemAlign.End
    }) {
      Column({ space: 4 }) {
        Text($r('app.string.financial_detail_benchmark_a'))
          .fontSize(16)
          .lineHeight(21)
          .fontColor($r('app.color.font_secondary'))
        Text($r('app.string.financial_detail_benchmark_b'))
          .fontSize(16)
          .lineHeight(21)
          .fontColor($r('app.color.font_secondary'))
      }
      .alignItems(HorizontalAlign.Start)

      Row({ space: 4 }) {
        Text($r('app.string.financial_detail_view_details'))
          .fontSize(12)
          .lineHeight(16)
          .fontColor($r('app.color.brand'))
        SymbolGlyph($r('sys.symbol.chevron_down'))
          .fontSize(16)
          .fontColor([$r('app.color.brand')])
      }
      .alignItems(VerticalAlign.Center)
      .margin({ top: this.widthBreakpoint === WidthBreakpoint.WIDTH_SM ? 12 : 0 })
    }
    .width('100%')
    .padding({
      top: 16,
      bottom: 16,
      left: 12,
      right: 12
    })
    .backgroundColor($r('app.color.background_tertiary'))
    .borderRadius(this.radius[1])
    .margin({ top: 24 })
  }

  @Builder
  TagChip(tag: TagInfo) {
    Row({ space: 2 }) {
      if (tag.icon) {
        SymbolGlyph(tag.icon)
          .fontSize(16)
          .fontColor([tag.fontColor])
      }
      Text(tag.text)
        .fontSize(16)
        .lineHeight(21)
        .fontColor(tag.fontColor)
    }
    .padding({
      left: 8,
      right: 8,
      top: 2,
      bottom: 2
    })
    .borderRadius(4)
    .backgroundColor(tag.bgColor)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  MetaInfoSeparator() {
    Text('|')
      .fontSize(16)
      .lineHeight(21)
      .fontColor($r('app.color.font_secondary'))
      .margin({ left: 12, right: 12 })
  }
}
