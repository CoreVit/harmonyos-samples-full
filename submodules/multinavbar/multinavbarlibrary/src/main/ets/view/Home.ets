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

import { Constants } from '../common/Constants';
import { BreakpointTypeEnum } from '../common/utils/BreakpointSystem';
import { TabDataModel } from '../model/TabDataModel';
import { TabViewModel } from '../viewmodel/TabViewModel';
import { SideBarView } from './SideBarView';
import { TopTabView } from './TopTabView';
import { VideoInfoView } from './VideoInfoView';

@Component
export struct Home {
  @StorageLink(Constants.KEY_BREAKPOINT) currentWidthBreakpoint: string = BreakpointTypeEnum.SM;
  @StorageLink(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @State firstLevelIndex: number = 0;
  @State secondLevelIndex: number = 0;
  @State tabViewModel: TabViewModel = new TabViewModel();
  @State tabData: TabDataModel = this.tabViewModel.getTabMap();

  @Builder
  tabBuilder(name: Resource, index: number) {
    Column() {
      SymbolGlyph($r('sys.symbol.person_crop_circle_fill_1'))
        .fontSize($r('sys.float.Title_M'))
        .fontColor(index === this.firstLevelIndex ? [$r('sys.color.font_emphasize')] : [$r('sys.color.font_secondary')])
      Text(name)
        .fontSize($r('sys.float.Caption_M'))
        .fontWeight(FontWeight.Medium)
        .fontColor(index === this.firstLevelIndex ? $r('sys.color.font_emphasize') : $r('sys.color.font_secondary'))
        .margin({ top: $r('sys.float.padding_level2') })
    }
    .padding({ bottom: $r('sys.float.padding_level12') })
    .height(this.currentWidthBreakpoint === BreakpointTypeEnum.LG ? $r('app.float.top_tab_button_height') : '100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }

  build() {
    if (this.currentWidthBreakpoint === BreakpointTypeEnum.XL) {
      // Use SideBarContainer at XL breakpoint.
      SideBarContainer(SideBarContainerType.Embed) {
        SideBarView({
          firstLevelIndex: this.firstLevelIndex,
          secondLevelIndex: this.secondLevelIndex,
          tabData: this.tabData
        })

        Column() {
          Text(this.tabViewModel.getTabNameOfSecondLevel(this.tabViewModel.getTabNameOfFirstLevel(this.firstLevelIndex),
            this.secondLevelIndex))
            .fontSize($r('sys.float.Title_S'))
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .height(Constants.WINDOW_DECOR_HEIGHT)
            .margin({
              left: $r('sys.float.padding_level16')
            })
          VideoInfoView({
            secondLevelIndex: this.secondLevelIndex
          })
        }
        .padding({ top: this.statusBarHeight })
        .alignItems(HorizontalAlign.Start)
      }
      .autoHide(false)
      .divider({ strokeWidth: 0.3 })
      .showControlButton(false)
      .sideBarWidth($r('app.float.side_bar_width'))
      .minSideBarWidth($r('app.float.side_bar_width'))
      .maxSideBarWidth($r('app.float.side_bar_width'))
    } else {
      // Use Tabs and List at other breakpoints.
      Tabs({
        barPosition: this.currentWidthBreakpoint === BreakpointTypeEnum.LG ? BarPosition.Start : BarPosition.End
      }) {
        TabContent() {
          TopTabView({ tabData: this.tabData })
        }
        .tabBar(this.tabBuilder($r('app.string.tab_home'), 0))

        TabContent() {
          TopTabView({ tabData: this.tabData })
        }
        .tabBar(this.tabBuilder($r('app.string.tab_moments'), 1))

        TabContent() {
          TopTabView({ tabData: this.tabData })
        }
        .tabBar(this.tabBuilder($r('app.string.tab_shopping'), 2))

        TabContent() {
          TopTabView({ tabData: this.tabData })
        }
        .tabBar(this.tabBuilder($r('app.string.tab_me'), 3))
      }
      .barBackgroundColor($r('sys.color.background_secondary'))
      .barWidth(this.currentWidthBreakpoint === BreakpointTypeEnum.LG ? $r('app.float.tab_bar_width') : '100%')
      .barHeight(this.currentWidthBreakpoint === BreakpointTypeEnum.LG ? '100%' : $r('app.float.tab_bar_height'))
      .barMode(this.currentWidthBreakpoint === BreakpointTypeEnum.LG ? BarMode.Scrollable : BarMode.Fixed,
        { nonScrollableLayoutStyle: LayoutStyle.ALWAYS_CENTER })
      .vertical(this.currentWidthBreakpoint === BreakpointTypeEnum.LG)
      .barBackgroundBlurStyle(BlurStyle.COMPONENT_THICK)
      .onChange((index: number) => {
        this.firstLevelIndex = index;
      })
      .scrollable(false)
      .height('100%')
      .width('100%')
    }
  }
}