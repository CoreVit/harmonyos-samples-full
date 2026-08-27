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
import { IndexTabsState, TabItem } from 'multishoppingbase';
import { hdsMaterial, HdsTabs } from '@kit.UIDesignKit';
import { Home } from './Home';
import { Category } from './Category';
import { uiObserver } from '@kit.ArkUI';
import { deviceInfo } from '@kit.BasicServicesKit';

@ComponentV2
export struct RootTabsPage {
  @Local indexTabsState: IndexTabsState = new IndexTabsState();
  @Env(SystemProperties.BREAK_POINT) public breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;

  @Builder
  tabBarItem(index: number) {
    TabItem({
      item: this.indexTabsState.items[index],
      selected: this.indexTabsState.selectedIndex === index,
    })
  }

  build() {
    if(deviceInfo.distributionOSApiVersion >= 60100){
      HdsTabs({ index: this.indexTabsState.selectedIndex }) {
        TabContent() {
          Home()
        }.tabBar(this.tabBarItem(0));

        TabContent() {
          Category()
        }.tabBar(this.tabBarItem(1));

        TabContent() {
          Column().width('100%').height('100%').backgroundColor($r('app.color.surface_primary'));
        }.tabBar(this.tabBarItem(2));

        TabContent() {
          Column().width('100%').height('100%').backgroundColor($r('app.color.surface_primary'));
        }.tabBar(this.tabBarItem(3));

        TabContent() {
          Column().width('100%').height('100%').backgroundColor($r('app.color.surface_primary'));
        }.tabBar(this.tabBarItem(4));
      }
      .onChange((index: number) => {
        this.indexTabsState.selectTab(index);
      })
      .barFloatingStyle({
        barBottomMargin: this.breakpoint.heightBreakpoint === HeightBreakpoint.HEIGHT_MD ? 8 : 18,
        gradientMask: { maskColor: $r('app.color.tab_mask_color') },
        systemMaterialEffect: {
          materialType: hdsMaterial.MaterialType.IMMERSIVE,
          materialLevel: hdsMaterial.MaterialLevel.EXQUISITE
        },
      })
      .barOverlap(true)
      .barPosition(BarPosition.End)
      .width('100%');
    }else {
      Tabs({ index: this.indexTabsState.selectedIndex }) {
        TabContent() {
          Home()
        }.tabBar(this.tabBarItem(0));

        TabContent() {
          Category()
        }.tabBar(this.tabBarItem(1));

        TabContent() {
          Column().width('100%').height('100%').backgroundColor($r('app.color.surface_primary'));
        }.tabBar(this.tabBarItem(2));

        TabContent() {
          Column().width('100%').height('100%').backgroundColor($r('app.color.surface_primary'));
        }.tabBar(this.tabBarItem(3));

        TabContent() {
          Column().width('100%').height('100%').backgroundColor($r('app.color.surface_primary'));
        }.tabBar(this.tabBarItem(4));
      }
      .onChange((index: number) => {
        this.indexTabsState.selectTab(index);
      })
      .barPosition(BarPosition.End)
      .padding({
        bottom: 18
      })
      .width('100%');
    }
  }
}
