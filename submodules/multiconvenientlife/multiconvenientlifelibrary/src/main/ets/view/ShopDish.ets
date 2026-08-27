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

import { BreakpointConstants } from '../constants/BreakpointConstants';
import { CommonConstants } from '../constants/CommonConstants';
import { ShopMenuItem } from '../viewmodel/ShopDisplayViewModel';
import { ShopPop } from './ShopPop';

@Component
export struct ShopDish {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') @Watch('screenChange') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'showPopUpChange') @Watch('popUpChange') showPopUpChange: boolean = false;
  @Consume(CommonConstants.LIFE_PREFIX + 'shopPageInfo') shopPageInfo: NavPathStack;
  @Consume(CommonConstants.LIFE_PREFIX + 'ifShowShopDisplay') ifShowShopDisplay: boolean;
  @Prop shopMenuItem: ShopMenuItem;
  @Prop showSelectButton: boolean;
  @State showPop: boolean = false;
  @State showPopUp: boolean = false;

  screenChange() {
    if (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
      this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL) {
      this.showPop = false;
    }
  }

  popUpChange() {
    if (!this.showPopUpChange) {
      this.showPopUp = false;
    }
  }

  @Builder
  popBuilder() {
    Column() {
      ShopPop();
    }
  }

  build() {
    Row() {
      Image(this.shopMenuItem.getDishImage())
        .width($r('app.float.goods_width'))
        .aspectRatio(1)
      Column() {
        Button()
          .size({ width: 70, height: 18 })
          .backgroundColor($r('sys.color.comp_divider'))
          .margin({ bottom: 6 })
        Button()
          .size({ width: 93, height: 14 })
          .backgroundColor($r('sys.color.ohos_id_color_alert'))
          .opacity(0.15)
          .margin({ bottom: 6 })
        Button()
          .height(12)
          .constraintSize({
            maxWidth: 112,
            minWidth: 100
          })
          .backgroundColor($r('sys.color.comp_background_secondary'))
          .margin({ bottom: 12 })
        Row() {
          Text($r('app.string.currency_symbol'))
            .fontSize(11)
            .fontWeight(CommonConstants.FONT_WEIGHT_400)
            .margin({
              right: $r('app.float.filtering_padding_lr')
            })
          Text('XX')
            .maxFontSize(16)
            .minFontSize(13)
            .fontWeight(CommonConstants.FONT_WEIGHT_400)
            .margin({
              right: $r('app.float.price_margin_dish')
            })
          Text(CommonConstants.CURRENCY_SYMBOL + ' ' + 'XX')
            .fontSize(11)
            .constraintSize({
              maxWidth: '100%',
              minWidth: 10
            })
            .maxLines(1)
            .layoutWeight(1)
            .ellipsisMode(EllipsisMode.END)
            .fontWeight(CommonConstants.FONT_WEIGHT_400)
            .decoration({
              type: TextDecorationType.LineThrough,
              color: $r('sys.color.font_tertiary')
            })
            .fontColor($r('sys.color.font_tertiary'))
          Blank()
          Text($r('app.string.select_specification'))
            .fontSize($r('app.float.delivery_font'))
            .fontWeight(CommonConstants.FONT_WEIGHT_400)
            .fontColor($r('sys.color.font_on_primary'))
            .backgroundColor($r('app.color.currency_symbol'))
            .borderRadius($r('app.float.text_radius'))
            .padding({
              top: $r('app.float.back_margin_bottom'),
              bottom: $r('app.float.back_margin_bottom'),
              left: $r('app.float.filtering_margin_right'),
              right: $r('app.float.filtering_margin_right')
            })
            .visibility(this.showSelectButton && this.shopMenuItem.getDishAddOrChoice() === 1 ?
              Visibility.Visible : Visibility.None)
            .onClick(() => {
              if (this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_LG &&
                this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_XL) {
                this.showPop = true;
              } else {
                this.showPopUp = true;
                this.showPopUpChange = true;
              }
            })
            .bindSheet($$this.showPop, this.popBuilder(), {
              height: SheetSize.FIT_CONTENT,
              backgroundColor: $r('sys.color.comp_background_primary'),
              title: {
                title: $r('app.string.select_specification')
              },
              maskColor: $r('sys.color.icon_tertiary')
            })
            .bindPopup(this.showPopUp, {
              builder: this.popBuilder,
              placement: Placement.Left,
              width: $r('app.float.popup_width'),
              mask: { color: $r('sys.color.icon_tertiary') },
              onStateChange: (e) => {
                if (!e.isVisible) {
                  this.showPopUp = false;
                }
              }
            })

          Text($r('app.string.add_symbol'))
            .fontSize($r('app.float.delivery_font'))
            .fontWeight(CommonConstants.FONT_WEIGHT_400)
            .fontColor($r('sys.color.font_on_primary'))
            .backgroundColor($r('sys.color.ohos_id_color_alert'))
            .borderRadius($r('app.float.nine_radius'))
            .width($r('app.float.search_width'))
            .height($r('app.float.search_width'))
            .textAlign(TextAlign.Center)
            .visibility(this.showSelectButton && this.shopMenuItem.getDishAddOrChoice() === 0 ?
              Visibility.Visible : Visibility.None)
        }
        .alignItems(VerticalAlign.Bottom)
        .width(CommonConstants.FULL_PERCENT)
      }
      .padding({
        left: $r('app.float.back_image_right')
      })
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

    }
    .onClick(() => {
      this.shopPageInfo.pushPath({ name: CommonConstants.DEFAULT_ROUTE }, false)
      this.ifShowShopDisplay = false
    })
    .margin({
      bottom: $r('app.float.margin_twelves')
    })
    .width(CommonConstants.FULL_PERCENT)
  }
}