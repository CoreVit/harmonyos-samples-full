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

import { FunctionDescription } from '../common/FunctionDescription';
import { TripDataType } from '../model/DataType';
import Constants from '../model/Constants';
import { TripDataSource } from '../model/DataSource';
import CommonConstants from '../../../common/CommonConstants';

@Entry
@Component
struct MarqueeView {
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) currentBreakpoint: string = '';
  private pageInfos: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Row() {
        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.chevron_backward'))
            .fontColor([$r('sys.color.icon_primary')])
            .fontSize($r('sys.float.Title_M'))
        }
        .height(40)
        .aspectRatio(1)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .onClick(() => this.pageInfos.pop())

        Text('')
          .margin({ left: $r('sys.float.padding_level4') })
          .font({ size: 20, weight: 700 })
          .fontColor($r('sys.color.font_primary'))
      }
      .padding({
        top: 40,
        left: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                 $r('sys.float.padding_level12') :
                                                                                 $r('sys.float.padding_level16'),
        right: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                  $r('sys.float.padding_level12') :
                                                                                  $r('sys.float.padding_level16')
      })
      .width('100%')
      .height(96)
      .zIndex(2)
      .backgroundColor($r('sys.color.background_secondary'))

      Column() {
        FunctionDescription({
          title: $r('app.string.marquee_title'),
          content: $r('app.string.marquee_content')
        })

        TripView()
      }
      .width(Constants.FULL_SIZE)
      .height(Constants.FULL_SIZE)
      .padding({
        top: $r('app.string.ohos_id_card_padding_start'),
        left: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                 $r('sys.float.padding_level12') :
                                                                                 $r('sys.float.padding_level16'),
        right: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                  $r('sys.float.padding_level12') :
                                                                                  $r('sys.float.padding_level16')
      })
      .backgroundColor($r('sys.color.background_secondary'))
    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;
    })

  }
}

@Component
struct TripView {
  @State tripData: TripDataSource = new TripDataSource();
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) currentBreakpoint: string = '';

  @Builder
  tripMessages(item: TripDataType) {
    ListItem() {
      TripMessage({
        tripDataItem: item
      })
    }
  }

  build() {
    Column() {
      Text($r('app.string.my_trip'))
        .width(Constants.FULL_SIZE)
        .fontSize($r('app.string.ohos_id_text_size_headline'))
        .padding({
          top: $r('app.string.ohos_id_elements_margin_vertical_l'),
          bottom: 8
        })
        .fontColor($r('sys.color.font_primary'))
        .fontWeight(FontWeight.Bold)
      List() {
        LazyForEach(this.tripData, (item: TripDataType) => {
          this.tripMessages(item);
        }, (item: TripDataType) => item.trainNumber)

      }
      .cachedCount(2)
      .lanes(this.currentBreakpoint === 'sm' ? 1 : 2, 12)

    }
  }
}

@Component
struct TripMessage {
  @State delay: number = 0;
  @State ticketCheckTextOffset: number = 0;
  @State ticketCheckTextWidth: number = 0;
  @State ticketCheckScrollWidth: number = 0;
  @State tripDataItem: TripDataType = {} as TripDataType;

  @Styles
  commonStyles() {
    .width(Constants.FULL_SIZE)
    .margin({ top: $r('app.string.ohos_id_elements_margin_vertical_m') })
  }

  build() {
    Column() {
      Row() {
        Text(this.tripDataItem.trainNumber)
        Text(this.tripDataItem.wholeCourse)
      }
      .width(Constants.FULL_SIZE)
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Text(this.tripDataItem.startingTime)
          .fontSize($r('sys.float.ohos_id_text_size_headline6'))
          .width(Constants.TEXT_WIDTH_DEFAULT)
          .textAlign(TextAlign.Start)
        Text($r('app.string.plan_text'))
          .fontColor($r('app.color.ohos_id_color_emphasize'))
          .width(Constants.TEXT_WIDTH_MINI)
          .height(Constants.TEXT_HEIGHT_MINI)
          .textAlign(TextAlign.Center)
          .border({
            width: 1,
            radius: $r('app.string.ohos_id_corner_radius_default_m'),
            color: $r('app.color.ohos_id_color_emphasize')
          })
        Text(this.tripDataItem.endingTime)
          .fontSize($r('sys.float.ohos_id_text_size_headline6'))
          .width(Constants.TEXT_WIDTH_DEFAULT)
          .textAlign(TextAlign.End)

      }
      .commonStyles()
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Text(this.tripDataItem.origin)
        Text(this.tripDataItem.timeDifference)
        Text(this.tripDataItem.destination)
      }
      .commonStyles()
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Row() {
          Text($r('app.string.ticket_entrance'))
          Text(this.tripDataItem.ticketEntrance)
            .width(120)
            .textOverflow({ overflow: TextOverflow.MARQUEE })
        }

        Row() {
          Text($r('app.string.vehicle_model'))
          Text(this.tripDataItem.vehicleModel)
        }
        .id('vehicleModel')
        .justifyContent(FlexAlign.End)
      }
      .commonStyles()
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .padding($r('app.string.ohos_id_card_padding_start'))
    .borderRadius($r('app.string.ohos_id_corner_radius_default_m'))
    .margin({ bottom: $r('app.string.ohos_id_elements_margin_vertical_l') })
    .backgroundColor($r('sys.color.comp_background_primary'))
  }
}

@Builder
export function MarqueeViewContainer(name: string) {
  if (name === 'PageWaterMarqueeView') {
    MarqueeView()

  }
}

export const wrappedBuilderMarqueeView: WrappedBuilder<[string, number]> = wrapBuilder(MarqueeViewContainer);
