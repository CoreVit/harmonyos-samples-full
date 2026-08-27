/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
 * Common constants for all features.
 */
export class CommonConstants {
  /**
   * font weight is 500.
   */
  public static readonly FONT_WEIGHT_FIVE: number = 500;
  /**
   * Transparency is 1.
   */
  public static readonly FULL_OPACITY: number = 1;

  /**
   * Transparency is 0.
   */
  public static readonly ZERO_OPACITY: number = 0;
  /**
   * font weight is 500.
   */
  public static readonly FONT_WEIGHT_FOUR: number = 400;
  /**
   * The width of the split line is 2.
   */
  public static readonly STROKE_WIDTH: number = 2;
  /**
   * Width the percentage of the 100.
   */
  public static readonly FULL_WIDTH: string = '100%';
  /**
   * Height the percentage of the 100.
   */
  public static readonly FULL_HEIGHT: string = '100%';
  /**
   * stack height.
   */
  public static readonly STACK_HEIGHT: Length = 'calc(100% - 60vp)';
  /**
   * AppStorage key prefix.
   */
  public static readonly KEY_PREFIX: string = 'ScrollComponent';
  public static readonly KEY_PREFIX_BREAKPOINT: string = CommonConstants.KEY_PREFIX + 'CurrentBreakpoint';
  public static readonly KEY_PREFIX_NAVIGATOR_BAR_HEIGHT: string = CommonConstants.KEY_PREFIX + 'NavigatorBarHeight';
  public static readonly KEY_PREFIX_STATUS_BAR_HEIGHT: string = CommonConstants.KEY_PREFIX + 'StatusBarHeight';
  public static readonly KEY_PREFIX_SYSTEM_COLOR_MODE: string = CommonConstants.KEY_PREFIX + 'SystemColorMode';
  public static readonly KEY_PREFIX_SYSTEM_UICONTEXT: string = CommonConstants.KEY_PREFIX + 'UIContext';
}
