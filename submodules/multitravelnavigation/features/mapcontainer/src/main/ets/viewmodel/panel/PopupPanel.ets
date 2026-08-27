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

import { UIContext } from '@kit.ArkUI';
import { Common, PanelMode, PanelType, WindowInfo } from 'multitravelbase/Index';

const HIGH_PANEL_TOP_OFFSET: number = 12;
const FLOATING_PANEL_WIDTH: number = 320;
const FLOATING_PANEL_BOTTOM_MARGIN: number = 24;
const PANEL_RADIUS: number = 32;

@Observed
export class PopupPanel {
  public panelType: PanelType = PanelType.Normal;
  public panelMode: PanelMode = PanelMode.Half;
  public panelHeight: number = Common.HALF_PANEL_HEIGHT;
  public panelHeightArray: number[] = [Common.LOW_PANEL_HEIGHT, Common.HALF_PANEL_HEIGHT, Common.HIGH_PANEL_HEIGHT];
  public panelWidth: number = FLOATING_PANEL_WIDTH;
  public isFloating: boolean = false;
  public panelBottomMargin: number = 0;
  public panelRadius: BorderRadiuses = {
    topLeft: PANEL_RADIUS,
    topRight: PANEL_RADIUS,
    bottomLeft: 0,
    bottomRight: 0
  };
  private originalPanelHeight: number = Common.HALF_PANEL_HEIGHT;
  private tempPanelHeight: number = Common.HALF_PANEL_HEIGHT;

  public setMode(panelMode: PanelMode): void {
    this.panelMode = panelMode;
    this.normalizePanelMode();
    this.syncPanelHeightByMode();
  }

  public updateLayout(uiContext: UIContext, mainWindowInfo: WindowInfo, layoutMode: string,
    widthBreakpoint: WidthBreakpoint,
    heightBreakpoint: HeightBreakpoint): void {
    let previousPanelType: PanelType = this.panelType;
    let previousFloating: boolean = this.isFloating;
    this.updatePanelType(widthBreakpoint, heightBreakpoint, layoutMode);
    this.updatePanelBorderRadius(widthBreakpoint);
    this.updatePanelWidth(uiContext, mainWindowInfo, layoutMode, widthBreakpoint);
    this.syncPanelMode(previousPanelType, previousFloating);
    if (this.panelType !== PanelType.None) {
      this.updatePanelHeightArray(uiContext, mainWindowInfo);
      this.syncPanelHeightByMode();
    }
    this.updatePanelMargin(mainWindowInfo);
  }

  public beginHeightDrag(): void {
    this.originalPanelHeight = this.panelHeight;
    this.tempPanelHeight = this.panelHeight;
  }

  public updateHeightDrag(offsetY: number): void {
    this.tempPanelHeight = this.clampPanelHeight(this.originalPanelHeight - offsetY);
    this.panelHeight = this.tempPanelHeight;
  }

  public endHeightDrag(): void {
    let lowHeight: number = this.panelHeightArray[0];
    let halfHeight: number = this.panelHeightArray[1];
    let highHeight: number = this.panelHeightArray[2];

    if (this.panelType === PanelType.Mini) {
      this.panelMode = this.tempPanelHeight > (highHeight - lowHeight) / 2 + lowHeight ?
        PanelMode.High : PanelMode.Half;
    } else if (this.tempPanelHeight > (highHeight - halfHeight) / 2 + halfHeight) {
      this.panelMode = PanelMode.High;
    } else if (this.tempPanelHeight < (halfHeight - lowHeight) / 2 + lowHeight) {
      this.panelMode = PanelMode.Low;
    } else {
      this.panelMode = PanelMode.Half;
    }

    this.syncPanelHeightByMode();
    this.tempPanelHeight = this.panelHeight;
  }

  private normalizePanelMode(): void {
    if (this.panelType === PanelType.Mini && this.panelMode === PanelMode.Low) {
      this.panelMode = PanelMode.Half;
    }
  }

  private syncPanelHeightByMode(): void {
    this.panelHeight = this.getHeightByMode();
  }

  private getHeightByMode(): number {
    switch (this.panelMode) {
      case PanelMode.Low:
        return this.panelHeightArray[0];
      case PanelMode.Half:
        return this.panelHeightArray[1];
      case PanelMode.High:
        return this.panelHeightArray[2];
      default:
        return this.panelHeightArray[1];
    }
  }

  private updatePanelType(widthBreakpoint: WidthBreakpoint, heightBreakpoint: HeightBreakpoint,
    layoutMode: string): void {
    if (layoutMode === 'embedded') {
      this.panelType = PanelType.None;
      return;
    }
    if (heightBreakpoint === HeightBreakpoint.HEIGHT_MD && widthBreakpoint === WidthBreakpoint.WIDTH_SM) {
      this.panelType = PanelType.Mini;
      return;
    }
    this.panelType = PanelType.Normal;
  }

  private syncPanelMode(previousPanelType: PanelType, previousFloating: boolean): void {
    if (previousPanelType !== this.panelType || previousFloating !== this.isFloating) {
      if (this.panelType === PanelType.None) {
        return;
      }
      if (this.panelType === PanelType.Mini) {
        this.panelMode = PanelMode.Half;
      } else {
        this.panelMode = this.isFloating ? PanelMode.High : PanelMode.Half;
      }
    }
    this.normalizePanelMode();
  }

  private updatePanelBorderRadius(widthBreakpoint: WidthBreakpoint): void {
    if (widthBreakpoint === WidthBreakpoint.WIDTH_SM || widthBreakpoint === WidthBreakpoint.WIDTH_XS) {
      this.panelRadius = {
        topLeft: PANEL_RADIUS,
        topRight: PANEL_RADIUS,
        bottomLeft: 0,
        bottomRight: 0
      };
    } else if (this.panelType === PanelType.None) {
      this.panelRadius = {
        topLeft: 0,
        topRight: 0,
        bottomLeft: 0,
        bottomRight: 0
      };
    } else {
      this.panelRadius = {
        topLeft: PANEL_RADIUS,
        topRight: PANEL_RADIUS,
        bottomLeft: PANEL_RADIUS,
        bottomRight: PANEL_RADIUS
      };
    }
  }

  private updatePanelWidth(uiContext: UIContext, mainWindowInfo: WindowInfo, layoutMode: string,
    widthBreakpoint: WidthBreakpoint): void {
    this.isFloating = layoutMode === 'overlay' && this.isWideWindow(widthBreakpoint) &&
      this.panelType !== PanelType.None;
    let windowWidth: number = uiContext.px2vp(mainWindowInfo.windowSize.width);
    this.panelWidth = this.isFloating ? FLOATING_PANEL_WIDTH : windowWidth;
  }

  private updatePanelHeightArray(uiContext: UIContext, mainWindowInfo: WindowInfo): void {
    let windowHeight: number = uiContext.px2vp(mainWindowInfo.windowSize.height);
    let topAvoid: number = uiContext.px2vp(mainWindowInfo.avoidSystem?.topRect.height ?? 0);
    let miniHeight: number = Common.LOW_PANEL_HEIGHT;
    let halfHeight: number = Common.HALF_PANEL_HEIGHT;
    let fullHeight: number = windowHeight - topAvoid - HIGH_PANEL_TOP_OFFSET - this.getBottomMargin();

    if (fullHeight < miniHeight) {
      fullHeight = miniHeight;
    }
    if (this.panelType === PanelType.None) {
      this.panelHeightArray = [fullHeight, fullHeight, fullHeight];
      return;
    }
    if (this.panelType === PanelType.Mini) {
      this.panelHeightArray = [miniHeight, miniHeight, fullHeight];
      return;
    }
    if (halfHeight < miniHeight) {
      halfHeight = miniHeight;
    }
    if (halfHeight > fullHeight) {
      halfHeight = fullHeight;
    }
    this.panelHeightArray = [miniHeight, halfHeight, fullHeight];
  }

  private updatePanelMargin(_mainWindowInfo: WindowInfo): void {
    this.panelBottomMargin = this.panelType === PanelType.None ? 0 : this.getBottomMargin();
  }

  private getBottomMargin(): number {
    if (this.panelType === PanelType.None) {
      return 0;
    }
    return this.isFloating ? FLOATING_PANEL_BOTTOM_MARGIN : 0;
  }

  private isWideWindow(widthBreakpoint: WidthBreakpoint): boolean {
    return widthBreakpoint !== WidthBreakpoint.WIDTH_XS && widthBreakpoint !== WidthBreakpoint.WIDTH_SM;
  }

  private clampPanelHeight(height: number): number {
    let miniHeight: number = this.panelHeightArray[0];
    let fullHeight: number = this.panelHeightArray[2];
    if (height < miniHeight) {
      return miniHeight;
    }
    if (height > fullHeight) {
      return fullHeight;
    }
    return height;
  }
}
