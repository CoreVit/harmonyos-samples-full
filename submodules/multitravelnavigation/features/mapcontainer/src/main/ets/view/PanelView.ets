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
import { map, navi } from '@kit.MapKit';
import { geoLocationManager } from '@kit.LocationKit';
import { Common, MapUiState, PanelMode, PanelRouteName, PanelType, WindowInfo } from 'multitravelbase/Index';
import { PopupPanel } from '../viewmodel/panel/PopupPanel';
import { HomePanelView, RoutePlanView, SearchResultListView, SearchViewModel, SiteDetailPageViewModel,
  SiteDetailView, TabView } from 'poiexplore';

const PANEL_DRAG_RESPONSE_HEIGHT: number = 96;

@Component
export struct PanelView {
  @StorageLink('multitravelnavigationsample_mapUiState') mapUiState: MapUiState = MapUiState.HOME;
  @Consume('pageInfo') pageInfo: NavPathStack;
  @ObjectLink popupPanel: PopupPanel;
  @ObjectLink mainWindowInfo: WindowInfo;
  @Link mapController: map.MapComponentController;
  @Require getBreakpoint: () => uiObserver.WindowSizeLayoutBreakpointInfo;
  waitForCurrentLocation?: () => Promise<geoLocationManager.Location | undefined>;
  onPanelModeChange?: (mode: PanelMode) => void;
  onPanelPullStart?: () => void;
  onPanelPullUpdate?: (offsetY: number) => void;
  onPanelPullEnd?: () => void;
  onRouteReady?: (roads: navi.RouteRoad[]) => void;
  onRouteCleared?: (mapUiState?: MapUiState) => void;
  @State searchViewModel: SearchViewModel = new SearchViewModel();
  @State siteDetailViewModel: SiteDetailPageViewModel = new SiteDetailPageViewModel();
  private panOptionHeight: PanGestureOptions = new PanGestureOptions({
    direction: PanDirection.Up | PanDirection.Down
  });

  private getPanelGradient(): LinearGradientOptions {
    if (this.mapUiState !== MapUiState.SITE_DETAIL) {
      return {
        direction: GradientDirection.Bottom,
        colors: [
          [$r('app.color.mapcontainer_panel_gradient_background'), 0.0],
          [$r('app.color.mapcontainer_panel_gradient_background'), 1.0]
        ]
      };
    }
    return {
      direction: GradientDirection.RightBottom,
      colors: [
        [$r('app.color.mapcontainer_panel_site_gradient_start'), 0.0],
        [$r('app.color.mapcontainer_panel_site_gradient_mid'), 0.5],
        [$r('app.color.mapcontainer_panel_site_gradient_end'), 1.0]
      ]
    };
  }

  @Builder
  private PageMap(name: string) {
    if (name === PanelRouteName.SEARCH_RESULT) {
      NavDestination() {
        SearchResultListView({
          mapController: this.mapController,
          searchViewModel: this.searchViewModel,
          waitForCurrentLocation: this.waitForCurrentLocation,
          panelMode: this.popupPanel.panelMode,
          panelType: this.popupPanel.panelType,
          getBreakpoint: () => this.getBreakpoint(),
          onPanelModeChange: this.onPanelModeChange,
          onPanelPullStart: this.onPanelPullStart,
          onPanelPullUpdate: this.onPanelPullUpdate,
          onPanelPullEnd: this.onPanelPullEnd
        })
      }
      .backgroundColor(Color.Transparent)
      .hideTitleBar(true)
      .hideToolBar(true)
      .hideBackButton(true)
    } else if (name === PanelRouteName.SITE_DETAIL) {
      NavDestination() {
        SiteDetailView({
          mainWindowInfo: this.mainWindowInfo,
          mapController: this.mapController,
          viewModel: this.siteDetailViewModel,
          panelMode: this.popupPanel.panelMode,
          panelType: this.popupPanel.panelType,
          isFloating: this.popupPanel.isFloating,
          onPanelPullStart: this.onPanelPullStart,
          onPanelPullUpdate: this.onPanelPullUpdate,
          onPanelPullEnd: this.onPanelPullEnd
        })
      }
      .backgroundColor(Color.Transparent)
      .hideTitleBar(true)
      .hideToolBar(true)
      .hideBackButton(true)
    } else if (name === PanelRouteName.ROUTE_PLAN) {
      NavDestination() {
        RoutePlanView({
          panelType: this.popupPanel.panelType,
          panelMode: this.popupPanel.panelMode,
          isFloating: this.popupPanel.isFloating,
          mainWindowInfo: this.mainWindowInfo,
          getBreakpoint: () => this.getBreakpoint(),
          waitForCurrentLocation: this.waitForCurrentLocation,
          onPanelModeChange: this.onPanelModeChange,
          onPanelPullStart: this.onPanelPullStart,
          onPanelPullUpdate: this.onPanelPullUpdate,
          onPanelPullEnd: this.onPanelPullEnd,
          onRouteReady: this.onRouteReady,
          onRouteCleared: this.onRouteCleared,
          mapController: this.mapController
        })
      }
      .backgroundColor(Color.Transparent)
      .onAppear(() => {
        if (this.popupPanel.panelMode === PanelMode.High) {
          this.onPanelModeChange?.(PanelMode.Half);
        }
      })
      .hideTitleBar(true)
      .hideToolBar(true)
      .hideBackButton(true)
    }
  }

  @Builder
  EmbeddedContent() {
    Navigation(this.pageInfo) {
      HomePanelView({
        mapController: this.mapController,
        searchViewModel: this.searchViewModel,
        waitForCurrentLocation: this.waitForCurrentLocation,
        panelMode: this.popupPanel.panelMode,
        panelType: this.popupPanel.panelType,
        onPanelModeChange: this.onPanelModeChange,
        onPanelPullStart: this.onPanelPullStart,
        onPanelPullUpdate: this.onPanelPullUpdate,
        onPanelPullEnd: this.onPanelPullEnd
      })
    }
    .hideToolBar(true)
    .hideTitleBar(true)
    .hideBackButton(true)
    .backgroundColor(Color.Transparent)
    .navDestination(this.PageMap)
    .width(Common.FULL_WIDTH)
    .layoutWeight(1)
  }

  @Builder
  OverlayContent() {
    Navigation(this.pageInfo) {
      TabView({
        mapController: this.mapController,
        searchViewModel: this.searchViewModel,
        waitForCurrentLocation: this.waitForCurrentLocation,
        panelMode: this.popupPanel.panelMode,
        panelType: this.popupPanel.panelType,
        panelWidth: this.popupPanel.panelWidth,
        mainWindowInfo: this.mainWindowInfo,
        onPanelModeChange: this.onPanelModeChange,
        onPanelPullStart: this.onPanelPullStart,
        onPanelPullUpdate: this.onPanelPullUpdate,
        onPanelPullEnd: this.onPanelPullEnd
      })
    }
    .hideToolBar(true)
    .hideTitleBar(true)
    .hideBackButton(true)
    .backgroundColor(Color.Transparent)
    .navDestination(this.PageMap)
    .width(Common.FULL_WIDTH)
    .layoutWeight(1)
  }

  build() {
    Column() {
      if (this.popupPanel.panelType !== PanelType.None) {
        Row() {
          Divider()
            .margin({ top: 6 })
            .strokeWidth(4)
            .color($r('sys.color.icon_fourth'))
            .width(48)
            .lineCap(LineCapStyle.Round)
        }
        .height($r('app.float.panel_drag_area_height'))
        .width('100%')
        .alignItems(VerticalAlign.Top)
        .justifyContent(FlexAlign.Center)
        .responseRegion({
          x: 0,
          y: 0,
          width: Common.FULL_WIDTH,
          height: PANEL_DRAG_RESPONSE_HEIGHT
        })
        .gesture(
          PanGesture(this.panOptionHeight)
            .onActionStart(() => {
              this.onPanelPullStart?.();
            })
            .onActionUpdate((event?: GestureEvent) => {
              if (event) {
                this.onPanelPullUpdate?.(event.offsetY);
              }
            })
            .onActionEnd(() => {
              this.onPanelPullEnd?.();
            })
        )
      } else {
        Row() {
          Image($r('app.media.startIcon'))
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
          Text($r('app.string.panel_title'))
            .fontSize(16)
            .margin({left: 12})
        }
        .width('100%')
        .height(59)
        .padding({
          left: 24,
          top: 17.5,
          bottom: 17.5
        })
        .margin({bottom: 8})
        .justifyContent(FlexAlign.Start)
      }

      if (this.mapController) {
        if (this.popupPanel.panelType === PanelType.None) {
          this.EmbeddedContent()
        } else {
          this.OverlayContent()
        }
      } else {
        Blank()
          .width(Common.FULL_WIDTH)
          .height(Common.FULL_HEIGHT)
          .layoutWeight(1)
      }
    }
    .borderRadius(this.popupPanel.panelRadius)
    .clip(true)
    .linearGradient(this.getPanelGradient())
    .width(this.popupPanel.isFloating ? this.popupPanel.panelWidth : Common.FULL_WIDTH)
    .height(this.popupPanel.panelType === PanelType.None ? '100%' : this.popupPanel.panelHeight)
  }
}
