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
import { SearchTicketDateItem } from '../model/SearchTicketDateItem';
import { TicketItem } from '../model/TicketItem';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';

@Component
export struct SearchTopView {
  @Link date: number;
  @StorageLink(Constants.KEY_BREAKPOINT) breakPoint: string = BreakpointTypeEnum.LG;
  @Consume('ticketItems') ticketItems: Array<TicketItem>;
  @Consume(Constants.KEY_PATH_STACK) pageInfos: NavPathStack;

  getDateTicket(): TicketItem[] {
    if (this.date < 0 || this.date >= Constants.SEARCH_DATE_MESSAGE.length) {
      return [];
    }
    let dateTicket: TicketItem[] = [];
    Constants.TICKET_MESSAGE.forEach((element) => {
      if (element.date === Constants.SEARCH_DATE_MESSAGE[this.date].getDate()) {
        dateTicket.push(element);
      }
    })
    return dateTicket;
  }

  getDateItems(breakPoint: string) {
    if (breakPoint === BreakpointTypeEnum.SM) {
      return Constants.SEARCH_DATE_MESSAGE.slice(Constants.NUMBER_ZERO, Constants.NUMBER_SIX);
    } else if (breakPoint === BreakpointTypeEnum.MD) {
      return Constants.SEARCH_DATE_MESSAGE.slice(Constants.NUMBER_ZERO, Constants.NUMBER_SEVEN);
    } else {
      return Constants.SEARCH_DATE_MESSAGE.slice(Constants.NUMBER_ZERO, Constants.NUMBER_SIX);
    }
  }

  build() {
    Column() {
      Row() {
        Row() {
          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.chevron_backward'))
              .fontColor([$r('sys.color.icon_on_primary')])
              .fontSize($r('sys.float.Title_M'))
          }
          .height($r('app.float.back_button_height'))
          .aspectRatio(1)
          .backgroundColor($r('sys.color.icon_on_fourth'))
          .onClick(() => this.pageInfos.pop())

          Text(Constants.JOURNEY)
            .margin({ left: $r('sys.float.padding_level4') })
            .font({ size: $r('app.float.low_price_font_size'), weight: Constants.FONT_WEIGHT_700 })
            .fontColor($r('sys.color.font_on_primary'))
        }

        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.dot_grid_2x2'))
            .fontColor([$r('sys.color.icon_on_primary')])
            .fontSize($r('sys.float.Title_M'))
        }
        .height($r('app.float.back_button_height'))
        .aspectRatio(1)
        .backgroundColor($r('sys.color.icon_on_fourth'))
      }
      .margin({ top: $r('app.float.hotel_bar_margin_top') })
      .justifyContent(FlexAlign.SpaceBetween)
      .width(Constants.FULL_WIDTH_PERCENT)
      .height($r('app.float.hotel_bar_height'))
      .zIndex(Constants.NUMBER_TWO)

      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.End
      }) {
        List() {
          ForEach(this.getDateItems(this.breakPoint), (item: SearchTicketDateItem, index) => {
            ListItem() {
              Column() {
                Text(item.getWeek())
                  .fontColor(this.date === index ? $r('app.color.Calendar_selected_backgroundColor') :
                    $r('sys.color.font_on_primary'))
                  .font({ size: $r('sys.float.Body_S'), weight: Constants.FONT_WEIGHT_500 })
                Text(item.getDate())
                  .fontColor(this.date === index ? $r('app.color.Calendar_selected_backgroundColor') :
                    $r('sys.color.font_on_primary'))
                  .font({ size: $r('app.float.calendar_money_font_size'), weight: Constants.FONT_WEIGHT_400 })
              }
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .borderRadius($r('app.float.hotel_room_border'))
              .onClick(() => {
                this.date = index;
                this.ticketItems = [];
                this.ticketItems = this.getDateTicket();
              })
              .backgroundColor(this.date === index ? $r('sys.color.font_on_primary') :
                $r('sys.color.brand'))
              .width(new BreakpointType({
                sm: $r('app.float.search_top_sm_width'),
                md: $r('app.float.search_top_md_width'),
                lg: $r('app.float.search_top_lg_width')
              }).getValue(this.breakPoint))
              .height($r('app.float.low_price_all_height'))
            }
          }, (item: string) => item.toString())

        }
        .flexBasis('auto')
        .width(Constants.FULL_WIDTH_PERCENT)
        .height($r('app.float.low_price_all_height'))
        .listDirection(Axis.Horizontal)
        .scrollBar(BarState.Off)

        Column() {
          SymbolGlyph($r('sys.symbol.calendar'))
            .fontColor([$r('sys.color.icon_on_primary')])
            .fontSize($r('app.float.one_night_height'))
          Text($r('app.string.calendar'))
            .font({ size: $r('app.float.hotel_message_font_size'), weight: Constants.FONT_WEIGHT_400 })
            .fontColor($r('app.color.Calendar_font_color'))
        }
        .flexBasis(Constants.CALENDAR_WIDTH)
      }
      .margin({ top: $r('app.float.index_page_button_margin') })
      .width(Constants.FULL_WIDTH_PERCENT)
      .height($r('app.float.low_price_all_height'))
    }
    .padding({
      left: $r('sys.float.padding_level8'),
      right: $r('sys.float.padding_level8')
    })
    .width(Constants.FULL_WIDTH_PERCENT)
    .height(Constants.FULL_WIDTH_PERCENT)
  }
}