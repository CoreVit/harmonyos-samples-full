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
import { CalendarItem } from '../model/CalendarItem';
import { BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CalendarDialogView } from './CalendarView';

@Component
export struct LowPriceView {
  @StorageLink(Constants.KEY_BREAKPOINT) breakPoint: string = BreakpointTypeEnum.SM;
  @StorageProp(Constants.KEY_NAV_INDICATOR_HEIGHT) navIndicatorHeight: number = 0;
  @Consume(Constants.KEY_PATH_STACK) pageInfos: NavPathStack;
  @State startTime: number = Constants.START_TIME;
  @State stopTime: number = Constants.START_TIME;

  getDate(index: number, item: CalendarItem) {
    if (index === Constants.NUMBER_ZERO) {
      return Number.parseInt(item.date);
    } else {
      return Constants.NUMBER_THIRTY_ONE + Number.parseInt(item.date);
    }
  }

  getIndex(index: number, temp: number, item: CalendarItem) {
    if (item.date === Constants.EMPTY_STRING || item.isLast) {
      return Constants.MAX_TIME;
    }
    if (index === Constants.NUMBER_ZERO) {
      return temp;
    } else {
      return Constants.NUMBER_TWENTY_EIGHT + temp;
    }
  }

  build() {
    NavDestination() {
      if (this.breakPoint === BreakpointTypeEnum.SM) {
        Column() {
          Stack({ alignContent: Alignment.Top }) {
            Stack({ alignContent: Alignment.Bottom }) {
              Column() {
                Row() {
                  Button({ type: ButtonType.Circle }) {
                    SymbolGlyph($r('sys.symbol.chevron_backward'))
                      .fontColor([$r('sys.color.icon_on_primary')])
                      .fontSize($r('sys.float.Title_M'))
                  }
                  .height($r('app.float.back_button_height'))
                  .aspectRatio(1)
                  .backgroundColor($r('sys.color.comp_background_tertiary'))
                  .onClick(() => this.pageInfos.pop())

                  Text($r('app.string.LowPriceCalendar'))
                    .margin({ left: $r('sys.float.padding_level4') })
                    .font({ size: $r('app.float.low_price_font_size'), weight: Constants.FONT_WEIGHT_700 })
                    .fontColor($r('sys.color.font_on_primary'))
                }
                .padding({
                  left: $r('sys.float.padding_level8'),
                  right: $r('sys.float.padding_level8')
                })
                .width(Constants.FULL_WIDTH_PERCENT)
                .margin({ top: $r('app.float.calendar_page_button_margin') })
              }
              .width(Constants.FULL_WIDTH_PERCENT)
              .height($r('app.float.calendar_height'))
              .backgroundColor($r('app.color.Calendar_selected_backgroundColor'))

              Row()
                .width(Constants.FULL_WIDTH_PERCENT)
                .height($r('app.float.week_info_lg_font_size'))
                .blendMode(BlendMode.SRC_IN)
                .zIndex(Constants.NUMBER_THREE)
            }

            Scroll() {
              Column() {
                ForEach(Constants.CALENDAR_TIME_MESSAGE, (item: Array<CalendarItem>, index) => {
                  Column() {
                    if (index === Constants.NUMBER_ZERO) {
                      Text($r('app.string.January_2024'))
                        .fontColor($r('sys.color.font_primary'))
                        .font({ size: $r('app.float.January_2024_font_size'), weight: Constants.FONT_WEIGHT_500 })
                        .opacity(Constants.OPACITY_NINETY_PERCENT)
                        .margin({ top: $r('app.float.week_info_font_size') })
                    } else {
                      Text($r('app.string.February_2024'))
                        .font({ size: $r('app.float.January_2024_font_size'), weight: Constants.FONT_WEIGHT_500 })
                        .fontColor($r('sys.color.font_primary'))
                        .opacity(Constants.OPACITY_NINETY_PERCENT)
                        .margin({ top: $r('app.float.week_info_font_size') })
                    }
                    Row() {
                      ForEach(Constants.WEEK_MESSAGE, (weekInfo: string) => {
                        Column() {
                          Text(weekInfo)
                            .fontColor($r('sys.color.font_primary'))
                            .font({ size: $r('sys.float.Body_S'), weight: Constants.FONT_WEIGHT_500 })
                            .opacity(Constants.OPACITY_NINETY_PERCENT)
                            .textAlign(TextAlign.Center)
                        }
                        .justifyContent(FlexAlign.Center)
                        .width($r('app.float.low_price_height'))
                        .height($r('app.float.low_price_height'))
                      }, (weekInfo: string) => JSON.stringify(weekInfo))
                    }
                    .width(Constants.NINETY_FIVE_PERCENT)
                    .justifyContent(FlexAlign.SpaceBetween)
                    .margin({ top: $r('app.float.January_2024_margin_top') })

                    Grid() {
                      ForEach(item, (dateItem: CalendarItem, temp: number) => {
                        GridItem() {
                          Column() {
                            Text(dateItem.isToday ? $r('app.string.Today') : Constants.EMPTY_STRING)
                              .font({
                                size: $r('app.float.calendar_money_font_size'),
                                weight: Constants.FONT_WEIGHT_200
                              })
                              .visibility((this.startTime === this.getIndex(index, temp, dateItem)) ||
                                (this.stopTime === this.getIndex(index, temp, dateItem)) ? Visibility.None :
                                Visibility.Visible)
                              .fontColor((this.startTime === this.getIndex(index, temp, dateItem)) ||
                                (this.stopTime === this.getIndex(index, temp, dateItem)) ?
                                $r('sys.color.font_on_primary') : $r('sys.color.font_primary'))
                            Text(dateItem.date)
                              .font({
                                size: $r('app.float.week_info_font_size'),
                                weight: Constants.FONT_WEIGHT_500
                              })
                              .opacity(dateItem.isLast ? Constants.OPACITY_FORTY_PERCENT :
                                Constants.OPACITY_FULL_PERCENT)
                              .fontColor((this.startTime === this.getIndex(index, temp, dateItem)) ||
                                (this.stopTime === this.getIndex(index, temp, dateItem)) ?
                                $r('sys.color.font_on_primary') : $r('sys.color.font_primary'))
                            Text(dateItem.money)
                              .font({
                                size: $r('app.float.calendar_money_font_size'),
                                weight: Constants.FONT_WEIGHT_400
                              })
                              .fontColor((this.startTime === this.getIndex(index, temp, dateItem)) ||
                                (this.stopTime === this.getIndex(index, temp, dateItem)) ?
                                $r('sys.color.font_on_primary') :
                                dateItem.isLowPrice ? $r('app.color.font_color_red') : $r('sys.color.font_primary'))
                            if (dateItem.isLowPrice) {
                              Text($r('app.string.LowPrice'))
                                .font({
                                  size: $r('app.float.calendar_money_font_size'),
                                  weight: Constants.FONT_WEIGHT_400
                                })
                                .fontColor((this.startTime === this.getIndex(index, temp, dateItem)) ||
                                  (this.stopTime === this.getIndex(index, temp, dateItem)) ?
                                  $r('sys.color.font_on_primary') :
                                  dateItem.isLowPrice ? $r('app.color.font_color_red') :
                                    $r('app.color.font_color_black'))
                                .visibility((this.startTime === this.getIndex(index, temp, dateItem)) ||
                                  (this.stopTime === this.getIndex(index, temp, dateItem)) ? Visibility.None :
                                  Visibility.Visible)
                            }
                            if (this.startTime === this.getIndex(index, temp, dateItem)) {
                              Text($r('app.string.MoveInto'))
                                .font({
                                  size: $r('app.float.calendar_money_font_size'),
                                  weight: Constants.FONT_WEIGHT_400
                                })
                                .fontColor($r('sys.color.font_on_primary'))
                            }
                            if (this.stopTime === this.getIndex(index, temp, dateItem)) {
                              Text($r('app.string.leave'))
                                .font({
                                  size: $r('app.float.calendar_money_font_size'),
                                  weight: Constants.FONT_WEIGHT_400
                                })
                                .fontColor($r('sys.color.font_on_primary'))
                            }
                          }
                          .backgroundColor((this.startTime === this.getIndex(index, temp, dateItem)) ||
                            (this.stopTime === this.getIndex(index, temp, dateItem)) ?
                            $r('app.color.Calendar_selected_backgroundColor') : $r('sys.color.comp_background_primary'))
                          .borderRadius($r('app.float.calendar_date_border'))
                          .onClick(() => {
                            if (this.startTime === Constants.START_TIME) {
                              this.startTime = this.getDate(index, dateItem);
                            } else if (this.stopTime === Constants.START_TIME) {
                              this.stopTime = Math.max(this.startTime, this.getDate(index, dateItem));
                              this.startTime = Math.min(this.startTime, this.getDate(index, dateItem));
                            } else {
                              this.stopTime = Math.max(this.startTime, this.getDate(index, dateItem));
                              this.startTime = Math.min(this.startTime, this.getDate(index, dateItem));
                            }
                          })
                          .justifyContent(FlexAlign.Center)
                          .width($r('app.float.low_price_all_height'))
                          .height($r('app.float.low_price_calendar_date_height'))
                        }
                      }, (dateItem: CalendarItem) => JSON.stringify(dateItem))
                    }
                    .backgroundColor($r('sys.color.comp_background_primary'))
                    .width(Constants.FULL_WIDTH_PERCENT)
                    .columnsGap(2)
                    .rowsGap($r('app.float.calendar_column_margin'))
                    .columnsTemplate(Constants.GRID_COLUMN_TEMPLATE)
                  }
                  .borderWidth({ bottom: 0.5 })
                  .borderColor($r('sys.color.comp_divider'))
                  .backgroundColor($r('sys.color.comp_background_primary'))
                  .width(Constants.FULL_WIDTH_PERCENT)
                  .height(Constants.AUTO_HEIGHT)
                  .borderRadius({
                    topLeft: index === 0 ? $r('app.float.calendar_card_border') : 0,
                    topRight: index === 0 ? $r('app.float.calendar_card_border') : 0,
                    bottomLeft: index === Constants.CALENDAR_TIME_MESSAGE.length - 1 ?
                      $r('app.float.calendar_card_border') : 0,
                    bottomRight: index === Constants.CALENDAR_TIME_MESSAGE.length - 1 ?
                      $r('app.float.calendar_card_border') : 0
                  })
                  .margin({ bottom: $r('app.float.calendar_column_margin') })
                }, (item: Array<CalendarItem>) => JSON.stringify(item))
              }
              .backgroundColor($r('sys.color.background_secondary'))
              .borderRadius($r('app.float.calendar_card_border'))
              .height(Constants.AUTO_HEIGHT)
              .width(Constants.FULL_WIDTH_PERCENT)
            }
            .scrollBar(BarState.Off)
            .borderRadius($r('app.float.calendar_card_border'))
            .width(Constants.NINETY_ONE_PERCENT)
            .height(Constants.FULL_WIDTH_PERCENT)
            .margin({ top: $r('app.float.calendar_margin_top'), bottom: this.navIndicatorHeight })
            .backgroundColor($r('sys.color.background_secondary'))
          }
          .width(Constants.FULL_WIDTH_PERCENT)
          .height(Constants.FULL_WIDTH_PERCENT)
          .backgroundColor($r('sys.color.background_secondary'))
        }
        .width(Constants.FULL_WIDTH_PERCENT)
        .height(Constants.FULL_WIDTH_PERCENT)
      } else {
        CalendarDialogView()
      }
    }
    .systemTransition(NavigationSystemTransitionType.NONE)
    .mode(NavDestinationMode.DIALOG)
    .hideTitleBar(true)
  }
}