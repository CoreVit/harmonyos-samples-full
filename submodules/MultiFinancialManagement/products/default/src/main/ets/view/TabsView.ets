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
import { deviceInfo } from '@kit.BasicServicesKit';
import { hdsMaterial, HdsTabs } from '@kit.UIDesignKit';
import { BreakpointType, WindowInfo } from 'financialbase';
import { TabItem } from '../model/TabsModel';
import { HomePage } from '../pages/HomePage';
import { TabsViewModel } from '../viewmodel/TabsViewModel';

@ComponentV2
export struct TabsView {
  @Param mainWindowInfo: WindowInfo = new WindowInfo();
  @Local currentBottomIndex: number = 0;
  @Local backgroundImageY: number = 0;
  @Consumer('isHideTitleBar') isHideTitleBar: boolean = false;
  @Env(SystemProperties.BREAK_POINT) breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  private tabList: TabItem[] = new TabsViewModel().getTabList();

  build() {
    if (deviceInfo.distributionOSApiVersion >= 60100) {
      HdsTabs() {
        this.TabContentBuilder()
      }
      .onChange((index: number) => {
        this.currentBottomIndex = index;
      })
      .barOverlap(true)
      .barPosition(BarPosition.End)
      .vertical(false)
      .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.ALL])
      .height(LayoutPolicy.matchParent)
      .backgroundColor($r('app.color.background_secondary'))
      .barWidth(296)
      .barHeight(56)
      .barFloatingStyle({
        barBottomMargin: Math.max(this.mainWindowInfo.naviIndicatorHeight, 16),
        adaptToHandedness: false,
        systemMaterialEffect: {
          materialType: hdsMaterial.MaterialType.IMMERSIVE,
          materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE
        },
      })
    } else {
      HdsTabs({
        barPosition: this.breakpoint.widthBreakpoint >= WidthBreakpoint.WIDTH_LG ? BarPosition.Start :
          BarPosition.End
      }) {
        this.TabContentBuilder()
      }
      .ignoreLayoutSafeArea()
      .height(LayoutPolicy.matchParent)
      .barPosition(this.breakpoint.widthBreakpoint >= WidthBreakpoint.WIDTH_LG ? BarPosition.Start : BarPosition.End)
      .vertical(this.breakpoint.widthBreakpoint >= WidthBreakpoint.WIDTH_LG)
      .barWidth(this.breakpoint.widthBreakpoint >= WidthBreakpoint.WIDTH_LG ? 96 : '100%')
      .barHeight(this.breakpoint.widthBreakpoint >= WidthBreakpoint.WIDTH_LG ? '100%' : 56)
      .padding({
        bottom: this.breakpoint.widthBreakpoint < WidthBreakpoint.WIDTH_LG ? this.mainWindowInfo.naviIndicatorHeight : 0
      })
      .backgroundColor($r('app.color.background_secondary'))
      .backgroundImage(new BreakpointType($r('app.media.ic_home_phone_background'),
        $r('app.media.ic_home_fold_background'),
        $r('app.media.ic_home_tablet_background'),
        $r('app.media.ic_home_tablet_background')).getValue(this.breakpoint.widthBreakpoint))
      .backgroundImageSize(ImageSize.Contain)
      .backgroundImagePosition({
        y: this.currentBottomIndex === 0 ? this.backgroundImageY : -600
      })
      .animationDuration(0)
      .barBackgroundBlurStyle(this.breakpoint.widthBreakpoint >= WidthBreakpoint.WIDTH_LG ? BlurStyle.Thin :
        BlurStyle.NONE,
        {
          colorMode: ThemeColorMode.LIGHT,
          adaptiveColor: AdaptiveColor.DEFAULT,
          scale: 1.0,
          blurOptions: { grayscale: [20, 20] }
        })
      .onChange((index: number) => {
        this.currentBottomIndex = index;
        this.isHideTitleBar = index !== 0;
      })
    }
  }

  @Builder
  TabContentBuilder() {
    TabContent() {
      HomePage({
        mainWindowInfo: this.mainWindowInfo,
        scrollY: this.backgroundImageY,
        updateScrollY: (value: number) => this.backgroundImageY = value
      })
    }

    .tabBar(this.BottomTabBuilder(this.tabList[0], 0))

    TabContent() {
      Column()
    }
    .tabBar(this.BottomTabBuilder(this.tabList[1], 1))

    TabContent() {
      Column()
    }
    .tabBar(this.BottomTabBuilder(this.tabList[2], 2))

    TabContent() {
      Column()
    }
    .tabBar(this.BottomTabBuilder(this.tabList[3], 3))

    TabContent() {
      Column()
    }
    .tabBar(this.BottomTabBuilder(this.tabList[4], 4))
  }

  @Builder
  TabIcon(item: TabItem, index: number) {
    SymbolGlyph(item.icon)
      .fontSize(24)
      .fontColor([index === this.currentBottomIndex ? $r('app.color.icon_emphasize') : $r('app.color.icon_primary')])
  }

  @Builder
  BottomTabBuilder(item: TabItem, index: number) {
    Column() {
      this.TabIcon(item, index)
      Text(item.name)
        .fontSize(10)
        .fontWeight(500)
        .fontColor(index === this.currentBottomIndex ? $r('app.color.font_emphasize') : $r('app.color.font_primary'))
        .margin({ top: 4 })
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}