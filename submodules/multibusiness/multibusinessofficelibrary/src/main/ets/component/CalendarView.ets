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
import { CalendarItem } from '../model/CalendarItem';
import { BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { TripScheduleView } from './TripSchedule';

@Component
export struct CalendarView {
  @StorageLink(CommonConstants.KEY_MAIN_BREAKPOINT) breakPoint: string = BreakpointTypeEnum.SM;
  @StorageLink(CommonConstants.KEY_MAIN_NAV_INDICATOR_HEIGHT) naviIndicatorHeight: number = 0;
  @StorageLink('navMode') navMode: NavigationMode = NavigationMode.Split;
  @StorageLink('selectedItem') selectedItem: CalendarItem = new CalendarItem('', '', false);
  @Consume(CommonConstants.KEY_CALENDAR_PATH_STACK) calendarPageInfos: NavPathStack;
  @State selected: number = -1;
  @State isTrip: boolean = false;
  @State day: ResourceStr = '';

  build() {
    Column() {
      Stack({ alignContent: Alignment.Top }) {
        Column() {
          Column() {
            Row() {
              Grid() {
                ForEach(CommonConstants.WEEK_MESSAGE, (weekInfo: string, index: number) => {
                  GridItem() {
                    Column() {
                      Text(weekInfo)
                        .fontColor((index === CommonConstants.COMMON_ZERO || index === CommonConstants.COMMON_SIX) ?
                          $r('sys.color.font_tertiary') : $r('sys.color.font_primary'))
                        .font({
                          size: $r('app.float.trip_content_font'),
                          weight: FontWeight.Medium
                        })
                        .lineHeight($r('app.float.height_or_line_height'))
                        .textAlign(TextAlign.Center)
                    }
                    .justifyContent(FlexAlign.Center)
                    .width(CommonConstants.FULL_PERCENT)
                    .height($r('app.float.height_or_line_height'))
                  }
                }, (weekInfo: string) => JSON.stringify(weekInfo))
              }
              .height(CommonConstants.FULL_PERCENT)
              .width(CommonConstants.FULL_PERCENT)
              .columnsTemplate(CommonConstants.GRID_COLUMN_TEMPLATE)
            }
            .height(this.breakPoint === BreakpointTypeEnum.SM ? $r('app.float.weeks_height') :
              $r('app.float.notes_list_image'))
            .width(CommonConstants.FULL_PERCENT)
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ top: $r('app.float.weeks_margin_top') })

            Grid() {
              ForEach(CommonConstants.CALENDAR_TIME_MESSAGE, (dateItem: CalendarItem, temp: number) => {
                GridItem() {
                  Column() {
                    if (this.breakPoint !== BreakpointTypeEnum.SM) {
                      Column() {
                        Text(dateItem.date)
                          .font({
                            size: $r('app.float.sub_title_font'),
                            weight: CommonConstants.FONT_WEIGHT_500
                          })
                          .fontColor(dateItem.isAug ? $r('sys.color.font_tertiary') :
                            (this.selected === temp ? $r('sys.color.comp_background_primary') :
                              ((temp % CommonConstants.COMMON_SEVEN === CommonConstants.COMMON_ZERO ||
                                (temp + CommonConstants.COMMON_ONE) % CommonConstants.COMMON_SEVEN ===
                                CommonConstants.COMMON_ZERO || temp === CommonConstants.COMMON_ZERO) ?
                                $r('sys.color.font_tertiary') : $r('sys.color.font_primary'))))
                        Text(dateItem.lunarDate)
                          .font({
                            size: $r('app.float.notes_content_font'),
                            weight: CommonConstants.FONT_WEIGHT_400
                          })
                          .fontColor(dateItem.isAug ? $r('sys.color.font_tertiary') :
                            (this.selected === temp ? $r('sys.color.comp_background_primary') :
                              ((temp % CommonConstants.COMMON_SEVEN === CommonConstants.COMMON_ZERO ||
                                (temp + CommonConstants.COMMON_ONE) % CommonConstants.COMMON_SEVEN ===
                                CommonConstants.COMMON_ZERO || temp === CommonConstants.COMMON_ZERO) ?
                                $r('sys.color.font_tertiary') : $r('sys.color.font_primary'))))
                        Row()
                          .width($r('app.float.notes_c_margin'))
                          .height($r('app.float.notes_c_margin'))
                          .borderRadius($r('app.float.common_margin_width'))
                          .backgroundColor(dateItem.isAug ? $r('sys.color.comp_background_primary') :
                            (dateItem.isTrip ? (this.selected === temp ? $r('sys.color.comp_background_primary') :
                              $r('app.color.orange')) : (this.selected === temp ?
                              $r('app.color.orange') : $r('sys.color.comp_background_primary'))))
                      }
                      .backgroundColor(dateItem.isAug ? (this.breakPoint === BreakpointTypeEnum.SM ? '' :
                        $r('sys.color.comp_background_primary')) : (this.selected === temp ?
                        $r('app.color.orange') : $r('sys.color.comp_background_primary')))
                      .borderRadius($r('app.float.schedule_border_radius'))
                      .justifyContent(FlexAlign.Center)
                      .width($r('app.float.schedule_size'))
                      .height($r('app.float.schedule_size'))
                      .onClick(() => {
                        if (!dateItem.isAug) {
                          this.selected = temp;
                          this.selectedItem = dateItem;
                          if (dateItem.isTrip && this.breakPoint !== BreakpointTypeEnum.SM) {
                            this.calendarPageInfos.replacePath({ name: dateItem.date, param: dateItem }, false);
                            this.navMode = NavigationMode.Split;
                          } else {
                            this.navMode = NavigationMode.Stack;
                            this.calendarPageInfos.clear();
                          }
                        }
                        if (dateItem.isTrip) {
                          this.isTrip = true;
                          this.day = dateItem.lunarDate;
                        } else {
                          this.isTrip = false;
                        }
                      })

                      if (dateItem.isTrip) {
                        ForEach(CommonConstants.TRIP_LIST, () => {
                          Row() {
                            Text($r('app.string.trip_content'))
                              .maxLines(1)
                              .textOverflow({ overflow: TextOverflow.Ellipsis })
                              .fontColor($r('app.color.purple'))
                              .fontSize($r('app.float.trip_content_font'))
                              .lineHeight($r('app.float.height_or_line_height'))
                              .fontWeight(FontWeight.Medium)
                              .margin({ left: $r('app.float.common_margin_width') })
                          }
                          .width($r('app.float.content_width'))
                          .height($r('app.float.height_or_line_height'))
                          .borderRadius($r('app.float.notes_c_margin'))
                          .margin($r('app.float.common_margin_width'))
                          .border({
                            style: { left: BorderStyle.Solid },
                            color: { left: $r('app.color.purple') },
                            width: { left: $r('app.float.common_margin_width') }
                          })
                          .backgroundColor($r('app.color.trip_background_color'))
                        }, (index: number) => JSON.stringify(index))
                      }
                    } else {
                      Column() {
                        Text(dateItem.date)
                          .font({
                            size: $r('app.float.sub_title_font'),
                            weight: CommonConstants.FONT_WEIGHT_500
                          })
                          .fontColor(dateItem.isAug ? $r('sys.color.font_tertiary') :
                            (this.selected === temp ? $r('sys.color.comp_background_primary') :
                              ((temp % CommonConstants.COMMON_SEVEN === CommonConstants.COMMON_ZERO ||
                                (temp + CommonConstants.COMMON_ONE) % CommonConstants.COMMON_SEVEN ===
                                CommonConstants.COMMON_ZERO || temp === CommonConstants.COMMON_ZERO) ?
                                $r('sys.color.font_tertiary') : $r('sys.color.font_primary'))))
                        Text(dateItem.lunarDate)
                          .font({
                            size: $r('app.float.notes_content_font'),
                            weight: CommonConstants.FONT_WEIGHT_400
                          })
                          .fontColor(dateItem.isAug ? $r('sys.color.font_tertiary') :
                            (this.selected === temp ? $r('sys.color.comp_background_primary') :
                              ((temp % CommonConstants.COMMON_SEVEN === CommonConstants.COMMON_ZERO ||
                                (temp + CommonConstants.COMMON_ONE) % CommonConstants.COMMON_SEVEN ===
                                CommonConstants.COMMON_ZERO || temp === CommonConstants.COMMON_ZERO) ?
                                $r('sys.color.font_tertiary') : $r('sys.color.font_primary'))))
                        Row()
                          .width($r('app.float.notes_c_margin'))
                          .height($r('app.float.notes_c_margin'))
                          .borderRadius($r('app.float.common_margin_width'))
                          .backgroundColor(dateItem.isAug ? '' : (dateItem.isTrip ? (this.selected === temp ?
                            $r('sys.color.comp_background_primary') : $r('app.color.orange')) :
                            (this.selected === temp ? $r('app.color.orange') : '')))
                      }
                      .backgroundColor(dateItem.isAug ? '' : (this.selected === temp ? $r('app.color.orange') : ''))
                      .borderRadius($r('app.float.schedule_border_radius'))
                      .justifyContent(FlexAlign.Center)
                      .width($r('app.float.schedule_size'))
                      .height($r('app.float.schedule_size'))
                      .onClick(() => {
                        if (!dateItem.isAug) {
                          this.selected = temp;
                          this.selectedItem = dateItem;
                          if (dateItem.isTrip) {
                            this.isTrip = true;
                            this.day = dateItem.lunarDate;
                          } else {
                            this.isTrip = false;
                          }
                        }
                      })
                    }
                  }
                }
                .align(Alignment.Top)
              }, (dateItem: CalendarItem) => JSON.stringify(dateItem))
            }
            .layoutWeight(1)
            .width(CommonConstants.FULL_PERCENT)
            .columnsTemplate(CommonConstants.GRID_COLUMN_TEMPLATE)
            .rowsTemplate(CommonConstants.GRID_ROW_TEMPLATE)
          }
          .backgroundColor(this.breakPoint === BreakpointTypeEnum.SM ? '' :
            $r('sys.color.comp_background_primary'))
          .width(CommonConstants.FULL_PERCENT)
          .height(this.breakPoint === BreakpointTypeEnum.SM ? $r('app.float.calendar_height') :
            CommonConstants.FULL_PERCENT)
          .borderRadius($r('app.float.height_or_line_height'))
          .margin({
            bottom: $r('sys.float.corner_radius_level5'),
            left: CommonConstants.COMMON_MARGIN,
            right: CommonConstants.COMMON_MARGIN
          })

          if (this.breakPoint === BreakpointTypeEnum.SM && this.isTrip) {
            Column() {
              Row() {
                Text($r('app.string.trip_schedule_view0'))
                  .fontSize($r('app.float.common_font_size'))
                  .lineHeight($r('app.float.line_height_common'))
                  .fontWeight(FontWeight.Bold)
                Text(CommonConstants.TRIP_SCHEDULE_VIEW[1] + CommonConstants.TRIP_SCHEDULE_VIEW[2] + this.day)
                  .fontSize($r('app.float.trip_content_font'))
                  .lineHeight($r('app.float.line_height_common'))
                  .fontColor($r('sys.color.font_secondary'))
                  .fontWeight(FontWeight.Regular)
                  .margin({ left: $r('app.float.margin_common') })
              }
              .width($r('app.float.navigation_width'))
              .height($r('app.float.text_today_title'))
              .margin({
                top: $r('app.float.trip_margin_top'),
                bottom: $r('sys.float.padding_level8')
              })

              TripScheduleView()
                .layoutWeight(1)
            }
            .layoutWeight(1)
          }
        }
        .height(CommonConstants.FULL_PERCENT)
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
    }
    .padding({
      left: CommonConstants.COMMON_MARGIN,
      right: CommonConstants.COMMON_MARGIN,
      bottom: this.naviIndicatorHeight
    })
    .backgroundColor($r('sys.color.gray_01'))
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
  }
}