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

import { DetailStat } from '../../model/exercise/ExerciseModel';
import { COMMON_DIMENSIONS, FONT_STYLES, SPACING } from '../../common/CommonConstants';
import { Logger } from '../../utils/Logger';

@Component
export struct DetailStatItem {
  @Prop item: DetailStat;

  aboutToAppear(): void {
    Logger.info(`DetailStatItem aboutToAppear success`);
  }

  build() {
    Row() {
      this.IconSection();
      Column() {
        this.TitleRow();
        this.ValueRow();
      }
      .margin({ left: SPACING.large })
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1);
    };
  }

  @Builder
  IconSection() {
    SymbolGlyph(this.item.icon)
      .fontSize(FONT_STYLES.valueLarge.fontSize)
      .fontColor([Color.White])
      .borderRadius(COMMON_DIMENSIONS.borderRadius)
      .backgroundColor(this.item.iconBg)
      .padding(SPACING.iconPadding);
  }

  @Builder
  TitleRow() {
    Row() {
      Text(this.item.title)
        .fontColor($r('sys.color.font_secondary'))
        .fontSize(FONT_STYLES.bodySmall.fontSize)
        .lineHeight(FONT_STYLES.bodySmall.lineHeight);
      Text(this.item.date)
        .fontColor($r('sys.color.font_secondary'))
        .fontSize(FONT_STYLES.bodySmall.fontSize)
        .lineHeight(FONT_STYLES.bodySmall.lineHeight);
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween);
  }

  @Builder
  ValueRow() {
    Row() {
      Text(this.item.value)
        .fontColor($r('sys.color.font_primary'))
        .fontWeight(FontWeight.Bold)
        .fontSize(FONT_STYLES.valueLarge.fontSize)
        .lineHeight(FONT_STYLES.valueLarge.lineHeight);
      Text(this.item.unit)
        .fontColor($r('sys.color.font_secondary'))
        .fontSize(FONT_STYLES.bodySmall.fontSize)
        .lineHeight(FONT_STYLES.bodySmall.lineHeight);
      Text(this.item.time)
        .fontColor($r('sys.color.font_primary'))
        .fontSize(FONT_STYLES.bodyMedium.fontSize)
        .lineHeight(FONT_STYLES.bodyMedium.lineHeight)
        .margin({ left: SPACING.medium });
      if (this.item.speed) {
        Text() {
          Span(this.item.speed)
            .fontColor($r('sys.color.font_primary'))
            .fontSize(FONT_STYLES.bodyMedium.fontSize)
            .lineHeight(FONT_STYLES.bodyMedium.lineHeight);
          Span(this.item.perUnit)
            .fontColor($r('sys.color.font_secondary'))
            .fontSize(FONT_STYLES.bodySmall.fontSize)
            .lineHeight(FONT_STYLES.bodySmall.lineHeight);
        }
        .margin({ left: SPACING.medium });
      }
      if (this.item.cost) {
        Text() {
          Span($r('app.string.exercise_unit_total_calories'))
            .fontColor($r('sys.color.font_secondary'))
            .fontSize(FONT_STYLES.bodySmall.fontSize)
            .lineHeight(FONT_STYLES.bodySmall.lineHeight);
          Span(this.item.cost)
            .fontColor($r('sys.color.font_primary'))
            .fontSize(FONT_STYLES.bodyMedium.fontSize)
            .lineHeight(FONT_STYLES.bodyMedium.lineHeight);
          Span($r('app.string.exercise_unit_kcal'))
            .fontColor($r('sys.color.font_secondary'))
            .fontSize(FONT_STYLES.bodySmall.fontSize)
            .lineHeight(FONT_STYLES.bodySmall.lineHeight);
        }
        .margin({ left: SPACING.medium });
      }
    }
    .width('100%')
    .alignItems(VerticalAlign.Bottom)
    .justifyContent(FlexAlign.Start);
  }
}