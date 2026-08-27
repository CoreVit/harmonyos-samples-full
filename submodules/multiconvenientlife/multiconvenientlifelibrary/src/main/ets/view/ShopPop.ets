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
import { BreakpointType } from '../utils/BreakpointSystem';
import { ShopMenuData } from '../viewmodel/ShopDisplayViewModel';

@Component
export struct ShopPop {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'showPopUpChange') showPopUpChange: boolean = false;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'naviIndicatorHeight') naviIndicatorHeight: number = 0;
  private shopMenuItem = new ShopMenuData().getMenuList()[0];

  build() {
    Column() {
      if (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
        this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL) {
        Row() {
          Text($r('app.string.select_specification'))
            .fontSize($r('app.float.delicious_font'))
            .lineHeight($r('app.float.specification_line_height'))
            .fontWeight(CommonConstants.FONT_WEIGHT_700)
          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.xmark'))
              .fontSize(24)
              .fontColor([$r('sys.color.icon_primary')])
          }
          .height(40)
          .aspectRatio(1)
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .onClick(() => {
            this.showPopUpChange = false;
          })
        }
        .width(CommonConstants.FULL_PERCENT)
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({
          top: $r('app.float.margin_small'),
          bottom: $r('app.float.eight_padding')
        })
      }

      Row() {
        Image($r('app.media.MenuGoods1'))
          .width($r('app.float.goods_width'))
          .aspectRatio(1)
        Column() {
          Text(this.shopMenuItem.getDishName())
            .fontSize($r('app.float.food_data_font'))
            .fontWeight(CommonConstants.FONT_WEIGHT_700)
            .margin({
              bottom: $r('app.float.flag_margin_right')
            })
          Button()
            .width('30%')
            .height(14)
            .backgroundColor($r('sys.color.ohos_id_color_alert'))
            .opacity(0.1)
            .margin({
              bottom: $r('app.float.flag_margin_right')
            })

          Row() {
            Button()
              .width('20%')
              .height(14)
              .backgroundColor($r('sys.color.comp_background_secondary'))
              .margin({
                right: 6
              })
            Button()
              .width('20%')
              .height(14)
              .backgroundColor($r('sys.color.comp_background_secondary'))
          }
          .margin({
            bottom: $r('app.float.swiper_margin_bottom')
          })

          Row() {
            Text($r('app.string.currency_symbol'))
              .fontSize($r('app.float.add_cart_font'))
              .fontWeight(CommonConstants.FONT_WEIGHT_400)
              .margin({
                right: $r('app.float.back_margin_bottom')
              })
            Text('XX')
              .fontSize($r('app.float.plants_language_font'))
              .fontWeight(CommonConstants.FONT_WEIGHT_400)
              .margin({
                right: $r('app.float.price_margin_dish')
              })
            Text(CommonConstants.CURRENCY_SYMBOL + ' ' + 'XX')
              .fontSize($r('app.float.add_cart_font'))
              .fontWeight(CommonConstants.FONT_WEIGHT_400)
              .decoration({ type: TextDecorationType.LineThrough })
              .fontColor($r('sys.color.font_tertiary'))
          }
          .width(CommonConstants.FULL_PERCENT)
        }
        .padding({
          left: $r('app.float.eight_padding')
        })
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }
      .margin({
        bottom: $r('app.float.margin_small')
      })

      Row() {
        Text($r('app.string.count'))
          .fontSize($r('app.float.add_cart_font'))
          .fontWeight(CommonConstants.FONT_WEIGHT_700)
        Blank()
        Row() {
          Text($r('app.string.minuses'))
          TextInput({ text: '1' })
            .backgroundColor($r('app.color.five_white'))
            .width(CommonConstants.SELF_ADAPTING)
            .fontSize($r('app.float.delivery_font'))
            .fontWeight(CommonConstants.FONT_WEIGHT_400)
            .padding({
              top: $r('app.float.filtering_padding_tb'),
              bottom: $r('app.float.filtering_padding_tb'),
              right: $r('app.float.avatar_padding_left'),
              left: $r('app.float.avatar_padding_left')
            })
            .height($r('app.float.search_width'))
            .borderRadius(0)
            .margin({
              left: $r('app.float.flag_margin_right'),
              right: $r('app.float.flag_margin_right')
            })
          Text($r('app.string.add_symbol'))
        }
      }
      .width(CommonConstants.FULL_PERCENT)
      .margin({
        bottom: $r('app.float.margin_small')
      })

      Column() {
        Text($r('app.string.tastes'))
          .fontSize($r('app.float.add_cart_font'))
          .fontWeight(CommonConstants.FONT_WEIGHT_700)
          .alignSelf(ItemAlign.Start)
          .margin({
            bottom: $r('app.float.eight_padding')
          })
        Row() {
          Button()
            .width('20%')
            .height($r('app.float.food_padding_left'))
            .backgroundColor($r('sys.color.ohos_id_color_alert'))
            .opacity(0.1)
            .margin({ right: $r('sys.float.padding_level4') })
          Button()
            .width('20%')
            .height($r('app.float.food_padding_left'))
            .backgroundColor($r('sys.color.comp_background_secondary'))
            .margin({ right: $r('sys.float.padding_level4') })
          Button()
            .width('20%')
            .height($r('app.float.food_padding_left'))
            .backgroundColor($r('sys.color.comp_background_secondary'))
            .margin({ right: $r('sys.float.padding_level4') })
          Button()
            .width('20%')
            .height($r('app.float.food_padding_left'))
            .backgroundColor($r('sys.color.comp_background_secondary'))
            .margin({ right: $r('sys.float.padding_level4') })
        }
        .width(CommonConstants.FULL_PERCENT)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .margin({
        bottom: $r('app.float.margin_small')
      })

      Text($r('app.string.chosen'))
        .fontColor(Color.White)
        .fontWeight(CommonConstants.FONT_WEIGHT_700)
        .fontSize($r('app.float.reviews_font'))
        .textAlign(TextAlign.Center)
        .width(CommonConstants.FULL_PERCENT)
        .backgroundColor($r('app.color.currency_symbol'))
        .borderRadius($r('app.float.line_height'))
        .height($r('app.float.tx2_width'))
    }
    .backgroundColor($r('sys.color.comp_background_primary'))
    .padding({
      left: new BreakpointType({
        sm: $r('sys.float.padding_level8'), md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.currentBreakpoint),
      right: new BreakpointType({
        sm: $r('sys.float.padding_level8'), md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.currentBreakpoint),
      bottom: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ? 16 + this.naviIndicatorHeight :
        $r('app.float.padding_small')
    })
  }
}