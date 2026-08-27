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

import { WindowInfo } from '../../utils/WindowUtil';
import { DateFormatter } from '../../utils/DateFormatter';
import { OverviewStat, DetailStat, DEFAULT_OVERVIEW_STATS, OVERVIEW_STATS_BY_MONTH,
  DETAIL_STATS } from '../../model/exercise/ExerciseModel';
import { COMMON_DIMENSIONS, Constants, FONT_STYLES, SPACING } from '../../common/CommonConstants';
import { DetailStatItem } from './DetailStatItem';
import { SelectorItem } from './SelectorItem';
import { StatsGrid } from './StatsGrid';
import { HeaderSection } from '../common/HeaderSection';
import RouterUtil from '../../utils/RouterUtil';

@Builder
export function ExercisePageViewBuilder() {
  ExercisePageView();
}

@Component
struct ExercisePageView {
  @StorageLink(Constants.KEY_CONTEXT) context?: Context = undefined;
  @StorageProp(Constants.KEY_WINDOW_INFO) windowInfo?: WindowInfo = undefined;
  @State overviewStats: OverviewStat[] = DEFAULT_OVERVIEW_STATS;

  aboutToAppear(): void {
    this.updateOverviewStatsFontSize();
  }

  private updateOverviewStatsFontSize(): void {
    const isWide = this.windowInfo && this.windowInfo.widthBp > WidthBreakpoint.WIDTH_SM;
    const firstItemFontSize = isWide ? 40 : 24;
    this.overviewStats = [
      { value: '832.58', unit: $r('app.string.exercise_unit_hour'), valueFontSize: firstItemFontSize },
      { value: '428', unit: $r('app.string.exercise_unit_count'), valueFontSize: FONT_STYLES.valueLarge.fontSize },
      { value: '8500', unit: $r('app.string.exercise_unit_calories'), valueFontSize: FONT_STYLES.valueLarge.fontSize }
    ];
  }

  private getPadding(): Padding {
    let width = 16;
    if (this.windowInfo) {
      if (this.windowInfo.widthBp >= WidthBreakpoint.WIDTH_LG) {
        width = 32;
      } else if (this.windowInfo.widthBp >= WidthBreakpoint.WIDTH_MD) {
        width = 24;
      }
    }

    return { left: width, right: width };
  }

  build() {
    NavDestination() {
      Column() {
        HeaderSection($r('app.string.exercise_title'));
        this.ExerciseSelectedView();
        Scroll() {
          Column() {
            StatsGrid({ stats: this.overviewStats, windowInfo: this.windowInfo, showTitle: true, title: $r('app.string.exercise_overview_title') });
            this.ExerciseRecordByMonth();
            StatsGrid({ stats: OVERVIEW_STATS_BY_MONTH, windowInfo: this.windowInfo, showTitle: false });
            this.ExerciseDetail();
          }
          .padding({ bottom: SPACING.large });
        }
        .align(Alignment.TopStart)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .layoutWeight(1);
      }
      .padding(this.getPadding())
      .width('100%')
      .height('100%');
    }
    .backgroundColor($r('sys.color.comp_background_gray'))
    .hideTitleBar(true)
    .onBackPressed(() => {
      RouterUtil.getInstance().closeApp();
      return false;
    });
  }

  @Builder
  ExerciseSelectedView() {
    Row() {
      Row() {
        SelectorItem($r('app.string.exercise_selector_all_sports'));
      }
      .layoutWeight(1);
      Row() {
        SelectorItem($r('app.string.exercise_selector_all_time'));
      }
      .margin({ left: SPACING.medium })
      .layoutWeight(1);
    }
    .margin({ top: SPACING.small, bottom: SPACING.medium });
  }

  @Builder
  ExerciseRecordByMonth() {
    Row() {
      Column() {
        Text(DateFormatter.formatYearMonth(new Date(2026, 6)))
          .fontWeight(FontWeight.Bold)
          .fontSize(FONT_STYLES.titleLarge.fontSize)
          .lineHeight(FONT_STYLES.titleLarge.lineHeight)
          .fontColor($r('sys.color.font_primary'));
        Text($r('app.string.exercise_month_summary_format'))
          .fontSize(FONT_STYLES.bodyMedium.fontSize)
          .lineHeight(FONT_STYLES.bodyMedium.lineHeight)
          .fontColor($r('sys.color.font_secondary'));
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1);
      SymbolGlyph($r('sys.symbol.chevron_up'))
        .fontSize(14)
        .fontColor([$r('sys.color.font_primary')])
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .borderRadius(30)
        .padding(5);
    }
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .padding({ left: SPACING.large, right: SPACING.large, top: 18, bottom: SPACING.small });
  }

  @Builder
  ExerciseDetail() {
    Column() {
      ForEach(DETAIL_STATS, (item: DetailStat, index: number) => {
        if (index !== 0) {
          Line()
            .backgroundColor($r('sys.color.comp_divider'))
            .height(COMMON_DIMENSIONS.dividerWidth)
            .width('100%');
        }
        Row() {
          DetailStatItem({ item: item });
        }
        .margin({ top: SPACING.large, bottom: SPACING.large });
      }, (index: number) => index.toString());
    }
    .margin({ top: COMMON_DIMENSIONS.padding })
    .borderRadius(COMMON_DIMENSIONS.borderRadius)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .padding({ left: SPACING.large, right: SPACING.large });
  }
}