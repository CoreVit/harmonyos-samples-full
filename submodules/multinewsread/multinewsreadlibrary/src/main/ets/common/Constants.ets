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

export default class Constants {
  /*
   * columns number default
  */
  public static readonly COLUMN_DEFAULT: number = 12;
  /*
   * auto
   */
  public static readonly LAYOUT_AUTO: string = 'auto';
  /*
   * Full Screen width
   */
  public static readonly FULL_WIDTH: string = '100%';
  /*
   * Full half height
   */
  public static readonly HALF_HEIGHT: string = '50%';
  /*
   * One-third width
   */
  public static readonly ONE_THIRD_WIDTH: string = '33%';
  /*
   * Full Screen height
   */
  public static readonly FULL_HEIGHT: string = '100%';
  /*
   * Index page padding top size.
   */
  public static readonly PADDING_TOP_INDEX: number = 64;
  /*
   * Index page padding bottom size.
   */
  public static readonly PADDING_BOTTOM_INDEX: number = 16;
  /*
   * List gutter
   */
  public static readonly LIST_GUTTER: string = '5vp';
  /*
   * Grid all columns
   */
  public static readonly GRID_ALL_COLUMNS: number = 4;
  /*
   * Grid row columns
   */
  public static readonly GRID_ROW_COLUMNS: number[] = [1, 2, 4];
  /*
   * Grid column span
   */
  public static readonly GRID_COLUMN_SPAN: number[] = [1, 2, 4];
  /*
   * The space occupied by the grid layout
   */
  public static readonly GRID_COL_SPAN: number[] = [1, 2, 3, 4, 6, 12];
  /*
   * Grid horizontal gutter
   */
  public static readonly GRID_HORIZONTAL_GUTTER: string[] = ['24vp', '32vp'];
  /*
   * Grid vertical gutter
   */
  public static readonly GRID_VERTICAL_GUTTER: string[] = ['4vp', '16vp'];
  /*
   * Font weight array
   */
  public static readonly FONT_WEIGHT: number[] = [400, 500, 700];
  /*
   * Opacity array
   */
  public static readonly OPACITY: number[] = [0.4, 0.6, 0.9, 0.2];
  /*
   * Hot list background colors
   */
  public static readonly HOT_LIST_BACKGROUND_COLORS: string[] = [
    '#E84026', '#E84026', '#E84026',
    '#969696', '#969696', '#969696',
    '#969696', '#969696'
  ];
  /*
   * Routes
   */
  public static readonly ROUTES: Route[] = [
    {
      text: $r('app.string.repeated_layout_1'), to: 'MediaNews'
    },
    {
      text: $r('app.string.repeated_layout_2'), to: 'NewsChannel'
    },
    {
      text: $r('app.string.list_to_grid'), to: 'NewsListPage'
    }
  ];
  /*
   * News ID List
   */
  public static readonly NEWS_ID_LIST: string[] = ['001', '002', '003', '004', '005', '006', '007', '008'];
  /*
   * Video duration
   */
  public static readonly VIDEO_DURATION: string = '00:45';
  /*
   * Empty string
   */
  public static readonly EMPTY_STRING: string = '';
  /*
   * All breakpoints
   */
  public static readonly BREAKPOINTS: string[] = ['sm', 'md', 'lg', 'xl'];
  /*
   * AppStorage key
   */
  public static readonly KEY_PREFIX_TEXT_EFFECTS: string = 'newsRead';
  public static readonly KEY_BREAKPOINT: string = Constants.KEY_PREFIX_TEXT_EFFECTS + 'Breakpoint';
  public static readonly KEY_STATUS_BAR_HEIGHT: string = Constants.KEY_PREFIX_TEXT_EFFECTS + 'StatusBarHeight';
  public static readonly KEY_NAV_INDICATOR_HEIGHT: string = Constants.KEY_PREFIX_TEXT_EFFECTS + 'NavIndicatorHeight';
  public static readonly KEY_PATH_STACK: string = Constants.KEY_PREFIX_TEXT_EFFECTS + 'PathStack';
  public static readonly KEY_UI_CONTEXT: string = Constants.KEY_PREFIX_TEXT_EFFECTS + 'UIContext';
}

/*
 * Route type define
 */
export interface Route {
  text: Resource,
  to: string
}
