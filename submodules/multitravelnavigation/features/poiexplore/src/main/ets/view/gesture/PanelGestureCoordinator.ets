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

import { PanelMode } from 'multitravelbase/Index';

const PANEL_PULL_DOWN_TRIGGER_DISTANCE: number = 18;
const PANEL_PULL_UP_TRIGGER_DISTANCE: number = 6;
const CONTENT_TOP_THRESHOLD: number = 0.3;

export class PanelGestureCoordinator {
  private contentAtTop: boolean = true;
  private pullingPanel: boolean = false;
  private panOptionVertical: PanGestureOptions = new PanGestureOptions({
    direction: PanDirection.Up | PanDirection.Down,
    distance: 6
  });
  private panOptionDown: PanGestureOptions = new PanGestureOptions({
    direction: PanDirection.Down,
    distance: 6
  });

  getVerticalPanOption(): PanGestureOptions {
    return this.panOptionVertical;
  }

  getDownPanOption(): PanGestureOptions {
    return this.panOptionDown;
  }

  reachTop(): void {
    this.contentAtTop = true;
  }

  updateVerticalOffset(offset: number): void {
    if (offset <= CONTENT_TOP_THRESHOLD) {
      this.contentAtTop = true;
      return;
    }
    this.contentAtTop = false;
  }

  beginGesture(): void {
    this.pullingPanel = false;
  }

  updatePanelGesture(event: GestureEvent | undefined, panelMode: PanelMode, onStart?: () => void,
    onUpdate?: (offsetY: number) => void): void {
    if (!event) {
      return;
    }
    if (event.offsetY < 0) {
      this.updateUpGesture(event, panelMode, onStart, onUpdate);
      return;
    }
    this.updateDownGesture(event, panelMode, onStart, onUpdate);
  }

  endGesture(onEnd?: () => void): void {
    if (this.pullingPanel) {
      onEnd?.();
    }
    this.pullingPanel = false;
  }

  private updateDownGesture(event: GestureEvent, panelMode: PanelMode, onStart?: () => void,
    onUpdate?: (offsetY: number) => void): void {
    if (panelMode === PanelMode.High && !this.contentAtTop && !this.pullingPanel) {
      return;
    }
    if (event.offsetY <= 0 && !this.pullingPanel) {
      return;
    }
    let panelOffsetY: number = Math.max(0, event.offsetY - PANEL_PULL_DOWN_TRIGGER_DISTANCE);
    if (panelOffsetY <= 0 && !this.pullingPanel) {
      return;
    }
    if (!this.pullingPanel) {
      onStart?.();
      this.pullingPanel = true;
    }
    onUpdate?.(panelOffsetY);
  }

  private updateUpGesture(event: GestureEvent, panelMode: PanelMode, onStart?: () => void,
    onUpdate?: (offsetY: number) => void): void {
    if (panelMode === PanelMode.High) {
      return;
    }
    let panelOffsetY: number = Math.min(0, event.offsetY + PANEL_PULL_UP_TRIGGER_DISTANCE);
    if (panelOffsetY >= 0 && !this.pullingPanel) {
      return;
    }
    if (!this.pullingPanel) {
      onStart?.();
      this.pullingPanel = true;
    }
    onUpdate?.(panelOffsetY);
  }
}
