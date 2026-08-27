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

import { HealthTask } from '../../model/sleep/SleepConstants';
import { ColorConstants } from '../../common/ColorConstants';
import { BorderRadius, IconSize, CardPadding, SPACING,
  FONT_STYLES, COMMON_DIMENSIONS } from '../../common/CommonConstants';

@Builder
export function TaskCardBuilder(item: HealthTask) {
  Row() {
    Row() {
      Image(item.icon)
        .width(IconSize.LARGE)
        .height(IconSize.LARGE);
      Column() {
        Text() {
          Span(item.current)
            .fontSize(FONT_STYLES.titleMedium.fontSize)
            .lineHeight(FONT_STYLES.titleMedium.lineHeight + 2)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('sys.color.font_primary'));
          Span('/')
            .fontSize(FONT_STYLES.bodySmall.fontSize)
            .lineHeight(FONT_STYLES.bodySmall.lineHeight)
            .fontWeight(FontWeight.Normal)
            .fontColor($r('sys.color.font_tertiary'));
          Span(item.target)
            .fontSize(FONT_STYLES.bodySmall.fontSize)
            .lineHeight(FONT_STYLES.bodySmall.lineHeight)
            .fontWeight(FontWeight.Normal)
            .fontColor($r('sys.color.font_tertiary'));
        };
        Text(item.name)
          .margin({ top: 2 })
          .fontSize(FONT_STYLES.bodySmall.fontSize)
          .lineHeight(FONT_STYLES.bodySmall.lineHeight)
          .fontWeight(FontWeight.Normal)
          .fontColor($r('sys.color.font_primary'));
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: CardPadding.SECTION });
    };
    Button() {
      Text(item.state)
        .fontColor(item.isCompleted ? ColorConstants.TASK_COMPLETED_ICON : $r('sys.color.font_secondary'))
        .maxFontSize(FONT_STYLES.bodyMedium.fontSize)
        .minFontSize(FONT_STYLES.bodySmall.fontSize)
        .fontWeight(FontWeight.Medium)
        .lineHeight(FONT_STYLES.bodyMedium.lineHeight)
        .textAlign(TextAlign.Center);
    }
    .height(28)
    .width(72)
    .padding({ left: SPACING.iconPadding, right: SPACING.iconPadding,
      top: SPACING.small, bottom: SPACING.small })
    .borderRadius(BorderRadius.PILL - 15)
    .backgroundColor(item.isCompleted ? ColorConstants.TASK_COMPLETED_BG : $r('sys.color.comp_background_tertiary'));
  }
  .width('100%')
  .backgroundColor($r('sys.color.comp_background_list_card'))
  .padding({ left: SPACING.medium, right: SPACING.medium,
    top: COMMON_DIMENSIONS.dividerHeight / 2 + 0.5, bottom: COMMON_DIMENSIONS.dividerHeight / 2 + 0.5 })
  .justifyContent(FlexAlign.SpaceBetween)
  .borderRadius(BorderRadius.BUTTON);
}