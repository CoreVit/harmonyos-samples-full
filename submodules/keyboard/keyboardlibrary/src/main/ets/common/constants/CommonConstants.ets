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
   * Tag
   */
  public static readonly TAG: string = '[keyboard]';
  /**
   * The hundred percent of the components
   */
  public static readonly FULL_PERCENT: string = '100%';
  /**
   * The seventy five percent of the components
   */
  public static readonly SEVENTY_FIVE_PERCENT: string = '75%';
  /**
   * The seventy percent of the components
   */
  public static readonly SEVENTY_PERCENT: string = '70%';
  /**
   * The sixty percent of the components
   */
  public static readonly SIXTY_PERCENT: string = '60%';
  /**
   * The fifty percent of the components
   */
  public static readonly FIFTY_PERCENT: string = '50%';
  /**
   * The forty six percent of the components
   */
  public static readonly FORTY_SIX_PERCENT: string = '46%';
  /**
   * The forty percent of the components
   */
  public static readonly FORTY_PERCENT: string = '40%';
  /**
   * The zero percent of the components
   */
  public static readonly ZERO_PERCENT: string = '0%';
  /**
   * The width of home page
   */
  public static readonly HOME_PAGE_WIDTH: number = 448;
  /**
   * The space of container
   */
  public static readonly CONTAINER_SPACE: number = 12;
  /**
   * The space of padding 16
   */
  public static readonly PADDING_SPACE_16: number = 16;
  /**
   * The prefix of app store key.
   */
  public static readonly PREFIX: string = 'keyboard_';
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
   * The key of chat list path stack.
   */
  public static readonly AS_KEY_CHAT_LIST_PATH_STACK: string = `${CommonConstants.PREFIX}chatListPathStack`;
  /**
   * The key of chat list path stack.
   */
  public static readonly AS_KEY_SYSTEM_UICONTEXT: string = `${CommonConstants.PREFIX}UIContext`;
}