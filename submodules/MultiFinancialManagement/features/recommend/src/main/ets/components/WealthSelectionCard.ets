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

import { BreakpointType, CommonConstants } from 'financialbase';
import { WealthProductInfo } from '../model/RecommendModel';
import { WealthProductViewModel } from '../viewmodel/WealthProductViewModel';

@ComponentV2
export struct WealthSelectionCard {
  @Param radius?: number = 16;
  @Param widthBreakpoint: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack();
  @Local wealthProductViewModel: WealthProductViewModel = new WealthProductViewModel();

  build() {
    Column() {
      Row() {
        Text($r('app.string.wealth_selection'))
          .fontSize(16)
          .lineHeight(22)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.font_primary'))
        Text($r('app.string.more'))
          .fontSize(14)
          .lineHeight(19)
          .fontColor($r('app.color.font_secondary'))
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: 16 })

      GridRow({ gutter: 12, columns: { sm: 2, md: 3, lg: 4 } }) {
        GridCol({ span: { sm: 2, md: 2, lg: 3 } }) {
          GridRow({ gutter: { x: 12, y: 8 }, columns: { sm: 2, md: 2, lg: 3 } }) {
            ForEach(this.wealthProductViewModel.wealthProductList(new BreakpointType(2, 4, 6,
              6).getValue(this.widthBreakpoint)), (item: WealthProductInfo) => {
              GridCol() {
                this.WealthStandardItem(item)
              }
            }, (item: WealthProductInfo, index: number) => JSON.stringify(item.name) + index)
          }
        }

        if (this.widthBreakpoint !== WidthBreakpoint.WIDTH_SM) {
          GridCol({ span: 1 }) {
            this.WealthWeekItem()
          }
        }
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor($r('app.color.comp_background_list_card'))
    .borderRadius(this.radius)
    .margin({ top: 16 })
  }

  @Builder
  WealthStandardItem(product: WealthProductInfo) {
    Column() {
      Text(product.name)
        .fontSize(14)
        .lineHeight(19)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.font_primary'))
        .width('100%')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Row({ space: 12 }) {
        Column() {
          Text(product.rate)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .lineHeight(24)
            .fontColor($r('app.color.multi_color_08'))
          Text($r('app.string.seven_day_annualized'))
            .fontSize(14)
            .lineHeight(20)
            .fontColor($r('app.color.font_tertiary'))
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)

        Column() {
          Text(product.duration)
            .fontSize(16)
            .lineHeight(24)
            .fontColor($r('app.color.font_primary'))
            .fontWeight(FontWeight.Medium)
          Text($r('app.string.medium_low_risk'))
            .fontSize(14)
            .lineHeight(20)
            .fontColor($r('app.color.font_tertiary'))
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.End)
      }
      .width(this.widthBreakpoint === WidthBreakpoint.WIDTH_SM ? '100%' : 159)
      .margin({ top: 12 })
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Bottom)
    }
    .height(107)
    .padding({
      top: 16,
      bottom: 16,
      left: 12,
      right: 12
    })
    .borderRadius(12)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor($r('app.color.alert5'))
    .onClick(() => {
      this.pageStack.pushPath({ name: CommonConstants.FINANCIAL_DETAIL_PAGE_NAME })
    })
  }

  @Builder
  WealthWeekItem() {
    Column() {
      Text($r('app.string.weekly_open_product'))
        .fontSize(14)
        .lineHeight(20)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.font_primary'))
        .width('100%')
      Text($r('app.string.purchased_count'))
        .fontSize(14)
        .lineHeight(20)
        .fontColor($r('app.color.font_tertiary'))
        .width('100%')
        .margin({ top: 2 })

      Image($r('app.media.rate'))
        .height(79)
        .width('100%')
        .objectFit(ImageFit.Fill)

      Row() {
        Text('02-24').fontSize(14).lineHeight(20).fontColor($r('app.color.font_fourth'))
        Text('05-24').fontSize(14).lineHeight(20).fontColor($r('app.color.font_fourth'))
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 4, bottom: 17 })

      Row({ space: 16 }) {
        Column() {
          Text('3.76%')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .lineHeight(21)
            .fontColor($r('app.color.multi_color_08'))
          Text($r('app.string.seven_day_annualized'))
            .fontSize(14)
            .lineHeight(19)
            .fontColor($r('app.color.font_tertiary'))
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)

        Column() {
          Text($r('app.string.duration_6_months'))
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.font_primary'))
          Text($r('app.string.medium_low_risk'))
            .fontSize(14)
            .lineHeight(19)
            .fontColor($r('app.color.font_tertiary'))
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Bottom)
    }
    .padding({
      top: 16,
      bottom: 16,
      left: 12,
      right: 12
    })
    .borderRadius(12)
    .height(222)
    .backgroundColor($r('app.color.alert5'))
    .onClick(() => {
      this.pageStack.pushPath({ name: CommonConstants.FINANCIAL_DETAIL_PAGE_NAME })
    })
  }
}