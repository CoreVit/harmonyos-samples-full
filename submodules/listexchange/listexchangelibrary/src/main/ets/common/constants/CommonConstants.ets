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

/**
 * Common constants for all features.
 */
import { ListInfo } from '../../viewmodel/ListInfo';

export class CommonConstants {
  /**
   *Mock data
   */
  public static readonly MEMO_DATA: ListInfo[] = [
    new ListInfo($r('app.media.list_exchange_ic_public_cards_filled'), $r('app.string.bank_card_NO1')),
    new ListInfo($r('app.media.list_exchange_ic_public_cards_filled2'), $r('app.string.bank_card_NO2')),
    new ListInfo($r('app.media.list_exchange_ic_public_cards_filled3'), $r('app.string.bank_card_NO3')),
    new ListInfo($r('app.media.list_exchange_ic_public_cards_filled4'), $r('app.string.bank_card_NO4'))
  ];
  /**
   *List item height
   */
  public static readonly ITEM_HEIGHT: number = 48;
  /**
   * List item zIndex value1
   */
  public static readonly COMPONENT_LEVEL1: number = 1;
  /**
   * List item zIndex value2
   */
  public static readonly COMPONENT_LEVEL2: number = 2;
  /**
   * List item opacity value1
   */
  public static readonly LIST_ITEM_IS_SELECT_OPACITY: number = 0.5;
  /**
   * List item opacity value2
   */
  public static readonly LIST_ITEM_NOT_SELECT_OPACITY: number = 1;
  /**
   * The animation duration
   */
  public static readonly ANIMATE_DURATION: number = 300;
  /**
   * The left offset of list item
   */
  public static readonly LIST_ITEM_LEFT_OFFSET: number = 150;
  /**
   * The prefix of app store key.
   */
  public static readonly PREFIX: string = 'list_exchange_';
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
   * The key of is long press.
   */
  public static readonly AS_KEY_IS_LONG_PRESS: string = `${CommonConstants.PREFIX}isLongPress`;
}