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
export function SelectorItem(label: string | Resource) {
  Row() {
    Text(label)
      .fontSize(FONT_STYLES.bodyMedium.fontSize)
      .lineHeight(FONT_STYLES.bodyMedium.lineHeight)
      .fontColor($r('sys.color.font_primary'));
    SymbolGlyph($r('sys.symbol.chevron_down'))
      .fontSize(FONT_STYLES.bodyMedium.fontSize)
      .fontColor([$r('sys.color.icon_primary')])
      .margin({ left: SPACING.small });
  }
  .width('100%')
  .justifyContent(FlexAlign.Center)
  .padding({ top: SPACING.buttonPadding, bottom: SPACING.buttonPadding })
  .backgroundColor($r('sys.color.comp_background_tertiary'))
  .borderRadius(COMMON_DIMENSIONS.borderRadius);
}