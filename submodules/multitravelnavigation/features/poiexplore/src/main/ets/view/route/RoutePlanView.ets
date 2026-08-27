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
import { common } from '@kit.AbilityKit';
import { geoLocationManager } from '@kit.LocationKit';
import { map, navi } from '@kit.MapKit';
import { LiveViewController } from 'maplive/Index';
import { Common, Logger, MapUiState, PanelType, PanelMode, SelectedSite, WidthBreakpointType, WindowInfo } from
  'multitravelbase/Index';
import { PanelGestureCoordinator } from '../gesture/PanelGestureCoordinator';
import { RoutePlanViewModel } from '../../viewmodel/RoutePlanViewModel';
import { RoutePlanContentView } from './RoutePlanContentView';

const TAG = 'RoutePlanView';

@Component
export struct RoutePlanView {
  @StorageLink('multitravelnavigationsample_mapUiState') mapUiState: MapUiState = MapUiState.HOME;
  @StorageLink('multitravelnavigationsample_currentLocation')
  currentLocation: geoLocationManager.Location | undefined = undefined;
  @StorageLink('multitravelnavigationsample_selectedSite') selectedSite: SelectedSite | undefined = undefined;
  @Consume('pageInfo') pageInfo: NavPathStack;
  @ObjectLink mainWindowInfo: WindowInfo;
  @State selectedTabIndex: number = 0;
  @Prop panelType: PanelType = PanelType.Normal;
  @Prop isFloating: boolean = false;
  @Watch('onPanelModeChanged') @Prop panelMode: PanelMode = PanelMode.Half;
  @Require getBreakpoint: () => uiObserver.WindowSizeLayoutBreakpointInfo;
  waitForCurrentLocation?: () => Promise<geoLocationManager.Location | undefined>;
  @Link mapController: map.MapComponentController | undefined;
  onPanelModeChange?: (mode: PanelMode) => void;
  onPanelPullStart?: () => void;
  onPanelPullUpdate?: (offsetY: number) => void;
  onPanelPullEnd?: () => void;
  onRouteReady?: (roads: navi.RouteRoad[]) => void;
  onRouteCleared?: (mapUiState?: MapUiState) => void;
  @State viewModel: RoutePlanViewModel = new RoutePlanViewModel();
  private isPageActive: boolean = false;
  private isLiveViewStarting: boolean = false;
  private isLiveViewStarted: boolean = false;
  private liveViewRequestToken: number = 0;
  private panelGestureCoordinator: PanelGestureCoordinator = new PanelGestureCoordinator();

  aboutToAppear(): void {
    this.isPageActive = true;
    this.mapUiState = MapUiState.ROUTE_PLAN;
    this.selectedTabIndex = 0;
    this.onRouteCleared?.(MapUiState.ROUTE_PLAN);
    this.onPanelModeChanged();
    this.viewModel.loadRoutes(this.selectedSite, this.currentLocation, this.waitForCurrentLocation,
      (location: geoLocationManager.Location) => this.currentLocation = location)
      .then((roads: navi.RouteRoad[] | undefined) => {
        if (!this.isPageActive || !roads || roads.length === 0) {
          return;
        }
        this.onRouteReady?.(roads);
      });
  }

  aboutToDisappear(): void {
    this.isPageActive = false;
    this.stopRouteLiveView();
    this.onRouteCleared?.(MapUiState.SITE_DETAIL);
    this.mapUiState = MapUiState.SITE_DETAIL;
  }

  private onPanelModeChanged(): void {
    if (this.panelMode === PanelMode.High) {
      this.panelGestureCoordinator.reachTop();
    }
  }

  private getBottomAvoid(): number {
    return this.getUIContext().px2vp(this.mainWindowInfo.avoidNavigationIndicator?.bottomRect.height ?? 0);
  }

  private backToSiteDetail(): void {
    this.isPageActive = false;
    this.stopRouteLiveView();
    this.onRouteCleared?.(MapUiState.SITE_DETAIL);
    this.mapUiState = MapUiState.SITE_DETAIL;
    this.pageInfo.pop();
  }

  private getAbilityContext(): common.UIAbilityContext | undefined {
    return this.getUIContext().getHostContext() as common.UIAbilityContext | undefined;
  }

  private showToast(message: Resource): void {
    void this.getUIContext().getPromptAction().openToast({
      message,
      duration: 1500
    }).catch((err: Error) => {
      Logger.error(TAG, `showToast failed, message=${err.message}`);
    });
  }

  private startRouteLiveView(): void {
    if (this.isLiveViewStarting || this.isLiveViewStarted) {
      this.showToast($r('app.string.live_view_started_toast'));
      return;
    }
    const context: common.UIAbilityContext | undefined = this.getAbilityContext();
    if (!context) {
      Logger.error(TAG, 'startRouteLiveView failed, context is undefined');
      return;
    }
    const token: number = ++this.liveViewRequestToken;
    this.isLiveViewStarting = true;
    void LiveViewController.startLiveView(context).then(() => {
      this.isLiveViewStarting = false;
      this.isLiveViewStarted = true;
      this.showToast($r('app.string.live_view_started_toast'));
      if (!this.isPageActive || token !== this.liveViewRequestToken) {
        this.stopRouteLiveView();
      }
    }).catch((err: Error) => {
      this.isLiveViewStarting = false;
      Logger.error(TAG, `startLiveView failed, message=${err.message}`);
      this.showToast($r('app.string.live_view_start_failed_toast'));
    });
  }

  private stopRouteLiveView(): void {
    const shouldStop: boolean = this.isLiveViewStarting || this.isLiveViewStarted;
    this.liveViewRequestToken++;
    this.isLiveViewStarting = false;
    this.isLiveViewStarted = false;
    if (!shouldStop) {
      return;
    }
    const context: common.UIAbilityContext | undefined = this.getAbilityContext();
    if (!context) {
      Logger.error(TAG, 'stopRouteLiveView failed, context is undefined');
      return;
    }
    void LiveViewController.stopLiveView(context).catch((err: Error) => {
      Logger.error(TAG, `stopLiveView failed, message=${err.message}`);
    });
  }

  private shouldShowBottomActions(): boolean {
    return this.panelType === PanelType.Mini ||
      (this.panelType === PanelType.Normal && this.panelMode !== PanelMode.Low);
  }

  build() {
    Column() {
      Column() {
        RoutePlanContentView({
          viewModel: this.viewModel,
          selectedTabIndex: this.selectedTabIndex,
          panelType: this.panelType,
          panelMode: this.panelMode,
          selectedSite: this.selectedSite,
          showBottomActions: this.shouldShowBottomActions(),
          onBack: () => this.backToSiteDetail(),
          onStartNavigate: () => this.startRouteLiveView(),
          onReachStart: () => this.panelGestureCoordinator.reachTop(),
          onDidScroll: (scrollOffset: number) => this.panelGestureCoordinator.updateVerticalOffset(scrollOffset)
        })
      }
      .alignItems(HorizontalAlign.Start)
      .width(Common.FULL_WIDTH)
    }
    .padding({ bottom: this.isFloating? 10 : this.getBottomAvoid() })
    .width(Common.FULL_WIDTH)
    .height(Common.FULL_HEIGHT)
    .backgroundColor($r('app.color.white'))
    .borderRadius({
      bottomLeft: new WidthBreakpointType($r('app.float.border_zero'),
        $r('app.float.border_radius'), $r('app.float.border_radius'),
        $r('app.float.border_radius')).getValue(this.getBreakpoint().widthBreakpoint),
      bottomRight: new WidthBreakpointType($r('app.float.border_zero'),
        $r('app.float.border_radius'), $r('app.float.border_radius'),
        $r('app.float.border_radius')).getValue(this.getBreakpoint().widthBreakpoint)
    })
    .parallelGesture(
      PanGesture(this.panelGestureCoordinator.getVerticalPanOption())
        .onActionStart(() => {
          this.panelGestureCoordinator.beginGesture();
        })
        .onActionUpdate((event?: GestureEvent) => {
          this.panelGestureCoordinator.updatePanelGesture(event, this.panelMode, this.onPanelPullStart,
            this.onPanelPullUpdate);
        })
        .onActionEnd(() => {
          this.panelGestureCoordinator.endGesture(this.onPanelPullEnd);
        })
    )
  }
}
