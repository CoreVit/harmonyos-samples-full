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
 * Constants for breakpoint.
 */
export class BreakpointConstants {
  /**
   * The break point value.
   */
  public static readonly BREAKPOINT_VALUE_NUMBER: Array<number> = [320, 600, 840];
  /**
   * The number of columns for SM device.
   */
  public static readonly COLUMN_SM: number = 4;
  /**
   * The number of columns for MD device.
   */
  public static readonly COLUMN_MD: number = 8;
  /**
   * The number of columns for LG device.
   */
  public static readonly COLUMN_LG: number = 12;
  /**
   * The number of columns for LG device.
   */
  public static readonly COLUMN_LYRIC_LG: number = 7;
  /**
   * The number of gutter X for device.
   */
  public static readonly GUTTER_MUSIC_X: number = 24;
  /**
   * The number of span for SM device.
   */
  public static readonly SPAN_SM: number = 4;
  /**
   * The number of span for MD device.
   */
  public static readonly SPAN_MD: number = 6;
  /**
   * The number of span for LG device.
   */
  public static readonly SPAN_LYRIC_LG: number = 5;
  /**
   * The number of offset for MD device.
   */
  public static readonly OFFSET_MD: number = 1;
  /**
   * Current breakpoints that to query the device types.
   */
  public static readonly CURRENT_BREAKPOINT: string = 'audioInterCurrentBreakpoint';
  /**
   * Range of the small device width.
   */
  public static readonly RANGE_SM: string = '(320vp<=width<600vp)';
  /**
   * Range of the middle device width.
   */
  public static readonly RANGE_MD: string = '(600vp<=width<840vp)';
  /**
   * Range of the large device width.
   */
  public static readonly RANGE_LG: string = '(840vp<=width)';
}