/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

export class CommonConstants {
  /**
   * The full percentage of component.
   */
  public static readonly FULL_PERCENT: string = '100%';
  /**
   * Forty-five percent.
   */
  public static readonly FORTY_FIVE_PERCENT: string = '45%';
  /**
   * Padding top.
   */
  public static readonly PADDING_TOP: string = '4%';
  /**
   * 1.5%.
   */
  public static readonly ONE_POINT_FIVE_PERCENT: string = '1.5%';
  /**
   * Margin 0.5%.
   */
  public static readonly MARGIN_ZERO_POINT_FIVE_PERCENT: string = '0.5%';
  /**
   * Margin top.
   */
  public static readonly MARGIN_TOP: string = '0.4%';
  /**
   * Margin 0.3%.
   */
  public static readonly MARGIN_ZERO_POINT_THREE_PERCENT: string = '0.3%';
  /**
   * Text fontWeight.
   */
  public static readonly TEXT_FONT_WEIGHT: number = 700;
  /**
   * Text lineHeight.
   */
  public static readonly TEXT_LINE_HEIGHT: number = 28;
  /**
   * Text lineHeight 19.
   */
  public static readonly TEXT_LINE_HEIGHT_19: number = 19;
  /**
   * Text fontWeight 400.
   */
  public static readonly TEXT_FONT_WEIGHT_400: number = 400;
  /**
   * Text opacity.
   */
  public static readonly TEXT_OPACITY: number = 0.6;
  /**
   * TextArea placeholder.
   */
  public static readonly TEXT_AREA_PLACEHOLDER: string = 'Input text here...';
  /**
   * The prefix of app store key.
   */
  public static readonly PREFIX: string = 'picker_';
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
   * The key of file name list.
   */
  public static readonly AS_KEY_FILE_NAME_LIST: string = `${CommonConstants.PREFIX}fileNameList`;
  /**
   * The key of file uri list.
   */
  public static readonly AS_KEY_FILE_URI_LIST: string = `${CommonConstants.PREFIX}fileUriList`;
  /**
   * The key of file size list.
   */
  public static readonly AS_KEY_FILE_SIZE_LIST: string = `${CommonConstants.PREFIX}fileSizeList`;
  /**
   * The key of my file name.
   */
  public static readonly AS_KEY_MY_FILE_NAME: string = `${CommonConstants.PREFIX}myFileName`;
  /**
   * The key of my file size.
   */
  public static readonly AS_KEY_MY_FILE_SIZE: string = `${CommonConstants.PREFIX}myFileSize`;
  /**
   * The key of my file content.
   */
  public static readonly AS_KEY_MY_FILE_CONTENT: string = `${CommonConstants.PREFIX}myFileContent`;
  /**
   * The duration of write file success.
   */
  public static readonly WRITE_SUCCESS_DURATION: number = 6500;
}
