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
import { SearchTicketBarItem } from '../model/SearchTicketBarItem';
import { TicketItem } from '../model/TicketItem';
import { BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { SearchTicketTabView } from './SearchTicketTabView';
import { SearchTopView } from './SearchTopView';

@Component
export struct SearchTicketView {
  @State index: number = Constants.NUMBER_ZERO;
  @State date: number = Constants.NUMBER_ZERO;
  @StorageLink(Constants.KEY_BREAKPOINT) breakPoint: BreakpointTypeEnum = BreakpointTypeEnum.LG;
  @Provide ticketItems: Array<TicketItem> =
    Constants.TICKET_MESSAGE.slice(Constants.NUMBER_ZERO, Constants.NUMBER_ELEVEN);
  @StorageProp(Constants.KEY_NAV_INDICATOR_HEIGHT) navIndicatorHeight: number = 0;

  private onBottomTabClick(index: number): void {
    if (this.index !== index) {
      this.index = index;
    }
    if (this.index === Constants.NUMBER_ONE) {
      this.ticketItems.sort((a: TicketItem, b: TicketItem) => {
        const aHour: number =
          Number.parseInt(a.totalDuration.slice(Constants.NUMBER_ZERO, Constants.NUMBER_ONE));
        const aMinuter: number =
          Number.parseInt(a.totalDuration.slice(Constants.NUMBER_TWO, Constants.NUMBER_FOUR))
        const aTime = aHour * Constants.NUMBER_SIXTY + aMinuter;
        const bHour: number =
          Number.parseInt(b.totalDuration.slice(Constants.NUMBER_ZERO, Constants.NUMBER_ONE));
        const bMinuter: number =
          Number.parseInt(b.totalDuration.slice(Constants.NUMBER_TWO, Constants.NUMBER_FOUR))
        const bTime = bHour * Constants.NUMBER_SIXTY + bMinuter;
        return aTime - bTime;
      })
    } else if (this.index === Constants.NUMBER_TWO) {
      this.ticketItems.sort((a: TicketItem, b: TicketItem) => {
        const aStartHour: number =
          Number.parseInt(a.startTime.slice(Constants.NUMBER_ZERO, Constants.NUMBER_TWO));
        const aStartMinuter: number =
          Number.parseInt(a.startTime.slice(Constants.NUMBER_THREE, Constants.NUMBER_FIVE))
        const bStartHour: number =
          Number.parseInt(b.startTime.slice(Constants.NUMBER_ZERO, Constants.NUMBER_TWO));
        const bStartMinuter: number =
          Number.parseInt(b.startTime.slice(Constants.NUMBER_THREE, Constants.NUMBER_FIVE))
        if (aStartHour - bStartHour !== Constants.NUMBER_ZERO) {
          return aStartHour - bStartHour;
        }
        return aStartMinuter - bStartMinuter;
      })
    } else if (this.index === Constants.NUMBER_THREE) {
      this.ticketItems.sort((a: TicketItem, b: TicketItem) => {
        return a.money - b.money;
      })
    } else {
      return;
    }
  }

  build() {
    if (this.breakPoint !== BreakpointTypeEnum.LG && this.breakPoint !== BreakpointTypeEnum.XL) {
      Column() {
        Flex({ direction: FlexDirection.Column }) {
          Stack({ alignContent: Alignment.Bottom }) {
            Stack({ alignContent: Alignment.Top }) {
              SearchTopView({ date: this.date })
                .backgroundColor($r('sys.color.brand'))
                .width(Constants.FULL_WIDTH_PERCENT)
                .height($r('app.float.calendar_height'))
              SearchTicketTabView({ date: this.date })
                .width(Constants.FULL_WIDTH_PERCENT)
                .height(Constants.AUTO_HEIGHT)
                .margin({ top: $r('app.float.Search_bar_margin_top') })
            }
            .width(Constants.FULL_WIDTH_PERCENT)
            .height(Constants.FULL_WIDTH_PERCENT)

            Row() {
              ForEach(Constants.SEARCH_BAR_MESSAGE, (item: SearchTicketBarItem, index) => {
                Column() {
                  SymbolGlyph(item.getImage())
                    .fontColor([index === this.index ? $r('sys.color.font_emphasize') : $r('sys.color.font_primary')])
                    .fontSize($r('app.float.week_info_lg_font_size'))
                  Text(item.getTitle())
                    .fontColor($r('sys.color.font_primary'))
                    .margin({ top: $r('app.float.hotel_content_margin_top') })
                    .font({ size: $r('app.float.calendar_money_font_size'), weight: Constants.FONT_WEIGHT_500 })
                }
                .width($r('app.float.search_bar_height'))
                .height($r('app.float.low_price_all_height'))
                .onClick(() => {
                  this.onBottomTabClick(index);
                })
              }, (item: SearchTicketBarItem) => JSON.stringify(item))
            }
            .padding({ bottom: this.navIndicatorHeight / 2 })
            .justifyContent(FlexAlign.SpaceAround)
            .width(Constants.FULL_WIDTH_PERCENT)
            .height($r('app.float.buy_button_width'))
            .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THIN)
          }
          .width(Constants.FULL_WIDTH_PERCENT)
          .height(Constants.FULL_WIDTH_PERCENT)
        }
        .width(Constants.FULL_WIDTH_PERCENT)
        .height(Constants.FULL_WIDTH_PERCENT)
      }
    } else {
      Row() {
        Column() {
          Flex({ direction: FlexDirection.Column }) {
            Stack({ alignContent: Alignment.Bottom }) {
              Stack({ alignContent: Alignment.Top }) {
                SearchTopView({ date: this.date })
                  .backgroundColor($r('sys.color.brand'))
                  .width(Constants.FULL_WIDTH_PERCENT)
                  .height($r('app.float.calendar_height'))

                SearchTicketTabView({ date: this.date })
                  .width(Constants.FULL_WIDTH_PERCENT)
                  .height(Constants.AUTO_HEIGHT)
                  .margin({ top: $r('app.float.Search_bar_margin_top') })
              }
              .width(Constants.FULL_WIDTH_PERCENT)
              .height(Constants.FULL_WIDTH_PERCENT)

              Row() {
                ForEach(Constants.SEARCH_BAR_MESSAGE, (item: SearchTicketBarItem, index) => {
                  Column() {
                    SymbolGlyph(item.getImage())
                      .fontColor([index === this.index ? $r('sys.color.interactive_active') :
                      $r('sys.color.font_tertiary')])
                      .fontSize($r('app.float.week_info_lg_font_size'))
                    Text(item.getTitle())
                      .fontColor(index === this.index ? $r('sys.color.interactive_active') :
                      $r('sys.color.font_tertiary'))
                      .margin({ top: $r('app.float.hotel_content_margin_top') })
                      .font({ size: $r('app.float.calendar_money_font_size'), weight: Constants.FONT_WEIGHT_500 })
                  }
                  .width($r('app.float.search_bar_height'))
                  .height($r('app.float.low_price_all_height'))
                  .onClick(() => {
                    this.onBottomTabClick(index);
                  })
                }, (item: SearchTicketBarItem) => JSON.stringify(item))
              }
              .padding({ bottom: this.navIndicatorHeight / 2 })
              .justifyContent(FlexAlign.SpaceAround)
              .width(Constants.FULL_WIDTH_PERCENT)
              .height($r('app.float.buy_button_width'))
              .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THIN)
            }
            .width(Constants.FULL_WIDTH_PERCENT)
            .height(Constants.FULL_WIDTH_PERCENT)
          }
          .width(Constants.FULL_WIDTH_PERCENT)
          .height(Constants.FULL_WIDTH_PERCENT)
        }
        .borderWidth({ right: 1 })
        .borderColor($r('sys.color.comp_divider'))
        .width(Constants.FORTY_PERCENT)
        .height(Constants.FULL_WIDTH_PERCENT)

        Column() {
          Column() {
            Image($r('app.media.SearchNoResult'))
              .width($r('app.float.room_all_picture_width'))
              .margin({ top: $r('app.float.result_image_margin_top') })
            Text($r('app.string.select_train_number'))
              .font({ size: $r('app.float.room_message_weo_width'), weight: Constants.FONT_WEIGHT_400 })
              .opacity(Constants.OPACITY_FORTY_PERCENT)
          }
          .alignItems(HorizontalAlign.Center)
          .width(Constants.FULL_WIDTH_PERCENT)
          .height(Constants.FULL_WIDTH_PERCENT)
          .borderRadius({
            topLeft: $r('app.float.hotel_grade_border'),
            topRight: $r('app.float.hotel_grade_border'),
          })
          .backgroundColor($r('sys.color.background_secondary'))
          .margin({ top: $r('app.float.Search_bar_margin_top') })
        }
        .backgroundColor($r('sys.color.brand'))
        .width(Constants.SIXTY_PERCENT)
        .height(Constants.FULL_WIDTH_PERCENT)
      }
    }
  }
}