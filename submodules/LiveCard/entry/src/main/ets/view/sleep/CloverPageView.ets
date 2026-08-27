/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { ColorConstants } from '../../common/ColorConstants';
import { SPACING, CommonPadding, Constants } from '../../common/CommonConstants';
import {
  CUSTOM_HEALTH_TASK_LIST,
  HealthTask, HEALTH_TASK_LIST, WeekDayItem, WEEK_DAYS } from '../../model/sleep/SleepConstants';
import { WindowInfo } from '../../utils/WindowUtil';
import { HeaderSection } from '../common/HeaderSection';
import { TaskCardBuilder } from './CloverTaskCard';
import { DateFormatter } from '../../utils/DateFormatter';
import { JSON } from '@kit.ArkTS';
import { Logger } from '../../utils/Logger';
import RouterUtil from '../../utils/RouterUtil';

const TAG = 'CloverPageView';

@Builder
export function CloverPageViewBuilder() {
  CloverPageView();
}

@Component
struct CloverPageView {
  @State selectedDayIndex: number = 2;
  @StorageProp(Constants.KEY_WINDOW_INFO) windowInfo?: WindowInfo = undefined;
  private taskList: HealthTask[] = HEALTH_TASK_LIST;
  private selfSelectedTasks: HealthTask[] = CUSTOM_HEALTH_TASK_LIST;

  aboutToAppear(): void {
    Logger.info(TAG, `CloverPageView aboutToAppear success`);
  }

  private getColumnsCount(): number {
    if (this.windowInfo) {
      switch (this.windowInfo.widthBp) {
        case WidthBreakpoint.WIDTH_XS:
        case WidthBreakpoint.WIDTH_SM:
          return 1;
        case WidthBreakpoint.WIDTH_MD:
        case WidthBreakpoint.WIDTH_LG:
          return 2;
        case WidthBreakpoint.WIDTH_XL:
          return 3;
      }
    }
    return 1;
  }

  private getPadding(): Padding {
    let width = CommonPadding.SMALL;
    if (this.windowInfo) {
      if (this.windowInfo.widthBp >= WidthBreakpoint.WIDTH_LG) {
        width = CommonPadding.LARGE;
      } else if (this.windowInfo.widthBp >= WidthBreakpoint.WIDTH_MD) {
        width = CommonPadding.MEDIUM;
      }
    }

    return { left: width, right: width };
  }

  build() {
    NavDestination() {
      Column() {
        HeaderSection($r('app.string.clover_title'));
        Scroll() {
          Column() {
            this.DateView();
            this.Clover();
            this.TaskList();
            this.SelfSelectedTaskList();
          }
          .padding({ bottom: SPACING.large });
        }
        .align(Alignment.TopStart)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .layoutWeight(1);
      }
      .width('100%')
      .height('100%');
    }
    .padding(this.getPadding())
    .backgroundColor($r('sys.color.comp_background_gray'))
    .hideTitleBar(true)
    .onBackPressed(() => {
      RouterUtil.getInstance().closeApp();
      return false;
    });
  }

  @Builder
  DateView() {
    Column() {
      Row() {
        Text(DateFormatter.formatMonthDayWeek(new Date(2026, 3, 1)))
          .fontColor($r('sys.color.font_secondary'))
          .fontSize(14)
          .lineHeight(19);
      };
      Row() {
        ForEach(WEEK_DAYS, (item: WeekDayItem, index: number) => {
          this.WeekDayColumn(item, index);
        }, (index: number) => index.toString());
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween);
    }
    .alignItems(HorizontalAlign.Start)
    .margin({ top: 12 });
  }

  @Builder
  WeekDayColumn(item: WeekDayItem, index: number) {
    Column() {
      Text(item.dayLabel)
        .fontSize(12)
        .fontColor(this.selectedDayIndex === index ? $r('sys.color.font_on_primary') : $r('sys.color.font_primary'))
        .padding({ top: 4, bottom: 4, left: 6, right: 6 })
        .lineHeight(16)
        .backgroundColor(this.selectedDayIndex === index ? $r('sys.color.comp_focused_primary') : Color.Transparent)
        .borderRadius($r('app.float.border_radius'));

      Image(item.icon)
        .objectFit(ImageFit.Contain)
        .width(24)
        .height(24)
        .margin({ top: 8 });

      if (item.completed) {
        Image($r('app.media.check_mark'))
          .width(10)
          .height(8);
      } else {
        Text('')
          .height(8);
      }
    }
    .padding({ top: 8, bottom: 4, left: 8, right: 8 })
    .backgroundColor(this.selectedDayIndex === index ? $r('sys.color.comp_background_tertiary') : Color.Transparent)
    .borderRadius($r('app.float.border_radius'));
  }

  getCloverSize(): number {
    if (this.windowInfo) {
      switch (this.windowInfo.widthBp) {
        case WidthBreakpoint.WIDTH_XS:
        case WidthBreakpoint.WIDTH_SM:
          let width = this.getUIContext().px2vp(this.windowInfo.windowSize.width);
          if (width > 360) {
            return 196;
          }
          return 156;
        case WidthBreakpoint.WIDTH_MD:
        case WidthBreakpoint.WIDTH_LG:
        case WidthBreakpoint.WIDTH_XL:
          return 176;
      }
    }
    return 156;
  }

  @Builder
  Clover() {
    Column() {
      Stack() {
        Image($r('app.media.clover_with_icon'))
          .width(this.getCloverSize())
          .height(this.getCloverSize());
      }
      .width(this.getCloverSize())
      .height(this.getCloverSize());
      GridRow({
        columns: { xs: 4, md: 8, lg: 12 }
      }) {
        GridCol({
          span: { xs: 4, lg: 6 },
          offset: { xs: 0, md: 2, lg: 3 }
        }) {
          Row() {
            Row() {
              Circle()
                .width(12)
                .height(12)
                .fill(ColorConstants.CLOVER_PURPLE);
              Text($r('app.string.task_wakeup_time'))
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ left: 3 })
                .fontSize(14)
                .fontColor($r('sys.color.font_secondary'));
            };

            Row() {
              Circle()
                .width(12)
                .height(12)
                .fill(ColorConstants.CLOVER_ORANGE);
              Text($r('app.string.task_exercise_time'))
                .margin({ left: 3 })
                .fontSize(14)
                .fontColor($r('sys.color.font_secondary'));
            };

            Row() {
              Circle()
                .width(12)
                .height(12)
                .fill(ColorConstants.CLOVER_BLUE);
              Text($r('app.string.task_stress'))
                .margin({ left: 3 })
                .fontSize(14)
                .fontColor($r('sys.color.font_secondary'));
            };
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceAround)
          .margin({ top: 20 });
        };
      }
      .alignItems(ItemAlign.Center);
    }
    .margin({
      top: 8
    });
  }

  @Builder
  TaskList() {
    Grid() {
      ForEach(this.taskList, (task: HealthTask) => {
        GridItem() {
          TaskCardBuilder(task);
        };
      }, (task: HealthTask) => { return JSON.stringify(task); });
    }
    .width('100%')
    .columnsTemplate('1fr '.repeat(this.getColumnsCount()))
    .rowsGap(12)
    .columnsGap(12)
    .margin({ top: 24 });
  }

  @Builder
  SelfSelectedTaskList() {
    Column() {
      Row() {
        Text($r('app.string.clover_self_task_title'))
          .fontSize(18)
          .lineHeight(24)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.font_primary'));
      }
      .padding({ top: 24, bottom: 8 });
      Grid() {
        ForEach(this.selfSelectedTasks, (task: HealthTask) => {
          GridItem() {
            TaskCardBuilder(task);
          };
        }, (task: HealthTask) => { return JSON.stringify(task); });
      }
      .width('100%')
      .columnsTemplate('1fr '.repeat(this.getColumnsCount()))
      .rowsGap(12)
      .columnsGap(12);
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%');
  }
}