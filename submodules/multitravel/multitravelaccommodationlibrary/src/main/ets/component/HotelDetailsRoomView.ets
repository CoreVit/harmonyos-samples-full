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
import { BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { HotelDetailsRoomItemView } from './HotelDetailsRoomItemView';

@Component
export struct HotelDetailsRoomView {
  @StorageLink(Constants.KEY_BREAKPOINT) breakPoint: string = BreakpointTypeEnum.LG;
  @Consume(Constants.KEY_PATH_STACK) pageInfos: NavPathStack;

  build() {
    Column() {
      Column() {
        Row() {
          Row() {
            Row() {
              Text(Constants.ROOM_BUTTON_MESSAGES[Constants.NUMBER_ZERO])
                .font({ size: $r('app.float.room_date_font_size'), weight: Constants.FONT_WEIGHT_500 })
                .fontColor($r('sys.color.font_primary'))
              Text(Constants.ROOM_BUTTON_MESSAGES[Constants.NUMBER_ONE])
                .font({ size: $r('app.float.hotel_message_font_size'), weight: Constants.FONT_WEIGHT_400 })
                .fontColor($r('sys.color.font_primary'))
                .margin({ left: $r('app.float.hotel_picture_padding') })
            }
            .alignItems(VerticalAlign.Bottom)

            Column() {
              Text(Constants.ROOM_BUTTON_MESSAGES[Constants.NUMBER_TWO])
                .font({ size: $r('app.float.today_font_Size'), weight: Constants.FONT_WEIGHT_400 })
                .height(Constants.FULL_WIDTH_PERCENT)
                .textAlign(TextAlign.Center)
                .fontColor($r('sys.color.font_primary'))
            }
            .margin({ left: $r('app.float.calendar_column_margin'), right: $r('app.float.calendar_column_margin') })
            .width($r('app.float.one_night_width'))
            .height($r('app.float.one_night_height'))
            .borderRadius($r('app.float.calendar_column_margin'))
            .backgroundColor($r('app.color.one_night_background'))

            Row() {
              Text(Constants.ROOM_BUTTON_MESSAGES[Constants.NUMBER_THREE])
                .font({ size: $r('app.float.room_date_font_size'), weight: Constants.FONT_WEIGHT_500 })
                .fontColor($r('sys.color.font_primary'))
              Text(Constants.ROOM_BUTTON_MESSAGES[Constants.NUMBER_FOUR])
                .margin({ left: $r('app.float.hotel_picture_padding') })
                .font({ size: $r('app.float.hotel_message_font_size'), weight: Constants.FONT_WEIGHT_500 })
                .fontColor($r('sys.color.font_primary'))
            }
            .alignItems(VerticalAlign.Bottom)
          }

          Blank()
          SymbolGlyph($r('sys.symbol.calendar'))
            .fontColor([$r('sys.color.icon_primary')])
            .fontSize($r('app.float.January_2024_margin_top'))
            .onClick(() => {
              this.pageInfos.pushPathByName(Constants.LOW_PRICE_CALENDAR_URL, null);
            })
        }
        .width(Constants.FULL_WIDTH_PERCENT)
        .height($r('app.float.hotel_detail_order_height'))

        Row() {
          Row() {
            Text()
              .backgroundColor($r('app.color.card_background'))
              .borderRadius($r('sys.float.corner_radius_level3'))
              .width($r('app.float.hotel_room_width'))
              .height($r('app.float.hotel_room_height'))
              .margin({ right: $r('app.float.calendar_column_margin') })
            Text()
              .backgroundColor($r('app.color.card_background'))
              .borderRadius($r('sys.float.corner_radius_level3'))
              .width($r('app.float.hotel_room_width'))
              .height($r('app.float.hotel_room_height'))
              .margin({ right: $r('app.float.calendar_column_margin') })
            Text()
              .backgroundColor($r('app.color.card_background'))
              .borderRadius($r('sys.float.corner_radius_level3'))
              .width($r('app.float.hotel_room_width'))
              .height($r('app.float.hotel_room_height'))
              .margin({ right: $r('app.float.calendar_column_margin') })
            Text()
              .backgroundColor($r('app.color.card_background'))
              .borderRadius($r('sys.float.corner_radius_level3'))
              .width($r('app.float.hotel_room_width'))
              .height($r('app.float.hotel_room_height'))
              .margin({ right: $r('app.float.calendar_column_margin') })
          }
          .width(Constants.NINETY_FIVE_PERCENT)
        }
        .margin({ bottom: $r('app.float.calendar_column_margin') })
        .width(Constants.FULL_WIDTH_PERCENT)
        .height($r('app.float.receive_height'))

        HotelDetailsRoomItemView()
          .width(Constants.FULL_WIDTH_PERCENT)
      }
      .width(Constants.NINETY_FIVE_PERCENT)
    }
    .borderRadius($r('app.float.calendar_card_border'))
    .width(Constants.FULL_WIDTH_PERCENT)
    .backgroundColor($r('sys.color.background_primary'))
  }
}