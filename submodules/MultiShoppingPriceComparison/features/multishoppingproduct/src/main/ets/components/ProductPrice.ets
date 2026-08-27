/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { WidthBreakpointType } from 'multishoppingbase';
import { ProductInfoState } from '../viewmodel/ProductInfoState';

@ComponentV2
export struct ProductPrice {
  private static readonly GRADIENT_COLORS: string[] = ['#FF6354', '#CF0A2C', '#FAE8E0', '#FFC9C9'];
  @Param public widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @Param public state: ProductInfoState = new ProductInfoState(this.getUIContext().getHostContext()!);

  private isLargeWidth(): boolean {
    return this.widthBp === WidthBreakpoint.WIDTH_LG || this.widthBp === WidthBreakpoint.WIDTH_XL;
  }

  @Builder
  private timeText(timeText: string) {
    Row() {
      Text(timeText)
        .fontSize(10)
        .lineHeight(14)
        .width(12)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_on_primary'))
    }
    .padding({ left: 2, right: 2 })
    .height(16)
    .width(16)
    .borderRadius(4)
    .backgroundColor($r('app.color.time_chip_background'))
  }

  @Builder
  private timeTip(tipText: string) {
    Text(tipText)
      .fontSize(9)
      .lineHeight(12)
      .fontWeight(FontWeight.Medium)
      .fontColor($r('sys.color.font_on_primary'))
  }

  @Builder
  private productTag(tagText: string) {
    Row() {
      Text(tagText)
        .fontSize(10)
        .lineHeight(14)
        .fontColor('#E84026')
        .fontWeight(FontWeight.Normal)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .height(17)
    .borderRadius(4)
    .borderColor('#FFD4CC')
    .borderWidth(0.5)
    .padding({ left: 6, right: 6 })
    .margin({ right: 4 })
    .opacity(0.55)
    .linearGradient({
      direction: GradientDirection.Right,
      repeating: false,
      colors: [[ProductPrice.GRADIENT_COLORS[2], 0.0], [ProductPrice.GRADIENT_COLORS[3], 1.0]]
    })
  }

  @Builder
  private detailRightArrow() {
    Image($r('app.media.arrow_right'))
      .width(12)
      .height(12)
  }

  build() {
    Column() {
      Row() {
        Text(this.state.priceNames[0])
          .fontSize(14)
          .lineHeight(14)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_on_primary'))
        Text(this.state.priceNames[1])
          .fontSize(22)
          .lineHeight(22)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_on_primary'))
        Text(this.state.priceNames[2])
          .decoration({
            type: TextDecorationType.LineThrough,
            color: $r('sys.color.font_on_primary')
          })
          .opacity(0.55)
          .fontSize(12)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_on_primary'))
        Blank()
        Row() {
          this.timeTip(this.state.priceNames[3])
          this.timeText(this.state.priceNames[4])
          this.timeTip(this.state.priceNames[5])
          this.timeText(this.state.priceNames[6])
          this.timeTip(this.state.priceNames[7])
          this.timeText(this.state.priceNames[8])
        }
        .padding({ bottom: 3 })
      }
      .width('100%')
      .height(54)
      .borderRadius(12)
      .padding({ left: 8, right: 8, bottom: 16 })
      .alignItems(VerticalAlign.Bottom)
      .linearGradient({
        direction: GradientDirection.Right,
        repeating: false,
        colors: [[ProductPrice.GRADIENT_COLORS[0], 0.0], [ProductPrice.GRADIENT_COLORS[1], 1.0]]
      })

      Row() {
        Text(this.state.priceNames[9])
          .fontSize(12)
          .fontWeight(FontWeight.Normal)
          .lineHeight(16)
          .fontColor($r('app.color.text_primary'))
          .opacity(0.55)
        Blank()
        this.detailRightArrow()
      }
      .width('100%')
      .margin({ top: 8, bottom: 8 })

      Row() {
        this.productTag(this.state.priceNames[10])
        this.productTag(this.state.priceNames[11])
        this.productTag(this.state.priceNames[12])
        Blank()
        Row() {
          Text(this.state.priceNames[13])
            .fontColor($r('sys.color.font_on_primary'))
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
        }
        .width(this.isLargeWidth() ? 72 : 48)
        .height(20)
        .borderRadius(10)
        .backgroundColor('#CF0A2C')
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .margin({ bottom: 8 })

      Row() {
        Image($r('app.media.ic_public_gps'))
          .opacity(0.55)
          .width(16)
          .height(16)
          .margin({ right: 8 })
        Column() {
          Row() {
            Text(this.state.priceNames[14])
              .fontSize(12)
              .fontWeight(FontWeight.Normal)
            .lineHeight(16)
              .opacity(0.55)
            Blank()
            this.detailRightArrow()
          }
          .width('100%')

          Text(this.state.priceNames[15])
            .fontSize(12)
            .lineHeight(16)
            .fontColor($r('app.color.text_primary'))
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
      }
      .alignItems(VerticalAlign.Top)
      .width('100%')
      .height(36)
    }
    .alignItems(HorizontalAlign.Start)
    .backgroundColor($r('app.color.surface_primary'))
    .width('100%')
    .borderRadius(12)
    .padding(12)
    .margin({
      top: this.isLargeWidth() ? 0 : 8,
      bottom: new WidthBreakpointType(12, 14, 16, 16).getValue(this.widthBp)
    })
  }
}
