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

import { geoLocationManager } from '@kit.LocationKit';
import { hdsMaterial, HdsTabs, HdsTabsController } from '@kit.UIDesignKit';
import { map } from '@kit.MapKit';
import { ColumnTab, Common, PanelMode, PanelType, WindowInfo } from 'multitravelbase/Index';
import { HomeDisplayData } from '../../model/data/HomeDisplayData';
import { SearchViewModel } from '../../viewmodel/SearchViewModel';
import { HomePanelView } from './HomePanelView';
import { deviceInfo } from '@kit.BasicServicesKit';

@Component
export struct TabView {
  @State currentIndex: number = 0;
  @Link mapController: map.MapComponentController;
  @ObjectLink searchViewModel: SearchViewModel;
  @Prop panelMode: PanelMode = PanelMode.Half;
  @Prop panelType: PanelType = PanelType.Normal;
  @Prop panelWidth: number = 0;
  @Prop mainWindowInfo: WindowInfo;
  waitForCurrentLocation?: () => Promise<geoLocationManager.Location | undefined>;
  onPanelModeChange?: (mode: PanelMode) => void;
  onPanelPullStart?: () => void;
  onPanelPullUpdate?: (offsetY: number) => void;
  onPanelPullEnd?: () => void;
  private tabsController: HdsTabsController = new HdsTabsController();
  private tabList: ColumnTab[] = HomeDisplayData.createFooterTabs(this.getUIContext().getHostContext()!);

  private getTabBarWidth(): number {
    let panelWidth: number = this.panelWidth || this.getUIContext().px2vp(this.mainWindowInfo.windowSize.width);
    return Math.max(0, panelWidth - 32);
  }

  private getBottomAvoid(): number {
    return this.getUIContext().px2vp(this.mainWindowInfo.avoidNavigationIndicator?.bottomRect.height ?? 0);
  }

  @Builder
  TabBuilder(item: ColumnTab, targetIndex: number) {
    Column() {
      SymbolGlyph(item.icon)
        .fontSize(24)
        .fontColor((this.currentIndex === targetIndex) ?
          [$r('sys.color.brand_font')] : [$r('app.color.tab_font_unselected')])
      Text(item.name)
        .fontSize($r('app.float.tab_font_size'))
        .fontColor((this.currentIndex === targetIndex) ?
          $r('app.color.tab_font_selected_color') : $r('app.color.tab_font_unselected'))
    }
  }

  build() {
    if (deviceInfo.distributionOSApiVersion >= 60100) {
      HdsTabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
        TabContent() {
          HomePanelView({
            mapController: this.mapController,
            searchViewModel: this.searchViewModel,
            waitForCurrentLocation: this.waitForCurrentLocation,
            panelMode: this.panelMode,
            panelType: this.panelType,
            onPanelModeChange: this.onPanelModeChange,
            onPanelPullStart: this.onPanelPullStart,
            onPanelPullUpdate: this.onPanelPullUpdate,
            onPanelPullEnd: this.onPanelPullEnd
          })
        }
        .tabBar(this.TabBuilder(this.tabList[0], 0))

        TabContent() {
        }
        .tabBar(this.TabBuilder(this.tabList[1], 1))

        TabContent() {
        }
        .tabBar(this.TabBuilder(this.tabList[2], 2))

        TabContent() {
        }
        .tabBar(this.TabBuilder(this.tabList[3], 3))
      }
      .barOverlap(true)
      .barPosition(BarPosition.End)
      .barFloatingStyle({
        barWidth: {
          smallWidth: this.getTabBarWidth(),
          mediumWidth: this.getTabBarWidth(),
          largeWidth: this.getTabBarWidth()
        },
        barBottomMargin: this.panelType === PanelType.Normal ? 28 : 16,
        gradientMask: { maskColor: $r('app.color.tab_gradient_mask'), maskHeight: 92 },
        systemMaterialEffect: {
          materialType: hdsMaterial.MaterialType.ADAPTIVE,
          materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE
        }
      })
      .scrollable(false)
      .onChange((index: number) => {
        this.currentIndex = index;
      })
      .barHeight($r('app.float.tab_height'))
      .width(Common.FULL_WIDTH)
      .height(Common.FULL_HEIGHT)
    } else {
      // Fallback to an earlier version
      HdsTabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
        TabContent() {
          HomePanelView({
            mapController: this.mapController,
            searchViewModel: this.searchViewModel,
            waitForCurrentLocation: this.waitForCurrentLocation,
            panelMode: this.panelMode,
            panelType: this.panelType,
            onPanelModeChange: this.onPanelModeChange,
            onPanelPullStart: this.onPanelPullStart,
            onPanelPullUpdate: this.onPanelPullUpdate,
            onPanelPullEnd: this.onPanelPullEnd
          })
        }
        .tabBar(this.TabBuilder(this.tabList[0], 0))

        TabContent() {
        }
        .tabBar(this.TabBuilder(this.tabList[1], 1))

        TabContent() {
        }
        .tabBar(this.TabBuilder(this.tabList[2], 2))

        TabContent() {
        }
        .tabBar(this.TabBuilder(this.tabList[3], 3))
      }
      .scrollable(false)
      .onChange((index: number) => {
        this.currentIndex = index;
      })
      .padding({
        bottom: this.getBottomAvoid()
      })
      .barHeight($r('app.float.tab_height'))
      .width(Common.FULL_WIDTH)
      .height(Common.FULL_HEIGHT)
    }
  }
}
