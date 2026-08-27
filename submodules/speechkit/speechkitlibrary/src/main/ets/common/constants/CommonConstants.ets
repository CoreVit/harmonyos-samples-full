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
   * The width of image in sm.
   */
  public static readonly NEWS_IMAGE_WIDTH_SM: string = '100%';
  /**
   * The width of image in md.
   */
  public static readonly NEWS_IMAGE_WIDTH_MD: string = '60%';
  /**
   * The width of image in lg.
   */
  public static readonly NEWS_IMAGE_WIDTH_LG: string = '50%';
  /**
   * The font weight of 400.
   */
  public static readonly FONT_WEIGHT_400: number = 400;
  /**
   * The font weight of 500.
   */
  public static readonly FONT_WEIGHT_500: number = 500;
  /**
   * The font weight of 700.
   */
  public static readonly FONT_WEIGHT_700: number = 700;
  /**
   * Width the percentage of the 100.
   */
  public static readonly FULL_WIDTH: string = '100%';
  /**
   * Height the percentage of the 100.
   */
  public static readonly FULL_HEIGHT: string = '100%';
  /**
   * The prefix of app store key.
   */
  public static readonly PREFIX: string = 'speech_kit_';
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