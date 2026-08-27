/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { image } from '@kit.ImageKit';

export class CommonConstants {
  /**
   * Title row width.
   */
  public static readonly TITLE_ROW_WEIGHT: string = '50%';

  /**
   * Layout full screen.
   */
  public static readonly LAYOUT_FULL_SCREEN: string = '100%';

  /**
   * Edit page height.
   */
  public static readonly EDIT_PAGE_HEIGHT: string = '30%';

  /**
   * Image show height.
   */
  public static readonly IMAGE_SHOW_HEIGHT: string = '70%';

  /**
   * Slider width.
   */
  public static readonly SLIDER_WIDTH: string = '70%';

  /**
   * Loading width and height.
   */
  public static readonly LOADING_WH: string = '30%';

  /**
   * Clock wise.
   */
  public static readonly CLOCK_WISE: number = 90;

  /**
   * Anti clock.
   */
  public static readonly ANTI_CLOCK: number = -90;

  /**
   * Tab menu width.
   */
  public static readonly TAB_MENU_WIDTH: number = 24;

  /**
   * Navigation height.
   */
  public static readonly NAVIGATION_HEIGHT: number = 56;

  public static readonly TRANSITION_DELAY: number = 1000;

  public static readonly TRANSITION_DURATION: number = 500;

  /**
   * Adjust slider value.
   */
  public static readonly ADJUST_SLIDER_VALUE: number[] = [100, 100, 100];

  /**
   * Slider min.
   */
  public static readonly SLIDER_MIN: number = 1;

  /**
   * Slider max.
   */
  public static readonly SLIDER_MAX: number = 100;

  /**
   * Slider step.
   */
  public static readonly SLIDER_STEP: number = 10;

  /**
   * Pixel step.
   */
  public static readonly PIXEL_STEP: number = 4;

  /**
   * Decimal two.
   */
  public static readonly DECIMAL_TWO: number = 2;

  /**
   * Color level max.
   */
  public static readonly COLOR_LEVEL_MAX: number = 255;

  /**
   * Convert int.
   */
  public static readonly CONVERT_INT: number = 100;

  /**
   * Angle 60.
   */
  public static readonly ANGLE_60: number = 60;

  /**
   * Angle 120.
   */
  public static readonly ANGLE_120: number = 120;

  /**
   * Angle 240.
   */
  public static readonly ANGLE_240: number = 240;

  /**
   * Angle 300.
   */
  public static readonly ANGLE_360: number = 360;

  /**
   * Average height and width.
   */
  public static readonly AVERAGE_WEIGHT_WIDTH: number = 2;

  /**
   * Crop rate 4:3.
   */
  public static readonly CROP_RATE_4_3: number = 0.75;

  /**
   * Crop rate 9:16.
   */
  public static readonly CROP_RATE_9_16: number = 9 / 16;

  /**
   * Encode quality.
   */
  public static readonly ENCODE_QUALITY: number = 100;

  /**
   * Title space.
   */
  public static readonly TITLE_SPACE: number = 0;

  /**
   * Slider mode click.
   */
  public static readonly SLIDER_CLICK_MODE: number = 3;

  /**
   * Encode format.
   */
  public static readonly ENCODE_FORMAT: string = 'image/jpeg';

  /**
   * Encode file permission.
   */
  public static readonly ENCODE_FILE_PERMISSION: string = 'rw';

  /**
   * Adjust worker file.
   */
  public static readonly ADJUST_WORKER_FILE: string = 'pixelmapimageeditsample/ets/workers/AdjustWork.ets';

  /**
   * Image name.
   */
  public static readonly IMAGE_PREFIX: string = 'image';

  /**
   * Image format.
   */
  public static readonly IMAGE_FORMAT: string = '.jpg';

  /**
   * Rawfile name.
   */
  public static readonly RAW_FILE_NAME: string = 'low.jpg';

  /**
   * Sample Prefix key.
   */
  public static readonly KEY_PREFIX: string = 'PIXEL_MAP_IMAGE_EDIT';

  /**
   * Current breakpoint key.
   */
  public static readonly BREAKPOINT_KEY: string = 'PIXEL_MAP_IMAGE_EDIT_CURRENT_BREAKPOINT';

  /**
   * Avoid area key.
   */
  public static readonly AVOID_AREA_KEY: string = 'PIXEL_MAP_IMAGE_EDIT_AVOID_AREA';

  /**
   * Avoid area top key.
   */
  public static readonly AVOID_AREA_TOP: string = 'PIXEL_MAP_IMAGE_EDIT_AVOID_TOP';

  /**
   * Avoid area bottom key.
   */
  public static readonly AVOID_AREA_BOTTOM: string = 'PIXEL_MAP_IMAGE_EDIT_AVOID_BOTTOM';

  /**
   * Is PC device key.
   */
  public static readonly IS_PC_DEVICE: string = 'PIXEL_MAP_IMAGE_EDIT_IS_PC_DEVICE';

  /**
   * Is Window Full Screen.
   */
  public static readonly IS_FULLSCREEN: string = 'PIXEL_MAP_IMAGE_EDIT_IS_FULLSCREEN';

  /**
   * Is Folded.
   */
  public static readonly IS_FOLDED: string = 'PIXEL_MAP_IMAGE_EDIT_IS_FOLDED';

  /**
   * Image properties keys.
   */
  public static readonly IMG_PROPERTIES_KEYS: image.PropertyKey[] = [
    image.PropertyKey.ORIENTATION,
    image.PropertyKey.BITS_PER_SAMPLE,
    image.PropertyKey.IMAGE_LENGTH,
    image.PropertyKey.IMAGE_WIDTH,
    image.PropertyKey.SCENE_TYPE,
    image.PropertyKey.ISO_SPEED_RATINGS,
    image.PropertyKey.F_NUMBER,
    image.PropertyKey.DATE_TIME,
    image.PropertyKey.IMAGE_DESCRIPTION,
    image.PropertyKey.MAKE,
    image.PropertyKey.MODEL,
    image.PropertyKey.PHOTO_MODE,
    image.PropertyKey.SENSITIVITY_TYPE,
    image.PropertyKey.ISO_SPEED,
    image.PropertyKey.APERTURE_VALUE,
    image.PropertyKey.METERING_MODE,
    image.PropertyKey.LIGHT_SOURCE,
    image.PropertyKey.FLASH,
    image.PropertyKey.FOCAL_LENGTH,
    image.PropertyKey.PIXEL_X_DIMENSION,
    image.PropertyKey.EXPOSURE_TIME,
  ];

  /**
   * Filter thumbnail size.
   */
  public static readonly FILTER_THUMBNAIL_SIZE: number = 68;

  /**
   * Filter item height in sm breakpoint (thumbnail + title height + margin).
   */
  public static readonly FILTER_ITEM_HEIGHT_SM: number = 86;

  /**
   * Edit menu icons.
   */
  public static readonly EDIT_MENU_ICONS: string[] = [
    'crop_rotate',
    'slider_horizontal_2',
    'camera_filters',
    'square_portrait_svg',
    'checkered_magnifyingglass',
  ];
}