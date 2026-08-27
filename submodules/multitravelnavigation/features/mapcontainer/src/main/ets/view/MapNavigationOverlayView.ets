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
import { geoLocationManager } from '@kit.LocationKit';
import { map, navi } from '@kit.MapKit';
import { Common, MapUiState, PanelMode, PanelType, WidthBreakpointType, WindowInfo } from
  'multitravelbase/Index';
import { PanelPositionController } from '../viewmodel/panel/PanelPositionController';
import { PopupPanel } from '../viewmodel/panel/PopupPanel';
import { BaseMapView } from './BaseMapView';
import { PanelView } from './PanelView';
import { hdsEffect } from '@kit.UIDesignKit';

@Component
export struct MapNavigationOverlayView {
  @StorageLink('multitravelnavigationsample_mapUiState') mapUiState: MapUiState = MapUiState.HOME;
  @Link currentLocation: geoLocationManager.Location | undefined;
  @Link mapController: map.MapComponentController | undefined;
  @ObjectLink popupPanel: PopupPanel;
  @ObjectLink panelPositionController: PanelPositionController;
  @ObjectLink mainWindowInfo: WindowInfo;
  @Require getBreakpoint: () => uiObserver.WindowSizeLayoutBreakpointInfo;
  @Prop panelVisible: boolean = true;
  @Prop isBottomSheet: boolean = false;
  onMapReady?: (mapController: map.MapComponentController) => void;
  onInitialLocationRequest?: (promise: Promise<geoLocationManager.Location | undefined>) => void;
  requestCurrentLocation?: () => Promise<geoLocationManager.Location | undefined>;
  onMapClick?: () => void;
  onMarkerClick?: (marker: map.Marker) => void;
  onRouteBack?: () => void;
  onPanelModeChange?: (mode: PanelMode) => void;
  onPanelPullStart?: () => void;
  onPanelPullUpdate?: (offsetY: number) => void;
  onPanelPullEnd?: () => void;
  onRouteReady?: (roads: navi.RouteRoad[]) => void;
  onRouteCleared?: (mapUiState?: MapUiState) => void;
  onPanelDragStart?: () => void;
  onPanelDragUpdate?: (offsetX: number) => void;
  onPanelDragEnd?: () => void;
  waitForCurrentLocation?: () => Promise<geoLocationManager.Location | undefined>;

  @Builder
  private OverlayPanel() {
    PanelView({
      mapController: this.mapController,
      popupPanel: this.popupPanel,
      mainWindowInfo: this.mainWindowInfo,
      getBreakpoint: () => this.getBreakpoint(),
      waitForCurrentLocation: this.waitForCurrentLocation,
      onPanelModeChange: this.onPanelModeChange,
      onPanelPullStart: this.onPanelPullStart,
      onPanelPullUpdate: this.onPanelPullUpdate,
      onPanelPullEnd: this.onPanelPullEnd,
      onRouteReady: this.onRouteReady,
      onRouteCleared: this.onRouteCleared
    })
    .gesture(
      PanGesture(new PanGestureOptions({
        direction: PanDirection.Left | PanDirection.Right,
        distance: 10
      }))
        .onActionStart(() => {
          this.onPanelDragStart?.();
        })
        .onActionUpdate((event?: GestureEvent) => {
          if (event) {
            this.onPanelDragUpdate?.(event.offsetX);
          }
        })
        .onActionEnd(() => {
          this.onPanelDragEnd?.();
        })
    )
    .backgroundColor($r('app.color.mapcontainer_panel_background'))
    .width(this.popupPanel.isFloating ? this.popupPanel.panelWidth : Common.FULL_WIDTH)
    .height(this.popupPanel.panelHeight)
    .borderRadius(this.popupPanel.panelRadius)
    .margin({
      bottom: this.popupPanel.panelBottomMargin,
      left: this.panelPositionController.panelLeftMargin
    })
    .visibility(this.panelVisible ? Visibility.Visible : Visibility.None)
  }

  @Builder
  private MapDimMask() {
    Row()
      .width(Common.FULL_WIDTH)
      .height(Common.FULL_HEIGHT)
      .backgroundColor($r('app.color.mapcontainer_dim_mask'))
      .opacity((this.isBottomSheet && this.popupPanel.panelMode === PanelMode.High) ? 0.4 : 0)
      .hitTestBehavior(HitTestMode.None)
  }

  @Builder
  private BackButton() {
    Button({ type: ButtonType.Circle }) {
      SymbolGlyph($r('sys.symbol.chevron_backward'))
        .fontSize(24)
        .fontColor([$r('sys.color.icon_primary')])
    }
    .width(42)
    .height(42)
    .backgroundColor($r('app.color.back_background'))
    .backdropBlur(10)
    .visibility((this.mapUiState === MapUiState.ROUTE_PLAN && this.popupPanel.panelType !== PanelType.None) ?
      Visibility.Visible : Visibility.None)
    .margin({
      top: this.getUIContext().px2vp(this.mainWindowInfo.avoidSystem?.topRect.height ?? 0) + 16,
      left: new WidthBreakpointType(16, 24, 32, 32).getValue(this.getBreakpoint().widthBreakpoint)
    })
    .onClick(() => {
      this.onRouteBack?.();
    })
  }

  build() {
    Stack({ alignContent: Alignment.BottomStart }) {
      Stack({ alignContent: Alignment.TopStart }) {
        Column() {
          BaseMapView({
            mapController: this.mapController,
            currentLocation: this.currentLocation,
            mainWindowInfo: this.mainWindowInfo,
            isBottomSheet: this.isBottomSheet,
            onMapReady: this.onMapReady,
            onInitialLocationRequest: this.onInitialLocationRequest,
            requestCurrentLocation: this.requestCurrentLocation,
            onMapClick: this.onMapClick,
            onMarkerClick: this.onMarkerClick
          })
        }
        .width('100%')
        .height('100%')
        .clip(true)
        this.MapDimMask()
        this.BackButton()
      }
      .width('100%')
      .height('100%')
      this.OverlayPanel()
    }
  }
}
