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

import { MapUiState, PanelMode, PanelType } from 'multitravelbase/Index';
import { PopupPanel } from './PopupPanel';

export interface PanelVisibilityOptions {
  mapUiState: MapUiState;
  panelVisible: boolean;
  onPanelVisibleChange: (visible: boolean) => void;
}

export class PanelInteractionController {
  public ensurePanelVisible(options: PanelVisibilityOptions): void {
    if (options.mapUiState !== MapUiState.HOME && !options.panelVisible) {
      options.onPanelVisibleChange(true);
    }
  }

  public togglePanelVisibility(options: PanelVisibilityOptions): boolean {
    if (options.mapUiState === MapUiState.ROUTE_PLAN) {
      return options.panelVisible;
    }
    let nextVisible: boolean = !options.panelVisible;
    options.onPanelVisibleChange(nextVisible);
    return nextVisible;
  }

  public canPullPanel(layoutMode: string, panelType: PanelType): boolean {
    return layoutMode === 'overlay' && panelType !== PanelType.None;
  }

  public setPanelMode(layoutMode: string, popupPanel: PopupPanel, mode: PanelMode,
    onPanelVisibleChange: (visible: boolean) => void): boolean {
    if (!this.canPullPanel(layoutMode, popupPanel.panelType)) {
      return false;
    }
    onPanelVisibleChange(true);
    popupPanel.setMode(mode);
    return true;
  }

  public beginPanelPull(layoutMode: string, popupPanel: PopupPanel,
    onPanelVisibleChange: (visible: boolean) => void): boolean {
    if (!this.canPullPanel(layoutMode, popupPanel.panelType)) {
      return false;
    }
    onPanelVisibleChange(true);
    popupPanel.beginHeightDrag();
    return true;
  }

  public updatePanelPull(layoutMode: string, popupPanel: PopupPanel, offsetY: number): boolean {
    if (!this.canPullPanel(layoutMode, popupPanel.panelType)) {
      return false;
    }
    popupPanel.updateHeightDrag(offsetY);
    return true;
  }

  public endPanelPull(layoutMode: string, popupPanel: PopupPanel): boolean {
    if (!this.canPullPanel(layoutMode, popupPanel.panelType)) {
      return false;
    }
    popupPanel.endHeightDrag();
    return true;
  }
}
