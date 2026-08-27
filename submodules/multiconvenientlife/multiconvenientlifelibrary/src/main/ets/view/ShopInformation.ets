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
import { ShopInformation } from '../viewmodel/ShopDisplayViewModel';

@Component
export struct ShopHeader {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @Consume(CommonConstants.LIFE_PREFIX + 'ifShowSides') ifShowSides: boolean;
  private shopInformation = new ShopInformation();

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Image($r('app.media.shopHeaderImage'))
        .width(CommonConstants.FULL_PERCENT)
        .objectFit(ImageFit.Cover)
        .height($r('app.float.head_image_height'))
      Column() {
        Row() {
          Column() {
            Row() {
              Text(this.shopInformation.getShopName())
                .fontWeight(CommonConstants.FONT_WEIGHT_700)
                .fontSize($r('app.float.delicious_font'))
                .fontColor($r('sys.color.font_primary'))
            }
            .margin({
              bottom: $r('app.float.margin_food')
            })

            Row() {
              Text(JSON.stringify(this.shopInformation.getShopRating()))
                .fontColor($r('sys.color.ohos_id_color_alert'))
                .fontSize($r('app.float.tabs_font'))
                .fontWeight(CommonConstants.FONT_WEIGHT_700)
                .margin({
                  right: $r('app.float.favor_bottom')
                })
              Text(this.shopInformation.getShopProfile())
                .fontColor($r('sys.color.font_tertiary'))
                .fontSize($r('app.float.delivery_font'))
                .fontWeight(CommonConstants.FONT_WEIGHT_400)
                .width('70%')
            }
            .margin({
              bottom: $r('app.float.tabs_padding_tb')
            })

            Row() {
              Button()
                .backgroundColor($r('sys.color.ohos_id_color_alert'))
                .opacity(0.15)
                .height(14)
                .width(80)
                .margin({
                  bottom: 8
                })
            }
          }
          .alignItems(HorizontalAlign.Start)

          Blank()
          Image($r('app.media.shopPicture'))
            .width($r('app.float.enlarge_dish_margin_left'))
            .aspectRatio(1)
        }
        .width(CommonConstants.FULL_PERCENT)
        .margin({
          bottom: $r('app.float.favor_bottom')
        })

        Row() {
          Button()
            .size({ width: 280, height: 16 })
            .backgroundColor($r('sys.color.comp_background_secondary'))
        }
        .width(CommonConstants.FULL_PERCENT)
        .margin({
          bottom: $r('sys.float.padding_level4')
        })

        Row() {
          ForEach(this.shopInformation.getShopTags(), () => {
            Button()
              .size({ width: 60, height: 16 })
              .backgroundColor($r('sys.color.ohos_id_color_alert'))
              .opacity(0.15)
              .margin({ right: 4 })
          }, (item: string) => item);
        }
      }
      .margin({
        top: $r('app.float.shop_margin_top')
      })
      .alignItems(HorizontalAlign.Start)
      .borderRadius({
        topLeft: $r('app.float.img_choose_width'),
        topRight: $r('app.float.img_choose_width')
      })
      .width(CommonConstants.FULL_PERCENT)
      .backgroundColor($r('sys.color.background_primary'))
      .padding({
        top: $r('app.float.padding_small'),
        left: this.ifShowSides ? new BreakpointType({
          sm: $r('app.float.padding_small'), md: $r('app.float.padding_small'),
          lg: $r('app.float.common_padding')
        }).getValue(this.currentBreakpoint) :
          new BreakpointType({
            sm: $r('app.float.padding_small'), md: $r('app.float.common_padding'),
            lg: $r('app.float.common_padding')
          }).getValue(this.currentBreakpoint),
        right: this.ifShowSides ? new BreakpointType({
          sm: $r('app.float.padding_small'), md: $r('app.float.padding_small'),
          lg: $r('app.float.common_padding')
        }).getValue(this.currentBreakpoint) :
          new BreakpointType({
            sm: $r('app.float.padding_small'), md: $r('app.float.common_padding'),
            lg: $r('app.float.common_padding')
          }).getValue(this.currentBreakpoint)
      })
    }
  }
}

@Component
export struct ShopSideBar {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'naviIndicatorHeight') naviIndicatorHeight: number = 0;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'statusBarHeight') statusBarHeight: number = 0;
  @Consume(CommonConstants.LIFE_PREFIX + 'ifShowSides') ifShowSides: boolean;
  handleBackPress?: Function;
  private shopInformation = new ShopInformation()

  build() {
    Stack() {
      Image($r('app.media.shopHeaderImage'))
        .height(CommonConstants.FULL_PERCENT)
        .width(CommonConstants.FULL_PERCENT)
        .objectFit(ImageFit.Cover)

      Column() {
        Row() {
          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.chevron_backward'))
              .fontSize($r('sys.float.Title_M'))
              .fontColor([$r('app.color.symbol_icon_dark')])
          }
          .backgroundColor($r('app.color.symbol_circle_bg_color_dark'))
          .height(40)
          .aspectRatio(1)
          .onClick(() => {
            this.handleBackPress?.();
          })
          .margin({
            right: $r('app.float.back_image_right')
          })

          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.arrow_down_right_and_arrow_up_left'))
              .fontSize($r('sys.float.Title_M'))
              .fontColor([$r('app.color.symbol_icon_dark')])
          }
          .backgroundColor($r('app.color.symbol_circle_bg_color_dark'))
          .height(40)
          .aspectRatio(1)
          .onClick(() => {
            this.ifShowSides = true;
          })
        }
        .width(CommonConstants.FULL_PERCENT)
        .justifyContent(FlexAlign.Start)
        .margin({
          top: this.statusBarHeight
        })

        Column() {
          Row() {
            Text(this.shopInformation.getShopName())
              .fontSize($r('app.float.shop_name_font'))
              .fontWeight(CommonConstants.FONT_WEIGHT_700)
              .fontColor(Color.White)
          }
          .margin({
            bottom: $r('app.float.filtering_margin_right')
          })

          Row() {
            Text(JSON.stringify(this.shopInformation.getShopRating()))
              .fontSize($r('app.float.shop_rating_font'))
              .fontWeight(CommonConstants.FONT_WEIGHT_700)
              .fontColor(Color.White)
          }
          .margin({
            bottom: $r('app.float.filtering_margin_right')
          })

          Row() {
            Text(this.shopInformation.getShopProfile())
              .fontSize($r('app.float.delivery_font'))
              .fontWeight(CommonConstants.FONT_WEIGHT_400)
              .fontColor($r('app.color.sixty_white'))
              .margin({
                right: $r('app.float.filtering_margin_right')
              })
            Text(this.shopInformation.getShopRanking())
              .fontColor(Color.White)
              .fontSize($r('app.float.filtering_font'))
              .fontWeight(CommonConstants.FONT_WEIGHT_400)
              .backgroundColor($r('app.color.ten_white'))
              .borderRadius($r('app.float.add_cart_border'))
              .padding({
                top: $r('app.float.filtering_padding_tb'),
                bottom: $r('app.float.filtering_padding_tb'),
                left: $r('app.float.flag_margin_right'),
                right: $r('app.float.flag_margin_right')
              })
              .margin({
                right: $r('app.float.flag_margin_right')
              })
          }
          .margin({
            bottom: $r('app.float.filtering_margin_right')
          })

          Row() {
            Button()
              .height(14)
              .width('60%')
              .backgroundColor($r('sys.color.font_on_fourth'))
          }
          .margin({
            bottom: $r('app.float.filtering_margin_right')
          })

          Row() {
            Button()
              .height(14)
              .width(48)
              .backgroundColor($r('sys.color.font_on_fourth'))
              .padding({
                top: $r('app.float.filtering_padding_tb'),
                bottom: $r('app.float.filtering_padding_tb'),
                left: $r('app.float.flag_margin_right'),
                right: $r('app.float.flag_margin_right')
              })
              .margin({
                right: $r('app.float.flag_margin_right')
              })
          }
        }
        .alignItems(HorizontalAlign.Start)
        .width(CommonConstants.FULL_PERCENT)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        top: $r('app.float.shop_padding_top'),
        left: $r('app.float.padding_header'),
        bottom: $r('app.float.padding_header')
      })
      .height(CommonConstants.FULL_PERCENT)
      .width(CommonConstants.FULL_PERCENT)
      .linearGradient({
        angle: CommonConstants.ANGLE_IMAGE,
        colors: [[CommonConstants.LINEAR_GRADIENT_FIRST, CommonConstants.LINEAR_GRADIENT_INDEX],
          [CommonConstants.LINEAR_GRADIENT_SECOND, 1]]
      })
    }
    .width(CommonConstants.FULL_PERCENT)
  }
}