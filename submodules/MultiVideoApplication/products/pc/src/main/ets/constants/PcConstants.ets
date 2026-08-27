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

export class PcConstants {
  public static readonly PAGE_NAME_FOR_VIDEO: string = 'MultiVideoDetail';
  public static readonly PAGE_NAME_FOR_SEARCH: string = 'MultiVideoSearch';
  public static readonly TOP_TOPIC_LIST: ResourceStr[] =
    [$r('app.string.sift'), $r('app.string.home_video'), $r('app.string.community'), $r('app.string.news'),
      $r('app.string.shop'), $r('app.string.science'), $r('app.string.finance'), $r('app.string.history'),
      $r('app.string.affairs')];
  public static readonly SEARCH_PLACEHOLDER: ResourceStr = $r('app.string.search');
  public static readonly BACKGROUND_CHANGE_HEIGHT: number[] = [27, 34, 56, 0];
  public static readonly DIRECTION_LIST: string[] = ['BottomTabs', 'TopTabs', 'Banner', 'IconList', 'PopularVideo',
    'NewRelease', 'DailyVideoOne', 'DailyVideoTwo', 'PreviousVideo'];
  public static readonly VP_UNIT: string = 'vp';
  public static readonly HOME_HEADER_HEIGHT_SM: number = 112;
  public static readonly TOP_BAR_HEIGHT: number = 64;
  public static readonly SCROLL_BAR_HIDE_THRESHOLD: number = 100;
  public static readonly HOME_BOTTOM_INDEX: number = 0;
  public static readonly COMMUNITY_TOP_INDEX: number = 2;
  public static readonly INVALID_ENVIRONMENT_CALLBACK_ID: number = -1;
}

export function getTabIndex(direction: string): number {
  let tabIndex: number = 0;
  switch (direction) {
    case PcConstants.DIRECTION_LIST[0]:
      tabIndex = 1;
      break;
    case PcConstants.DIRECTION_LIST[1]:
      tabIndex = 2;
      break;
    case PcConstants.DIRECTION_LIST[2]:
      tabIndex = 3;
      break;
    case PcConstants.DIRECTION_LIST[3]:
      tabIndex = 4;
      break;
    case PcConstants.DIRECTION_LIST[4]:
      tabIndex = 5;
      break;
    case PcConstants.DIRECTION_LIST[5]:
      tabIndex = 6;
      break;
    case PcConstants.DIRECTION_LIST[6]:
      tabIndex = 7;
      break;
    case PcConstants.DIRECTION_LIST[7]:
      tabIndex = 8;
      break;
    case PcConstants.DIRECTION_LIST[8]:
      tabIndex = 9;
      break;
    default:
      break;
  }
  return tabIndex;
}
