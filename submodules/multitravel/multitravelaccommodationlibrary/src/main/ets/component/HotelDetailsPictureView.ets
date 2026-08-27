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

import { JSON } from '@kit.ArkTS';
import { Constants } from '../commons/constants/Constants';
import { BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { HotelDetailsContentView } from './HotelDetailsContentView';
import { HotelDetailsOrderView } from './HotelDetailsOrderView';
import { HotelDetailsRoomView } from './HotelDetailsRoomView';

@Component
export struct HotelDetailsPictureView {
  @StorageLink(Constants.KEY_BREAKPOINT) breakPoint: string = BreakpointTypeEnum.LG;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @State mainPictureResource: Resource = Constants.HOTEL_PICTURE_MESSAGE[Constants.NUMBER_ZERO];
  @Link topLength: number;
  @Consume(Constants.KEY_PATH_STACK) pageInfos: NavPathStack;

  getMainPicture(index: number) {
    this.mainPictureResource = Constants.HOTEL_PICTURE_MESSAGE[index];
  }

  build() {
    if (this.breakPoint === BreakpointTypeEnum.SM) {
      Column() {
        Stack({ alignContent: Alignment.Top }) {
          Row() {
            Button({ type: ButtonType.Circle }) {
              SymbolGlyph($r('sys.symbol.chevron_backward'))
                .fontColor([$r('sys.color.icon_on_primary')])
                .fontSize($r('sys.float.Title_M'))
            }
            .height($r('app.float.back_button_height'))
            .aspectRatio(1)
            .margin({ right: $r('sys.float.padding_level4') })
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .onClick(() => this.pageInfos.pop())

            Row() {
              Button({ type: ButtonType.Circle }) {
                SymbolGlyph($r('sys.symbol.heart'))
                  .fontColor([$r('sys.color.icon_on_primary')])
                  .fontSize($r('sys.float.Title_M'))
              }
              .height($r('app.float.back_button_height'))
              .aspectRatio(1)
              .margin({ right: $r('sys.float.padding_level4') })
              .backgroundColor($r('sys.color.comp_background_tertiary'))

              Button({ type: ButtonType.Circle }) {
                SymbolGlyph($r('sys.symbol.arrowshape_turn_up_right'))
                  .fontColor([$r('sys.color.icon_on_primary')])
                  .fontSize($r('sys.float.Title_M'))
              }
              .height($r('app.float.back_button_height'))
              .aspectRatio(1)
              .backgroundColor($r('sys.color.comp_background_tertiary'))
            }
          }
          .margin({ top: $r('app.float.hotel_bar_margin_top'), })
          .padding({
            left: $r('sys.float.padding_level8'),
            right: $r('sys.float.padding_level8')
          })
          .justifyContent(FlexAlign.SpaceBetween)
          .width(Constants.FULL_WIDTH_PERCENT)
          .height($r('app.float.hotel_bar_height'))
          .zIndex(Constants.NUMBER_TWO)

          Column() {
            Image($r('app.media.hotel_phone'))
              .width(Constants.FULL_WIDTH_PERCENT)
          }
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .width(Constants.FULL_WIDTH_PERCENT)
          .height(this.topLength)
          .zIndex(Constants.NUMBER_ONE)
          .animation({
            duration: Constants.NUMBER_THOUSAND,
            curve: Curve.EaseOut,
            iterations: Constants.NUMBER_ONE,
            playMode: PlayMode.Normal
          })

          Column() {
            HotelDetailsContentView()
              .width(Constants.FULL_WIDTH_PERCENT)
              .height($r('app.float.hotel_detail_content_height'))
            HotelDetailsOrderView()
              .margin({ top: $r('app.float.hotel_grade_border') })
              .width(Constants.FULL_WIDTH_PERCENT)
              .height($r('app.float.hotel_detail_order_height'))
            HotelDetailsRoomView()
              .margin({ top: $r('app.float.hotel_grade_border') })
              .width(Constants.FULL_WIDTH_PERCENT)
          }
          .margin({ top: this.topLength - Constants.NUMBER_FIFTEEN })
          .animation({
            duration: Constants.NUMBER_THOUSAND,
            curve: Curve.EaseOut,
            iterations: Constants.NUMBER_ONE,
            playMode: PlayMode.Normal
          })
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .width(Constants.FULL_WIDTH_PERCENT)
          .zIndex(Constants.NUMBER_TWO)
        }
      }
    } else if (this.breakPoint === BreakpointTypeEnum.MD) {
      Column() {
        Row() {
          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.chevron_backward'))
              .fontColor([$r('sys.color.icon_primary')])
              .fontSize($r('sys.float.Title_M'))
          }
          .height($r('app.float.back_button_height'))
          .aspectRatio(1)
          .margin({ right: $r('sys.float.padding_level4') })
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .onClick(() => this.pageInfos.pop())

          Row() {
            Button({ type: ButtonType.Circle }) {
              SymbolGlyph($r('sys.symbol.heart'))
                .fontColor([$r('sys.color.icon_primary')])
                .fontSize($r('sys.float.Title_M'))
            }
            .height($r('app.float.back_button_height'))
            .aspectRatio(1)
            .margin({ right: $r('sys.float.padding_level4') })
            .backgroundColor($r('sys.color.comp_background_tertiary'))

            Button({ type: ButtonType.Circle }) {
              SymbolGlyph($r('sys.symbol.arrowshape_turn_up_right'))
                .fontColor([$r('sys.color.icon_primary')])
                .fontSize($r('sys.float.Title_M'))
            }
            .height($r('app.float.back_button_height'))
            .aspectRatio(1)
            .margin({ right: $r('sys.float.padding_level4') })
            .backgroundColor($r('sys.color.comp_background_tertiary'))
          }
        }
        .padding({
          left: $r('sys.float.padding_level12'),
          right: $r('sys.float.padding_level12')
        })
        .margin({ top: $r('app.float.hotel_bar_margin_top') })
        .justifyContent(FlexAlign.SpaceBetween)
        .width(Constants.FULL_WIDTH_PERCENT)
        .height($r('app.float.hotel_bar_height'))
        .zIndex(Constants.NUMBER_TWO)

        Row() {
          Column() {
            Image(this.mainPictureResource)
              .width(Constants.NINETY_PERCENT)
              .borderRadius($r('app.float.calendar_card_border'))
              .margin({ bottom: $r('sys.float.padding_level6') })
            Scroll() {
              Row() {
                ForEach(Constants.HOTEL_PICTURE_MESSAGE, (item: Resource, index: number) => {
                  Column() {
                    Image(item)
                      .width(Constants.THIRTY_PERCENT)
                      .borderRadius($r('app.float.hotel_grade_border'))
                      .margin(index === Constants.NUMBER_FOUR ? {} : { right: Constants.FIVE_PERCENT })
                      .onClick(() => {
                        this.getMainPicture(index);
                      })
                  }
                }, (item: Resource) => JSON.stringify(item))
              }
            }
            .scrollBar(BarState.Off)
            .margin({ top: $r('app.float.calendar_column_margin') })
            .width(Constants.NINETY_PERCENT)
            .scrollable(ScrollDirection.Horizontal)
          }
          .margin({ left: $r('sys.float.padding_level4') })
          .width(Constants.FIFTY_PERCENT)
          .height(Constants.FULL_WIDTH_PERCENT)

          Scroll() {
            Column() {
              HotelDetailsContentView()
                .width(Constants.FULL_WIDTH_PERCENT)
                .height($r('app.float.hotel_detail_content_height'))
              HotelDetailsOrderView()
                .margin({ top: $r('app.float.hotel_grade_border') })
                .width(Constants.FULL_WIDTH_PERCENT)
                .height($r('app.float.hotel_detail_order_height'))
              HotelDetailsRoomView()
                .margin({ top: $r('app.float.hotel_grade_border') })
                .width(Constants.FULL_WIDTH_PERCENT)
            }
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .width(Constants.NINETY_FIVE_PERCENT)
            .zIndex(Constants.NUMBER_TWO)
          }
          .scrollBar(BarState.Off)
          .width(Constants.FIFTY_PERCENT)
        }
        .width(Constants.FULL_WIDTH_PERCENT)
        .height(Constants.NINETY_PERCENT)
      }
      .width(Constants.FULL_WIDTH_PERCENT)
      .height(Constants.FULL_WIDTH_PERCENT)
    } else {
      Stack({ alignContent: Alignment.Top }) {
        Row() {
          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.chevron_backward'))
              .fontColor([$r('sys.color.icon_primary')])
              .fontSize($r('sys.float.Title_M'))
          }
          .height($r('app.float.back_button_height'))
          .aspectRatio(1)
          .margin({ right: $r('sys.float.padding_level4') })
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .onClick(() => this.pageInfos.pop())

          Row() {
            Button({ type: ButtonType.Circle }) {
              SymbolGlyph($r('sys.symbol.heart'))
                .fontColor([$r('sys.color.icon_primary')])
                .fontSize($r('sys.float.Title_M'))
            }
            .height($r('app.float.back_button_height'))
            .aspectRatio(1)
            .margin({ right: $r('sys.float.padding_level4') })
            .backgroundColor($r('sys.color.comp_background_tertiary'))

            Button({ type: ButtonType.Circle }) {
              SymbolGlyph($r('sys.symbol.arrowshape_turn_up_right'))
                .fontColor([$r('sys.color.icon_primary')])
                .fontSize($r('sys.float.Title_M'))
            }
            .height($r('app.float.back_button_height'))
            .aspectRatio(1)
            .margin({ right: $r('sys.float.padding_level4') })
            .backgroundColor($r('sys.color.comp_background_tertiary'))
          }
        }
        .margin({ top: this.statusBarHeight + Constants.COLUMN_MD })
        .justifyContent(FlexAlign.SpaceBetween)
        .width(Constants.NINETY_FIVE_PERCENT)
        .height($r('app.float.hotel_bar_height'))
        .zIndex(Constants.NUMBER_TWO)

        Row() {
          Swiper() {
            ForEach(Constants.HOTEL_PICTURE_MESSAGE, (item: Resource) => {
              Image(item)
                .width(Constants.FULL_WIDTH_PERCENT)
            }, (item: Resource) => JSON.stringify(item))
          }
          .width(Constants.FORTY_PERCENT)
          .height(Constants.FULL_WIDTH_PERCENT)

          Scroll() {
            Column() {
              HotelDetailsContentView()
                .width(Constants.FULL_WIDTH_PERCENT)
                .height($r('app.float.hotel_detail_content_height'))
              HotelDetailsOrderView()
                .margin({ top: $r('app.float.hotel_grade_border') })
                .width(Constants.FULL_WIDTH_PERCENT)
                .height($r('app.float.hotel_detail_order_height'))
              HotelDetailsRoomView()
                .margin({ top: $r('app.float.hotel_grade_border') })
                .width(Constants.FULL_WIDTH_PERCENT)
            }
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .width(Constants.FULL_WIDTH_PERCENT)
            .zIndex(Constants.NUMBER_TWO)
          }
          .padding({ top: Constants.COLUMN_MD })
          .margin({ top: this.statusBarHeight })
          .width(Constants.SIXTY_PERCENT)
          .scrollBar(BarState.Off)
        }
        .width(Constants.FULL_WIDTH_PERCENT)
        .height(Constants.FULL_WIDTH_PERCENT)
      }
    }
  }
}