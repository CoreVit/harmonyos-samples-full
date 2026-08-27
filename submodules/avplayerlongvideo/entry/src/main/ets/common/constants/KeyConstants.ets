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

/**
 * Constants for AppStorage key
 */
export class KeyConstants {
  /**
   * AppStorage key
   */
  public static readonly KEY_PREFIX: string = 'AVPlayerLongVideo';
  public static readonly KEY_CONTEXT: string = KeyConstants.KEY_PREFIX + 'Context';
  public static readonly KEY_UI_CONTEXT: string = KeyConstants.KEY_PREFIX + 'UIContext';
  public static readonly KEY_WINDOW_STAGE: string = KeyConstants.KEY_PREFIX + 'WindowStage';
  public static readonly KEY_DEVICE_WIDTH: string = KeyConstants.KEY_PREFIX + 'DeviceWidth';
  public static readonly KEY_DEVICE_HEIGHT: string = KeyConstants.KEY_PREFIX + 'DeviceHeight';
  public static readonly KEY_STATUS_BAR_HEIGHT: string = KeyConstants.KEY_PREFIX + 'StatusBarHeight';
  public static readonly KEY_NAV_BAR_HEIGHT: string = KeyConstants.KEY_PREFIX + 'NavBarHeight';
  public static readonly KEY_TITLE_BTN_HEIGHT: string = KeyConstants.KEY_PREFIX + 'TitleButtonHeight';
  public static readonly KEY_WIDTH_BREAKPOINT: string = KeyConstants.KEY_PREFIX + 'WidthBreakpoint';
  public static readonly KEY_HEIGHT_BREAKPOINT: string = KeyConstants.KEY_PREFIX + 'HeightBreakpoint';
  public static readonly KEY_IS_HALF_FOLDED: string = KeyConstants.KEY_PREFIX + 'isHalfFolded';
  public static readonly KEY_CREASE_REGION: string = KeyConstants.KEY_PREFIX + 'creaseRegion';
  public static readonly KEY_IS_PIP_SHOW: string = KeyConstants.KEY_PREFIX + 'isPIPShow';
  public static readonly KEY_START_RENDER: string = KeyConstants.KEY_PREFIX + 'StartRender';
  public static readonly KEY_DURATION_TIME: string = KeyConstants.KEY_PREFIX + 'DurationTime';
  public static readonly KEY_CURRENT_TIME: string = KeyConstants.KEY_PREFIX + 'CurrentTime';
}