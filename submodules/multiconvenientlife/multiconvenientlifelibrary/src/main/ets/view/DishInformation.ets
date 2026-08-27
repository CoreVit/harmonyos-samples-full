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
import { DishDetailConstants } from '../constants/DishDetailConstants';
import { BreakpointType } from '../utils/BreakpointSystem';

@Component
export struct DishHead {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @Consume(CommonConstants.LIFE_PREFIX + 'ifShowSides') ifShowSides: boolean;
  @Consume(CommonConstants.LIFE_PREFIX + 'ifShowShopDisplay') ifShowShopDisplay: boolean;
  @Link @Watch('resizeImage') ifPictureExpansion: Boolean;
  @Link imageHeightExtension: number;
  @Link imageHeightFold: number;
  @Link imageHeight: number;
  @State @Watch('resizeImage') imageRatio: number = 0;
  @State @Watch('resizeImage') imageWidth: number = 0;
  handleBackPress?: Function;

  resizeImage(): void {
    this.imageHeightExtension = this.imageWidth * this.imageRatio;
    this.imageHeightFold = Math.min(380, this.imageHeightExtension);
    if (this.ifPictureExpansion) {
      this.imageHeight = this.imageHeightExtension;
    } else {
      this.imageHeight = this.imageHeightFold;
    }
  }

  build() {
    Column() {
      Stack({
        alignContent: Alignment.TopStart
      }) {
        Image($r('app.media.merchandiseMap'))
          .width(CommonConstants.FULL_PERCENT)
          .height(this.imageHeight)
          .objectFit(ImageFit.Cover)
          .animation({
            duration: 250,
            curve: Curve.EaseOut,
            iterations: 1,
            playMode: PlayMode.Normal
          })
          .onComplete((msg) => {
            if (msg !== undefined) {
              this.imageRatio = msg.height / msg.width;
            }
          })
          .onAreaChange((oldArea: Area, newArea: Area) => {
            this.imageWidth = Number.parseInt(newArea.width as string);
            if (!this.ifPictureExpansion) {
              this.imageHeight = this.imageHeightFold;
            } else {
              this.imageHeight = this.imageHeightExtension;
            }
          })

        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.chevron_backward'))
            .fontColor([$r('app.color.symbol_icon_light')])
            .fontSize($r('sys.float.Title_M'))
        }
        .height(40)
        .aspectRatio(1)
        .margin({
          left: this.ifShowSides ? new BreakpointType({
            sm: $r('app.float.margin_small'), md: $r('app.float.margin_small'),
            lg: $r('app.float.common_margin')
          }).getValue(this.currentBreakpoint) :
            new BreakpointType({
              sm: $r('app.float.margin_small'), md: $r('app.float.common_margin'),
              lg: $r('app.float.common_margin')
            }).getValue(this.currentBreakpoint),
          top: $r('app.float.back_dish_margin')
        })
        .onClick(() => {
          this.handleBackPress?.();
          this.ifShowShopDisplay = true;
        })
        .backgroundColor($r('app.color.symbol_circle_bg_color_light'))

        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.arrow_up_left_and_arrow_down_right'))
            .fontSize($r('sys.float.Title_M'))
            .fontColor([$r('app.color.symbol_icon_light')])
        }
        .height(40)
        .aspectRatio(1)
        .margin({
          left: this.ifShowSides ?
            new BreakpointType({
              sm: $r('app.float.zero_margin'), md: $r('app.float.enlarge_dish_margin_left'),
              lg: $r('app.float.enlarge_margin')
            }).getValue(this.currentBreakpoint) :
            new BreakpointType({
              sm: $r('app.float.zero_margin'), md: $r('app.float.enlarge_margin'),
              lg: $r('app.float.enlarge_margin')
            }).getValue(this.currentBreakpoint),
          top: $r('app.float.back_dish_margin')
        })
        .onClick(() => {
          this.ifShowSides = false;
        })
        .backgroundColor($r('app.color.symbol_circle_bg_color_light'))
        .visibility(this.ifShowSides && this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_SM ?
          Visibility.Visible : Visibility.None)

        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.arrow_down_right_and_arrow_up_left'))
            .fontSize($r('sys.float.Title_M'))
            .fontColor([$r('app.color.symbol_icon_light')])
        }
        .height(40)
        .aspectRatio(1)
        .margin({
          left: this.ifShowSides ?
            new BreakpointType({
              sm: $r('app.float.zero_margin'), md: $r('app.float.enlarge_dish_margin_left'),
              lg: $r('app.float.enlarge_margin')
            }).getValue(this.currentBreakpoint) :
            new BreakpointType({
              sm: $r('app.float.zero_margin'), md: $r('app.float.enlarge_margin'),
              lg: $r('app.float.enlarge_margin')
            }).getValue(this.currentBreakpoint),
          top: $r('app.float.back_dish_margin')
        })
        .onClick(() => {
          this.ifShowSides = true;
        })
        .backgroundColor($r('app.color.symbol_circle_bg_color_light'))
        .visibility(!this.ifShowSides && this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_SM ?
          Visibility.Visible : Visibility.None)
      }

      Column() {
        DishMainInformation({ largeMode: false })
      }
      .margin({
        left: this.ifShowSides ? new BreakpointType({
          sm: $r('app.float.margin_small'), md: $r('app.float.margin_small'),
          lg: $r('app.float.common_margin')
        }).getValue(this.currentBreakpoint) :
          new BreakpointType({
            sm: $r('app.float.margin_small'), md: $r('app.float.common_margin'),
            lg: $r('app.float.common_margin')
          }).getValue(this.currentBreakpoint),
        right: this.ifShowSides ? new BreakpointType({
          sm: $r('app.float.margin_small'), md: $r('app.float.margin_small'),
          lg: $r('app.float.common_margin')
        }).getValue(this.currentBreakpoint) :
          new BreakpointType({
            sm: $r('app.float.margin_small'), md: $r('app.float.common_margin'),
            lg: $r('app.float.common_margin')
          }).getValue(this.currentBreakpoint),
        top: $r('app.float.margin_twelves')
      })
      .padding($r('app.float.twelves_padding'))
      .backgroundColor($r('sys.color.comp_background_primary'))
      .borderRadius($r('app.float.dish_border'))
    }
    .margin({
      bottom: $r('app.float.margin_twelves')
    })
  }
}

@Component
export struct DishSideBar {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'naviIndicatorHeight') naviIndicatorHeight: number = 0;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'statusBarHeight') statusBarHeight: number = 0;
  @Consume(CommonConstants.LIFE_PREFIX + 'ifShowSides') ifShowSides: boolean;
  @Consume(CommonConstants.LIFE_PREFIX + 'ifShowShopDisplay') ifShowShopDisplay: boolean;
  handleBackPress?: Function;

  build() {
    Column() {
      Row() {
        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.chevron_backward'))
            .fontColor([$r('sys.color.icon_primary')])
            .fontSize($r('sys.float.Title_M'))
        }
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .height(40)
        .aspectRatio(1)
        .margin({
          right: $r('app.float.back_image_right')
        })
        .onClick(() => this.handleBackPress?.())

        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.arrow_down_right_and_arrow_up_left'))
            .fontSize($r('sys.float.Title_M'))
            .fontColor([$r('sys.color.icon_primary')])
        }
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .height(40)
        .aspectRatio(1)
        .onClick(() => {
          this.ifShowSides = true;
        })
      }
      .margin({
        bottom: $r('sys.float.padding_level4'),
        top: this.statusBarHeight
      })
      .justifyContent(FlexAlign.Start)
      .width(CommonConstants.EIGHTY_THREE_PERCENT)

      Image($r('app.media.merchandiseMap'))
        .objectFit(ImageFit.Cover)
        .borderRadius($r('app.float.merchandise_border'))
        .width(CommonConstants.EIGHTY_THREE_PERCENT)
        .flexGrow(1)
        .linearGradient({
          angle: CommonConstants.ANGLE_IMAGE,
          colors: [
            [CommonConstants.LINEAR_GRADIENT_FIRST, CommonConstants.LINEAR_GRADIENT_INDEX],
            [CommonConstants.LINEAR_GRADIENT_SECOND, 1]
          ]
        })

      Row() {
        DishMainInformation({ largeMode: true })
      }
      .flexGrow(0)
      .flexShrink(0)
      .width(CommonConstants.EIGHTY_THREE_PERCENT)
      .padding({
        top: $r('app.float.twelves_padding'),
        bottom: $r('app.float.merchandise_bottom')
      })
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
  }
}

@Component
export struct DishMainInformation {
  @Prop largeMode: boolean;

  build() {
    Column() {
      Row() {
        Text($r('app.string.delicious_fried'))
          .fontSize(this.largeMode ? $r('app.float.fried_font') : $r('app.float.delicious_font'))
          .fontWeight(CommonConstants.FONT_WEIGHT_700)
          .layoutWeight(1)
        Blank()
        Column() {
          SymbolGlyph($r('sys.symbol.star'))
            .fontColor([$r('sys.color.icon_secondary')])
            .fontSize(14)
          Text($r('app.string.collections_text'))
            .fontColor($r('sys.color.font_secondary'))
            .fontSize($r('app.float.delivery_font'))
        }
      }
      .alignSelf(ItemAlign.Center)
      .width(CommonConstants.FULL_PERCENT)
      .margin({
        bottom: this.largeMode ? $r('app.float.margin_twelves') : $r('app.float.margin_food')
      })

      Row() {
        ForEach(DishDetailConstants.PRODUCT_TAG_LIST, () => {
          Button()
            .size({ width: 56, height: 14 })
            .backgroundColor($r('sys.color.ohos_id_color_alert'))
            .opacity(0.1)
            .margin({
              right: $r('sys.float.padding_level2')
            })
        }, (item: string) => item);
      }
      .width(CommonConstants.FULL_PERCENT)
      .margin({
        bottom: $r('sys.float.padding_level4')
      })

      Button()
        .size({ width: 64, height: 14 })
        .backgroundColor($r('sys.color.comp_background_secondary'))
        .alignSelf(ItemAlign.Start)
        .margin({
          bottom: $r('app.float.margin_twelves')
        })
      Row() {
        Row() {
          Text($r('app.string.currency_symbol'))
            .fontColor($r('sys.color.ohos_id_color_alert'))
            .fontSize(this.largeMode ? $r('app.float.currency_symbol') : $r('app.float.delivery_font'))
            .margin({
              right: $r('app.float.currency_symbol_margin_right')
            })
          Text($r('app.string.pay_price'))
            .fontColor($r('sys.color.ohos_id_color_alert'))
            .fontSize(this.largeMode ? $r('app.float.pay_price_font') : $r('app.float.currency_symbol'))
            .fontWeight(CommonConstants.FONT_WEIGHT_700)
            .margin({
              right: $r('app.float.pay_price_margin_right')
            })
          Text($r('app.string.original_price'))
            .fontColor($r('sys.color.font_tertiary'))
            .fontSize(this.largeMode ? $r('app.float.amounts_font') : $r('app.float.filtering_font'))
            .fontWeight(CommonConstants.FONT_WEIGHT_400)
            .decoration({ type: TextDecorationType.LineThrough, color: $r('sys.color.font_tertiary') })
        }
        .alignItems(VerticalAlign.Bottom)

        Blank()
        Text($r('app.string.add_cart'))
          .backgroundColor($r('sys.color.ohos_id_color_alert'))
          .fontSize($r('app.float.add_cart_font'))
          .fontWeight(CommonConstants.FONT_WEIGHT_700)
          .fontColor(Color.White)
          .width($r('app.float.add_cart_width'))
          .height($r('app.float.add_cart_height'))
          .borderRadius($r('app.float.add_cart_border'))
          .textAlign(TextAlign.Center)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width(CommonConstants.FULL_PERCENT)
    }
  }
}