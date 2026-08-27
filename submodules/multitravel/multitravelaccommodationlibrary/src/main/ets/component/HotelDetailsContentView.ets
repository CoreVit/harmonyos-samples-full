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

import { Constants } from '../commons/constants/Constants';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';

@Component
export struct HotelDetailsContentView {
  @StorageLink(Constants.KEY_BREAKPOINT) breakPoint: BreakpointTypeEnum = BreakpointTypeEnum.LG;

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
        Flex({
          direction: this.breakPoint === BreakpointTypeEnum.LG || this.breakPoint === BreakpointTypeEnum.XL ?
            FlexDirection.Row : FlexDirection.Column,
          alignItems: this.breakPoint === BreakpointTypeEnum.LG || this.breakPoint === BreakpointTypeEnum.XL ?
            ItemAlign.Center : ItemAlign.Start
        }) {
          Row() {
            Text(Constants.HOTEL_NAME)
              .fontColor($r('sys.color.font_primary'))
              .font({
                size: this.breakPoint === BreakpointTypeEnum.LG || this.breakPoint === BreakpointTypeEnum.XL ?
                  $r('app.float.week_info_lg_font_size') : $r('app.float.week_info_font_size'),
                weight: Constants.FONT_WEIGHT_500
              })
              .margin({ top: $r('sys.float.padding_level1'), bottom: $r('sys.float.padding_level4') })
            Rating({ rating: 5, indicator: true })
              .stars(5)
              .height($r('app.float.start_width'))
              .stepSize(0.5)
              .margin({ left: $r('sys.float.padding_level5') })
          }

          Column() {
            Text()
              .padding({
                left: $r('app.float.hotel_picture_padding'),
                right: $r('app.float.hotel_picture_padding'),
                top: $r('app.float.hotel_picture_padding'),
                bottom: $r('app.float.hotel_picture_padding')
              })
              .width($r('app.float.hotel_content_title_second_width'))
          }
          .height($r('app.float.hotel_first_width'))
          .opacity(Constants.OPACITY_FIFTEEN_PERCENT)
          .backgroundColor($r('sys.color.multi_color_09'))
          .borderRadius($r('sys.float.corner_radius_level2'))
          .margin({
            left: this.breakPoint === BreakpointTypeEnum.LG || this.breakPoint === BreakpointTypeEnum.XL ?
              $r('app.float.calendar_column_margin') :
              $r('app.float.no_border')
          })
        }
        .margin({ top: $r('app.float.hotel_message_margin_top') })
        .width(Constants.NINETY_FIVE_PERCENT)
        .height($r('app.float.low_price_all_height'))

        Column() {
          Text()
            .width(Constants.NINETY_FIVE_PERCENT)
        }
        .alignSelf(ItemAlign.Start)
        .width($r('app.float.hotel_content_title_third_width'))
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .margin({ top: $r('sys.float.padding_level4'), left: $r('sys.float.padding_level4') })
        .height($r('app.float.hotel_content_title_third_height'))
        .borderRadius($r('app.float.font_radius'))

        Row() {
          Column() {
            Row() {
              Row() {
                Text(Constants.HOTEL_MESSAGE_SIX)
                  .fontSize($r('app.float.week_info_font_size'))
                  .fontColor($r('app.color.Calendar_selected_backgroundColor'))
                Text()
                  .backgroundColor($r('sys.color.comp_background_tertiary'))
                  .borderRadius($r('sys.float.corner_radius_level2'))
                  .width($r('app.float.hotel_content_title_seven_width'))
                  .height($r('app.float.hotel_content_title_seven_height'))
                  .margin({ left: $r('sys.float.padding_level2') })
              }

              Text()
                .backgroundColor($r('sys.color.comp_background_tertiary'))
                .borderRadius($r('sys.float.corner_radius_level2'))
                .width($r('app.float.hotel_content_title_eight_width'))
                .height($r('app.float.hotel_content_title_seven_height'))
                .margin({ right: $r('sys.float.padding_level3') })
            }
            .margin({ top: $r('app.float.calendar_column_margin') })
            .width(Constants.NINETY_PERCENT)
            .justifyContent(FlexAlign.SpaceBetween)

            Column() {
              Text()
                .backgroundColor($r('sys.color.comp_background_tertiary'))
                .borderRadius($r('sys.float.corner_radius_level2'))
                .width(Constants.FULL_WIDTH_PERCENT)
                .height($r('app.float.hotel_content_title_seven_height'))
                .margin({ bottom: $r('sys.float.padding_level1') })
              Text()
                .backgroundColor($r('sys.color.comp_background_tertiary'))
                .borderRadius($r('sys.float.corner_radius_level2'))
                .width(Constants.FULL_WIDTH_PERCENT)
                .height($r('app.float.hotel_content_title_seven_height'))
            }
            .width(Constants.NINETY_PERCENT)
            .margin({ top: $r('sys.float.padding_level4') })
          }
          .borderRadius($r('app.float.hotel_grade_border'))
          .backgroundColor($r('app.color.card_background'))
          .width(Constants.CARD_ONE_WIDTH)
          .height(Constants.FULL_WIDTH_PERCENT)
          .justifyContent(FlexAlign.Start)

          Column() {
            Row() {
              Column() {
                Text()
                  .backgroundColor($r('sys.color.comp_background_tertiary'))
                  .borderRadius($r('sys.float.corner_radius_level2'))
                  .width($r('app.float.hotel_map_width'))
                  .height($r('app.float.hotel_content_title_seven_height'))
                  .margin({ bottom: $r('sys.float.padding_level2') })
                Text()
                  .backgroundColor($r('sys.color.comp_background_tertiary'))
                  .borderRadius($r('sys.float.corner_radius_level2'))
                  .width($r('app.float.hotel_map_width'))
                  .height($r('app.float.hotel_content_title_seven_height'))
              }

              Column() {
                SymbolGlyph($r('sys.symbol.local_fill'))
                  .height(Constants.SIXTY_PERCENT)
                  .fontColor([$r('sys.color.font_primary')])
                  .fontSize($r('sys.float.Title_M'))
                Text(Constants.HOTEL_MESSAGE_NINE)
                  .opacity(Constants.OPACITY_SIXTY_PERCENT)
                  .font({ size: $r('app.float.calendar_money_font_size'), weight: Constants.FONT_WEIGHT_500 })
              }
              .width(Constants.TWENTY_FIVE_PERCENT)
              .height(Constants.SIXTY_PERCENT)
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .width(Constants.NINETY_PERCENT)
          }
          .borderRadius($r('app.float.hotel_grade_border'))
          .justifyContent(FlexAlign.Center)
          .backgroundColor($r('app.color.card_background'))
          .width(Constants.CARD_TWO_WIDTH)
          .height(Constants.FULL_WIDTH_PERCENT)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width(Constants.NINETY_FIVE_PERCENT)
        .height(Constants.FORTY_PERCENT)
        .margin({ top: $r('sys.float.padding_level4') })
      }
      .width(Constants.FULL_WIDTH_PERCENT)
    }
    .width(Constants.FULL_WIDTH_PERCENT)
    .height(Constants.FULL_WIDTH_PERCENT)
    .borderRadius(
      {
        bottomLeft: $r('sys.float.corner_radius_level8'),
        bottomRight: $r('sys.float.corner_radius_level8'),
        topLeft: new BreakpointType({
          sm: $r('sys.float.corner_radius_level8'),
          md: $r('app.float.no_border'),
          lg: $r('app.float.no_border')
        }).getValue(this.breakPoint),
        topRight: new BreakpointType({
          sm: $r('sys.float.corner_radius_level8'),
          md: $r('app.float.no_border'),
          lg: $r('app.float.no_border')
        }).getValue(this.breakPoint)
      })
    .backgroundColor($r('sys.color.background_primary'))
  }
}