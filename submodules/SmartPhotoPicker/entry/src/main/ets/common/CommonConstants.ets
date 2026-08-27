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

export class CommonConstants {
  /**
   * Key prefix.
   * */
  public static readonly KEY_PREFIX: string = 'SmartPhotoPicker';
  /**
   * Current weight breakpoint.
   * */
  public static readonly KEY_WIDTH_BP: string = CommonConstants.KEY_PREFIX + 'currentWidthBreakpoint';
  /**
   * Current height breakpoint.
   * */
  public static readonly KEY_HEIGHT_BP: string = CommonConstants.KEY_PREFIX + 'currentHeightBreakpoint';
  /**
   * Window.
   * */
  public static readonly KEY_WINDOW_CLASS: string = CommonConstants.KEY_PREFIX + 'windowClass';
  /**
   * Window width.
   * */
  public static readonly KEY_WINDOW_WIDTH: string = CommonConstants.KEY_PREFIX + 'windowWidth';
  /**
   * Device types.
   */
  public static readonly DEVICE_TYPE: string = '2in1';
  /**
   * Height and width is 100%.
   * */
  public static readonly FULL_PARENT: string = '100%';
}