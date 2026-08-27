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

export class Constants {
  /**
   * All breakpoints
   */
  public static readonly BREAKPOINTS: string[] = ['sm', 'md', 'lg'];
  /**
   * Full Screen width
   */
  public static readonly FULL_WIDTH: string = '100%';
  /**
   * Full Screen height
   */
  public static readonly FULL_HEIGHT: string = '100%';
  /**
   * Index page padding top size.
   */
  public static readonly PADDING_TOP_INDEX: number = 64;
  /**
   * Index page padding bottom size.
   */
  public static readonly PADDING_BOTTOM_INDEX: number = 16;
  /**
   * Set the url whitelist of the current web
   */
  public static readonly URL_TRUST: string =
    '{\"UrlPermissionList\": [{\"scheme\": \"https\",\"host\": \"developer.huawei.com\"}]}';
  /**
   * AppStorage key
   */
  public static readonly KEY_PREFIX: string = 'webPrerender';
  public static readonly KEY_BREAKPOINT: string = Constants.KEY_PREFIX + 'BreakPoint';
  public static readonly KEY_STATUS_BAR_HEIGHT: string = Constants.KEY_PREFIX + 'StatusBarHeight';
  public static readonly KEY_NAV_INDICATOR_HEIGHT: string = Constants.KEY_PREFIX + 'NavIndicatorHeight';
  public static readonly KEY_UI_CONTEXT: string = Constants.KEY_PREFIX + 'UIContext';
}