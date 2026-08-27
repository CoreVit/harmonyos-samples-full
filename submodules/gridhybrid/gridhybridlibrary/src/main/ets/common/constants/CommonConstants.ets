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
   * Table grid nested list uri.
   */
  public static readonly WATER_FLOW_LAYOUT_WEIGHT: number = 1;
  /**
   * Divider stroke width
   */
  public static readonly DIVIDER_STROKE_WIDTH: number = 2;
  /**
   * List space size
   */
  public static readonly LIST_SPACE_SIZE: number = 16;
  /**
   * Height of the first page of the swiper
   */
  public static readonly SWIPER_HEIGHT_SM_SIZE: number = 160;
  /**
   * Height of the second page of the swiper.
   */
  public static readonly SWIPER_HEIGHT_MD_SIZE: number = 160;
  /**
   * Height of the second page of the swiper.
   */
  public static readonly SWIPER_HEIGHT_LG_SIZE: number = 160;
  /**
   * The height of the WaterFlow item
   */
  public static readonly WATER_FLOW_ITEM_HEIGHT: number = 159;
  /**
   * The Animation Duration of swiper
   */
  public static readonly SWIPER_DURATION: number = 700;
  /**
   * The hundred  percent of the components
   */
  public static readonly FULL_PERCENT: string = '100%';
  /**
   * Water flow layout columns template sm
   */
  public static readonly GRID_COLUMNS_TEMPLATE_SM: string = '1fr 1fr 1fr 1fr';
  /**
   * Water flow layout columns template md
   */
  public static readonly GRID_COLUMNS_TEMPLATE_MD: string = '1fr 1fr 1fr 1fr 1fr 1fr';
  /**
   * Water flow layout columns template sm
   */
  public static readonly GRID_COLUMNS_TEMPLATE_LG: string = '1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr';
  /**
   * The prefix of app store key.
   */
  public static readonly PREFIX: string = 'grid_hybrid_';
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
}

/**
 * The state of main page
 */
export enum ScrollPosition {
  start = 0,
  center = 1,
  end = 2
}