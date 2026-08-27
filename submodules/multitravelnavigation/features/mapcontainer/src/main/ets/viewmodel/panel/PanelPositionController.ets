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

import { Common, PanelType } from 'multitravelbase/Index';

const PANEL_LEFT_MIN: number = Common.LEFT_MD;
const PANEL_SIDE_SNAP_TRIGGER_RATIO: number = 0.3;

@Observed
export class PanelPositionController {
  public panelLeftMargin: number = 0;
  private originalPanelLeft: number = PANEL_LEFT_MIN;
  private tempPanelLeft: number = PANEL_LEFT_MIN;
  private panelLeftMin: number = PANEL_LEFT_MIN;
  private panelLeftMax: number = PANEL_LEFT_MIN;
  private rightAligned: boolean = false;

  public updateLayout(layoutMode: string, panelType: PanelType, panelWidth: number, windowWidth: number,
    widthBreakpoint: WidthBreakpoint): void {
    if (!this.canDrag(layoutMode, this.isWidthSmall(widthBreakpoint), panelType)) {
      if (this.panelLeftMargin !== 0) {
        this.rightAligned = this.isRightAligned();
      }
      this.panelLeftMargin = 0;
      this.originalPanelLeft = PANEL_LEFT_MIN;
      this.tempPanelLeft = PANEL_LEFT_MIN;
      this.panelLeftMin = PANEL_LEFT_MIN;
      this.panelLeftMax = PANEL_LEFT_MIN;
      return;
    }
    this.updateBounds(panelWidth, windowWidth);
    this.rightAligned = this.panelLeftMargin === 0 ? this.rightAligned : this.isRightAligned();
    this.panelLeftMargin = this.rightAligned ? this.panelLeftMax : this.panelLeftMin;
    this.originalPanelLeft = this.panelLeftMargin;
    this.tempPanelLeft = this.panelLeftMargin;
  }

  public canDrag(layoutMode: string, isBottomSheet: boolean, panelType: PanelType): boolean {
    return layoutMode === 'overlay' && !isBottomSheet && panelType !== PanelType.None;
  }

  public beginDrag(): void {
    this.originalPanelLeft = this.panelLeftMargin;
    this.tempPanelLeft = this.panelLeftMargin;
  }

  public updateDrag(offsetX: number): void {
    this.tempPanelLeft = this.clampPanelLeft(this.originalPanelLeft + offsetX);
    this.panelLeftMargin = this.tempPanelLeft;
  }

  public endDrag(): void {
    this.panelLeftMargin = this.shouldSnapToRight() ? this.panelLeftMax : this.panelLeftMin;
    this.rightAligned = this.panelLeftMargin === this.panelLeftMax;
    this.originalPanelLeft = this.panelLeftMargin;
    this.tempPanelLeft = this.panelLeftMargin;
  }

  private isWidthSmall(widthBreakpoint: WidthBreakpoint): boolean {
    return widthBreakpoint === WidthBreakpoint.WIDTH_XS || widthBreakpoint === WidthBreakpoint.WIDTH_SM;
  }

  public isRightAligned(): boolean {
    if (this.panelLeftMax <= this.panelLeftMin) {
      return false;
    }
    return this.panelLeftMargin >= (this.panelLeftMin + this.panelLeftMax) / 2;
  }

  private shouldSnapToRight(): boolean {
    let panelRange: number = this.panelLeftMax - this.panelLeftMin;
    if (panelRange <= 0) {
      return false;
    }
    let middleLeft: number = (this.panelLeftMin + this.panelLeftMax) / 2;
    let startedFromRight: boolean = this.originalPanelLeft >= middleLeft;
    if (startedFromRight) {
      let leftSnapThreshold: number = this.panelLeftMax - panelRange * PANEL_SIDE_SNAP_TRIGGER_RATIO;
      return this.tempPanelLeft > leftSnapThreshold;
    }
    let rightSnapThreshold: number = this.panelLeftMin + panelRange * PANEL_SIDE_SNAP_TRIGGER_RATIO;
    return this.tempPanelLeft >= rightSnapThreshold;
  }

  private updateBounds(panelWidth: number, windowWidth: number): void {
    this.panelLeftMin = PANEL_LEFT_MIN;
    this.panelLeftMax = windowWidth - panelWidth - PANEL_LEFT_MIN;
    if (this.panelLeftMax < this.panelLeftMin) {
      this.panelLeftMax = this.panelLeftMin;
    }
  }

  private clampPanelLeft(left: number): number {
    if (left < this.panelLeftMin) {
      return this.panelLeftMin;
    }
    if (left > this.panelLeftMax) {
      return this.panelLeftMax;
    }
    return left;
  }
}
