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
  /*
   * AppStorage key
   */
  public static readonly KEY_PREFIX: string = 'gesturesShare';
  public static readonly KEY_BREAKPOINT: string = Constants.KEY_PREFIX + 'BreakPoint';
  public static readonly KEY_STATUS_BAR_HEIGHT: string = Constants.KEY_PREFIX + 'StatusBarHeight';
  public static readonly KEY_NAV_INDICATOR_HEIGHT: string = Constants.KEY_PREFIX + 'NavIndicatorHeight';
  public static readonly KEY_PATH_STACK: string = Constants.KEY_PREFIX + 'PathStack';
  public static readonly KEY_UI_CONTEXT: string = Constants.KEY_PREFIX + 'UIContext';
  public static readonly KEY_VIDEO_INDEX: string = Constants.KEY_PREFIX + 'VideoIndex';
  public static readonly KEY_IS_LINK: string = Constants.KEY_PREFIX + 'IsLink';
  public static readonly LOG_TAG: string = 'GesturesShare';
  public static readonly WINDOW_DECOR_HEIGHT: number = 56;
  public static readonly WINDOW_NAV_HEIGHT: number = 56;
  public static readonly PADDING_12: number = 12;
  public static readonly PADDING_16: number = 16;
  public static readonly PADDING_32: number = 32;
  public static readonly LANES_2: number = 2;
  public static readonly LANES_4: number = 4;
  public static readonly LANES_6: number = 6;
  public static readonly ASPECT_RATIO_16_9: number = 16 / 9;
  public static readonly COLUMNS_1: number = 1;
  public static readonly COLUMNS_2: number = 2;
  public static readonly COLUMNS_3: number = 3;
  public static readonly MAX_VIDEO_INDEX: number = 3;
  public static readonly MIN_VIDEO_INDEX: number = 0;
}