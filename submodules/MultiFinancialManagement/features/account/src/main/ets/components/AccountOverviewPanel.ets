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
import { WindowInfo } from 'financialbase';
import { AccountConstants } from '../constants/AccountConstants';
import { Summary } from '../model/AccountModel';
import { SummaryViewModel } from '../viewmodel/SummaryViewModel';

@ComponentV2
export struct AccountOverviewPanel {
  @Env(SystemProperties.BREAK_POINT) breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Param @Require mainWindowInfo: WindowInfo;
  @Local topPadding: number = this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? 88 : 16;
  @Param radius: number | string = '50%';
  @Local summaryViewModel: SummaryViewModel = new SummaryViewModel();

  build() {
    Column({ space: 16 }) {
      Row({ space: 16 }) {
        Text(AccountConstants.TOTAL_AMOUNT)
          .fontSize(this.breakpoint.widthBreakpoint >= WidthBreakpoint.WIDTH_LG ? 38 : 24)
          .lineHeight(this.breakpoint.widthBreakpoint >= WidthBreakpoint.WIDTH_LG ? 50 : 32)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.font_on_primary'))
        SymbolGlyph($r('sys.symbol.chevron_right'))
          .fontSize(24)
          .fontColor([$r('app.color.icon_on_primary')])
      }
      .justifyContent(FlexAlign.Center)

      Row({ space: 8 }) {
        Text($r('app.string.account_yesterday_income'))
          .fontSize(12)
          .lineHeight(16)
          .fontColor($r('app.color.font_on_primary'))
        Text(AccountConstants.YESTERDAY_INCOME)
          .fontSize(12)
          .lineHeight(16)
          .fontColor($r('app.color.font_on_primary'))
      }
      .padding({
        top: 6,
        bottom: 6,
        left: 10,
        right: 10
      })
      .borderRadius(this.radius)
      .backgroundColor($r('app.color.on_primary10'))

      Row() {
        ForEach(this.summaryViewModel.getMessageList(), (item: Summary) => {
          this.SummaryItem(item)
        }, (item: Summary, index: number) => JSON.stringify(item) + index)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)

      .margin({ top: this.topPadding - 16 })
    }
    .padding({
      top: this.mainWindowInfo.statusBarHeight + 56 + this.topPadding,
      bottom: 24
    })
    .width('100%')
    .height(this.breakpoint.widthBreakpoint >= WidthBreakpoint.WIDTH_LG ? '100%' : 'auto')
    .linearGradient({
      direction: this.breakpoint.widthBreakpoint >= WidthBreakpoint.WIDTH_LG ? GradientDirection.RightBottom :
        GradientDirection.LeftBottom,
      colors: [[$r('app.color.brand'), 0.0], [$r('app.color.brand30'), 1.0]]
    })
  }

  @Builder
  private SummaryItem(summary: Summary) {
    Column({ space: 8 }) {
      Text(summary.amount)
        .fontSize(14)
        .lineHeight(19)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.font_on_primary'))
      Text(summary.name)
        .fontSize(12)
        .lineHeight(16)
        .opacity(0.6)
        .fontColor($r('app.color.font_on_primary'))
    }
    .alignItems(HorizontalAlign.Center)
  }
}