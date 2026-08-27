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

import { BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/constants/CommonConstants';
import { DataManager } from '../viewmodel/DataManager';
import { DateModel } from '../viewmodel/DateModel';
import { getMonthDate } from '../viewmodel/GetDate';
import Logger from '../utils/Logger';
import { MonthDataSource, Month } from '../viewmodel/MonthDataSource';

const TAG = 'CustomCalendarPickerDialog';

@CustomDialog
export struct CustomCalendarPickerDialog {
  @StorageLink(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @State contentData: MonthDataSource = new MonthDataSource();
  @State nextMonth: number = 1;
  @State nextYear: number = 1;
  @State currentMonthDay: number[] = [];
  @State initialIndex: number = 0;
  @Link currentMonth: number;
  @Link currentDay: number;
  @Link currentYear: number;
  @StorageLink(CommonConstants.AS_KEY_SELECTED_DATE) dateModel: DateModel = new DateModel(0, 0, 0, 0);
  controller: CustomDialogController;
  cancel: () => void = () => {
  };
  private week: ResourceStr[] =
    [$r('app.string.sun'), $r('app.string.mon'), $r('app.string.tue'), $r('app.string.wed'), $r('app.string.thu'),
      $r('app.string.fri'), $r('app.string.sat')];

  getResourceString(resource: Resource): string {
    let resourceString: string = '';
    try {
      let hostContext = this.getUIContext().getHostContext();
      if (hostContext) {
        resourceString = hostContext.resourceManager.getStringSync(resource.id);
      }
    } catch (err) {
      Logger.error(TAG, 'getStringSync get exception');
    }
    return resourceString;
  }

  aboutToAppear() {
    this.currentMonthDay = getMonthDate(this.currentMonth, this.currentYear);
    if (this.currentMonth === CommonConstants.MONTHS) {
      this.nextMonth = CommonConstants.JANUARY;
      this.nextYear = this.currentYear + 1;
    } else {
      this.nextMonth = this.currentMonth + 1;
      this.nextYear = this.currentYear;
    }
    let months: Month[] = [
      {
        month: `${this.currentYear}${this.getResourceString($r('app.string.year'))} ${this.currentMonth}${this.getResourceString($r('app.string.month'))}`,
        num: this.currentMonth,
        days: this.currentMonthDay
      }
    ]
    this.contentData.pushData(months);
    this.initialIndex = this.dateModel.month > this.currentMonth ? 1 : 0;
  }

  @Builder
  itemHead(text: string) {
    Row() {
      SymbolGlyph($r('sys.symbol.chevron_left'))
        .fontColor([$r('sys.color.font_primary')])
        .fontSize($r('sys.float.Title_M'))
      Text(text)
        .fontSize($r('sys.float.Subtitle_L'))
        .fontColor($r('sys.color.font_primary'))
        .fontWeight(FontWeight.Bold)
        .height($r('app.float.text_height'))
        .textAlign(TextAlign.Center)
      SymbolGlyph($r('sys.symbol.chevron_right'))
        .fontColor([$r('sys.color.font_primary')])
        .fontSize($r('sys.float.Title_M'))
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width(CommonConstants.FULL_PERCENT)
    .margin({
      bottom: $r('sys.float.padding_level16')
    })
    .padding({
      left: $r('sys.float.padding_level12'),
      right: $r('sys.float.padding_level12')
    })
  }

  @Builder
  itemWeek() {
    List() {
      ForEach(this.week, (weekInformation: string) => {
        ListItem() {
          Text(weekInformation)
            .textAlign(TextAlign.Center)
            .width(CommonConstants.FULL_PERCENT)
            .fontSize($r('sys.float.Subtitle_M'))
            .fontColor(weekInformation === CommonConstants.SUNDAY || weekInformation ===
            CommonConstants.SATURDAY ? $r('sys.color.font_emphasize') : $r('sys.color.font_primary'))
        }
        .width($r('app.string.week_width'))
      }, (weekInformation: string, index: number) => (weekInformation + index).toString())
    }
    .width(CommonConstants.FULL_PERCENT)
    .height($r('sys.float.Subtitle_M'))
    .listDirection(Axis.Horizontal)
    .scrollBar(BarState.Off)
  }

  @Builder
  itemCard(monthItem: Month) {
    Column() {
      this.itemHead(monthItem.month)
      this.itemWeek()
    }
  }

  @Builder
  gridCard(monthItem: Month) {
    Grid() {
      ForEach(monthItem.days, (day: number) => {
        GridItem() {
          if (day === this.dateModel.day && monthItem.num === this.dateModel.month) {
            Text(day.toString())
              .fontSize($r('sys.float.Subtitle_M'))
              .fontColor($r('sys.color.background_primary'))
          } else {
            Text(day.toString())
              .fontSize($r('sys.float.Subtitle_M'))
              .fontColor(day < this.currentDay && monthItem.num ===
              this.currentMonth ? $r('sys.color.font_tertiary') : $r('sys.color.font_primary'))
          }
        }
        .height($r('app.float.calendar_height'))
        .width($r('app.float.calendar_height'))
        .borderRadius($r('sys.float.corner_radius_level2'))
        .backgroundColor(day === this.dateModel.day && monthItem.num ===
        this.dateModel.month ? $r('sys.color.font_emphasize') : $r('app.color.month_day_background'))
        .opacity(day === CommonConstants.ZERO ? CommonConstants.ZERO : CommonConstants.JANUARY)
        .onClick(() => {
          if (day >= this.currentDay || monthItem.num > this.currentMonth) {
            let weekIndex = monthItem.days.indexOf(day) % CommonConstants.WEEK_NUMBER;
            this.dateModel.day = day;
            this.dateModel.week = weekIndex;
            this.dateModel.month = monthItem.num;
            let hostContext = this.getUIContext().getHostContext();
            if (hostContext) {
              DataManager.setDate(hostContext, this.dateModel, () => {
              });
            }
            this.controller.close();
          }
        })
      }, (day: number, index: number) => (day + index).toString())
    }
    .columnsTemplate(CommonConstants.GRID_SEVEN)
    .rowsTemplate(monthItem.days.length > CommonConstants.MONTH_NUMBER ?
      CommonConstants.GRID_SIX : CommonConstants.GRID_FIVE)
    .height(monthItem.days.length > CommonConstants.MONTH_NUMBER ? CommonConstants.GRID_HEIGHT_L :
      CommonConstants.GRID_HEIGHT_M)
  }

  build() {
    Column({ space: CommonConstants.ELEMENTS_MARGIN }) {
      Row() {
        Text($r('app.string.departure_date'))
          .fontSize($r('sys.float.Subtitle_L'))
          .fontColor($r('sys.color.font_primary'))
          .fontWeight(FontWeight.Bold)

        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.xmark'))
            .fontColor([$r('sys.color.icon_primary')])
            .fontSize($r('sys.float.Subtitle_L'))
            .onClick(() => {
              this.controller.close();
            })
        }
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .height($r('app.integer.icon_size'))
        .aspectRatio(1)
      }
      .height($r('app.integer.icon_size'))
      .width(CommonConstants.FULL_PERCENT)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: $r('sys.float.padding_level12'),
        right: $r('sys.float.padding_level12')
      })

      List({ initialIndex: this.initialIndex }) {
        LazyForEach(this.contentData, (monthItem: Month) => {
          ListItemGroup() {
            ListItem() {
              this.itemCard(monthItem)
            }
            .width(CommonConstants.FULL_PERCENT)

            ListItem() {
              this.gridCard(monthItem)
            }
          }
        }, (monthItem: Month) => monthItem.month.toString())
      }
      .width(CommonConstants.FULL_PERCENT)
      .edgeEffect(EdgeEffect.None)
      .scrollBar(BarState.Off)
      .sticky(StickyStyle.Header)
      .padding({
        right: $r('sys.float.padding_level4'),
        left: $r('sys.float.padding_level4')
      })
    }
    .padding({ top: $r('sys.float.padding_level12') })
    .width(this.curBp === 'sm' ? '90%' : $r('app.integer.bind_sheet_width'))
    .borderRadius($r('sys.float.corner_radius_level12'))
    .backgroundColor($r('app.color.month_day_background'))
    .alignItems(HorizontalAlign.Center)
  }
}