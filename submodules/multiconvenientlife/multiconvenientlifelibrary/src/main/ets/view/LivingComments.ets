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
import { LivingCommentsViewModel } from '../viewmodel/LivingCommentsViewModel';

@Component
export struct LivingComments {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'naviIndicatorHeight') naviIndicatorHeight: number = 0;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'statusBarHeight') statusBarHeight: number = 0;

  build() {
    Column() {
      Scroll() {
        Column() {
          Row() {
            Image($r('app.media.ic_public_contacts_group_filled'))
              .width($r('app.float.group_width'))
              .aspectRatio(1)
              .margin({
                right: $r('app.float.dish_margin_right')
              })
            Text($r('app.string.viewers_online'))
              .fontSize($r('app.float.tabs_font'))
              .fontColor(Color.White)
          }
          .width(CommonConstants.FULL_PERCENT)

          Column({ space: CommonConstants.COLUMN_SPACE }) {
            this.headerListBuild('1', $r('app.media.tx1_img'), '6', $r('app.color.candy_pocket'))
            this.headerListBuild('2', $r('app.media.tx2_img'), '6', $r('app.color.city_park_font'))
            this.headerListBuild('3', $r('app.media.tx3_img'), '4', $r('app.color.quiet_years'))
          }
          .padding({
            top: $r('app.float.thirty_padding'),
            bottom: $r('app.float.thirty_padding')
          })
          .width(CommonConstants.FULL_PERCENT)

          Divider()
            .color($r('app.color.ten_white'))
          Column({ space: CommonConstants.COLUMN_SPACE_LIVING }) {
            ForEach(LivingCommentsViewModel.getLivingCommentsList(), (item: LivingCommentsViewModel) => {
              this.commentsListBuilder(item)
            }, (item: string) => item);
          }
          .width(CommonConstants.FULL_PERCENT)
          .alignItems(HorizontalAlign.Start)
          .padding({
            top: $r('app.float.rating_margin_right')
          })
        }
      }
      .align(Alignment.Top)
      .layoutWeight(1)
      .padding({
        top: $r('app.float.living_padding_top'),
        left: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD ?
          $r('app.float.twelves_padding') : $r('app.float.common_padding'),
        right: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD ?
          $r('app.float.twelves_padding') : $r('app.float.common_padding'),
        bottom: $r('app.float.avatar_margin_bottom')
      })

      Row() {
        Row() {
          Image($r('app.media.v2_ic_public_edit'))
            .width($r('app.float.search_width'))
            .height($r('app.float.search_width'))
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
        .width(CommonConstants.FULL_PERCENT)
        .backgroundColor($r('app.color.ten_white'))
        .padding({
          top: $r('app.float.avatar_margin_bottom'),
          bottom: $r('app.float.avatar_margin_bottom'),
          left: $r('app.float.twelves_padding'),
          right: $r('app.float.twelves_padding')
        })
      }
      .padding({
        top: $r('app.float.eight_padding'),
        left: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD ?
          $r('app.float.twelves_padding') : $r('app.float.common_padding'),
        right: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD ?
          $r('app.float.twelves_padding') : $r('app.float.common_padding'),
        bottom: 8 + this.naviIndicatorHeight
      })
      .width(CommonConstants.FULL_PERCENT)
      .backgroundColor($r('app.color.swiper_choose_background'))
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .backgroundColor($r('app.color.forty_black'))
    .padding({
      top: this.statusBarHeight
    })
  }

  @Builder
  commentsListBuilder(item: LivingCommentsViewModel) {
    Column() {
      if (item.type === 1) {
        Row() {
          Button({ type: ButtonType.Circle })
            .height(24)
            .aspectRatio(1)
            .backgroundColor($r('sys.color.font_on_tertiary'))
            .margin({ right: $r('sys.float.padding_level4') })

          Button()
            .height(16)
            .backgroundColor($r('sys.color.font_on_secondary'))
            .layoutWeight(1)
        }
      } else if (item.type === 2) {
        Row() {
          Button({ type: ButtonType.Circle })
            .height(24)
            .aspectRatio(1)
            .backgroundColor($r('sys.color.font_on_tertiary'))
            .margin({ right: $r('sys.float.padding_level4') })
          Button()
            .height(16)
            .backgroundColor($r('sys.color.font_on_secondary'))
            .layoutWeight(1)
        }
        .width(CommonConstants.FULL_PERCENT)
        .margin({ bottom: 4 })

        Row() {
          Button()
            .height(16)
            .backgroundColor($r('sys.color.font_on_secondary'))
            .layoutWeight(1)
            .margin({ bottom: 8 })
        }

        Row() {
          Button()
            .height(16)
            .backgroundColor($r('sys.color.font_on_secondary'))
            .layoutWeight(1)
            .margin({ bottom: 8 })
        }
      } else {
        Row() {
          Button()
            .height(16)
            .backgroundColor($r('sys.color.font_on_secondary'))
            .layoutWeight(1)
        }
      }
    }
    .padding({
      top: $r('app.float.flag_margin_right'),
      left: $r('app.float.tabs_margin_right'),
      right: $r('app.float.swiper_margin_top'),
      bottom: $r('app.float.flag_margin_right')
    })
    .borderRadius($r('app.float.text_radius'))
  }

  @Builder
  headerListBuild(index: ResourceStr, avatars: Resource, level: ResourceStr, color: ResourceColor) {
    Row() {
      Text(index)
        .fontColor(color)
        .fontSize($r('app.float.reviews_font'))
        .margin({
          right: $r('app.float.rating_margin_right')
        })
        .fontWeight(CommonConstants.FONT_WEIGHT_600);
      Image(avatars)
        .width($r('app.float.padding_header'))
        .aspectRatio(1)
        .margin({
          right: $r('app.float.margin_twelves')
        })
      Button()
        .size({ width: 85, height: 16 })
        .constraintSize({
          minWidth: 36,
          maxWidth: 85
        })
        .backgroundColor($r('sys.color.font_on_tertiary'))
        .margin({
          right: $r('app.float.margin_twelves')
        })
      Row() {
        Stack() {
          Image($r('app.media.ic_public_love'))
            .width($r('app.float.love_width'))
            .height($r('app.float.love_width'))
          Text(level)
            .fontSize($r('app.float.level_font'))
            .fontColor($r('sys.color.font_on_primary'))
            .fontWeight(CommonConstants.FONT_WEIGHT_500)
        }

        Button()
          .size({ width: 40, height: 10 })
          .backgroundColor($r('sys.color.font_on_secondary'))
          .margin({
            left: $r('app.float.tabs_padding_tb')
          })
      }
      .padding({
        left: $r('app.float.pay_price_margin_right'),
        right: $r('app.float.pay_price_margin_right'),
        top: $r('app.float.filtering_padding_tb'),
        bottom: $r('app.float.filtering_padding_tb')
      })
      .backgroundColor(color)
      .borderRadius($r('app.float.nine_padding'))
      .opacity(0.4)
    }
    .width(CommonConstants.FULL_PERCENT)
  }
}