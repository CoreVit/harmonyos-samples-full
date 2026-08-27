/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { uiObserver } from '@kit.ArkUI';
import { WidthBreakpointType } from 'multishoppingbase';

/**
 * Migrated from detail/CommentInput, including the bottom comment input and action area.
 */
@ComponentV2
export struct LiveUtil {
  private static readonly ROW_HEIGHT: number = 48;
  private static readonly ICON_SIZE: number = 24;
  @Env(SystemProperties.BREAK_POINT) private breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Param public widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @Event public onOpenShopBag: () => void = () => {
  };

  build() {
    Row() {
      TextInput({ placeholder: $r('app.string.LIVE_COMMENT_PLACEHOLDER') })
        .layoutWeight(1)
        .placeholderColor($r('sys.color.font_on_primary'))
        .fontColor($r('sys.color.font_on_primary'))
        .fontSize(16)
        .height(40)
        .borderRadius(20)
        .enableKeyboardOnFocus(false)
        .backgroundColor($r('app.color.live_input_scrim'))
        .margin({
          right: new WidthBreakpointType(16, 16, 24, 24).getValue(this.widthBp)
        })

      SymbolGlyph($r('sys.symbol.share'))
        .fontSize(24)
        .fontColor([$r('sys.color.font_on_primary')])
        .margin({
          right: new WidthBreakpointType(16, 16, 24, 24).getValue(this.widthBp)
        })

      SymbolGlyph($r('sys.symbol.heart'))
        .fontSize(24)
        .fontColor([$r('sys.color.font_on_primary')])
        .margin({
          right: new WidthBreakpointType(16, 16, 24, 24).getValue(this.widthBp)
        })

      Row() {
        SymbolGlyph($r('sys.symbol.bag_fill'))
          .fontSize(24)
          .fontColor([$r('sys.color.font_on_primary')])
      }
      .height(40)
      .width(40)
      .borderRadius(20)
      .backgroundColor('#CF0A2C')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .onClick(() => {
        this.onOpenShopBag();
      })
    }
    .width('100%')
    .height(LiveUtil.ROW_HEIGHT)
    .padding({
      left: new WidthBreakpointType(16, 24, 32, 32).getValue(this.widthBp),
      right: new WidthBreakpointType(16, 24, 32, 32).getValue(this.widthBp)
    })
    .margin({ top: 18, bottom: 8 })
  }
}
