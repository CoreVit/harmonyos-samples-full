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

import { COMMON_DIMENSIONS, FONT_STYLES, SPACING } from '../../common/CommonConstants';

@Builder
export function OverviewStatItem(value: string, unit: string | Resource,
  showDivider: boolean = false, valueFontSize: number = 24) {
  Row() {
    if (showDivider) {
      Line()
        .width(COMMON_DIMENSIONS.dividerWidth)
        .height(COMMON_DIMENSIONS.dividerHeight)
        .backgroundColor($r('sys.color.comp_divider'));
    }
    Column() {
      Text(value)
        .fontSize(valueFontSize)
        .lineHeight(valueFontSize + 13)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('sys.color.font_primary'))
        .maxLines(1);
      Text(unit)
        .fontSize(FONT_STYLES.bodySmall.fontSize)
        .lineHeight(FONT_STYLES.bodySmall.lineHeight)
        .fontColor($r('sys.color.font_secondary'))
        .maxLines(1);
    }
    .padding({ left: showDivider ? SPACING.medium : 0 })
    .alignItems(HorizontalAlign.Start);
  }
  .justifyContent(FlexAlign.Start)
  .width('100%')
  .alignItems(VerticalAlign.Bottom);
}