/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

export class ConstValues {
  /**
   * How much money.
   */
  public static readonly MONEY: string = '88888.88';
  /**
   * The benefits.
   */
  public static readonly BENEFIT: string = '+3.63';
  /**
   * Flexible access name
   */
  public static readonly FLEXIBLE_ACCESS: ResourceStr = $r('app.string.flexible_access');
  /**
   * Stable financial management
   */
  public static readonly STABLE_FINANCIAL_MANAGEMENT: ResourceStr = $r('app.string.stable_financial_management');
  /**
   * Advanced Financial Management
   */
  public static readonly ADVANCED_FINANCIAL_MANAGEMENT: ResourceStr = $r('app.string.advanced_financial_management');
  /**
   * Default money.
   */
  public static readonly DEFAULT_MONEY: string = '0.00';
  /**
   * The benefits.
   */
  public static readonly DEFAULT_BENEFIT: string = '0.00';
  /**
   * default hide info
   */
  public static readonly DEFAULT_HIDE_INFO: string = '****';
  /**
   * the key for window id
   */

  public static readonly KEY_PREFIX: string = 'anti-peep';
  public static readonly WINDOW_ID_NAME: string = `${ConstValues.KEY_PREFIX}WINDOW_ID_NAME`;
  public static readonly KEY_BREAK_POINT: string = `${ConstValues.KEY_PREFIX}currentBreakpoint`;
  public static readonly KEY_STATUS_BAR_HEIGHT: string = `${ConstValues.KEY_PREFIX}statusBarHeight`;
  public static readonly KEY_NAVIGATOR_BAR_HEIGHT: string = `${ConstValues.KEY_PREFIX}navigatorBarHeight`;
}