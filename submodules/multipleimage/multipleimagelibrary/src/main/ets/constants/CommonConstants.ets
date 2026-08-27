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

export class CommonConstants {
  /**
   * Full percent.
   */
  public static readonly FULL_PERCENT: string = '100%';

  /**
   * None percent.
   */
  public static readonly NONE_PERCENT: string = '0';

  /**
   * Swiper initially currentIndex.
   */
  public static readonly INITIALLY_CURRENT_INDEX: number = -1;

  /**
   * Swiper slide index.
   */
  public static readonly SLIDE_INDEX: number = -1;

  /**
   * Swiper image duration.
   */
  public static readonly IMAGE_DURATION: number = 300;

  /**
   * Swiper duration.
   */
  public static readonly DURATION: number = 3000;

  /**
   * Swiper interval.
   */
  public static readonly INTERVAL: number = 3000;

  /**
   * Swiper item space.
   */
  public static readonly ITEM_SPACE: number = 0;

  /**
   * Swiper cached count.
   */
  public static readonly SWIPER_CACHED_COUNT: number = 2;

  /**
   * Progress wrap height.
   */
  public static readonly PROGRESS_WRAP_HEIGHT: number = 50;

  /**
   * zIndex.
   */
  public static readonly Z_INDEX_0: number = 0;

  /**
   * zIndex.
   */
  public static readonly Z_INDEX_1: number = 1;

  /**
   * zIndex.
   */
  public static readonly Z_INDEX_2: number = 2;

  /**
   * Layout weight.
   */
  public static readonly LAYOUT_WEIGHT: number = 1;

  /**
   * Row space.
   */
  public static readonly ROW_SPACE: number = 5;

  /**
   * Column space.
   */
  public static readonly COLUMN_SPACE: number = 16;

  /**
   * Column space inside.
   */
  public static readonly COLUMN_SPACE_INSIDE: number = 8;

  /**
   * AppStorage key prefix.
   */
  public static readonly KEY_PREFIX: string = 'MultipleImage';
  public static readonly KEY_PREFIX_BREAKPOINT: string = CommonConstants.KEY_PREFIX + 'CurrentBreakpoint';
  public static readonly KEY_PREFIX_NAVIGATOR_BAR_HEIGHT: string = CommonConstants.KEY_PREFIX + 'NavigatorBarHeight';
  public static readonly KEY_PREFIX_STATUS_BAR_HEIGHT: string = CommonConstants.KEY_PREFIX + 'StatusBarHeight';
  public static readonly KEY_PREFIX_SYSTEM_COLOR_MODE: string = CommonConstants.KEY_PREFIX + 'SystemColorMode';
  public static readonly KEY_PREFIX_SYSTEM_UICONTEXT: string = CommonConstants.KEY_PREFIX + 'UIContext';
}