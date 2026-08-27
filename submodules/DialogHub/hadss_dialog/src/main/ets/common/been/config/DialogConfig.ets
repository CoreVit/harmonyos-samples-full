/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
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

import { TopDialogPriority } from '../../constant/TopDialogPriority';

export interface DialogConfig {
  dialogBehavior?: DialogBehavior; // Configure the unique behavior of the pop-up window
  dialogPosition?: DialogPosition;
  dialogMode?: DialogMode;
}

export interface DialogBehavior {
  keyboardAvoidMode?: CustomKeyboardAvoidMode; // Keyboard avoidance mode
  keyboardAvoidSpace?: Dimension; // Avoidance distance
  autoKeyboardAvoidMode?: boolean;
  isModal?: boolean; // Whether to open the enlightenment layer
  maskRect?: Rectangle; // Size and location of the mask layer
  // Whether the pop-up window itself transmits gestures such as clicking and sliding. It is disabled by default.
  passThroughGesture?: boolean;
  layerPolicy?: DialogLayerPolicy;
  autoDismiss?: boolean; // Click whether the popup mask closes automatically, which defaults to true
  // Whether to shift the current focus to the popup when the popup pops up. By default, the focus is not shifted
  requestFocusWhenShow?: boolean;

  levelMode?: LevelMode;
  levelUniqueId?: number;
}

/**
 * Suppression strategy for a single pop-up window
 */
export interface DialogLayerPolicy {
  alwaysTop?: boolean; // Whether the current popup is on top
  topDialogPriority?: TopDialogPriority; // Popup conflict resolution strategy
}

export interface DialogPosition {
  alignment?: DialogAlignment;
  offset?: Offset;
}

export enum CustomKeyboardAvoidMode {
  //Default, input avoid;
  // The input box in the popup window avoids the keyboard when it is focused, but the popup itself does not avoid
  INPUT_AVOID,
  //Content avoidance;
  // The popup itself will avoid the keyboard; The avoidance distance is determined by the keyboardAvoidSpace
  CONTENT_AVOID
}

export enum DialogMode {
  OVERLAY_MANAGER,
  CUSTOM_DIALOG
}