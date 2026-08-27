/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/CommonConstants';

@Builder
export function BottomTabBuilder() {
  BottomTab();
}

@Component
struct BottomTab {
  @State currentIndex: number = 0;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  private tabsController: TabsController = new TabsController();

  @Builder
  tabBuilder(title: Resource, index: number, icon: Resource) {
    Column() {
      SymbolGlyph(icon)
        .fontColor([this.currentIndex === index ? $r('sys.color.brand') : $r('sys.color.font_primary')])
        .fontSize(24)

      Text(title)
        .margin({ top: 4 })
        .fontSize(10)
        .fontColor(this.currentIndex === index ? $r('sys.color.brand') : $r('sys.color.font_primary'))
    }
    .justifyContent(FlexAlign.Center)
    .height(48)
    .width('100%')
    .onClick(() => {
      this.currentIndex = index;
      this.tabsController.changeIndex(this.currentIndex);
    })
  }

  @Builder
  tabContentBuilder(text: Resource, index: number, icon: Resource) {
    TabContent() {
      Row() {
        Text(text)
          .fontColor($r('sys.color.font_primary'))
          .height(300)
          .fontSize(30)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .padding({ left: 12, right: 12 })
    .backgroundColor($r('sys.color.background_secondary'))
    .tabBar(this.tabBuilder(text, index, icon))
  }

  build() {
    NavDestination() {
      Tabs({
        barPosition: new BreakpointType({
          sm: BarPosition.End,
          md: BarPosition.End,
          lg: BarPosition.Start
        }).getValue(this.curBp),
        controller: this.tabsController
      }) {
        this.tabContentBuilder($r('app.string.message'),
          CommonConstants.TAB_INDEX_ZERO, $r('sys.symbol.dot_2_message'))
        this.tabContentBuilder($r('app.string.people'),
          CommonConstants.TAB_INDEX_ONE, $r('sys.symbol.person'))
        this.tabContentBuilder($r('app.string.activity'),
          CommonConstants.TAB_INDEX_TWO, $r('sys.symbol.star'))
      }
      .vertical(new BreakpointType({ sm: false, md: false, lg: true }).getValue(this.curBp))
      .width('100%')
      .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
      .barHeight(new BreakpointType({ sm: '56vp', md: '56vp', lg: '50%' }).getValue(this.curBp))
      .barWidth(new BreakpointType({ sm: '100%', md: '100%', lg: '96vp' }).getValue(this.curBp))
      .barMode(BarMode.Fixed)
      .onAnimationStart((index: number, targetIndex: number) => {
        this.currentIndex = targetIndex;
      })
    }
    .padding({
      top: this.statusBarHeight,
      bottom: this.navigatorBarHeight
    })
    .backgroundColor($r('sys.color.background_secondary'))
  }
}