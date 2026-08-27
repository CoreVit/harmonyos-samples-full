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

@Component
export struct LivingHome {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'naviIndicatorHeight') naviIndicatorHeight: number = 0;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'statusBarHeight') statusBarHeight: number = 0;
  handleBackPress?: Function;

  build() {
    Stack() {
      Image($r('app.media.fm2_img'))
        .height(CommonConstants.FULL_PERCENT)
        .width((this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
          this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL) ?
          CommonConstants.SIXTY_PERCENT : CommonConstants.FULL_PERCENT)
      Column() {
      }
      .width(CommonConstants.FULL_PERCENT)
      .height($r('app.float.shadow_height'))
      .position({
        bottom: 0
      })
      .linearGradient({
        colors: [
          [$r('app.color.shadow_start_color'), 0.0],
          [$r('app.color.shadow_end_color'), 1.0],
        ]
      })

      Row() {
        Row() {
          Button() {
            SymbolGlyph($r('sys.symbol.chevron_backward'))
              .fontColor([$r('sys.color.icon_primary')])
              .fontSize($r('sys.float.Title_M'))
          }
          .height(40)
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .aspectRatio(1)
          .margin({
            right: $r('app.float.margin_small')
          })
          .onClick(() => {
            this.handleBackPress?.();
          })

          Row() {
            Image($r('app.media.tx1_img'))
              .width($r('app.float.padding_header'))
              .aspectRatio(1)
              .margin({
                right: $r('app.float.favor_bottom')
              })
            Column() {
              Text($r('app.string.lee_look'))
                .fontSize($r('app.float.delivery_font'))
                .fontWeight(CommonConstants.FONT_WEIGHT_700)
                .fontColor(Color.White)
                .fontFamily(CommonConstants.FONT_FAMILY_BLACK)
              Text($r('app.string.following_people'))
                .fontSize($r('app.float.filtering_font'))
                .fontWeight(CommonConstants.FONT_WEIGHT_400)
                .fontColor(Color.White)
                .fontFamily(CommonConstants.FONT_FAMILY_BLACK)
            }

            Button($r('app.string.follows'))
              .height($r('app.float.padding_header'))
              .margin({
                left: $r('app.float.span_line_height')
              })
              .fontSize('14fp')
          }
          .borderRadius($r('app.float.follows_border_radius'))
          .backgroundColor($r('app.color.twenty_black'))
          .padding($r('app.float.flag_margin_right'))
        }

        Image($r('app.media.ic_public_more_filled'))
          .width($r('app.float.common_image'))
          .height($r('app.float.common_image'))
          .fillColor(Color.White)
      }
      .width(CommonConstants.FULL_PERCENT)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: new BreakpointType({ sm: '12vp', md: '24vp', lg: '32vp' }).getValue(this.currentBreakpoint),
        right: new BreakpointType({ sm: '12vp', md: '24vp', lg: '32vp' }).getValue(this.currentBreakpoint),
      })
      .position({
        top: 8 + this.statusBarHeight
      })

      Row() {
        Row() {
          Image($r('app.media.v2_ic_public_edit'))
            .width($r('app.float.span_line_height'))
            .height($r('app.float.span_line_height'))
            .fillColor($r('app.color.sixty_white'))
          Text($r('app.string.write_review'))
            .fontSize($r('app.float.delivery_font'))
            .fontColor($r('app.color.sixty_white'))
            .fontWeight(CommonConstants.FONT_WEIGHT_400)
            .margin({
              left: $r('app.float.avatar_padding_left')
            })
        }
        .borderRadius($r('app.float.food_border_radius'))
        .height($r('app.float.food_height'))
        .layoutWeight(1)
        .backgroundColor($r('app.color.ten_white'))
        .padding({
          top: $r('app.float.avatar_margin_bottom'),
          bottom: $r('app.float.avatar_margin_bottom'),
          left: $r('app.float.twelves_padding'),
          right: $r('app.float.twelves_padding')
        })
        .margin({
          right: $r('app.float.price_margin_right')
        })
        .visibility(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ? Visibility.Visible :
          Visibility.Hidden)

        Row({ space: CommonConstants.COLUMN_SPACE_HOME }) {
          Image($r('app.media.ic_public_communicates'))
            .height($r('app.float.communicates_width'))
            .width($r('app.float.communicates_width'))
          Image($r('app.media.ic_public_merchandise'))
            .height($r('app.float.communicates_width'))
            .width($r('app.float.communicates_width'))
          Image($r('app.media.ic_public_presents'))
            .height($r('app.float.communicates_width'))
            .width($r('app.float.communicates_width'))
        }
      }
      .width(CommonConstants.FULL_PERCENT)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: $r('app.float.padding_small'),
        right: $r('app.float.padding_small')
      })
      .position({
        bottom: 10 + this.naviIndicatorHeight
      })
    }
  }
}