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

/*
 * Common constants for all features.
 */
export class Constants {
  /*
   * Back Button size.
   */
  public static readonly BACK_SIZE: number = 48;
  /*
   * Index page padding top size.
   */
  public static readonly PADDING_TOP_INDEX: number = 64;
  /*
   * Index page padding bottom size.
   */
  public static readonly PADDING_BOTTOM_INDEX: number = 16;
  /*
   * Image size.
   */
  public static readonly IMAGE_SIZE_SMALL: number = 24;
  /*
   * Grid space.
   */
  public static readonly GRID_SPACE: number = 12;
  /*
   * List space.
   */
  public static readonly LIST_SPACE: number = 20;
  /*
   * Custom padding top size.
   */
  public static readonly PADDING_CUSTOM: number = 8;
  /*
   * Custom padding size 16.
   */
  public static readonly PADDING_16: number = 16;
  /*
   * Custom padding size 24.
   */
  public static readonly PADDING_24: number = 24;
  /*
   * Custom padding size 32.
   */
  public static readonly PADDING_32: number = 32;
  /*
   * Album title padding left.
   */
  public static readonly ALBUMS_PADDING_LEFT: number = 36;
  /*
   * Mail content mail-to min text size.
   */
  public static readonly MAIL_TEXT_MIN: number = 50;
  /*
   * Width the percentage of the 100.
   */
  public static readonly FULL_WIDTH: string = '100%';
  /*
   * Height the percentage of the 100.
   */
  public static readonly FULL_HEIGHT: string = '100%';
  /*
   * Breakpoint sm navBarWidth.
   */
  public static readonly NAV_BAR_WIDTH_SM: number = 321;
  /*
   * Breakpoint md navBarWidth.
   */
  public static readonly NAV_BAR_WIDTH_MD: number = 321;
  /*
 * Breakpoint lg navBarWidth.
 */
  public static readonly NAV_BAR_WIDTH_LG: number = 321;
  /*
   * Breakpoint xl navBarWidth.
   */
  public static readonly NAV_BAR_WIDTH_XL: number = 390;
  /*
   * SideBarContainer minSideBarWidth.
   */
  public static readonly SIDE_BAR_WIDTH_MIN: number = 240;
  /*
   * SideBarContainer minContentWidth.
   */
  public static readonly SIDE_BAR_WIDTH_CONTENT_MIN: number = 600;
  /*
   * AppStorage key
   */
  public static readonly KEY_PREFIX_COLUMNS: string = 'multiColumns';
  public static readonly KEY_BREAKPOINT: string = Constants.KEY_PREFIX_COLUMNS + 'BreakPoint';
  public static readonly KEY_STATUS_BAR_HEIGHT: string = Constants.KEY_PREFIX_COLUMNS + 'StatusBarHeight';
  public static readonly KEY_NAV_INDICATOR_HEIGHT: string = Constants.KEY_PREFIX_COLUMNS + 'NavIndicatorHeight';
  public static readonly KEY_PATH_STACK: string = Constants.KEY_PREFIX_COLUMNS + 'PathStack';
  public static readonly KEY_UI_CONTEXT: string = Constants.KEY_PREFIX_COLUMNS + 'UIContext';
  /*
   * Routes
   */
  public static readonly ROUTES: Route[] = [
    {
      text: $r('app.string.first_title'), to: 'MailBox'
    },
    {
      text: $r('app.string.second_title'), to: 'PhotoAlbum'
    },
    {
      text: $r('app.string.third_title'), to: 'Settings'
    }
  ];
}

/*
 * Route type define
 */
export interface Route {
  text: Resource,
  to: string
}