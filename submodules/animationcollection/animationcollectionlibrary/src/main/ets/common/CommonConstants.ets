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

import { NavDestinationItem } from '../viewmodel/NavDestinationItem';

export default class CommonConstants {
  /**
   * One hundred percent.
   */
  public static readonly FULL_PERCENT: string = '100%';
  /**
   * NavDestinationItem.
   */
  public static readonly navDestinationData: NavDestinationItem[] = [
    {
      name: 'PageTurningAnimation',
      detail: $r('app.string.page_turning_animation'),
      xsHasDivide: true,
      mdHasDivide: true
    },
    {
      name: 'PageStatusBarChange',
      detail: $r('app.string.page_status_bar_change'),
      xsHasDivide: true,
      mdHasDivide: true
    },
    {
      name: 'PageListSlideToHistory',
      detail: $r('app.string.page_list_slide_to_history'),
      xsHasDivide: true,
      mdHasDivide: true
    },
    {
      name: 'PageWaterRipples',
      detail: $r('app.string.page_water_ripples'),
      xsHasDivide: true,
      mdHasDivide: true
    },
    {
      name: 'PageWaterMarqueeView',
      detail: $r('app.string.page_marquee_view'),
      xsHasDivide: true,
      mdHasDivide: true
    },
    {
      name: 'SwiperSmoothVariation',
      detail: $r('app.string.swiper_smooth_variation'),
      xsHasDivide: true,
      mdHasDivide: true
    },
    {
      name: 'PagePaintComponent',
      detail: $r('app.string.page_paint_component'),
      xsHasDivide: true,
      mdHasDivide: true
    },
    {
      name: 'DigitalScrollExample',
      detail: $r('app.string.digital_scroll_example'),
      xsHasDivide: true,
      mdHasDivide: true
    },
    {
      name: 'VotingComponent',
      detail: $r('app.string.voting_component'),
      xsHasDivide: false,
      mdHasDivide: false
    }
  ];

  /**
   * AppStorage key prefix.
   */
  public static readonly KEY_PREFIX: string = 'animation-collection';
  public static readonly KEY_PREFIX_BREAKPOINT: string = CommonConstants.KEY_PREFIX + 'CurrentBreakpoint';
  public static readonly KEY_PREFIX_NAVIGATOR_BAR_HEIGHT: string = CommonConstants.KEY_PREFIX + 'NavigatorBarHeight';
  public static readonly KEY_PREFIX_STATUS_BAR_HEIGHT: string = CommonConstants.KEY_PREFIX + 'StatusBarHeight';
  public static readonly KEY_PREFIX_SYSTEM_UICONTEXT: string = CommonConstants.KEY_PREFIX + 'UIContext';
  public static readonly KEY_PREFIX_SYSTEM_PAGE_INFO: string = CommonConstants.KEY_PREFIX + 'PageInfos';
  public static readonly KEY_PREFIX_SYSTEM_NAVPATHSTACK: string = CommonConstants.KEY_PREFIX + 'NavPathStack';

}
