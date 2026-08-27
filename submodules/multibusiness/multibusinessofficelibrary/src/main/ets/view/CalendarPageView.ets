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

import { ItemRestriction, SegmentButton, SegmentButtonOptions, SegmentButtonTextItem } from '@kit.ArkUI';
import { CalendarSideBarView } from '../component/CalendarSideBarView';
import { CalendarView } from '../component/CalendarView';
import { TripScheduleView } from '../component/TripSchedule';
import { CommonConstants } from '../constants/CommonConstants';
import { CalendarItem } from '../model/CalendarItem';
import { BreakpointTypeEnum } from '../utils/BreakpointSystem';

@Builder
export function CalendarPageBuilder() {
  CalendarPageView()
}

@Component
export struct CalendarPageView {
  @StorageLink(CommonConstants.KEY_MAIN_BREAKPOINT) @Watch('handleBreakPointChange') breakPoint: string =
    BreakpointTypeEnum.SM;
  @StorageLink(CommonConstants.KEY_MAIN_WINDOW_WIDTH) windowSize: number = CommonConstants.COMMON_ZERO;
  @StorageLink('sideBarStatus') sideBarStatus: boolean = this.breakPoint === BreakpointTypeEnum.XL ? true : false;
  @StorageLink('monthStatus') monthStatus: boolean =
    this.breakPoint === BreakpointTypeEnum.LG || this.breakPoint === BreakpointTypeEnum.XL ? false : true;
  @StorageLink('navMode') navMode: NavigationMode = NavigationMode.Split;
  @StorageLink('selectedItem') selectedItem: CalendarItem = new CalendarItem('', '', false);
  @State singleSelectCapsuleOptions: SegmentButtonOptions = SegmentButtonOptions.tab({
    buttons: [{ text: $r('app.string.year') }, { text: $r('app.string.month') },
      { text: $r('app.string.week') }, { text: $r('app.string.day') }] as ItemRestriction<SegmentButtonTextItem>,
    backgroundBlurStyle: BlurStyle.BACKGROUND_THICK,
    backgroundColor: $r('sys.color.comp_background_tertiary'),
    selectedBackgroundColor: $r('sys.color.comp_background_primary')
  });
  @State singleSelectCapsuleSelectedIndexes: number[] = [1];
  @Provide(CommonConstants.KEY_CALENDAR_PATH_STACK) calendarPageInfos: NavPathStack = new NavPathStack();
  @Consume(CommonConstants.KEY_MAIN_PATH_STACK) mainPageInfos: NavPathStack;

  handleBreakPointChange() {
    this.navMode =
      this.breakPoint !== BreakpointTypeEnum.SM && this.selectedItem.isTrip ? NavigationMode.Split :
        NavigationMode.Stack;
  }

  @Builder
  pageMap(_: string, param: CalendarItem) {
    if (param.isTrip) {
      NavDestination() {
        Column() {
          Text($r('app.string.trip_schedule_view0'))
            .fontSize($r('app.float.font_size_title'))
            .fontWeight(FontWeight.Bold)
            .width(CommonConstants.FULL_PERCENT)
          Text(CommonConstants.TRIP_SCHEDULE_VIEW[1] + CommonConstants.TRIP_SCHEDULE_VIEW[2] + param.lunarDate)
            .fontSize($r('app.float.font_size_common'))
            .fontColor($r('sys.color.font_secondary'))
            .width(CommonConstants.FULL_PERCENT)
            .fontWeight(FontWeight.Regular)

          TripScheduleView()
        }
        .width(CommonConstants.FULL_PERCENT)
      }
      .width(CommonConstants.FULL_PERCENT)
      .padding({
        left: CommonConstants.COMMON_MARGIN,
        right: CommonConstants.COMMON_MARGIN
      })
      .backgroundColor($r('sys.color.gray_01'))
      .hideTitleBar(true)
    } else {
      NavDestination()
        .hideTitleBar(true)
    }
  }

  aboutToAppear(): void {
    this.navMode = NavigationMode.Stack;
    this.sideBarStatus =
      this.breakPoint === BreakpointTypeEnum.LG || this.breakPoint === BreakpointTypeEnum.XL ? true :
        this.sideBarStatus;
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.TopStart }) {
        SideBarContainer(this.breakPoint === BreakpointTypeEnum.LG ||
          this.breakPoint === BreakpointTypeEnum.XL ? SideBarContainerType.Embed :
          SideBarContainerType.Overlay) {
          CalendarSideBarView()

          Stack() {
            if (this.breakPoint !== BreakpointTypeEnum.LG &&
              this.breakPoint !== BreakpointTypeEnum.XL) {
              Column()
                .height(CommonConstants.FULL_PERCENT)
                .width(CommonConstants.FULL_PERCENT)
                .backgroundColor($r('sys.color.comp_background_secondary'))
                .zIndex(1)
                .visibility(this.sideBarStatus ? Visibility.Visible : Visibility.Hidden)
            }

            Column() {
              Row() {
                Blank()
                Text($r('app.string.trip_schedule_view3'))
                  .fontSize($r('app.float.symbol_font_size'))
                  .lineHeight($r('app.float.line_height_or_top'))
                  .fontWeight(FontWeight.Bold)
                  .margin({ left: $r('sys.float.padding_level24'), right: $r('sys.float.padding_level5') })

                if (this.breakPoint !== BreakpointTypeEnum.SM) {
                  Column() {
                    SegmentButton({
                      options: this.singleSelectCapsuleOptions,
                      selectedIndexes: $singleSelectCapsuleSelectedIndexes
                    })
                  }
                  .width($r('app.float.navigation_width'))
                  .height($r('app.float.image_size'))
                  .padding({ top: $r('app.float.notes_c_margin') })

                  Blank()

                  Column() {
                    SymbolGlyph($r('sys.symbol.thumbnails'))
                      .fontColor([$r('sys.color.font_primary')])
                      .fontSize($r('app.float.symbol_font_size'))
                      .margin($r('app.float.margin_common'))
                  }
                  .width($r('app.float.image_size'))
                  .height($r('app.float.image_size'))
                  .borderRadius($r('sys.float.corner_radius_level10'))
                  .backgroundColor(this.breakPoint === BreakpointTypeEnum.XL ? '' :
                    $r('sys.color.comp_background_tertiary'))
                  .margin({ right: $r('app.float.margin_common') })
                  .onClick(() => {
                    if (this.navMode === NavigationMode.Split) {
                      this.navMode = NavigationMode.Stack;
                    } else if (this.navMode === NavigationMode.Stack && this.selectedItem.isTrip) {
                      this.navMode = NavigationMode.Split;
                    }
                  })
                }

                Column() {
                  SymbolGlyph($r('sys.symbol.plus'))
                    .fontColor([$r('sys.color.font_primary')])
                    .fontSize($r('app.float.symbol_font_size'))
                    .margin($r('app.float.margin_common'))
                }
                .width($r('app.float.image_size'))
                .height($r('app.float.image_size'))
                .borderRadius($r('sys.float.corner_radius_level10'))
                .backgroundColor(this.breakPoint === BreakpointTypeEnum.XL ?
                  '' : $r('sys.color.comp_background_tertiary'))
                .margin({ right: $r('app.float.margin_common') })

                Column() {
                  SymbolGlyph($r('sys.symbol.dot_grid_2x2'))
                    .fontColor([$r('sys.color.font_primary')])
                    .fontSize($r('app.float.symbol_font_size'))
                    .margin($r('app.float.margin_common'))
                }
                .width($r('app.float.image_size'))
                .height($r('app.float.image_size'))
                .borderRadius($r('sys.float.corner_radius_level10'))
                .backgroundColor(this.breakPoint === BreakpointTypeEnum.XL ?
                  '' : $r('sys.color.comp_background_tertiary'))
              }
              .height($r('app.float.image_size'))
              .width(CommonConstants.FULL_PERCENT)
              .padding({
                left: this.breakPoint !== BreakpointTypeEnum.LG && this.breakPoint !== BreakpointTypeEnum.XL ?
                  $r('app.float.margin_row_top') :
                  (this.monthStatus ? $r('app.float.margin_row_top') : CommonConstants.COMMON_MARGIN),
                right: this.breakPoint === BreakpointTypeEnum.XL ?
                  $r('app.float.margin_right') : CommonConstants.COMMON_MARGIN
              })
              .margin({
                top: this.breakPoint === BreakpointTypeEnum.XL ?
                  CommonConstants.COMMON_MARGIN : $r('app.float.margin_common'),
                bottom: CommonConstants.COMMON_MARGIN
              })

              if (this.breakPoint === BreakpointTypeEnum.SM) {
                Row() {
                  Column() {
                    SegmentButton({
                      options: this.singleSelectCapsuleOptions,
                      selectedIndexes: $singleSelectCapsuleSelectedIndexes
                    })
                  }
                  .width(CommonConstants.FULL_PERCENT)
                  .height($r('app.float.segment_button_height'))
                  .padding({
                    left: CommonConstants.COMMON_MARGIN,
                    right: CommonConstants.COMMON_MARGIN
                  })
                }
                .width(CommonConstants.FULL_PERCENT)
                .height($r('app.float.segment_button_height'))
              }

              Navigation(this.calendarPageInfos) {
                CalendarView()
              }
              .navDestination(this.pageMap)
              .mode(this.breakPoint === BreakpointTypeEnum.SM ? NavigationMode.Stack : this.navMode)
              .backgroundColor($r('sys.color.gray_01'))
              .layoutWeight(1)
              .width(CommonConstants.FULL_PERCENT)
              .navBarWidthRange([$r('app.float.nav_bar_width_range'), $r('app.string.eighty_percent')])
              .navBarWidth(this.breakPoint === BreakpointTypeEnum.LG ||
                this.breakPoint === BreakpointTypeEnum.XL ?
                this.windowSize - CommonConstants.SIDEBAR_WIDTH - CommonConstants.NOTES_SIDEBAR_WIDTH :
                this.windowSize - CommonConstants.CALENDAR_CONTENT_WIDTH)
              .hideTitleBar(true)
              .onNavigationModeChange((mode: NavigationMode) => {
                if (this.breakPoint === BreakpointTypeEnum.SM || mode === NavigationMode.Stack) {
                  this.calendarPageInfos.clear();
                } else if (mode === NavigationMode.Split) {
                  this.calendarPageInfos.replacePath({ name: this.selectedItem.date, param: this.selectedItem }, false);
                }
              })
            }
            .height(CommonConstants.FULL_PERCENT)
            .backgroundColor($r('sys.color.gray_01'))
            .padding({
              top: this.breakPoint === BreakpointTypeEnum.XL ?
                CommonConstants.COMMON_ZERO : $r('app.float.navigation_margin_top')
            })
          }
          .height(CommonConstants.FULL_PERCENT)
          .backgroundColor($r('sys.color.gray_01'))
        }
        .height(CommonConstants.FULL_PERCENT)
        .width(CommonConstants.FULL_PERCENT)
        .autoHide(false)
        .controlButton(this.breakPoint === BreakpointTypeEnum.MD ? {
          top: CommonConstants.CONTROL_BUTTON_TOP + CommonConstants.PADDING_8,
          left: CommonConstants.PADDING_54 + CommonConstants.COMMON_MARGIN,
          width: CommonConstants.PADDING_24,
          height: CommonConstants.PADDING_24
        } : {
          icons: {
            hidden: this.breakPoint === BreakpointTypeEnum.XL ?
              $r('app.media.close_sidebar') :
              $r('app.media.close_sidebar_bg'),
            shown: this.breakPoint === BreakpointTypeEnum.XL ?
              $r('app.media.open_sidebar') :
              $r('app.media.open_sidebar_bg'),
            switching: this.sideBarStatus ?
              (this.breakPoint === BreakpointTypeEnum.XL ?
                $r('app.media.open_sidebar') :
                $r('app.media.open_sidebar_bg')) :
              (this.breakPoint === BreakpointTypeEnum.XL ?
                $r('app.media.close_sidebar') : $r('app.media.close_sidebar_bg'))
          },
          top: this.breakPoint === BreakpointTypeEnum.XL ?
            CommonConstants.COMMON_MARGIN : CommonConstants.CONTROL_BUTTON_TOP,
          left: ((this.breakPoint === BreakpointTypeEnum.XL) && this.sideBarStatus) ?
            CommonConstants.PADDING_54 + CommonConstants.CONTROL_BUTTON_LEFT :
            CommonConstants.PADDING_54 + CommonConstants.COMMON_MARGIN,
          width: CommonConstants.CONTROL_BUTTON,
          height: CommonConstants.CONTROL_BUTTON
        })
        .showSideBar(this.breakPoint === BreakpointTypeEnum.LG ||
          this.breakPoint === BreakpointTypeEnum.XL ? true : false)
        .sideBarWidth(CommonConstants.SIDEBAR_WIDTH)
        .maxSideBarWidth(CommonConstants.SIDEBAR_WIDTH)
        .onChange((value: boolean) => {
          this.sideBarStatus = value;
          this.monthStatus = !value;
        })
        .backgroundColor($r('app.color.sidebar_color'))

        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.chevron_backward'))
            .fontColor([$r('sys.color.icon_primary')])
            .fontSize($r('sys.float.Title_M'))
        }
        .margin({
          left: ((this.breakPoint === BreakpointTypeEnum.XL) && this.sideBarStatus) ?
            CommonConstants.CONTROL_BUTTON_LEFT : CommonConstants.COMMON_MARGIN,
          top: (this.breakPoint === BreakpointTypeEnum.XL) ?
            CommonConstants.COMMON_MARGIN : CommonConstants.CONTROL_BUTTON_TOP
        })
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .height($r('app.float.image_size'))
        .aspectRatio(1)
        .onClick(() => {
          this.backEvent();
        })
      }
    }
    .hideTitleBar(true)
    .onBackPressed(() => {
      this.backEvent();
      return true;
    })
  }

  private backEvent(): void {
    this.sideBarStatus = false;
    this.mainPageInfos.pop();
  }
}