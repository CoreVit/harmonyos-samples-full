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
import { map } from '@kit.MapKit';
import { Common, PanelMode, PanelType } from 'multitravelbase/Index';
import { PanelGestureCoordinator } from '../gesture/PanelGestureCoordinator';
import { SearchViewModel } from '../../viewmodel/SearchViewModel';
import { SearchBarView } from '../search/SearchBarView';
import { ColumnView } from './ColumnView';
import { GridView } from './GridView';
import { ListView } from './ListView';

@Component
export struct HomePanelView {
  @Watch('onPanelModeChanged') @Prop panelMode: PanelMode = PanelMode.Half;
  @Prop panelType: PanelType = PanelType.Normal;
  @Link mapController: map.MapComponentController;
  @ObjectLink searchViewModel: SearchViewModel;
  waitForCurrentLocation?: () => Promise<geoLocationManager.Location | undefined>;
  onPanelModeChange?: (mode: PanelMode) => void;
  onPanelPullStart?: () => void;
  onPanelPullUpdate?: (offsetY: number) => void;
  onPanelPullEnd?: () => void;
  private contentScroller: Scroller = new Scroller();
  private panelGestureCoordinator: PanelGestureCoordinator = new PanelGestureCoordinator();

  aboutToAppear(): void {
    this.onPanelModeChanged();
  }

  private onPanelModeChanged(): void {
    if (this.panelMode === PanelMode.High) {
      this.panelGestureCoordinator.reachTop();
    }
  }

  build() {
    Scroll(this.contentScroller) {
      Column() {
        SearchBarView({
          panelMode: this.panelMode,
          mapController: this.mapController,
          searchViewModel: this.searchViewModel,
          waitForCurrentLocation: this.waitForCurrentLocation,
          onPanelModeChange: this.onPanelModeChange
        })
        GridView({ panelMode: this.panelMode, panelType: this.panelType })
          .visibility((this.panelType === PanelType.Mini && this.panelMode !== PanelMode.High) ||
            this.panelMode === PanelMode.Low ? Visibility.None : Visibility.Visible)
        ColumnView({ panelMode: this.panelMode })
          .visibility((this.panelType === PanelType.Mini && this.panelMode !== PanelMode.High) ||
            this.panelMode === PanelMode.Low ? Visibility.None : Visibility.Visible)
          .margin({
            bottom: this.panelType === PanelType.Mini ? 72 : 0
          })
        ListView()
          .visibility((this.panelType === PanelType.Mini || this.panelMode === PanelMode.Low) ?
            Visibility.None : Visibility.Visible)
        Blank()
          .layoutWeight(1)
      }
      .justifyContent(FlexAlign.Start)
      .width(Common.FULL_WIDTH)
      .padding({
        left: 16,
        right: 16,
        bottom: 16,
      })
    }
    .width(Common.FULL_WIDTH)
    .scrollBar(BarState.Off)
    .onDidScroll(() => {
      this.panelGestureCoordinator.updateVerticalOffset(this.contentScroller.currentOffset().yOffset);
    })
    .onScrollEdge((side: Edge) => {
      if (side === Edge.Top) {
        this.panelGestureCoordinator.reachTop();
      }
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
    .scrollable((this.panelType === PanelType.None || this.panelMode === PanelMode.High) ?
      ScrollDirection.Vertical : ScrollDirection.None)
  }
}
