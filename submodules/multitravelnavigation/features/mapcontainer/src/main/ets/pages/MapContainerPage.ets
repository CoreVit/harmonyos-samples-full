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

import { KeyboardAvoidMode, uiObserver } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { inputMethod } from '@kit.IMEKit';
import { geoLocationManager } from '@kit.LocationKit';
import { map, navi, site } from '@kit.MapKit';
import { Logger, LocationPermissionStatus, LocationRequestResult, LocationUtil, MapUiState, PanelMode, PanelRouteName,
  SelectedSite, WindowInfo } from 'multitravelbase/Index';
import { PanelInteractionController } from '../viewmodel/panel/PanelInteractionController';
import { PanelPositionController } from '../viewmodel/panel/PanelPositionController';
import { PopupPanel } from '../viewmodel/panel/PopupPanel';
import { MapPaddingState, MapViewportCoordinator } from '../model/MapViewportCoordinator';
import { MapContainerPageViewModel } from '../viewmodel/MapContainerPageViewModel';
import { MapNavigationEmbeddedView } from '../view/MapNavigationEmbeddedView';
import { MapNavigationOverlayView } from '../view/MapNavigationOverlayView';
import { PcDecorativeToolbar } from '../view/PcDecorativeToolbar';
import { LocationPermissionTipView } from '../view/LocationPermissionTipView';

const PANEL_SNAP_ANIMATION_DURATION: number = 220;
const TAG = 'MapContainerPage';

@Component
export struct MapContainerPage {
  @StorageLink('multitravelnavigationsample_currentLocation')
  currentLocation: geoLocationManager.Location | undefined = undefined;
  @Watch('syncMapContent') @StorageLink('multitravelnavigationsample_mapUiState')
  mapUiState: MapUiState = MapUiState.HOME;
  @Watch('syncMapContent') @StorageLink('multitravelnavigationsample_selectedSite')
  selectedSite: SelectedSite | undefined = undefined;
  @Watch('syncMapContent') @StorageLink('multitravelnavigationsample_sites') sites: site.Site[] | undefined = [];
  @Provide('pageInfo') pageInfo: NavPathStack = new NavPathStack();
  @ObjectLink mainWindowInfo: WindowInfo;
  @Prop layoutMode: string = 'overlay';
  @Require getBreakpoint: () => uiObserver.WindowSizeLayoutBreakpointInfo;
  @State popupPanel: PopupPanel = new PopupPanel();
  @State panelPositionController: PanelPositionController = new PanelPositionController();
  @State mapController: map.MapComponentController | undefined = undefined;
  @State mapPadding: MapPaddingState = { left: 0, right: 0, bottom: 0 };
  @State activeRouteRoads: navi.RouteRoad[] = [];
  @State panelVisible: boolean = true;
  @State showLocationPermissionTip: boolean = false;
  @State locationPermissionStatus: LocationPermissionStatus = LocationPermissionStatus.DENIED;
  @State pageViewModel: MapContainerPageViewModel = new MapContainerPageViewModel();
  @State panelInteractionController: PanelInteractionController = new PanelInteractionController();
  @State mapViewportCoordinator: MapViewportCoordinator = new MapViewportCoordinator();
  private initialLocationPromise: Promise<geoLocationManager.Location | undefined> | undefined = undefined;
  private locationEnabledChangeCallback: (enabled: boolean) => void = (enabled: boolean) => {
    this.handleLocationEnabledChange(enabled);
  };

  private isBottomSheet(): boolean {
    let widthBreakpoint: WidthBreakpoint = this.getBreakpoint().widthBreakpoint;
    return widthBreakpoint === WidthBreakpoint.WIDTH_XS || widthBreakpoint === WidthBreakpoint.WIDTH_SM;
  }

  private isEmbeddedLayout(): boolean {
    return this.layoutMode === 'embedded';
  }

  private syncPanelLayout(): void {
    let breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo = this.getBreakpoint();
    this.popupPanel.updateLayout(this.getUIContext(), this.mainWindowInfo, this.layoutMode,
      breakpoint.widthBreakpoint, breakpoint.heightBreakpoint);
    this.panelPositionController.updateLayout(this.layoutMode, this.popupPanel.panelType, this.popupPanel.panelWidth,
      this.getUIContext().px2vp(this.mainWindowInfo.windowSize.width), breakpoint.widthBreakpoint);
    this.syncMapPaddingWithPanel();
  }

  aboutToAppear(): void {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.NONE);
    this.subscribeLocationEnabledChange();
    this.syncPanelLayout();
    this.pageInfo.disableAnimation(true);
  }

  aboutToDisappear(): void {
    this.unsubscribeLocationEnabledChange();
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.OFFSET);
  }

  private updatePanelVisible(visible: boolean): void {
    this.panelVisible = visible;
  }

  private updateActiveRouteRoads(roads: navi.RouteRoad[]): void {
    this.activeRouteRoads = roads;
  }

  private ensurePanelVisibleForState(): void {
    this.panelInteractionController.ensurePanelVisible({
      mapUiState: this.mapUiState,
      panelVisible: this.panelVisible,
      onPanelVisibleChange: (visible: boolean) => this.updatePanelVisible(visible)
    });
  }

  private togglePanelVisibility(): void {
    this.panelInteractionController.togglePanelVisibility({
      mapUiState: this.mapUiState,
      panelVisible: this.panelVisible,
      onPanelVisibleChange: (visible: boolean) => this.updatePanelVisible(visible)
    });
    this.syncMapPaddingWithPanel();
  }

  private openSearchMarkerSite(marker: map.Marker): void {
    if (this.mapUiState !== MapUiState.SEARCH_RESULT) {
      return;
    }
    let selectedSite: site.Site | undefined = this.pageViewModel.getSearchSiteByMarker(marker);
    if (!selectedSite) {
      return;
    }
    this.selectedSite = this.pageViewModel.toSelectedSite(selectedSite);
    this.mapUiState = MapUiState.SITE_DETAIL;
    this.pageInfo.pushPathByName(PanelRouteName.SITE_DETAIL, undefined);
  }

  private setPanelMode(mode: PanelMode): void {
    if (this.popupPanel.panelMode === PanelMode.High && mode !== PanelMode.High) {
      this.dismissKeyboard();
    }
    this.getUIContext().animateTo({
      duration: PANEL_SNAP_ANIMATION_DURATION,
      curve: Curve.EaseOut
    }, () => {
      if (!this.panelInteractionController.setPanelMode(this.layoutMode, this.popupPanel, mode,
        (visible: boolean) => this.updatePanelVisible(visible))) {
        return;
      }
      this.syncPanelLayout();
    });
  }

  private beginPanelPull(): void {
    if (this.popupPanel.panelMode === PanelMode.High) {
      this.dismissKeyboard();
    }
    this.panelInteractionController.beginPanelPull(this.layoutMode, this.popupPanel,
      (visible: boolean) => this.updatePanelVisible(visible));
  }

  private dismissKeyboard(): void {
    try {
      inputMethod.getController().stopInputSession().catch((err: BusinessError) => {
        Logger.info(TAG, `dismiss keyboard failed, error code=${err.code}, message=${err.message}`);
      });
    } catch (error) {
      let err = error as BusinessError;
      Logger.info(TAG, `dismiss keyboard failed, error code=${err.code}, message=${err.message}`);
    }
  }

  private updatePanelPull(offsetY: number): void {
    if (!this.panelInteractionController.updatePanelPull(this.layoutMode, this.popupPanel, offsetY)) {
      return;
    }
    this.syncMapPaddingWithPanel();
  }

  private endPanelPull(): void {
    this.getUIContext().animateTo({
      duration: PANEL_SNAP_ANIMATION_DURATION,
      curve: Curve.EaseOut
    }, () => {
      if (!this.panelInteractionController.endPanelPull(this.layoutMode, this.popupPanel)) {
        return;
      }
      this.syncPanelLayout();
    });
  }

  private syncMapPaddingWithPanel(): void {
    let windowWidth: number = this.getUIContext().px2vp(this.mainWindowInfo.windowSize.width);
    this.mapPadding = this.mapViewportCoordinator.calculateMapPadding({
      layoutMode: this.layoutMode,
      panelType: this.popupPanel.panelType,
      panelMode: this.popupPanel.panelMode,
      panelVisible: this.panelVisible,
      panelHeight: this.popupPanel.panelHeight,
      panelBottomMargin: this.popupPanel.panelBottomMargin,
      panelWidth: this.popupPanel.panelWidth,
      panelLeftMargin: this.panelPositionController.panelLeftMargin,
      windowWidth,
      floating: this.popupPanel.isFloating,
      isRightAligned: this.panelPositionController.isRightAligned()
    });

    this.mapViewportCoordinator.syncZoomControls(this.mapController, this.isBottomSheet());
    this.mapViewportCoordinator.applyMapPadding(this.mapController, this.mapPadding,
      (value: number) => this.getUIContext().vp2px(value));
  }

  private canDragPanelPosition(): boolean {
    return this.panelPositionController.canDrag(this.layoutMode, this.isBottomSheet(), this.popupPanel.panelType);
  }

  private beginPanelPositionDrag(): void {
    if (!this.canDragPanelPosition()) {
      return;
    }
    this.panelPositionController.beginDrag();
  }

  private updatePanelPositionDrag(offsetX: number): void {
    if (!this.canDragPanelPosition()) {
      return;
    }
    this.panelPositionController.updateDrag(offsetX);
    this.syncMapPaddingWithPanel();
  }

  private endPanelPositionDrag(): void {
    if (!this.canDragPanelPosition()) {
      return;
    }
    this.panelPositionController.endDrag();
    this.syncMapPaddingWithPanel();
  }

  private syncMapContent(): void {
    this.pageViewModel.syncMapContent({
      mapController: this.mapController,
      mapUiState: this.mapUiState,
      selectedSite: this.selectedSite,
      sites: this.sites,
      activeRouteRoads: this.activeRouteRoads,
      onEnsurePanelVisible: () => this.ensurePanelVisibleForState()
    });
  }

  private showRoute(roads: navi.RouteRoad[]): void {
    this.pageViewModel.showRoute({
      roads,
      mapController: this.mapController,
      selectedSite: this.selectedSite,
      mapUiState: this.mapUiState,
      sites: this.sites,
      onEnsurePanelVisible: () => this.ensurePanelVisibleForState(),
      onActiveRouteRoadsChange: (activeRouteRoads: navi.RouteRoad[]) =>
        this.updateActiveRouteRoads(activeRouteRoads)
    });
  }

  private clearRoute(mapUiState: MapUiState = this.mapUiState): void {
    this.pageViewModel.clearRoute({
      mapController: this.mapController,
      selectedSite: this.selectedSite,
      mapUiState,
      sites: this.sites,
      onEnsurePanelVisible: () => this.ensurePanelVisibleForState(),
      onActiveRouteRoadsChange: (activeRouteRoads: navi.RouteRoad[]) =>
        this.updateActiveRouteRoads(activeRouteRoads)
    });
  }

  private handleMapReady(mapController: map.MapComponentController): void {
    this.mapController = mapController;
    this.syncPanelLayout();
    this.syncMapContent();
    if (this.activeRouteRoads.length > 0) {
      this.pageViewModel.focusRoute(this.mapController, this.activeRouteRoads);
    }
  }

  private handleInitialLocationRequest(promise: Promise<geoLocationManager.Location | undefined>): void {
    this.initialLocationPromise = promise;
    promise.finally(() => {
      if (this.initialLocationPromise === promise) {
        this.initialLocationPromise = undefined;
      }
    });
  }

  private async waitForCurrentLocation(): Promise<geoLocationManager.Location | undefined> {
    if (this.currentLocation) {
      return this.currentLocation;
    }
    if (this.initialLocationPromise) {
      return this.initialLocationPromise;
    }
    return this.requestCurrentLocation();
  }

  private async requestCurrentLocation(): Promise<geoLocationManager.Location | undefined> {
    let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let result: LocationRequestResult = await LocationUtil.getLocationWithPermissionResult(context);
    this.updateLocationPermissionTip(result);
    return result.location;
  }

  private updateLocationPermissionTip(result: LocationRequestResult): void {
    if (result.location) {
      this.showLocationPermissionTip = false;
      return;
    }
    this.locationPermissionStatus = result.status;
    this.showLocationPermissionTip = result.status === LocationPermissionStatus.DENIED ||
      result.status === LocationPermissionStatus.LOCATION_SWITCH_OFF;
  }

  private subscribeLocationEnabledChange(): void {
    try {
      geoLocationManager.on('locationEnabledChange', this.locationEnabledChangeCallback);
    } catch (error) {
      let err = error as BusinessError;
      Logger.info(TAG, `subscribe location enabled change failed, error code=${err.code}, message=${err.message}`);
    }
  }

  private unsubscribeLocationEnabledChange(): void {
    try {
      geoLocationManager.off('locationEnabledChange', this.locationEnabledChangeCallback);
    } catch (error) {
      let err = error as BusinessError;
      Logger.info(TAG, `unsubscribe location enabled change failed, error code=${err.code}, message=${err.message}`);
    }
  }

  private handleLocationEnabledChange(enabled: boolean): void {
    if (!enabled || this.locationPermissionStatus !== LocationPermissionStatus.LOCATION_SWITCH_OFF) {
      return;
    }
    this.showLocationPermissionTip = false;
    void this.retryCurrentLocation();
  }

  private async retryCurrentLocation(): Promise<void> {
    let location: geoLocationManager.Location | undefined = await this.requestCurrentLocation();
    if (location) {
      this.currentLocation = location;
    }
  }

  private getLocationTipTopMargin(): number {
    return this.getUIContext().px2vp(this.mainWindowInfo.avoidSystem?.topRect.height ?? 0) + 12;
  }

  @Builder
  private LocationPermissionTip() {
    LocationPermissionTipView({
      status: this.locationPermissionStatus,
      onRetry: () => {
        this.showLocationPermissionTip = false;
        void this.retryCurrentLocation();
      },
      onClose: () => {
        this.showLocationPermissionTip = false;
      }
    })
      .width(this.isEmbeddedLayout() ? 420 : 'calc(100% - 32vp)')
      .margin({
        top: this.getLocationTipTopMargin(),
        left: this.isEmbeddedLayout() ? 24 : 16,
        right: this.isEmbeddedLayout() ? 0 : 16
      })
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Column() {
        if (this.isEmbeddedLayout()) {
          MapNavigationEmbeddedView({
            currentLocation: this.currentLocation,
            mapController: this.mapController,
            popupPanel: this.popupPanel,
            mainWindowInfo: this.mainWindowInfo,
            getBreakpoint: () => this.getBreakpoint(),
            panelVisible: this.panelVisible,
            isBottomSheet: this.isBottomSheet(),
            onMapReady: (mapController: map.MapComponentController) => this.handleMapReady(mapController),
            onInitialLocationRequest: (promise: Promise<geoLocationManager.Location | undefined>) =>
              this.handleInitialLocationRequest(promise),
            requestCurrentLocation: () => this.requestCurrentLocation(),
            waitForCurrentLocation: () => this.waitForCurrentLocation(),
            onMapClick: () => this.togglePanelVisibility(),
            onMarkerClick: (marker: map.Marker) => this.openSearchMarkerSite(marker),
            onSideBarChange: (isShow: boolean) => {
              this.panelVisible = isShow;
              this.syncMapPaddingWithPanel();
            },
            onRouteReady: (roads: navi.RouteRoad[]) => this.showRoute(roads),
            onRouteCleared: (mapUiState?: MapUiState) => this.clearRoute(mapUiState)
          })
        } else {
          MapNavigationOverlayView({
            currentLocation: this.currentLocation,
            mapController: this.mapController,
            popupPanel: this.popupPanel,
            panelPositionController: this.panelPositionController,
            mainWindowInfo: this.mainWindowInfo,
            getBreakpoint: () => this.getBreakpoint(),
            panelVisible: this.panelVisible,
            isBottomSheet: this.isBottomSheet(),
            onMapReady: (mapController: map.MapComponentController) => this.handleMapReady(mapController),
            onInitialLocationRequest: (promise: Promise<geoLocationManager.Location | undefined>) =>
              this.handleInitialLocationRequest(promise),
            requestCurrentLocation: () => this.requestCurrentLocation(),
            waitForCurrentLocation: () => this.waitForCurrentLocation(),
            onMapClick: () => this.togglePanelVisibility(),
            onMarkerClick: (marker: map.Marker) => this.openSearchMarkerSite(marker),
            onRouteBack: () => {
              this.mapUiState = MapUiState.SITE_DETAIL;
              this.clearRoute(MapUiState.SITE_DETAIL);
              this.pageInfo.pop();
            },
            onPanelModeChange: (mode: PanelMode) => this.setPanelMode(mode),
            onPanelPullStart: () => this.beginPanelPull(),
            onPanelPullUpdate: (offsetY: number) => this.updatePanelPull(offsetY),
            onPanelPullEnd: () => this.endPanelPull(),
            onRouteReady: (roads: navi.RouteRoad[]) => this.showRoute(roads),
            onRouteCleared: (mapUiState?: MapUiState) => this.clearRoute(mapUiState),
            onPanelDragStart: () => this.beginPanelPositionDrag(),
            onPanelDragUpdate: (offsetX: number) => this.updatePanelPositionDrag(offsetX),
            onPanelDragEnd: () => this.endPanelPositionDrag()
          })
        }
      }
      .height('100%')
      .width('100%')
      if (this.isEmbeddedLayout()) {
        PcDecorativeToolbar({ mainWindowInfo: this.mainWindowInfo })
      }
      if (this.showLocationPermissionTip) {
        this.LocationPermissionTip()
      }
    }
    .height('100%')
    .width('100%')
    .onAreaChange(() => {
      this.syncPanelLayout();
    })
  }
}
