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
import { SearchTicketListView } from './SearchTicketListView';

@Component
export struct SearchTicketTabView {
  @State tabArray: Array<number> = [Constants.NUMBER_ZERO, Constants.NUMBER_ONE];
  @State focusIndex: number = Constants.NUMBER_ZERO;
  @Link date: number;
  private controller: TabsController = new TabsController();

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Row() {
        Stack({ alignContent: Alignment.TopStart }) {
          Row()
            .height(Constants.NINETY_PERCENT)
            .width(Constants.FULL_WIDTH_PERCENT)
            .backgroundColor($r('sys.color.background_secondary'))
            .borderRadius({ topLeft: $r('app.float.hotel_grade_border'), topRight: $r('app.float.hotel_grade_border') })
          Flex({ direction: FlexDirection.Row }) {
            ForEach(Constants.SEARCH_TICKET_BAR, (item: string, index) => {
              if (this.focusIndex !== index) {
                Column() {
                  Text(item)
                    .height(Constants.FULL_WIDTH_PERCENT)
                    .textAlign(TextAlign.Center)
                    .font({ size: $r('app.float.room_date_font_size'), weight: Constants.FONT_WEIGHT_500 })
                    .fontColor($r('sys.color.font_primary'))
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .alignItems(HorizontalAlign.Center)
                .height(Constants.FULL_WIDTH_PERCENT)
                .onClick(() => {
                  this.focusIndex = index;
                })
                .width(Constants.FIFTY_PERCENT)
              } else {
                Column() {
                  Text(item)
                    .height(Constants.FULL_WIDTH_PERCENT)
                    .textAlign(TextAlign.Center)
                    .font({ size: $r('app.float.room_date_font_size'), weight: Constants.FONT_WEIGHT_500 })
                    .fontColor($r('sys.color.brand'))
                }
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .width(Constants.FIFTY_PERCENT)
                .height(Constants.FULL_WIDTH_PERCENT)
              }
            }, (item: string) => JSON.stringify(item))
          }
          .zIndex(Constants.NUMBER_TWO)
          .borderRadius({ topLeft: $r('app.float.hotel_grade_border'), topRight: $r('app.float.hotel_grade_border') })
          .backgroundColor(Color.Transparent)
          .height(Constants.FULL_WIDTH_PERCENT)
          .width(Constants.FULL_WIDTH_PERCENT)
        }
        .height(Constants.FULL_WIDTH_PERCENT)
        .width(Constants.FULL_WIDTH_PERCENT)
      }
      .borderRadius($r('app.float.hotel_grade_border'))
      .height($r('app.float.hotel_bar_height'))
      .width(Constants.FULL_WIDTH_PERCENT)

      Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
        ForEach(this.tabArray, () => {
          TabContent() {
            SearchTicketListView({ date: this.date })
              .height(Constants.FULL_WIDTH_PERCENT)
              .width(Constants.FULL_WIDTH_PERCENT)
          }
          .backgroundColor($r('sys.color.background_secondary'))
        }, (item: number) => JSON.stringify(item))
      }
      .barOverlap(true)
      .height(Constants.FULL_WIDTH_PERCENT)
      .width(Constants.FULL_WIDTH_PERCENT)
      .barHeight(Constants.NUMBER_ZERO)
      .animationDuration(Constants.NUMBER_ONE_HUNDRED)
      .onChange((index: number) => {
        this.focusIndex = index;
      })
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .height(Constants.FULL_WIDTH_PERCENT)
    .width(Constants.FULL_WIDTH_PERCENT)
    .borderRadius($r('app.float.calendar_card_border'))
  }
}