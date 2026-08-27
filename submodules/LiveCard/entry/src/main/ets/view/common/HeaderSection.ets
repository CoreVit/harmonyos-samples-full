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

import { FONT_STYLES, SPACING } from '../../common/CommonConstants';
import RouterUtil from '../../utils/RouterUtil';


@Builder
export function HeaderSection(title?: string | Resource,
  fontColor?: Resource, hideIconBg?: boolean, hideIcon?: boolean, iconColor?: string) {
  Row() {
    Row() {
      if (title) {
        Text(title)
          .fontSize(FONT_STYLES.bodyXLarge.fontSize)
          .lineHeight(FONT_STYLES.bodyXLarge.lineHeight)
          .fontWeight(FontWeight.Bold)
          .fontColor(fontColor ? fontColor : $r('sys.color.font_primary'));
      }
    };
    Row() {
      if (!hideIcon) {
        SymbolGlyph($r('sys.symbol.xmark'))
          .fontSize(FONT_STYLES.valueLarge.fontSize)
          .fontColor([iconColor || $r('sys.color.icon_primary')])
          .backgroundColor(hideIconBg ? Color.Transparent : $r('sys.color.comp_background_tertiary'))
          .borderRadius(30)
          .padding(SPACING.iconPadding)
          .onClick(() => {
            RouterUtil.getInstance().closeApp();
          });
      }
    };
  }
  .justifyContent(FlexAlign.SpaceBetween)
  .width('100%')
  .padding({ top: SPACING.medium, bottom: SPACING.medium });
}