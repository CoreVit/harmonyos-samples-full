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

import { OverviewStat } from '../../model/exercise/ExerciseModel';
import { WindowInfo } from '../../utils/WindowUtil';
import { COMMON_DIMENSIONS, FONT_STYLES, SPACING } from '../../common/CommonConstants';
import { OverviewStatItem } from './OverviewStatItem';

@Component
export struct StatsGrid {
  @ObjectLink stats: OverviewStat[];
  @ObjectLink windowInfo: WindowInfo;
  @Prop showTitle: boolean = false;
  @Prop title: string | Resource = '';

  private getColumnsCount(): number {
    const isWide = this.windowInfo && this.windowInfo.widthBp > WidthBreakpoint.WIDTH_SM;
    return isWide ? 4 : 3;
  }

  build() {
    Column() {
      if (this.showTitle) {
        Text(this.title)
          .fontWeight(FontWeight.Bold)
          .fontSize(FONT_STYLES.titleLarge.fontSize)
          .lineHeight(FONT_STYLES.titleLarge.lineHeight)
          .fontColor($r('sys.color.font_primary'))
          .margin({ top: SPACING.large + SPACING.medium, bottom: SPACING.small });
      }

      Grid() {
        ForEach(this.stats, (stat: OverviewStat, index: number) => {
          GridItem() {
            OverviewStatItem(
              stat.value,
              stat.unit,
              index % this.getColumnsCount() !== 0,
              stat.valueFontSize ?? FONT_STYLES.valueLarge.fontSize
            );
          }
          .alignSelf(ItemAlign.End);
        }, (index: number) => index.toString());
      }
      .align(Alignment.BottomStart)
      .columnsGap(SPACING.large)
      .columnsTemplate('1fr '.repeat(this.getColumnsCount()))
      .rowsGap(SPACING.medium)
      .width('100%')
      .margin({ bottom: this.showTitle ? 20 : 0 });
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .borderRadius(COMMON_DIMENSIONS.borderRadius)
    .padding({
      left: COMMON_DIMENSIONS.padding,
      right: COMMON_DIMENSIONS.padding,
      top: this.showTitle ? 0 : 18,
      bottom: this.showTitle ? 0 : 18
    });
  }
}