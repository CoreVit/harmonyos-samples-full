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
import { ShopHeader, ShopSideBar } from '../view/ShopInformation';
import { ShopOrderList } from '../view/ShopOrderList';
import { DishDetails } from './DishDetails';

@Component
export struct ShopDisplay {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'naviIndicatorHeight') naviIndicatorHeight: number = 0;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'statusBarHeight') statusBarHeight: number = 0;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'payWidth') payWidth: Length = 0;
  @Provide(CommonConstants.LIFE_PREFIX + 'shopPageInfo') shopPageInfo: NavPathStack = new NavPathStack();
  @Consume(CommonConstants.LIFE_PREFIX + 'ifShowShopDisplay') ifShowShopDisplay: boolean;
  @Consume(CommonConstants.LIFE_PREFIX + 'ifShowSides') ifShowSides: boolean;
  pageInfo?: NavPathStack;
  private scroller: Scroller = new Scroller();

  @Builder
  PageMap() {
    DishDetails()
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom }) {
        Navigation(this.shopPageInfo) {
          Stack({ alignContent: Alignment.Top }) {
            Scroll(this.scroller) {
              Flex({
                direction: (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
                  this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL) && !this.ifShowSides ?
                  FlexDirection.Row : FlexDirection.Column,
                justifyContent: FlexAlign.Start
              }) {
                ShopHeader()
                  .visibility((this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_LG &&
                    this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_XL) || this.ifShowSides ?
                    Visibility.Visible : Visibility.None)
                ShopSideBar({
                  handleBackPress: () => {
                    this.pageInfo?.pop();
                  }
                })
                  .width(CommonConstants.THIRTY_SEVEN_PERCENT)
                  .flexShrink(0)
                  .visibility((this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
                    this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL) && !this.ifShowSides ?
                    Visibility.Visible : Visibility.None)
                ShopOrderList()
                  .height(CommonConstants.FULL_PERCENT)

                Row() {
                  Button({ type: ButtonType.Circle }) {
                    SymbolGlyph($r('sys.symbol.chevron_backward'))
                      .fontColor([$r('app.color.symbol_icon_dark')])
                      .fontSize($r('sys.float.Title_M'))
                  }
                  .height(40)
                  .aspectRatio(1)
                  .margin({ left: $r('sys.float.padding_level8') })
                  .backgroundColor($r('app.color.symbol_circle_bg_color_dark'))
                  .onClick(() => {
                    this.pageInfo?.pop();
                    if (this.ifShowSides) {
                      this.ifShowSides = false;
                    }
                  })

                  Button() {
                    SymbolGlyph($r('sys.symbol.arrow_up_left_and_arrow_down_right'))
                      .fontColor([$r('app.color.symbol_icon_dark')])
                      .fontSize($r('sys.float.Title_M'))
                  }
                  .backgroundColor($r('app.color.symbol_circle_bg_color_dark'))
                  .height(40)
                  .aspectRatio(1)
                  .margin({ left: $r('sys.float.padding_level4') })
                  .onClick(() => {
                    this.ifShowSides = false;
                  })
                  .visibility(this.ifShowSides && this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_SM ?
                    Visibility.Visible : Visibility.None)

                  Button() {
                    SymbolGlyph($r('sys.symbol.arrow_down_right_and_arrow_up_left'))
                      .fontColor([$r('app.color.symbol_icon_dark')])
                      .fontSize($r('sys.float.Title_M'))
                  }
                  .backgroundColor($r('app.color.symbol_circle_bg_color_dark'))
                  .height(40)
                  .aspectRatio(1)
                  .margin({ left: $r('sys.float.padding_level4') })
                  .onClick(() => {
                    this.ifShowSides = true;
                  })
                  .visibility(!this.ifShowSides && this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_SM ?
                    Visibility.Visible : Visibility.None)
                }
                .width(CommonConstants.FULL_PERCENT)
                .visibility((this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_LG &&
                  this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_XL) || this.ifShowSides ?
                  Visibility.Visible : Visibility.None)
                .position({
                  top: this.statusBarHeight
                })
              }
              .layoutWeight(1)
            }
            .scrollBar(BarState.Off)
          }
        }
        .width(CommonConstants.FULL_PERCENT)
        .hideTitleBar(true)
        .hideToolBar(true)
        .navDestination(this.PageMap)
        .mode(NavigationMode.Stack)

        Row() {
          Row() {
            Column() {
              Text($r('app.string.shop_amounts'))
                .fontColor($r('sys.color.comp_background_primary'))
                .fontSize($r('app.float.amounts_font'))
                .fontWeight(CommonConstants.FONT_WEIGHT_700)
              Text($r('app.string.estimated_delivery'))
                .fontColor($r('sys.color.comp_background_primary'))
                .fontSize($r('sys.float.Body_S'))
                .fontWeight(CommonConstants.FONT_WEIGHT_400)
            }
            .alignItems(HorizontalAlign.Start)

            Blank()
            Text($r('app.string.send_from'))
              .fontColor($r('sys.color.comp_background_primary'))
              .fontSize($r('app.float.send_font'))
              .fontWeight(CommonConstants.FONT_WEIGHT_700)
          }
          .layoutWeight(1)
          .backgroundColor($r('sys.color.icon_primary'))
          .height($r('app.float.amounts_height'))
          .borderRadius($r('app.float.amounts_border'))
          .padding({
            left: $r('app.float.common_padding'),
            right: $r('app.float.common_padding')
          })
        }
        .position({
          right: 0,
          bottom: this.naviIndicatorHeight
        })
        .width(this.ifShowSides || this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ?
          CommonConstants.SELF_ADAPTING : this.ifShowShopDisplay ?
            this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD ? CommonConstants.SELF_ADAPTING :
              CommonConstants.SIXTY_PERCENT : this.payWidth)
        .padding({
          left: this.ifShowSides ? new BreakpointType({
            sm: $r('app.float.padding_small'), md: $r('app.float.padding_small'),
            lg: $r('app.float.common_padding')
          }).getValue(this.currentBreakpoint) :
            this.ifShowShopDisplay ? new BreakpointType({
              sm: $r('app.float.padding_small'), md: $r('app.float.common_padding'),
              lg: $r('app.float.common_padding')
            }).getValue(this.currentBreakpoint) : new BreakpointType(
              {
                sm: $r('app.float.padding_small'), md: $r('app.float.common_padding'),
                lg: $r('app.float.zero_padding')
              }).getValue(this.currentBreakpoint),
          right: this.ifShowSides ? new BreakpointType({
            sm: $r('app.float.padding_small'), md: $r('app.float.padding_small'),
            lg: $r('app.float.common_padding')
          }).getValue(this.currentBreakpoint) :
            new BreakpointType({
              sm: $r('app.float.padding_small'), md: $r('app.float.common_padding'),
              lg: $r('app.float.common_padding')
            }).getValue(this.currentBreakpoint),
        })
      }
      .width(CommonConstants.FULL_PERCENT)
    }
    .width(CommonConstants.FULL_PERCENT)
    .hideTitleBar(true)
    .height(CommonConstants.FULL_PERCENT)
    .onReady((context: NavDestinationContext) => {
      this.pageInfo = context.pathStack;
    })
  }
}