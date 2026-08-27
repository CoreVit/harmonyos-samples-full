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
   * PanGesture distance.
   */
  public static readonly PAN_GESTURE_DISTANCE = 1;
  /**
   * Month.
   */
  public static readonly MONTHS = 12;
  /**
   * January.
   */
  public static readonly JANUARY = 1;
  /**
   * A week.
   */
  public static readonly WEEK_NUMBER = 7;
  /**
   * Month number.
   */
  public static readonly MONTH_NUMBER = 35;
  /**
   * Small grid height.
   */
  public static readonly GRID_HEIGHT_L = 360;
  /**
   * Large grid height.
   */
  public static readonly GRID_HEIGHT_M = 300;
  /**
   * Dialog animate duration.
   */
  public static readonly DIALOG_ANIMATE_DURATION = 300;
  /**
   * Outside margin.
   */
  public static readonly ELEMENTS_MARGIN = 12;
  /**
   * The hundred  percent of the components
   */
  public static readonly FULL_PERCENT: string = '100%';
  /**
   * Forty percent.
   */
  public static readonly FORTY_PERCENT: string = '40%';
  /**
   * Seventy-five percent.
   */
  public static readonly SEVENTY_FIVE_PERCENT: string = '75%';
  /**
   * Duration.
   */
  public static readonly DURATION: number = 1200;
  /**
   * Delay.
   */
  public static readonly DELAY: number = 500;
  /**
   * Zero.
   */
  public static readonly ZERO: number = 0;
  /**
   * Space.
   */
  public static readonly SPACE_ONE: number = 20;
  /**
   * Element margin large.
   */
  public static readonly ELEMENTS_MARGIN_L: number = 16;
  /**
   * Element margin small.
   */
  public static readonly ELEMENTS_MARGIN_M: number = 8;
  /**
   * Saturday.
   */
  public static readonly SATURDAY: string = '六';
  /**
   * Sunday.
   */
  public static readonly SUNDAY: string = '日';
  /**
   * Seven grid.
   */
  public static readonly GRID_SEVEN: string = '1fr 1fr 1fr 1fr 1fr 1fr 1fr';
  /**
   * Six grid.
   */
  public static readonly GRID_SIX: string = '1fr 1fr 1fr 1fr 1fr 1fr';
  /**
   * Five grid.
   */
  public static readonly GRID_FIVE: string = '1fr 1fr 1fr 1fr 1fr';
  /**
   * MD and LG width.
   */
  public static readonly WIDTH_MD_LG: number = 448;
  /**
   * The prefix of app store key.
   */
  public static readonly PREFIX: string = 'custom_dialog_gathers_';
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
   * The key of selected date.
   */
  public static readonly AS_KEY_SELECTED_DATE: string = `${CommonConstants.PREFIX}selectedDate`;
}