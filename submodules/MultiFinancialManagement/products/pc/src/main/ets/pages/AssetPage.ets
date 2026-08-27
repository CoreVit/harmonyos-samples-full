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

import { ConfigurationConstant } from '@kit.AbilityKit';
import { AppStorageV2, uiObserver } from '@kit.ArkUI';
import { AccountOverviewPanel, DemandDepositSection, InvestmentSection, LiabilitySection } from 'account';
import { CommonConstants, WindowInfo, WindowUtil } from 'financialbase';
import { RecommendNoticeBar } from 'recommend';

@ComponentV2
export struct AssetPage {
  @Env(SystemProperties.BREAK_POINT) breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Local windowUtil: WindowUtil = AppStorageV2.connect(WindowUtil, CommonConstants.WINDOW_UTIL_KEY)!;
  @Local mainWindowInfo: WindowInfo = this.windowUtil.mainWindowInfo;
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack();
  scroller: Scroller = new Scroller()

  onShown(): void {
    this.windowUtil.setDecorButtonStyle(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)
  }

  onHidden(): void {
    this.windowUtil.setDecorButtonStyle()
  }

  build() {
    NavDestination() {
      GridRow({ columns: { sm: 4, md: 8, lg: 12 } }) {
        GridCol({ span: { sm: 4, md: 8, lg: 4 } }) {
          Stack({ alignContent: Alignment.TopStart }) {
            AccountOverviewPanel({
              mainWindowInfo: this.mainWindowInfo,
              radius: 8
            })
            Row({ space: 16 }) {
              SymbolGlyph($r('sys.symbol.chevron_left'))
                .fontSize(24)
                .fontColor([$r('app.color.icon_on_primary')])
                .onClick(() => {
                  if (this.pageStack.size() > 0) {
                    this.pageStack.pop();
                  }
                })
              Text($r('app.string.account_overview_title'))
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.font_on_primary'))
            }
            .padding({ left: 24 })
            .height(56)
          }
        }

        GridCol({ span: { sm: 4, md: 8, lg: 8 } }) {
          Stack({ alignContent: Alignment.TopStart }) {
            Scroll(this.scroller) {
              this.BodyContent()
            }
            .scrollBar(BarState.Off)
            .width('100%')
            .height('100%')
            .align(Alignment.TopStart)
          }
          .background($r('app.color.background_secondary'))

        }
      }
      .width('100%')
    }
    .hideTitleBar(true)
    .hideToolBar(true)
    .padding(0)
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.ALL])
    .onWillDisappear(() => this.onHidden())
    .onShown(() => this.onShown())
  }

  @Builder
  private BodyContent() {
    Column({ space: 24 }) {
      DemandDepositSection({
        radius: 8
      })
      RecommendNoticeBar({
        radius: 8
      })
      InvestmentSection({
        radius: 8
      })
      LiabilitySection({
        radius: 8
      })
    }
    .padding({
      left: CommonConstants.COMMON_PADDING[3].getValue(this.breakpoint.widthBreakpoint),
      right: CommonConstants.COMMON_PADDING[3].getValue(this.breakpoint.widthBreakpoint),
      bottom: 20,
      top: 56
    })
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .expandSafeArea()
    .background($r('app.color.background_secondary'))
  }
}