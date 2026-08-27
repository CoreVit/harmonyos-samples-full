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
   * Index content width.
   */
  public static readonly INDEX_CONTENT_WIDTH: string = '91.1%';
  /**
   * Content padding top size.
   */
  public static readonly PADDING_TOP_SMALL: number = 8;
  /**
   * Card title height.
   */
  public static readonly CARD_TITLE_HEIGHT: number = 20;
  /**
   * Index title height.
   */
  public static readonly INDEX_TITLE_HEIGHT: number = 40;
  /**
   * Full screen width.
   */
  public static readonly FULL_WIDTH: string = '100%';
  /**
   * Full screen height.
   */
  public static readonly FULL_HEIGHT: string = '100%';
  /**
   * Content height.
   */
  public static readonly CONTENT_HEIGHT: number = 300;
  /**
   * Sub tab bottom height.
   */
  public static readonly SUB_TAB_BOT_HEIGHT: number = 25;
  /**
   * Sub tab width.
   */
  public static readonly SUB_TAB_HEIGHT: number = 30;
  /**
   * image size.
   */
  public static readonly IMAGE_SIZE: number = 24;
  /**
   * padding 8.
   */
  public static readonly PADDING_8: number = 8;
  /**
   * padding 12.
   */
  public static readonly PADDING_12: number = 12;
  /**
   * padding 36.
   */
  public static readonly PADDING_36: number = 36;
  /**
   * Tab index0.
   */
  public static readonly TAB_INDEX_ZERO: number = 0;
  /**
   * Tab index1.
   */
  public static readonly TAB_INDEX_ONE: number = 1;
  /**
   * Tab index2.
   */
  public static readonly TAB_INDEX_TWO: number = 2;
  /**
   * Tab index3.
   */
  public static readonly TAB_INDEX_THREE: number = 3;
  /**
   * More image width.
   */
  public static readonly MORE_IMAGE_WIDTH: number = 20;
  /**
   * Icon offset.
   */
  public static readonly ICON_OFFSET: number = -3;
  /**
   * Animation duration.
   */
  public static readonly ANIMATION_DURATION: number = 300;
  /**
   * Divider strokeWidth.
   */
  public static readonly STROKE_WIDTH: number = 2;
  /**
   * fontWeight.
   */
  public static readonly FONT_WEIGHT_TAB: number = 600;
  /**
   * TopTabData.
   */
  public static readonly TOP_TAB_DATA: Array<Resource | string> =
    [$r('app.string.tab1'), $r('app.string.tab2'), $r('app.string.tab3'),
      $r('app.string.tab4'), $r('app.string.ceremony'), $r('app.string.play')];
  /**
   * Routes.
   */
  public static readonly ROUTES: Route[] = [
    {
      id: 0,
      title: $r('app.string.bottom_nav'),
      child: [
        {
          id: 0,
          text: $r('app.string.common_bottom_nav'),
          to: 'BottomTab'
        },
        {
          id: 1,
          text: $r('app.string.rudder_bottom_nav'),
          to: 'RudderStyleTab'
        }
      ]
    },
    {
      id: 1,
      title: $r('app.string.top_nav'),
      child: [
        {
          id: 0,
          text: $r('app.string.left_tab'),
          to: 'LeftTab'
        },
        {
          id: 1,
          text: $r('app.string.underline_tab'),
          to: 'UnderlineTab'
        },
        {
          id: 2,
          text: $r('app.string.background_light_tab'),
          to: 'BackgroundLightTab'
        },
        {
          id: 3,
          text: $r('app.string.word_tab'),
          to: 'WordTab'
        },
        {
          id: 4,
          text: $r('app.string.double_nesting_tab_one'),
          to: 'DoubleNestingTabOne'
        },
        {
          id: 5,
          text: $r('app.string.double_nesting_tab_two'),
          to: 'DoubleNestingTabTwo'
        },
        {
          id: 6,
          text: $r('app.string.slide_and_mor_tab'),
          to: 'SlideAndMoreTab'
        },
        {
          id: 7,
          text: '',
          to: ''
        }
      ]
    },
    {
      id: 2,
      title: $r('app.string.side_tab'),
      child: [
        {
          id: 0,
          text: $r('app.string.common_side_tab'),
          to: 'SideTab'
        },
        {
          id: 1,
          text: $r('app.string.drawer_tab'),
          to: 'DrawerTab'
        }
      ]
    }
  ];
  /**
   * The prefix of app store key.
   */
  public static readonly PREFIX: string = 'multi_tab_navigation_';
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

/**
 * Route type define.
 */
export interface Route {
  id: number;
  title: string | Resource;
  child: Array<ChildRoute>;
}

/**
 * ChildRoute type define.
 */
export interface ChildRoute {
  id: number;
  text: string | Resource;
  to: string;
}