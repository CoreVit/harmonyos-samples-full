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
import { HotelRoomItem } from '../model/HotelRoomItem';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';

@Component
export struct HotelDetailsRoomItemView {
  @StorageLink(Constants.KEY_BREAKPOINT) breakPoint: string = BreakpointTypeEnum.LG;

  build() {
    Column() {
      ForEach(Constants.HOTEL_ROOMS_MESSAGES, (item: HotelRoomItem) => {
        Flex({ direction: FlexDirection.Row }) {
          if (item.getStandings() === Constants.NUMBER_ONE) {
            Stack({ alignContent: Alignment.TopStart }) {
              Image($r('app.media.salesOne'))
                .width($r('app.float.room_picture_width'))
                .zIndex(Constants.NUMBER_TWO)
              Image($r('app.media.roomOne'))
                .padding({ left: $r('app.float.room_grade_padding') })
                .borderRadius($r('app.float.room_picture_border'))
                .zIndex(Constants.NUMBER_ONE)
                .width($r('app.float.room_true_picture_width'))
            }
            .width($r('app.float.room_all_picture_width'))
            .height(Constants.FULL_WIDTH_PERCENT)
          } else if (item.getStandings() === Constants.NUMBER_TWO) {
            Stack({ alignContent: Alignment.TopStart }) {
              Image($r('app.media.salesTwo'))
                .width($r('app.float.room_picture_width'))
                .zIndex(Constants.NUMBER_TWO)
              Image($r('app.media.roomTwo'))
                .padding({ left: $r('app.float.room_grade_padding') })
                .borderRadius($r('app.float.room_picture_border'))
                .zIndex(Constants.NUMBER_ONE)
                .width($r('app.float.room_true_picture_width'))
            }
            .width($r('app.float.room_all_picture_width'))
            .height(Constants.FULL_WIDTH_PERCENT)
          } else if (item.getStandings() === Constants.NUMBER_THREE) {
            Stack({ alignContent: Alignment.TopStart }) {
              Image($r('app.media.salesThree'))
                .width($r('app.float.room_picture_width'))
                .zIndex(Constants.NUMBER_TWO)
              Image($r('app.media.roomThree'))
                .padding({ left: $r('app.float.room_grade_padding') })
                .borderRadius($r('app.float.room_picture_border'))
                .zIndex(Constants.NUMBER_ONE)
                .width($r('app.float.room_true_picture_width'))
            }
            .width($r('app.float.room_all_picture_width'))
            .height(Constants.FULL_WIDTH_PERCENT)
          } else {
            Stack({ alignContent: Alignment.TopStart }) {
              Image(item.getImage())
                .padding({ left: $r('app.float.room_grade_padding') })
                .borderRadius($r('app.float.room_picture_border'))
                .zIndex(Constants.NUMBER_ONE)
                .width($r('app.float.room_true_picture_width'))
            }
            .width($r('app.float.room_all_picture_width'))
            .height(Constants.FULL_WIDTH_PERCENT)
          }
          Column() {
            Row() {
              Column() {
              }
              .width($r('app.float.hotel_room_item_width1'))
              .margin({ right: $r('sys.float.padding_level2') })
              .height($r('app.float.start_width'))
              .backgroundColor($r('sys.color.brand'))
              .borderRadius($r('app.float.calendar_date_border'))

              Text()
                .backgroundColor($r('sys.color.comp_background_secondary'))
                .borderRadius($r('sys.float.corner_radius_level3'))
                .width($r('app.float.hotel_room_width'))
                .height($r('app.float.hotel_room_height'))
            }
            .margin($r('sys.float.padding_level2'))
            .width(Constants.FULL_WIDTH_PERCENT)

            Row() {
              Text()
                .backgroundColor($r('sys.color.comp_background_tertiary'))
                .borderRadius($r('sys.float.corner_radius_level3'))
                .width($r('app.float.hotel_room_item_width2'))
                .height($r('app.float.hotel_room_item_height2'))
            }
            .margin({ top: $r('sys.float.padding_level4') })
            .width(Constants.FULL_WIDTH_PERCENT)

            Row() {
              Text()
                .width($r('app.float.hotel_room_item_width3'))
                .height($r('app.float.hotel_room_item_height3'))
                .backgroundColor($r('sys.color.comp_emphasize_secondary'))
                .borderRadius($r('sys.float.corner_radius_level3'))
                .margin({ right: $r('sys.float.padding_level1') })

              Text()
                .backgroundColor($r('sys.color.comp_background_tertiary'))
                .borderRadius($r('sys.float.corner_radius_level3'))
                .width($r('app.float.hotel_room_item_width3'))
                .height($r('app.float.hotel_room_item_height3'))
            }
            .margin({ top: $r('sys.float.padding_level4') })
            .width(Constants.FULL_WIDTH_PERCENT)

            Row() {
              Column() {
              }
              .margin({ right: $r('sys.float.padding_level2') })
              .width($r('app.float.room_message_weo_height'))
              .height($r('app.float.room_message_weo_width'))
              .backgroundColor($r('sys.color.brand'))
              .borderRadius($r('sys.float.corner_radius_level5'))

              Text()
                .backgroundColor($r('sys.color.comp_background_tertiary'))
                .borderRadius($r('sys.float.corner_radius_level3'))
                .width($r('app.float.hotel_room_item_width2'))
                .height($r('app.float.hotel_room_item_height2'))
            }
            .margin({ top: $r('app.float.hotel_content_margin_top') })
            .width(Constants.FULL_WIDTH_PERCENT)

            Row() {
              Text(item.getOriginalPrice())
                .opacity(Constants.OPACITY_FIFTY_PERCENT)
                .font({ size: $r('app.float.calendar_money_font_size'), weight: Constants.FONT_WEIGHT_400 })
                .decoration({ type: TextDecorationType.LineThrough })
              Text(item.getDiscountedPrice())
                .fontColor($r('app.color.Calendar_selected_backgroundColor'))
                .fontSize($r('app.float.room_price_font_size'))
                .fontWeight(Constants.FONT_WEIGHT_500)
                .margin({
                  left: new BreakpointType({
                    sm: $r('app.float.calendar_date_border'),
                    md: $r('app.float.calendar_date_border'),
                    lg: $r('app.float.calendar_date_border')
                  }).getValue(this.breakPoint)
                })
              if (item.getRemain()) {
                Stack({ alignContent: Alignment.TopStart }) {
                  Image($r('app.media.remain'))
                    .zIndex(Constants.NUMBER_TWO)
                    .width($r('app.float.low_price_all_height'))
                  Button(Constants.ROOM_MESSAGE_THREE)
                    .margin({
                      top: $r('app.float.hotel_content_margin_top'),
                      left: new BreakpointType({
                        sm: $r('app.float.calendar_date_border'),
                        md: $r('app.float.calendar_date_border'),
                        lg: $r('app.float.calendar_date_border')
                      }).getValue(this.breakPoint)
                    })
                    .width($r('app.float.buy_button_width'))
                    .height($r('app.float.receive_height'))
                }
              } else {
                Stack({ alignContent: Alignment.TopStart }) {
                  Button(Constants.ROOM_MESSAGE_THREE)
                    .margin({ top: $r('app.float.hotel_content_margin_top') })
                    .width($r('app.float.buy_button_width'))
                    .height($r('app.float.receive_height'))
                }
              }
            }
            .margin({ top: $r('sys.float.padding_level5') })
            .width(Constants.FULL_WIDTH_PERCENT)
            .justifyContent(FlexAlign.End)
            .alignItems(VerticalAlign.Bottom)
          }
          .padding({ left: $r('sys.float.padding_level12') })
          .height(Constants.FULL_WIDTH_PERCENT)
        }
        .margin({ bottom: $r('app.float.calendar_date_border') })
        .width(Constants.FULL_WIDTH_PERCENT)
        .height($r('app.float.room_item_height'))
      }, (item: HotelRoomItem) => JSON.stringify(item))
    }
    .width(Constants.FULL_WIDTH_PERCENT)
  }
}