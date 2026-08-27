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
   * AppStorage key.
   */
  public static readonly KEY_PREFIX: string = 'multimobilepayment';

  /**
   * AppStorage key for WindowUtil instance.
   */
  public static readonly KEY_WINDOWUTIL: string = CommonConstants.KEY_PREFIX + 'WindowUtil';
  /**
   * Percentage representing the full width.
   */
  public static readonly FULL_WIDTH: string = '100%';
  /**
   * Percentage representing the full height.
   */
  public static readonly FULL_HEIGHT: string = '100%';

  /**
   * Percentage representing the business section width.
   */
  public static readonly BUSINESS_WIDTH: string = '90%';

  /**
   * Default user name for display.
   */
  public static readonly NAME: string = 'Alice';

  /**
   * Size of the barcode image in pixels.
   */
  public static BAR_CODE_SIZE: number = 200;

  /**
   * Number of columns in business grid for small screens.
   */
  public static BUSINESS_GRID_COLUMNS_SM: number = 4;

  /**
   * Number of columns in business grid for medium screens.
   */
  public static BUSINESS_GRID_COLUMNS_MD: number = 6;

  /**
   * Number of columns in business grid for large and extra-large screens.
   */
  public static BUSINESS_GRID_COLUMNS_LG_XL: number = 8;

  /**
   * Percentage representing the quick action button width.
   */
  public static QUICK_ACTION_WIDTH: string = '18%';

  /**
   * Number of columns in wealth grid for small screens.
   */
  public static WEALTH_GRID_COLUMNS_SM: number = 1;

  /**
   * Number of columns in wealth grid for medium screens.
   */
  public static WEALTH_GRID_COLUMNS_MD: number = 2;

  /**
   * Number of columns in wealth grid for large and extra-large screens.
   */
  public static WEALTH_GRID_COLUMNS_LG_XL: number = 4;

  /**
   * Initial camera height in pixels.
   */
  public static INIT_CAMERA_HEIGHT: number = 640;

  /**
   * Initial camera width in pixels.
   */
  public static INIT_CAMERA_WIDTH: number = 360;

  /**
   * Top padding for scan view in pixels.
   */
  public static SCAN_PADDING_TOP: number = 16;

  /**
   * Start value for linear gradient (0.0).
   */
  public static LINEAR_BEGIN: number = 0.0;

  /**
   * End value for linear gradient (1.0).
   */
  public static LINEAR_END: number = 1.0;

  /**
   * Height of the background image in pixels.
   */
  public static BACKGROUND_IMAGE_HEIGHT: number = 200;

  /**
   * Spacing between list items on watch devices in pixels.
   */
  public static WATCH_LIST_SPACE: number = 12;

  /**
   * Time of cool down duration.
   */
  public static COOLDOWN_DURATION: number = 700;

  /**
   * Width of watch list items in pixels.
   */
  public static WATCH_LIST_WIDTH: number = 414;

  /**
   * Height of watch buttons in pixels.
   */
  public static WATCH_BUTTON_HEIGHT: number = 120;

  /**
   * Width percentage for watch text elements.
   */
  public static WATCH_TEXT_WIDTH: string = '50%';

  /**
   * Size of watch pixel elements.
   */
  public static WATCH_PIXEL_SIZE: number = 216;

  /**
   * Background size for watch pixel elements.
   */
  public static WATCH_PIXEL_BACKGROUND: number = 250;
}