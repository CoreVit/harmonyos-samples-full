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
import { CustomCalendarPickerDialog } from '../view/CustomCalendarPickerDialog';
import { DateModel } from '../viewmodel/DateModel';
import { getRealTimeDate } from '../viewmodel/GetDate';
import Logger from '../utils/Logger';

const TAG = 'CalendarView';

@Builder
export function CalendarViewBuilder() {
  CalendarView();
}

@Component
export struct CalendarView {
  @StorageLink(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @State currentMonth: number = 1;
  @State currentDay: number = 1;
  @State currentYear: number = 1;
  @StorageLink(CommonConstants.AS_KEY_SELECTED_DATE) dateModel: DateModel = new DateModel(0, 0, 0, 0);
  pageInfos: NavPathStack = new NavPathStack();
  private week: ResourceStr[] =
    [$r('app.string.sunday'), $r('app.string.monday'), $r('app.string.tuesday'), $r('app.string.wednesday'),
      $r('app.string.thursday'), $r('app.string.friday'), $r('app.string.saturday')];
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomCalendarPickerDialog({
      currentMonth: this.currentMonth,
      currentDay: this.currentDay,
      currentYear: this.currentYear,
      cancel: this.onCancel
    }),
    isModal: true,
    customStyle: true,
    maskColor: $r('sys.color.mask_fourth')
  });

  aboutToAppear(): void {
    this.dateModel = getRealTimeDate();
    this.currentMonth = this.dateModel.month;
    this.currentDay = this.dateModel.day;
    this.currentYear = this.dateModel.year;
  }

  onCancel(): void {
    this.dialogController?.close();
  }

  getResourceString(resource: Resource): string {
    let resourceString: string = '';
    try {
      let hostContext = this.getUIContext().getHostContext();
      if (hostContext) {
        resourceString = hostContext.resourceManager.getStringSync(resource.id);
      }
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getResourceString catch error, errCode: ${err.code}, errMessage: ${err.message}.`);
    }
    return resourceString;
  }

  @Builder
  calendarMainView() {
    Column({ space: CommonConstants.ELEMENTS_MARGIN_L }) {
      Row() {
        Text($r('app.string.departure'))
          .fontSize($r('sys.float.Subtitle_M'))
          .fontColor($r('sys.color.font_primary'))
        SymbolGlyph($r('sys.symbol.monorail_fill'))
          .fontColor([$r('sys.color.icon_primary')])
          .fontSize($r('sys.float.Title_S'))
        Text($r('app.string.destination'))
          .fontSize($r('sys.float.Subtitle_M'))
          .fontColor($r('sys.color.font_primary'))
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width(CommonConstants.FULL_PERCENT)
      .padding({
        right: $r('sys.float.padding_level6'),
        left: $r('sys.float.padding_level6')
      })

      Row({ space: CommonConstants.ELEMENTS_MARGIN_M }) {
        Text(`${this.dateModel.month}${this.getResourceString($r('app.string.month'))}${this.dateModel.day}${this.getResourceString($r('app.string.day'))}`)
          .fontSize($r('sys.float.Subtitle_M'))
          .fontColor($r('sys.color.font_primary'))
        Text(this.dateModel.week >= 0 && this.dateModel.week < this.week.length ? this.week[this.dateModel.week] : '')
          .fontSize($r('sys.float.Subtitle_M'))
          .fontColor($r('sys.color.font_primary'))
      }
      .justifyContent(FlexAlign.Center)
      .width(CommonConstants.FULL_PERCENT)
      .onClick(() => {
        this.dialogController?.open();
      })

      Button($r('app.string.ticket_inquiry'))
        .width(this.curBp === 'md' ? CommonConstants.WIDTH_MD_LG : CommonConstants.FULL_PERCENT)
        .height($r('app.integer.button_height_small'))
        .fontSize($r('sys.float.Subtitle_M'))
        .backgroundColor($r('sys.color.brand'))
        .onClick(() => {
          this.pageInfos.replacePath({ name: 'QueryTicketList' });
        })
    }
    .width(CommonConstants.FULL_PERCENT)
    .backgroundColor($r('sys.color.comp_background_primary'))
    .borderRadius($r('sys.float.corner_radius_level6'))
    .padding($r('sys.float.padding_level12'))
  }

  build() {
    NavDestination() {
      Navigation(this.pageInfos) {
        Column() {
          this.calendarMainView()
        }
        .width(CommonConstants.FULL_PERCENT)
        .padding($r('sys.float.padding_level8'))
      }
      .mode(this.curBp === 'lg' ? NavigationMode.Split : NavigationMode.Stack)
      .title($r('app.string.calendar_dialog'))
      .titleMode(NavigationTitleMode.Mini)
      .navBarWidth($r('app.integer.nav_bar_width'))
      .padding({
        top: this.statusBarHeight,
        bottom: this.navigatorBarHeight
      })
    }
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}