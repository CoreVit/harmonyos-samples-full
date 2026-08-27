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
   * Component opacity value: 1.
   */
  public static readonly FULL_OPACITY: number = 1;
  /**
   * Component opacity value: 0.6.
   */
  public static readonly SIXTY_OPACITY: number = 0.6;
  /**
   * Font weight value: five.
   */
  public static readonly FONT_WEIGHT_FIVE: number = 500;
  /**
   * Water flow layout weight value:1.
   */
  public static readonly WATER_FLOW_LAYOUT_WEIGHT: number = 1;
  /**
   * Width the percentage of the 100.
   */
  public static readonly FULL_WIDTH: string = '100%';
  /**
   * Height the percentage of the 100.
   */
  public static readonly FULL_HEIGHT: string = '100%';
  /**
   * cached_count
   */
  public static readonly CACHED_COUNT: number = 6;
  /**
   * Water flow friction
   */
  public static readonly WATER_FLOW_FRICTION: number = 0.65;
  /**
   * datasource min count
   */
  public static readonly DATASOURCE_MIN_COUNT: number = 5;
  /**
   * time out 500
   */
  public static readonly TIME_OUT_FIVE_HUNDREDS: number = 500;
  /**
   * time out 2000
   */
  public static readonly TIME_OUT_TWO_THOUSANDS: number = 2000;
  /**
   * Flow height.
   */
  public static readonly FLOW_HEIGHT: Length = 244;
  /**
   * Width the search bar of the 308vp.
   */
  public static readonly SEARCH_BAR_MD_WIDTH: string = '308vp';
  /**
   * Width the search bar of the 400vp.
   */
  public static readonly SEARCH_BAR_LG_WIDTH: string = '400vp';
  /**
   * The prefix of app store key.
   */
  public static readonly PREFIX: string = 'water_flow_';
  /**
   * The key of break point.
   */
  public static readonly AS_KEY_BREAK_POINT: string = `${CommonConstants.PREFIX}currentBreakpoint`;
  /**
   * The key of status bar height.
   */
  public static readonly AS_KEY_STATUS_BAR_HEIGHT: string = `${CommonConstants.PREFIX}statusBarHeight`;
  /**
   * The key of navigator bar height.
   */
  public static readonly AS_KEY_NAVIGATOR_BAR_HEIGHT: string = `${CommonConstants.PREFIX}navigatorBarHeight`;
  /**
   * The key of path stack.
   */
  public static readonly AS_KEY_PATH_STACK: string = `${CommonConstants.PREFIX}pathStack`;
  /**
   * The key of sub path stack.
   */
  public static readonly AS_KEY_SUB_PATH_STACK: string = `${CommonConstants.PREFIX}subpathStack`;
  /**
   * The key of item height array.
   */
  public static readonly AS_KEY_ITEM_HEIGHT_ARRAY: string = `${CommonConstants.PREFIX}itemHeightArray`;
  /**
   * The key of good nav title height.
   */
  public static readonly GOOD_NAV_TITLE_HEIGHT: number = 60;
}

/**
 * The style of NavPage.
 */
export class NavPageStyle {
  /**
   * The height of Tabs.
   */
  public static readonly BAR_HEIGHT: number = 56;
}
