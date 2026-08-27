/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

/*
 * Common constants for all features.
 */
export class Constants {
  public static readonly SPACE_2: number = 2;
  public static readonly SPACE_8: number = 8;
  public static readonly WINDOW_DECOR_HEIGHT: number = 64;
  /*
   * AppStorage key
   */
  public static readonly KEY_PREFIX: string = 'multiNavBar';
  public static readonly KEY_BREAKPOINT: string = Constants.KEY_PREFIX + 'Breakpoint';
  public static readonly KEY_STATUS_BAR_HEIGHT: string = Constants.KEY_PREFIX + 'StatusBarHeight';
  public static readonly KEY_NAV_INDICATOR_HEIGHT: string = Constants.KEY_PREFIX + 'NavIndicatorHeight';
  public static readonly KEY_UI_CONTEXT: string = Constants.KEY_PREFIX + 'UIContext';
}