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

import { map, mapCommon } from '@kit.MapKit';
import { PanelMode, PanelType } from 'multitravelbase/Index';

const HIDDEN_PANEL_BOTTOM_PADDING: number = 32;

export interface MapPaddingState {
  left: number;
  right: number;
  bottom: number;
}

export interface MapPaddingOptions {
  layoutMode: string;
  panelType: PanelType;
  panelMode: PanelMode;
  panelVisible: boolean;
  panelHeight: number;
  panelBottomMargin: number;
  panelWidth: number;
  panelLeftMargin: number;
  windowWidth: number;
  floating: boolean;
  isRightAligned: boolean;
}

export class MapViewportCoordinator {
  public calculateMapPadding(options: MapPaddingOptions): MapPaddingState {
    let mapPadding: MapPaddingState = { left: 0, right: 0, bottom: 0 };
    if (!options.panelVisible) {
      mapPadding.bottom = HIDDEN_PANEL_BOTTOM_PADDING;
      return mapPadding;
    }
    if (options.layoutMode === 'embedded') {
      mapPadding.left = 360;
      mapPadding.bottom = 16;
      return mapPadding;
    }
    if (options.layoutMode === 'overlay' && options.panelType !== PanelType.None) {
      mapPadding.bottom = options.panelHeight + options.panelBottomMargin +
        (options.panelMode === PanelMode.High ? 80 : 16);
      if (options.floating) {
        if (options.isRightAligned) {
          mapPadding.right = options.windowWidth - options.panelLeftMargin + 16;
        } else {
          mapPadding.left = options.panelLeftMargin + options.panelWidth;
        }
        mapPadding.bottom = options.panelBottomMargin + 24;
      }
    }
    return mapPadding;
  }

  public syncZoomControls(mapController: map.MapComponentController | undefined, isBottomSheet: boolean): void {
    mapController?.setZoomControlsEnabled(!isBottomSheet);
  }

  public applyMapPadding(mapController: map.MapComponentController | undefined, mapPadding: MapPaddingState,
    vp2px: (value: number) => number): void {
    if (!mapController) {
      return;
    }
    let paddingLeftPx: number = vp2px(mapPadding.left);
    let paddingRightPx: number = vp2px(mapPadding.right);
    let paddingBottomPx: number = vp2px(mapPadding.bottom);
    this.setMapPadding(mapController, paddingLeftPx, paddingBottomPx, paddingRightPx);
  }

  private setMapPadding(mapController: map.MapComponentController | undefined, paddingLeft: number,
    paddingBottom: number, paddingRight: number): void {
    let padding: mapCommon.Padding = {
      left: paddingLeft,
      bottom: paddingBottom,
      right: paddingRight
    };
    mapController?.setPadding(padding);
  }
}
