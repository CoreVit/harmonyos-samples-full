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

import { deviceInfo } from '@kit.BasicServicesKit';
import { HdsTabs } from '@hms.hds.hdsBaseComponent';
import { hdsMaterial } from '@hms.hds.hdsMaterial';
import { WindowInfo, WindowUtil, BreakpointType, KEY_WINDOW_UTIL, KEY_MAIN_WINDOW_INFO,
  KEY_IS_SPLIT_SCREEN } from '@stock/base';
import { StockDetailsPage } from '@stock/stockdetail';
import { OptionPage } from './OptionPage';

@Entry
@Component
struct Index {
  @StorageLink(KEY_WINDOW_UTIL) windowUtil: WindowUtil | undefined = undefined;
  @StorageLink(KEY_MAIN_WINDOW_INFO) mainWindowInfo: WindowInfo = new WindowInfo();
  @StorageLink(KEY_IS_SPLIT_SCREEN) isSplitScreen: boolean = false;
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack();
  @Provide('tabletMode') tabletMode: NavigationMode = NavigationMode.Split;
  @State currentTabIndex: number = 2;
  @State backgroundImageY: number = 0;

  @Builder
  pageMap(pageName: string): void {
    if (pageName === 'StockDetailsPage') {
      StockDetailsPage();
    }
  }

  getTabBarColor(index: number, currentTabIndex: number, breakPoint: number, isHds?: boolean): ResourceColor {
    if (this.backgroundImageY < -20 && this.currentTabIndex === 0 && index === 0) {
      return $r('app.color.tab_selected_color');
    } else if (index === 0 && (breakPoint === WidthBreakpoint.WIDTH_LG || breakPoint === WidthBreakpoint.WIDTH_XL)) {
      return currentTabIndex === index ? $r('app.color.tab_content_background') :
        (isHds ? $r('app.color.tab_unselected_color_dark') : $r('app.color.tab_unselected_color_light'));
    }
    return currentTabIndex === index ? $r('app.color.tab_selected_color') :
      (isHds ? $r('app.color.tab_unselected_color_dark') : $r('app.color.tab_unselected_color_light'));
  }

  @Builder
  BuildTabs(icon: Resource, title: ResourceStr, index: number, isHds?: boolean): void {
    Column() {
      Image(icon)
        .width(24)
        .height(24)
        .fillColor(this.getTabBarColor(index, this.currentTabIndex, this.mainWindowInfo.widthBp, isHds))
      Text(title)
        .fontSize(10)
        .lineHeight(14)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.getTabBarColor(index, this.currentTabIndex, this.mainWindowInfo.widthBp, isHds))
    }
  }

  aboutToAppear(): void {
    setTimeout(() => {
      if (this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_LG || this.isSplitScreen) {
        this.pageInfos.replacePathByName('StockDetailsPage', null, true);
      }
    }, 100);
  }

  aboutToDisappear(): void {
    this.windowUtil?.release();
  }

  build() {
    Navigation(this.pageInfos) {
      Column() {
        // [Start homepage_tabs]
        if (deviceInfo.distributionOSApiVersion >= 60100) {
          HdsTabs({
            barPosition: BarPosition.End,
            index: this.currentTabIndex
          }) {
            // [StartExclude homepage_tabs]
            TabContent() {
            }
            .tabBar(this.BuildTabs($r('app.media.house_fill'), $r('app.string.home_page'), 0, true))
            .backgroundColor($r('app.color.tab_content_background'))

            TabContent() {
            }
            .tabBar(this.BuildTabs($r('app.media.doc_text_fill'), $r('app.string.information'), 1, true))
            .backgroundColor($r('app.color.tab_content_background'))

            TabContent() {
              OptionPage()
            }
            .tabBar(this.BuildTabs($r('app.media.square_and_pencil_fill'), $r('app.string.optional'), 2, true))
            .backgroundColor($r('app.color.tab_content_background'))

            TabContent() {
            }
            .tabBar(this.BuildTabs($r('app.media.doc_plaintext_fill'), $r('app.string.market'), 3, true))
            .backgroundColor($r('app.color.tab_content_background'))

            // [EndExclude homepage_tabs]
          }
          .barHeight(56)
          .backgroundImageSize(ImageSize.Contain)
          .backgroundColor($r('app.color.tabs_background'))
          .scrollable(false)
          // [End homepage_tabs]
          .backgroundImagePosition({
            y: this.backgroundImageY
          })
          .onChange((index: number) => {
            this.currentTabIndex = index;
          })
          .barOverlap(true)
          .barFloatingStyle({
            barBottomMargin: this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_SM ? 16 :
              this.getUIContext().px2vp(this.mainWindowInfo.avoidNavigationIndicator?.bottomRect?.height ?? 0),
            systemMaterialEffect: {
              materialType: hdsMaterial.MaterialType.IMMERSIVE,
              materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE,
            },
          })
        } else {
          // Fallback to an earlier version
          Tabs({
            barPosition: new BreakpointType(BarPosition.End, BarPosition.End, BarPosition.End, BarPosition.Start,
              BarPosition.Start)
              .getValue(this.mainWindowInfo.widthBp),
            index: this.currentTabIndex
          }) {
            // [StartExclude homepage_tabs]
            TabContent() {
            }
            .tabBar(this.BuildTabs($r('app.media.house_fill'), $r('app.string.home_page'), 0))
            .backgroundColor($r('app.color.tab_content_background'))

            TabContent() {
            }
            .tabBar(this.BuildTabs($r('app.media.doc_text_fill'), $r('app.string.information'), 1))
            .backgroundColor($r('app.color.tab_content_background'))

            TabContent() {
              OptionPage()
            }
            .tabBar(this.BuildTabs($r('app.media.square_and_pencil_fill'), $r('app.string.optional'), 2))
            .backgroundColor($r('app.color.tab_content_background'))

            TabContent() {
            }
            .tabBar(this.BuildTabs($r('app.media.doc_plaintext_fill'), $r('app.string.market'), 3))
            .backgroundColor($r('app.color.tab_content_background'))

            // [EndExclude homepage_tabs]
          }
          .vertical(this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_LG ||
            this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_XL)
          .barWidth(this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_LG ||
            this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_XL ? 96 : '100%')
          .barHeight(this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_LG ||
            this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_XL ? '50%' : 56)
          .backgroundImageSize(ImageSize.Contain)
          .backgroundColor($r('app.color.tabs_background'))
          .scrollable(false)
          // [End homepage_tabs]
          .backgroundImagePosition({
            y: this.backgroundImageY
          })
          .onChange((index: number) => {
            if (this.mainWindowInfo.widthBp !== WidthBreakpoint.WIDTH_LG) {
              this.currentTabIndex = index;
            }
          })
          .onContentWillChange(() => {
            if (this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_LG ||
              this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_XL) {
              return false;
            }
            return true;
          })
          .padding({
            bottom: this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_LG ||
              this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_XL ? 0 :
              this.getUIContext().px2vp(this.mainWindowInfo.avoidNavigationIndicator?.bottomRect.height)
          })
        }
      }
      .width('100%')
      .height('100%')
    }
    .navDestination(this.pageMap)
    .navBarWidthRange([474, 474])
    .mode(new BreakpointType(NavigationMode.Stack, NavigationMode.Stack, NavigationMode.Stack, this.tabletMode,
      this.tabletMode)
      .getValue(this.mainWindowInfo.widthBp))
    .hideTitleBar(true)
    .hideToolBar(true)
    .height('100%')
    .backgroundColor($r('sys.color.gray_01'))
  }
}
