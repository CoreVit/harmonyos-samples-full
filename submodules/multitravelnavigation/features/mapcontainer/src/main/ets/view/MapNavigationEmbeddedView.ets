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
import { WindowInfo } from 'multitravelbase/Index';
import { PopupPanel } from '../viewmodel/panel/PopupPanel';
import { BaseMapView } from './BaseMapView';
import { PanelView } from './PanelView';

@Component
export struct MapNavigationEmbeddedView {
  @Link currentLocation: geoLocationManager.Location | undefined;
  @Link mapController: map.MapComponentController | undefined;
  @ObjectLink popupPanel: PopupPanel;
  @ObjectLink mainWindowInfo: WindowInfo;
  @Require getBreakpoint: () => uiObserver.WindowSizeLayoutBreakpointInfo;
  @Prop panelVisible: boolean = true;
  @Prop isBottomSheet: boolean = false;
  onMapReady?: (mapController: map.MapComponentController) => void;
  onInitialLocationRequest?: (promise: Promise<geoLocationManager.Location | undefined>) => void;
  requestCurrentLocation?: () => Promise<geoLocationManager.Location | undefined>;
  onMapClick?: () => void;
  onMarkerClick?: (marker: map.Marker) => void;
  onSideBarChange?: (isShow: boolean) => void;
  onRouteReady?: (roads: navi.RouteRoad[]) => void;
  onRouteCleared?: () => void;
  waitForCurrentLocation?: () => Promise<geoLocationManager.Location | undefined>;

  @Builder
  private EmbeddedSideBar() {
    Column() {
      PanelView({
        mapController: this.mapController,
        popupPanel: this.popupPanel,
        mainWindowInfo: this.mainWindowInfo,
        getBreakpoint: () => this.getBreakpoint(),
        waitForCurrentLocation: this.waitForCurrentLocation,
        onRouteReady: this.onRouteReady,
        onRouteCleared: this.onRouteCleared
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.input_area'))
  }

  @Builder
  private EmbeddedMainContent() {
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
    .backgroundColor($r('app.color.white'))
    .padding(0)
  }

  build() {
    SideBarContainer(SideBarContainerType.Overlay) {
      this.EmbeddedSideBar()
      this.EmbeddedMainContent()
    }
    .showSideBar(this.panelVisible)
    .onChange((isShow: boolean) => {
      this.onSideBarChange?.(isShow);
    })
    .sideBarWidth(360)
    .showControlButton(true)
    .controlButton({
      top: 17.5,
      left: this.panelVisible ? 312 : 24,
      height: 24,
      width: 24,
      icons: {
        shown: $r('sys.symbol.close_sidebar'),
        hidden: $r('sys.symbol.open_sidebar'),
      }
    })
    .autoHide(false)
  }
}
