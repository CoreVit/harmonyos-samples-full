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

@Component
export struct CalendarDialogView {
  @State startTime: number = Constants.START_TIME;
  @State stopTime: number = Constants.START_TIME;
  @Consume(Constants.KEY_PATH_STACK) pageInfos: NavPathStack;

  getDate(item: CalendarItem) {
    return Number.parseInt(item.date);
  }

  getIndex(index: number, item: CalendarItem) {
    if (item.date === Constants.EMPTY_STRING || item.isLast) {
      return Constants.MAX_TIME;
    }
    return index;
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Row() {
          Text($r('app.string.LowPriceCalendar'))
            .fontColor($r('sys.color.font_primary'))
            .font({ size: $r('app.float.low_price_font_size'), weight: Constants.FONT_WEIGHT_500 })
            .height($r('app.float.low_price_height'))

          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.xmark'))
              .fontColor([$r('sys.color.font_primary')])
              .fontSize($r('app.float.calendar_size'))
          }
          .width($r('app.float.low_price_height'))
          .height($r('app.float.low_price_height'))
          .aspectRatio(1)
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .onClick(() => {
            this.pageInfos.pop();
          })
        }
        .margin({ top: $r('app.float.low_price_margin_top') })
        .width(Constants.NINETY_PERCENT)
        .height($r('app.float.low_price_all_height'))
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          SymbolGlyph($r('sys.symbol.chevron_left'))
            .fontColor([$r('sys.color.font_primary')])
            .fontSize($r('app.float.low_price_height'))
          Text($r('app.string.January_2024'))
            .fontColor($r('sys.color.font_primary'))
            .font({ size: $r('app.float.January_2024_font_size'), weight: Constants.FONT_WEIGHT_500 })
            .opacity(Constants.OPACITY_NINETY_PERCENT)
          SymbolGlyph($r('sys.symbol.chevron_right'))
            .fontColor([$r('sys.color.font_primary')])
            .fontSize($r('app.float.low_price_height'))
        }
        .width(Constants.NINETY_PERCENT)
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: $r('app.float.January_2024_margin_top') })

        Row() {
          ForEach(Constants.WEEK_MESSAGE, (weekInfo: string) => {
            Column() {
              Text(weekInfo)
                .fontColor($r('sys.color.font_primary'))
                .font({ size: $r('sys.float.Caption_M'), weight: Constants.FONT_WEIGHT_500 })
                .opacity(Constants.OPACITY_NINETY_PERCENT)
                .textAlign(TextAlign.Center)
                .width(Constants.FULL_WIDTH_PERCENT)
            }
            .justifyContent(FlexAlign.Center)
            .width($r('app.float.low_price_all_height'))
            .height($r('app.float.low_price_height'))
          }, (weekInfo: string) => JSON.stringify(weekInfo))
        }
        .width(Constants.NINETY_PERCENT)
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: $r('app.float.index_page_button_margin') })

        Column() {
          Grid() {
            ForEach(Constants.CALENDAR_TIME_MESSAGE[0], (item: CalendarItem, index) => {
              GridItem() {
                Column() {
                  Text(item.isToday ? $r('app.string.Today') : Constants.EMPTY_STRING)
                    .font({ size: $r('app.float.calendar_money_font_size'), weight: Constants.FONT_WEIGHT_200 })
                    .fontColor((this.startTime === this.getIndex(index, item)) ||
                      (this.stopTime === this.getIndex(index, item)) ? $r('sys.color.font_on_primary') :
                      $r('sys.color.font_primary'))
                    .visibility((this.startTime === this.getIndex(index, item)) ||
                      (this.stopTime === this.getIndex(index, item)) ? Visibility.None : Visibility.Visible)
                  Text(item.date)
                    .font({ size: $r('app.float.week_info_font_size'), weight: Constants.FONT_WEIGHT_500 })
                    .opacity(item.isLast ? Constants.OPACITY_FORTY_PERCENT : Constants.OPACITY_FULL_PERCENT)
                    .fontColor((this.startTime === this.getIndex(index, item)) ||
                      (this.stopTime === this.getIndex(index, item)) ? $r('sys.color.font_on_primary') :
                      $r('sys.color.font_primary'))
                  Text(item.money)
                    .font({ size: $r('app.float.calendar_money_font_size'), weight: Constants.FONT_WEIGHT_400 })
                    .fontColor((this.startTime === this.getIndex(index, item)) ||
                      (this.stopTime === this.getIndex(index, item)) ? $r('sys.color.font_on_primary') :
                      item.isLowPrice ?
                        $r('app.color.font_color_red') : $r('sys.color.font_primary'))
                  if (item.isLowPrice) {
                    Text($r('app.string.LowPrice'))
                      .font({ size: $r('app.float.calendar_money_font_size'), weight: Constants.FONT_WEIGHT_400 })
                      .fontColor((this.startTime === this.getIndex(index, item)) ||
                        (this.stopTime === this.getIndex(index, item)) ? $r('sys.color.font_on_primary') :
                        item.isLowPrice ? $r('app.color.font_color_red') : $r('sys.color.font_primary'))
                      .visibility((this.startTime === this.getIndex(index, item)) ||
                        (this.stopTime === this.getIndex(index, item)) ? Visibility.None : Visibility.Visible)
                  }
                  Text($r('app.string.MoveInto'))
                    .font({ size: $r('app.float.calendar_money_font_size'), weight: Constants.FONT_WEIGHT_400 })
                    .fontColor($r('sys.color.font_on_primary'))
                    .visibility(this.startTime === this.getIndex(index, item) ? Visibility.Visible : Visibility.None)
                  Text($r('app.string.leave'))
                    .font({ size: $r('app.float.calendar_money_font_size'), weight: Constants.FONT_WEIGHT_400 })
                    .fontColor($r('sys.color.font_on_primary'))
                    .visibility(this.stopTime === this.getIndex(index, item) ? Visibility.Visible : Visibility.None)
                }
                .backgroundColor((this.startTime === this.getIndex(index, item)) ||
                  (this.stopTime === this.getIndex(index, item)) ? $r('app.color.Calendar_selected_backgroundColor') :
                  $r('sys.color.comp_background_primary'))
                .borderRadius($r('app.float.calendar_date_border'))
                .onClick(() => {
                  if (this.startTime === Constants.START_TIME) {
                    this.startTime = this.getDate(item);
                  } else if (this.stopTime === Constants.START_TIME) {
                    this.stopTime = Math.max(this.startTime, this.getDate(item));
                    this.startTime = Math.min(this.startTime, this.getDate(item));
                  } else {
                    this.stopTime = Math.max(this.startTime, this.getDate(item));
                    this.startTime = Math.min(this.startTime, this.getDate(item));
                  }
                })
                .justifyContent(FlexAlign.Center)
                .width($r('app.float.low_price_all_height'))
                .height($r('app.float.calendar_date_height'))
              }
            }, (item: CalendarItem) => JSON.stringify(item))

          }
          .width(Constants.FULL_WIDTH_PERCENT)
          .columnsGap($r('app.float.calendar_column_margin'))
          .rowsGap($r('app.float.calendar_column_margin'))
          .height(Constants.FULL_WIDTH_PERCENT)
          .columnsTemplate(Constants.GRID_COLUMN_TEMPLATE)

        }
        .width(Constants.NINETY_PERCENT)
        .height(Constants.AUTO_HEIGHT)
      }
      .borderRadius($r('app.float.calendar_card_border'))
      .width($r('app.float.calendar_card_width'))
      .height($r('app.float.calendar_card_height'))
      .backgroundColor($r('sys.color.comp_background_primary'))
    }
    .backgroundColor($r('sys.color.ohos_id_color_mask_regular'))
    .height('100%')
    .width('100%')
  }
}