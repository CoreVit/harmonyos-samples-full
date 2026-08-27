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
import { SearchTicketCheckboxItem } from '../model/SearchTicketCheckboxItem';
import { TicketItem } from '../model/TicketItem';
import { BreakpointTypeEnum } from '../utils/BreakpointSystem';
import Logger from '../utils/Logger';

const TAG = '[SearchTicketListView]';

@Component
export struct SearchTicketListView {
  @StorageLink(Constants.KEY_BREAKPOINT) breakPoint: string = BreakpointTypeEnum.LG;
  @Consume('ticketItems') ticketItems: Array<TicketItem>;
  @Link date: number;
  @State siftCondition: SearchTicketCheckboxItem[] = Constants.FILTERING_CRITERIA.slice(0, 3).map(name =>
  new SearchTicketCheckboxItem(name, false));

  private getTicketItem(condition: boolean[]): void {
    let allTicket: TicketItem[] = this.getDateTicket();
    this.ticketItems = [];
    if ((condition[Constants.NUMBER_ZERO] && condition[Constants.NUMBER_ONE]) ||
      (!condition[Constants.NUMBER_ZERO] && !condition[Constants.NUMBER_ONE])) {
      this.ticketItems = this.getDateTicket();
    } else {
      if (condition[Constants.NUMBER_ZERO]) {
        allTicket.forEach((element) => {
          if (!element.getWhetherTrain()) {
            this.ticketItems.push(element);
          }
        })
        allTicket = this.ticketItems;
      } else {
        allTicket.forEach((element) => {
          if (element.getWhetherTrain()) {
            this.ticketItems.push(element);
          }
        })
        allTicket = this.ticketItems;
      }
    }
    if (condition[Constants.NUMBER_TWO]) {
      this.ticketItems.forEach((element) => {
        if (!element.getWhetherHasTicket()) {
          this.ticketItems.splice(this.ticketItems.indexOf(element), Constants.NUMBER_ONE);
        }
      })
    }
  }

  private getDateTicket(): TicketItem[] {
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

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Row() {
        Row() {
          ForEach(this.siftCondition, (item: SearchTicketCheckboxItem, index: number) => {
            Checkbox()
              .shape(CheckBoxShape.ROUNDED_SQUARE)
              .onChange((value: boolean) => {
                this.siftCondition[index].setResult(value);
              })
              .margin({ right: $r('app.float.hotel_content_margin_top') })
              .width($r('app.float.checkbox_width'))
            Text(item.getTitle())
              .fontColor($r('sys.color.font_primary'))
              .margin({ right: $r('app.float.hotel_content_margin_top'), top: $r('sys.float.padding_level2') })
              .font({ size: $r('app.float.hotel_message_font_size'), weight: Constants.FONT_WEIGHT_400 })
              .opacity(Constants.OPACITY_NINETY_PERCENT)
          }, (item: SearchTicketCheckboxItem) => JSON.stringify(item))
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)

        Row() {
          SymbolGlyph($r('sys.symbol.funnel'))
            .fontColor([$r('sys.color.font_primary')])
            .fontSize($r('app.float.one_night_height'))
          Text($r('app.string.sift'))
            .fontColor($r('sys.color.font_primary'))
            .margin({ left: $r('app.float.hotel_picture_padding') })
            .font({ size: $r('app.float.hotel_message_font_size'), weight: Constants.FONT_WEIGHT_400 })
            .opacity(Constants.OPACITY_NINETY_PERCENT)
        }
        .margin({ left: $r('sys.float.padding_level2'), top: $r('sys.float.padding_level2') })
        .onClick(() => {
          this.getTicketItem([
            this.siftCondition[Constants.NUMBER_ZERO].getResult(),
            this.siftCondition[Constants.NUMBER_ONE].getResult(),
            this.siftCondition[Constants.NUMBER_TWO].getResult()
          ]);
        })
      }
      .margin({
        top: $r('app.float.calendar_column_margin'),
        right: this.breakPoint === BreakpointTypeEnum.SM ? $r('sys.float.padding_level8') :
        $r('sys.float.padding_level0')
      })
      .width(Constants.NINETY_ONE_PERCENT)

      Row() {
        ForEach(Constants.SEARCH_ADDRESS_BUTTON_MESSAGE, (item: Resource, index: number) => {
          Column() {
            Text(item)
              .font({ size: $r('app.float.hotel_message_font_size'), weight: Constants.FONT_WEIGHT_400 })
              .fontColor($r('sys.color.font_primary'))
              .textAlign(TextAlign.Center)
          }
          .margin({ right: $r('app.float.calendar_column_margin') })
          .onClick(() => {
            let allTicket = this.getDateTicket();
            this.ticketItems = [];
            const context: Context = this.getUIContext().getHostContext()!;
            if (!context) {
              return;
            }
            if (index === Constants.NUMBER_ZERO || index === Constants.NUMBER_ONE) {
              allTicket.forEach((element) => {
                try {
                  const startPoint: string = context.resourceManager.getStringSync(element.startPoint.id);
                  const button: string = context.resourceManager.getStringSync(item.id);
                  if (startPoint === button) {
                    this.ticketItems.push(element);
                  }
                } catch (err) {
                  Logger.error(TAG, `getStringSync fail. error code: ${err.code}.`);
                }
              });
            } else {
              allTicket.forEach((element) => {
                try {
                  const arrivePoint: string = context.resourceManager.getStringSync(element.arrivePoint.id);
                  const button: string = context.resourceManager.getStringSync(item.id);
                  if (arrivePoint === button) {
                    this.ticketItems.push(element);
                  }
                } catch (err) {
                  Logger.error(TAG, `getStringSync fail. error code: ${err.code}.`);
                }
              });
            }
          })
          .justifyContent(FlexAlign.Center)
          .width($r('app.float.hotel_room_Width'))
          .height($r('app.float.receive_height'))
          .borderRadius($r('app.float.hotel_room_border'))
          .backgroundColor($r('sys.color.comp_background_primary'))
        }, (item: string) => JSON.stringify(item))
      }
      .margin({ top: $r('app.float.room_picture_border'), bottom: $r('app.float.room_picture_border') })
      .width(Constants.NINETY_ONE_PERCENT)

      Scroll() {
        Column() {
          ForEach(this.ticketItems, (item: TicketItem) => {
            Column() {
              Row() {
                Column() {
                  Text(item.startTime)
                    .fontColor($r('sys.color.font_primary'))
                    .font({ size: $r('app.float.low_price_font_size'), weight: Constants.FONT_WEIGHT_500 })
                  Text(item.startPoint)
                    .fontColor($r('sys.color.font_primary'))
                    .font({ size: $r('app.float.room_message_weo_width'), weight: Constants.FONT_WEIGHT_400 })
                }

                Column() {
                  Text(item.tranTrip)
                    .fontColor($r('sys.color.font_primary'))
                    .font({ size: $r('app.float.low_price_font_size'), weight: Constants.FONT_WEIGHT_400 })
                  Column()
                    .backgroundColor($r('sys.color.font_primary'))
                    .opacity(Constants.OPACITY_EIGHTY_PERCENT)
                    .height(1)
                    .width(Constants.TWENTY_TWO_PERCENT)
                    .margin({ top: $r('sys.float.padding_level4'), bottom: $r('sys.float.padding_level4') })
                  Text(item.totalDuration)
                    .fontColor($r('sys.color.font_primary'))
                    .font({ size: $r('app.float.hotel_message_font_size'), weight: Constants.FONT_WEIGHT_400 })
                    .opacity(Constants.OPACITY_FORTY_PERCENT)
                }
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)

                Column() {
                  Text(item.arriveTime)
                    .fontColor($r('sys.color.font_primary'))
                    .font({ size: $r('app.float.low_price_font_size'), weight: Constants.FONT_WEIGHT_500 })
                  Text(item.arrivePoint)
                    .fontColor($r('sys.color.font_primary'))
                    .font({ size: $r('app.float.room_message_weo_width'), weight: Constants.FONT_WEIGHT_400 })
                }

                Row() {
                  Text(Constants.MONEY)
                    .fontColor($r('app.color.money_color'))
                    .font({ size: $r('app.float.hotel_message_font_size'), weight: Constants.FONT_WEIGHT_400 })
                    .margin({ bottom: $r('sys.float.padding_level2') })
                  Text(item.money + Constants.EMPTY_STRING)
                    .fontColor($r('app.color.money_color'))
                    .font({ size: $r('app.float.week_info_lg_font_size'), weight: Constants.FONT_WEIGHT_500 })
                  Text(Constants.START)
                    .fontColor($r('app.color.money_color'))
                    .font({ size: $r('app.float.hotel_message_font_size'), weight: Constants.FONT_WEIGHT_400 })
                    .margin({ bottom: $r('sys.float.padding_level2') })
                }
                .alignItems(VerticalAlign.Bottom)
              }
              .backgroundColor($r('sys.color.comp_background_primary'))
              .width(Constants.NINETY_FIVE_PERCENT)
              .justifyContent(FlexAlign.SpaceBetween)

              Row() {
                Row() {
                  Text($r('app.string.second_class_seating'))
                    .font({ size: $r('app.float.hotel_message_font_size'), weight: Constants.FONT_WEIGHT_400 })
                    .opacity(Constants.OPACITY_FORTY_PERCENT)
                    .margin({ right: $r('app.float.hotel_content_margin_top') })
                  Text(item.secondClassNumber.toString())
                    .font({ size: $r('app.float.hotel_message_font_size'), weight: Constants.FONT_WEIGHT_400 })
                    .fontColor($r('app.color.ticket_number'))
                    .margin({ right: $r('app.float.calendar_column_margin') })
                }
                .backgroundColor($r('sys.color.comp_background_primary'))
                .margin({ right: $r('app.float.calendar_column_margin') })

                Row() {
                  Text($r('app.string.first_class_seating'))
                    .font({ size: $r('app.float.hotel_message_font_size'), weight: Constants.FONT_WEIGHT_400 })
                    .opacity(Constants.OPACITY_FORTY_PERCENT)
                    .margin({ right: $r('app.float.hotel_content_margin_top') })
                  Text(item.firstClassNumber.toString())
                    .font({ size: $r('app.float.hotel_message_font_size'), weight: Constants.FONT_WEIGHT_400 })
                    .fontColor($r('app.color.ticket_number'))
                    .margin({ right: $r('app.float.calendar_column_margin') })
                }
                .backgroundColor($r('sys.color.comp_background_primary'))
                .margin({ right: $r('app.float.calendar_column_margin') })

                Row() {
                  Text($r('app.string.Business_Seating'))
                    .font({ size: $r('app.float.hotel_message_font_size'), weight: Constants.FONT_WEIGHT_400 })
                    .opacity(Constants.OPACITY_FORTY_PERCENT)
                    .margin({ right: $r('app.float.hotel_content_margin_top') })
                  Text(item.businessNumber.toString())
                    .font({ size: $r('app.float.hotel_message_font_size'), weight: Constants.FONT_WEIGHT_400 })
                    .fontColor($r('app.color.ticket_number'))
                    .margin({ right: $r('app.float.calendar_column_margin') })
                }
                .backgroundColor($r('sys.color.comp_background_primary'))
                .margin({ right: $r('app.float.calendar_column_margin') })
              }
              .width(Constants.NINETY_FIVE_PERCENT)
            }
            .justifyContent(FlexAlign.SpaceAround)
            .width(Constants.NINETY_ONE_PERCENT)
            .height($r('app.float.room_all_picture_width'))
            .backgroundColor($r('sys.color.comp_background_primary'))
            .margin({ bottom: $r('app.float.calendar_column_margin') })
            .borderRadius($r('app.float.hotel_grade_border'))
          }, (item: TicketItem) => JSON.stringify(item))
        }
        .height(Constants.AUTO_HEIGHT)
        .backgroundColor($r('sys.color.background_secondary'))
      }
      .align(Alignment.Top)
      .scrollBar(BarState.Off)
      .margin({ bottom: $r('app.float.buy_button_width') })
      .width(Constants.FULL_WIDTH_PERCENT)
    }
    .width(Constants.FULL_WIDTH_PERCENT)
    .height(Constants.FULL_WIDTH_PERCENT)
    .backgroundColor($r('sys.color.background_secondary'))
    .borderRadius({ topLeft: $r('app.float.calendar_card_border'), topRight: $r('app.float.calendar_card_border') })
  }
}