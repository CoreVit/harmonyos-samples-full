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

import { common } from '@kit.AbilityKit';
import { hdsMaterial } from '@kit.UIDesignKit';
import { HdsTabs } from '@hms.hds.hdsBaseComponent';
import {
  BreakpointType,
  CommonConstants,
  DeviceApiVersionUtil,
  SetDecorButtonStyleUtil,
  WindowInfo,
  WindowUtil
} from 'multivideobase';
import { MainPageView } from 'multivideorecommended';
import { DefaultConstants } from '../constants/DefaultConstants';
import { DefaultHomeHeader } from './HomeHeader';
import HomeFooterItemListViewModel, { HomeFooterItemViewModel } from '../viewmodel/HomeFooterItemViewModel';

@Component
export struct HomeView {
  @StorageLink(CommonConstants.WINDOW_UTIL) windowUtil: WindowUtil | undefined = undefined;
  @ObjectLink @Watch('mainWindowInfoChange') mainWindowInfo: WindowInfo;
  @Consume('currentTopIndex') currentTopIndex: number = 0;
  @Consume('pageInfo') pageInfo: NavPathStack;
  @State currentBottomIndex: number = 0;
  @State bottomAvoidHeight: number =
    this.getUIContext().px2vp(this.mainWindowInfo.avoidNavigationIndicator?.bottomRect.height);
  @State barOpacity: number = 1;
  @State bottomBarHeight: number = 56 + this.bottomAvoidHeight;
  @State homeScrollHeight: number = 0;
  @State topAvoidHeight: number = this.getUIContext().px2vp(this.mainWindowInfo.avoidSystem?.topRect.height);
  @State hdsTabsAvoidHeight: number =
    this.getUIContext().px2vp(this.mainWindowInfo.avoidNavigationIndicator?.bottomRect.height) || 16;
  @State hdsTabsOpacity: number = 1;
  @State hdsTabsHeight: number = 56;
  @State homeFooterItemListViewModel: HomeFooterItemListViewModel = new HomeFooterItemListViewModel();
  @StorageLink(CommonConstants.SYSTEM_COLOR_MODE_VERSION) @Watch('onSystemColorModeVersionChange') systemColorModeVersion: number = 0;
  private bottomPaddingBase: number = 8;

  onSystemColorModeVersionChange(): void {
    this.syncDecorButtonStyle();
  }

  private syncDecorButtonStyle(): void {
    const ctx = this.getUIContext().getHostContext() as common.UIAbilityContext;
    if ((this.pageInfo.getAllPathName().length > 0 &&
      this.pageInfo.getAllPathName()[this.pageInfo.getAllPathName().length - 1] ===
        DefaultConstants.PAGE_NAME_FOR_VIDEO)) {
      return;
    }
    SetDecorButtonStyleUtil.setDecorButtonForNormal(this.windowUtil, ctx);
  }

  build() {
    if (DeviceApiVersionUtil.isApiVersionAfter23()) {
      HdsTabs({
        barPosition: BarPosition.End
      }) {
        TabContent() {
          this.HomeViewContent()
        }
        .tabBar(this.BottomTabBuilder(
          this.homeFooterItemListViewModel.getItems()[DefaultConstants.HOME_FOOTER_TAB_INDEXES[0]],
          DefaultConstants.HOME_FOOTER_TAB_INDEXES[0]))

        TabContent() {
          Column()
        }
        .tabBar(this.BottomTabBuilder(
          this.homeFooterItemListViewModel.getItems()[DefaultConstants.HOME_FOOTER_TAB_INDEXES[1]],
          DefaultConstants.HOME_FOOTER_TAB_INDEXES[1]))

        TabContent() {
          Column()
        }
        .tabBar(this.BottomTabBuilder(
          this.homeFooterItemListViewModel.getItems()[DefaultConstants.HOME_FOOTER_TAB_INDEXES[2]],
          DefaultConstants.HOME_FOOTER_TAB_INDEXES[2]))

        TabContent() {
          Column()
        }
        .tabBar(this.BottomTabBuilder(
          this.homeFooterItemListViewModel.getItems()[DefaultConstants.HOME_FOOTER_TAB_INDEXES[3]],
          DefaultConstants.HOME_FOOTER_TAB_INDEXES[3]))
      }
      .barOverlap(true)
      .vertical(false)
      .barFloatingStyle({
        barWidth: {
          smallWidth: this.mainWindowInfo.heightBp >= HeightBreakpoint.HEIGHT_LG ? 328 : 294,
          mediumWidth: 328,
          largeWidth: 328
        },
        barBottomMargin: this.hdsTabsAvoidHeight,
        systemMaterialEffect: {
          materialType: hdsMaterial.MaterialType.IMMERSIVE,
          materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE
        },
        barOpacity: this.hdsTabsOpacity
      })
      .barHeight(this.hdsTabsHeight)
      .onChange((index: number) => {
        this.currentBottomIndex = index;
      })
      .scrollable(false)
    } else {
      Tabs({
        barPosition: this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? BarPosition.Start : BarPosition.End
      }) {
        TabContent() {
          this.HomeViewContent()
        }
        .tabBar(this.BottomTabBuilder(
          this.homeFooterItemListViewModel.getItems()[DefaultConstants.HOME_FOOTER_TAB_INDEXES[0]],
          DefaultConstants.HOME_FOOTER_TAB_INDEXES[0]))

        TabContent() {
          Column()
        }
        .tabBar(this.BottomTabBuilder(
          this.homeFooterItemListViewModel.getItems()[DefaultConstants.HOME_FOOTER_TAB_INDEXES[1]],
          DefaultConstants.HOME_FOOTER_TAB_INDEXES[1]))

        TabContent() {
          Column()
        }
        .tabBar(this.BottomTabBuilder(
          this.homeFooterItemListViewModel.getItems()[DefaultConstants.HOME_FOOTER_TAB_INDEXES[2]],
          DefaultConstants.HOME_FOOTER_TAB_INDEXES[2]))

        TabContent() {
          Column()
        }
        .tabBar(this.BottomTabBuilder(
          this.homeFooterItemListViewModel.getItems()[DefaultConstants.HOME_FOOTER_TAB_INDEXES[3]],
          DefaultConstants.HOME_FOOTER_TAB_INDEXES[3]))
      }
      // Change the position and size of the tab at the bottom.
      .barWidth(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '96vp' : '100%')
      .barHeight(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '100%' : this.bottomBarHeight)
      .barMode(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? BarMode.Scrollable : BarMode.Fixed,
        { nonScrollableLayoutStyle: LayoutStyle.ALWAYS_CENTER })
      .vertical(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG)
      .barOverlap(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG &&
        this.currentTopIndex === DefaultConstants.COMMUNITY_TOP_INDEX ? true :
        false)
      .barBackgroundBlurStyle(BlurStyle.NONE)
      .barBackgroundColor(this.currentTopIndex === DefaultConstants.COMMUNITY_TOP_INDEX &&
        this.currentBottomIndex === DefaultConstants.HOME_BOTTOM_INDEX ?
        (this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ?
          $r('app.color.dft_home_tab_background_on_immersive') : $r('app.color.dft_home_content_background')) :
        $r('app.color.dft_page_background'))
      .onChange((index: number) => {
        this.currentBottomIndex = index;
      })
      .scrollable(false)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .height('100%')
      .width('100%')
    }
  }

  @Builder
  BottomTabBuilder(item: HomeFooterItemViewModel, index: number) {
    Column() {
      SymbolGlyph(item.getIcon())
        .fontSize('24fp')
        .fontColor([index !== this.currentBottomIndex ?
          (this.currentTopIndex === DefaultConstants.COMMUNITY_TOP_INDEX &&
            this.currentBottomIndex === DefaultConstants.HOME_BOTTOM_INDEX ?
            (DeviceApiVersionUtil.isApiVersionAfter23() ? $r('app.color.dft_bottom_tab_icon_unselected_hds') :
              $r('app.color.dft_bottom_tab_icon_unselected_on_immersive')) :
            (DeviceApiVersionUtil.isApiVersionAfter23() ? $r('app.color.dft_bottom_tab_icon_unselected_hds') :
              $r('app.color.dft_bottom_tab_icon_unselected'))) :
          $r('app.color.dft_bottom_tab_icon_selected')])
      Text(item.getName())
        .fontSize('10fp')
        .fontWeight(500)
        .fontColor(index !== this.currentBottomIndex ?
          (this.currentTopIndex === DefaultConstants.COMMUNITY_TOP_INDEX &&
            this.currentBottomIndex === DefaultConstants.HOME_BOTTOM_INDEX ?
            (DeviceApiVersionUtil.isApiVersionAfter23() ? $r('app.color.dft_bottom_tab_icon_unselected_hds') :
              $r('app.color.dft_bottom_tab_icon_unselected_on_immersive')) :
            (DeviceApiVersionUtil.isApiVersionAfter23() ? $r('app.color.dft_bottom_tab_icon_unselected_hds') :
              $r('app.color.dft_bottom_tab_icon_unselected'))) :
          $r('app.color.dft_bottom_tab_icon_selected'))
        .margin({ top: '4vp' })
    }
    .padding({
      bottom: DeviceApiVersionUtil.isApiVersionAfter23() ?
        '0vp' : this.getUIContext().px2vp(this.mainWindowInfo.avoidNavigationIndicator?.bottomRect.height)
    })
    .height(DeviceApiVersionUtil.isApiVersionAfter23() ? '100%' :
      this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '100vp' : '100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .opacity(this.barOpacity)
  }

  @Builder
  HomeViewContent() {
    if (this.currentTopIndex === DefaultConstants.COMMUNITY_TOP_INDEX) {
      Stack() {
        MainPageView({
          mainWindowInfo: this.mainWindowInfo,
          bottomBarHeight: this.bottomBarHeight,
          scrollHeight: this.homeScrollHeight,
          hdsTabsHeight: this.hdsTabsHeight,
          hdsTabsOpacity: this.hdsTabsOpacity,
          hdsTabsAvoidHeight: this.hdsTabsAvoidHeight
        })
        DefaultHomeHeader({
          mainWindowInfo: this.mainWindowInfo,
          scrollHeight: this.homeScrollHeight
        })
          .opacity(this.getHomeHeaderOpacity())
          .height(this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
            this.mainWindowInfo.heightBp <= HeightBreakpoint.HEIGHT_MD ? this.getHomeHeaderHeight() : 'auto')
          .padding({
            left: DeviceApiVersionUtil.isApiVersionAfter23() ? '0vp' :
              this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '96vp' : '0vp',
            top: '0vp',
            bottom: this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
              this.mainWindowInfo.heightBp <= HeightBreakpoint.HEIGHT_MD ? '8vp' : '0vp'
          })
      }
      .height('100%')
      .width('100%')
      .alignContent(Alignment.Top)
    } else {
      Column() {
        DefaultHomeHeader({
          mainWindowInfo: this.mainWindowInfo,
          scrollHeight: this.homeScrollHeight
        })
          .opacity(this.getHomeHeaderOpacity())
          .height(this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
            this.mainWindowInfo.heightBp <= HeightBreakpoint.HEIGHT_MD ? this.getHomeHeaderHeight() : 'auto')
          .padding({
            top: this.getHomeHeaderPaddingTop(),
            bottom: this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
              this.mainWindowInfo.heightBp <= HeightBreakpoint.HEIGHT_MD ? this.getHomeHeaderPaddingBottom() : '0vp'
          })

        MainPageView({
          mainWindowInfo: this.mainWindowInfo,
          bottomBarHeight: this.bottomBarHeight,
          scrollHeight: this.homeScrollHeight,
          hdsTabsHeight: this.hdsTabsHeight,
          hdsTabsOpacity: this.hdsTabsOpacity,
          hdsTabsAvoidHeight: this.hdsTabsAvoidHeight
        })
      }
    }
  }

  aboutToAppear(): void {
    this.mainWindowInfoChange();
    this.homeFooterItemListViewModel.loadHomeFooterData();
  }

  aboutToDisappear(): void {
    this.homeFooterItemListViewModel.clearHomeFooterData();
  }

  getHomeHeaderPaddingTop(): string | number {
    return new BreakpointType(0, 0, this.currentTopIndex === DefaultConstants.COMMUNITY_TOP_INDEX ? '0vp' : this.topAvoidHeight,
      this.currentTopIndex === DefaultConstants.COMMUNITY_TOP_INDEX ? '0vp' : this.topAvoidHeight,
      this.currentTopIndex === DefaultConstants.COMMUNITY_TOP_INDEX ? '0vp' : this.topAvoidHeight)
      .getValue(this.mainWindowInfo.widthBp);
  }

  getHomeHeaderPaddingBottom(): string | number {
    return this.bottomPaddingBase * this.getHomeHeaderOpacity() + DefaultConstants.VP_UNIT;
  }

  getHomeHeaderOpacity(): number {
    if (this.mainWindowInfo.widthBp > WidthBreakpoint.WIDTH_SM ||
      this.mainWindowInfo.heightBp > HeightBreakpoint.HEIGHT_MD) {
      return 1;
    }
    if (this.homeScrollHeight <= 0) {
      return 1;
    }
    const ratio = 1 - this.homeScrollHeight / DefaultConstants.SCROLL_BAR_HIDE_THRESHOLD;
    return ratio < 0 ? 0 : ratio;
  }

  getHomeHeaderHeight(): number {
    const baseHeight = this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
      this.mainWindowInfo.heightBp >= HeightBreakpoint.HEIGHT_LG ?
      DefaultConstants.HOME_HEADER_HEIGHT_SM + this.topAvoidHeight :
      DefaultConstants.TOP_BAR_HEIGHT + this.topAvoidHeight;
    return baseHeight * this.getHomeHeaderOpacity();
  }

  mainWindowInfoChange(): void {
    this.topAvoidHeight = this.getUIContext().px2vp(this.mainWindowInfo.avoidSystem?.topRect.height);
  }
}