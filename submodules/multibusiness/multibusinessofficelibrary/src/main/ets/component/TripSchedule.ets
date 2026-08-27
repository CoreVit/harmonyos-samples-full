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

import { CommonConstants } from '../constants/CommonConstants';
import { TripData } from '../model/TripData';

@Component
export struct TripScheduleView {
  build() {
    Column() {
      Scroll() {
        Column() {
          ForEach(CommonConstants.TRIP_SCHEDULE, (tripItem: TripData) => {
            Row() {
              Column() {
                Text(tripItem.startTime)
                  .fontSize($r('app.float.trip_content_font'))

                Row()
                  .border({
                    style: { left: BorderStyle.Solid },
                    color: { left: $r('sys.color.icon_fourth') },
                    width: { left: CommonConstants.COMMON_ONE }
                  })
                  .margin({ left: $r('app.float.trip_icon_margin') })
                  .height(CommonConstants.COMMON_SEVEN)
                  .width(CommonConstants.COMMON_ONE)
                Row()
                  .borderColor($r('app.color.purple'))
                  .borderRadius($r('app.float.trip_schedule_icon_radius'))
                  .borderWidth($r('app.float.trip_schedule_icon_width'))
                  .height(CommonConstants.COMMON_FIVE)
                  .width(CommonConstants.COMMON_FIVE)
                Row()
                  .border({
                    style: { left: BorderStyle.Solid },
                    color: { left: $r('sys.color.icon_fourth') },
                    width: { left: CommonConstants.COMMON_ONE }
                  })
                  .margin({ left: $r('app.float.trip_icon_margin') })
                  .height(CommonConstants.COMMON_SEVEN)
                  .width(CommonConstants.COMMON_ONE)

                Text(tripItem.endTime)
                  .fontSize($r('app.float.trip_content_font'))
              }
              .width($r('app.float.trip_icon_width'))
              .margin({
                top: $r('app.float.trip_icon_margin_top'),
                left: $r('app.float.width_or_margin')
              })
              .height($r('app.float.trip_icon_height'))
              .justifyContent(FlexAlign.SpaceBetween)

              Column() {
                Row() {
                  Text('                                                    ')
                    .backgroundColor($r('sys.color.comp_background_tertiary'))
                    .borderRadius($r('sys.float.corner_radius_level6'))
                }
                .width(CommonConstants.FULL_PERCENT)
                .justifyContent(FlexAlign.Start)

                Row() {
                  Text('                          ')
                    .backgroundColor($r('sys.color.comp_background_tertiary'))
                    .borderRadius($r('sys.float.corner_radius_level6'))
                }
                .margin({ top: $r('app.float.trip_item_location_margin') })
                .width(CommonConstants.FULL_PERCENT)
                .justifyContent(FlexAlign.Start)
              }
              .margin({ left: $r('app.float.width_or_margin') })
              .layoutWeight(CommonConstants.COMMON_ONE)
              .height(CommonConstants.FULL_PERCENT)
              .justifyContent(FlexAlign.Center)
            }
            .margin({ bottom: $r('sys.float.corner_radius_level5') })
            .backgroundColor($r('sys.color.comp_background_primary'))
            .height($r('app.float.trip_height'))
            .width(CommonConstants.FULL_PERCENT)
            .borderRadius($r('app.float.border_radius_entry'))
            .justifyContent(FlexAlign.Start)
          }, (tripItem: TripData) => JSON.stringify(tripItem))
        }
        .width(CommonConstants.FULL_PERCENT)
        .height($r('app.float.trip_schedule_height'))
        .justifyContent(FlexAlign.Start)
      }
      .scrollBar(BarState.Off)
    }
    .width(CommonConstants.FULL_PERCENT)
  }
}