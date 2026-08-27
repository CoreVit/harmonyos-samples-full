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
import { BusinessError } from '@kit.BasicServicesKit';
import { BreakpointType, CommonConstants, Logger, SetDecorButtonStyleUtil, WindowInfo, WindowUtil } from 'multivideobase';
import { MainPageView } from 'multivideorecommended';
import { PcConstants } from '../constants/PcConstants';
import HomeFooterItemListViewModel, { HomeFooterItemViewModel } from '../viewmodel/HomeFooterItemViewModel';
import { PcHomeHeader } from './HomeHeader';

const TAG = '[HomeView]';

@Component
export struct HomeView {
  @StorageLink(CommonConstants.WINDOW_UTIL) windowUtil: WindowUtil | undefined = undefined;
  @ObjectLink @Watch('updateHeaderStateByWindow') mainWindowInfo: WindowInfo;
  @Consume('currentTopIndex') currentTopIndex: number = 0;
  @Consume('pageInfo') pageInfo: NavPathStack;
  @State currentBottomIndex: number = 0;
  @State bottomAvoidHeight: number =
    this.getUIContext().px2vp(this.mainWindowInfo.avoidNavigationIndicator?.bottomRect.height);
  @State barOpacity: number = 1;
  @State bottomBarHeight: number = 56 + this.bottomAvoidHeight;
  @State homeScrollHeight: number = 0;
  @State topAvoidHeight: number = this.getUIContext().px2vp(this.mainWindowInfo.avoidSystem?.topRect.height);
  @State decorWidth: number = 140;
  @State decorHeight: number = 63;
  @State hdsTabsAvoidHeight: number =
    this.getUIContext().px2vp(this.mainWindowInfo.avoidNavigationIndicator?.bottomRect.height) || 10;
  @State hdsTabsOpacity: number = 1;
  @State hdsTabsHeight: number = 56;
  @State homeFooterItemListViewModel: HomeFooterItemListViewModel = new HomeFooterItemListViewModel();
  @StorageLink(CommonConstants.SYSTEM_COLOR_MODE_VERSION) @Watch('onSystemColorModeVersionChange') systemColorModeVersion: number = 0;

  onSystemColorModeVersionChange(): void {
    this.syncDecorButtonStyle();
  }

  private syncDecorButtonStyle(): void {
    const ctx = this.getUIContext().getHostContext() as common.UIAbilityContext;
    if ((this.pageInfo.getAllPathName().length > 0 &&
      this.pageInfo.getAllPathName()[this.pageInfo.getAllPathName().length - 1] ===
        PcConstants.PAGE_NAME_FOR_VIDEO)) {
      return;
    } else if (this.currentBottomIndex === PcConstants.HOME_BOTTOM_INDEX) {
      SetDecorButtonStyleUtil.setDecorButtonForImmersive(this.currentTopIndex, this.pageInfo, this.windowUtil, ctx);
    } else {
      SetDecorButtonStyleUtil.setDecorButtonForNormal(this.windowUtil, ctx);
    }
  }

  build() {
    SideBarContainer(SideBarContainerType.Embed) {
      this.SideBar()
      if (this.currentBottomIndex === PcConstants.HOME_BOTTOM_INDEX) {
        this.HomeViewContent()
      } else {
        Column()
      }
    }
    .height('100%')
    .width('100%')
    .sideBarWidth('20%')
    .showControlButton(false)
    .minSideBarWidth('240vp')
    .maxSideBarWidth('300vp')
    .autoHide(false)
    .divider(this.currentTopIndex === PcConstants.COMMUNITY_TOP_INDEX &&
      this.currentBottomIndex === PcConstants.HOME_BOTTOM_INDEX ?
      { strokeWidth: 0.2, color: $r('app.color.pc_home_content_background') } :
      { strokeWidth: 0.2, color: $r('app.color.pc_slider_bar_divider') })
  }

  @Builder
  SideBarBuilder(item: HomeFooterItemViewModel, index: number) {
    Row({ space: 10 }) {
      SymbolGlyph(item.getIcon())
        .fontSize('24fp')
        .fontColor([index !== this.currentBottomIndex ?
          (this.currentTopIndex === PcConstants.COMMUNITY_TOP_INDEX &&
            this.currentBottomIndex === PcConstants.HOME_BOTTOM_INDEX ?
            $r('app.color.pc_sidebar_icon_unselected_on_immersive') : $r('app.color.pc_sidebar_icon_unselected')) :
          $r('app.color.pc_sidebar_icon_selected')])
      Text(item.getName())
        .fontSize('18fp')
        .fontWeight(FontWeight.Medium)
        .height('24vp')
        .fontColor(index !== this.currentBottomIndex ?
          (this.currentTopIndex === PcConstants.COMMUNITY_TOP_INDEX &&
            this.currentBottomIndex === PcConstants.HOME_BOTTOM_INDEX ?
            $r('app.color.pc_sidebar_icon_unselected_on_immersive') : $r('app.color.pc_sidebar_icon_unselected')) :
          $r('app.color.pc_sidebar_icon_selected'))
    }
    .backgroundColor(this.currentBottomIndex === index ? $r('app.color.pc_sidebar_selected_background') : $r('app.color.pc_transparent'))
    .borderRadius(12)
    .width('100%')
    .height('45vp')
    .padding({ left: '20vp' })
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      this.currentBottomIndex = index;
      if (this.currentBottomIndex === PcConstants.HOME_BOTTOM_INDEX) {
        SetDecorButtonStyleUtil.setDecorButtonForImmersive(this.currentTopIndex, this.pageInfo, this.windowUtil,
          this.getUIContext().getHostContext() as common.UIAbilityContext);
      } else {
        SetDecorButtonStyleUtil.setDecorButtonForNormal(this.windowUtil,
          this.getUIContext().getHostContext() as common.UIAbilityContext);
      }
    })
  }

  @Builder
  SideBar() {
    Column() {
      Row() {
        Image($r('app.media.startIcon'))
          .width(24)
          .height(24)
          .margin({ right: 12 })
        Text($r('app.string.videoApplication'))
          .fontSize('16fp')
          .fontColor(this.currentTopIndex === PcConstants.COMMUNITY_TOP_INDEX &&
            this.currentBottomIndex === PcConstants.HOME_BOTTOM_INDEX ?
            $r('app.color.pc_text_primary_on_immersive') : $r('app.color.pc_text_primary'))
          .fontWeight(500)
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .padding({
        left: '24vp',
        top: '16vp'
      })
      .width('100%')
      .height('56vp')

      Column() {
        ForEach(this.homeFooterItemListViewModel.getItems(), (item: HomeFooterItemViewModel, index: number) => {
          ListItem() {
            this.SideBarBuilder(item, index)
          }
        }, (item: HomeFooterItemViewModel) => item.getId())
      }
      .margin('20vp')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.currentTopIndex === PcConstants.COMMUNITY_TOP_INDEX &&
      this.currentBottomIndex === PcConstants.HOME_BOTTOM_INDEX ?
      $r('app.color.pc_home_content_background') : $r('app.color.pc_slider_bar_background'))
  }

  @Builder
  HomeViewContent() {
    if (this.currentTopIndex === PcConstants.COMMUNITY_TOP_INDEX) {
      Stack() {
        MainPageView({
          mainWindowInfo: this.mainWindowInfo,
          bottomBarHeight: this.bottomBarHeight,
          scrollHeight: this.homeScrollHeight,
          hdsTabsHeight: this.hdsTabsHeight,
          hdsTabsOpacity: this.hdsTabsOpacity,
          hdsTabsAvoidHeight: this.hdsTabsAvoidHeight
        })
        PcHomeHeader({
          mainWindowInfo: this.mainWindowInfo,
          scrollHeight: this.homeScrollHeight,
          decorWidth: this.decorWidth,
          decorHeight: this.decorHeight
        })
          .opacity(this.getHomeHeaderOpacity())
      }
      .height('100%')
      .width('100%')
      .alignContent(Alignment.Top)
    } else {
      Column() {
        PcHomeHeader({
          mainWindowInfo: this.mainWindowInfo,
          scrollHeight: this.homeScrollHeight,
          decorWidth: this.decorWidth,
          decorHeight: this.decorHeight
        })
          .opacity(this.getHomeHeaderOpacity())
          .height(this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
            this.mainWindowInfo.heightBp <= HeightBreakpoint.HEIGHT_MD ? this.getHomeHeaderHeight() : 'auto')
          .padding({
            top: this.getHomeHeaderPaddingTop(),
            bottom: this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
              this.mainWindowInfo.heightBp <= HeightBreakpoint.HEIGHT_MD ? '8vp' : '0vp'
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
    this.updateHeaderStateByWindow();
    this.homeFooterItemListViewModel.loadHomeFooterData();
  }

  aboutToDisappear(): void {
    this.homeFooterItemListViewModel.clearHomeFooterData();
  }

  getHomeHeaderPaddingTop(): string | number {
    return new BreakpointType(0, 0, this.currentTopIndex === PcConstants.COMMUNITY_TOP_INDEX ? '0vp' : this.topAvoidHeight,
      this.currentTopIndex === PcConstants.COMMUNITY_TOP_INDEX ? '0vp' : this.topAvoidHeight,
      this.currentTopIndex === PcConstants.COMMUNITY_TOP_INDEX ? '0vp' : this.topAvoidHeight)
      .getValue(this.mainWindowInfo.widthBp);
  }

  getHomeHeaderOpacity(): number {
    if (this.mainWindowInfo.widthBp > WidthBreakpoint.WIDTH_SM ||
      this.mainWindowInfo.heightBp > HeightBreakpoint.HEIGHT_MD) {
      return 1;
    }
    if (this.homeScrollHeight <= 0) {
      return 1;
    }
    const ratio = 1 - this.homeScrollHeight / PcConstants.SCROLL_BAR_HIDE_THRESHOLD;
    return ratio < 0 ? 0 : ratio;
  }

  getHomeHeaderHeight(): number {
    const baseHeight = this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
      this.mainWindowInfo.heightBp >= HeightBreakpoint.HEIGHT_LG ?
      PcConstants.HOME_HEADER_HEIGHT_SM + this.topAvoidHeight :
      PcConstants.TOP_BAR_HEIGHT + this.topAvoidHeight;
    return baseHeight * this.getHomeHeaderOpacity();
  }

  updateHeaderStateByWindow(): void {
    this.topAvoidHeight = this.getUIContext().px2vp(this.mainWindowInfo.avoidSystem?.topRect.height);
    if (this.windowUtil) {
      try {
        this.decorWidth = this.windowUtil.mainWindow.getTitleButtonRect().width > 0 ?
          this.windowUtil.mainWindow.getTitleButtonRect().width : 140;
        this.decorHeight = this.windowUtil.mainWindow.getTitleButtonRect().height > 0 ?
          this.windowUtil.mainWindow.getTitleButtonRect().height : 63;
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `getTitleButtonRect failed, errCode = ${err.code}, errMessage = ${err.message}.`);
      }
    }
  }
}