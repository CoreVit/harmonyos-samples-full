/*
* Copyright (C) 2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
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

export default class Constants {
  /*
   * AppStorage key
   */
  public static readonly KEY_PREFIX: string = 'docScan';
  public static readonly KEY_PATH_STACK: string = Constants.KEY_PREFIX + 'PathStack';
  public static readonly KEY_BREAKPOINT: string = Constants.KEY_PREFIX + 'Breakpoint';
  public static readonly KEY_STATUS_BAR_HEIGHT: string = Constants.KEY_PREFIX + 'StatusBarHeight';
  public static readonly KEY_NAV_INDICATOR_HEIGHT: string = Constants.KEY_PREFIX + 'NavIndicatorHeight';
  public static readonly KEY_UI_CONTEXT: string = Constants.KEY_PREFIX + 'UIContext';
  /**
   * default width
   */
  public static readonly DEFAULT_WIDTH: number = 360;
  /**
   * item space
   */
  public static readonly LIST_ITEM_SPACE: number = 2;
  /**
   * show count
   */
  public static readonly SHOW_COUNT: number = 8;
  /**
   * double number
   */
  public static readonly DOUBLE_NUMBER: number = 2;
}