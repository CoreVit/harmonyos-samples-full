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
import { CategoryHeaderState } from '../viewmodel/CategoryHeaderState';

@ComponentV2
export struct CategoryHeader {
  private context: Context = this.getUIContext().getHostContext()!;
  @Env(SystemProperties.BREAK_POINT) private breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Local private state: CategoryHeaderState = new CategoryHeaderState(this.context);

  build() {
    Row() {
      Row() {
        Stack({ alignContent: Alignment.Start }) {
          TextInput({ placeholder: this.state.placeholder })
            .placeholderFont({ size: 16, weight: FontWeight.Normal })
            .placeholderColor($r('sys.color.font_secondary'))
            .backgroundColor($r('app.color.overlay_low'))
            .width((this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
              this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? '100%' : 232)
            .height(40)
            .fontSize(16)
            .padding({ left: 36, right: 12 })
            .borderRadius(20)
            .enableKeyboardOnFocus(false)

          SymbolGlyph($r('sys.symbol.magnifyingglass'))
            .fontSize(16)
            .margin({ left: 16 })
            .fontColor([$r('sys.color.font_secondary')])
        }
        .layoutWeight(1)

        SymbolGlyph($r('sys.symbol.ellipsis_message'))
          .fontSize(24)
          .margin({
            left: (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
              this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? 16 : 24
          })
      }
      .width((this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
        this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? '100%' : 328)
      .padding({
        left: (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
          this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? 16 : 24,
        right: (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
          this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? 16 : 24
      })
    }
    .height(56)
    .width('100%')
    .justifyContent((this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
      this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? FlexAlign.Center : FlexAlign.End)
  }
}
