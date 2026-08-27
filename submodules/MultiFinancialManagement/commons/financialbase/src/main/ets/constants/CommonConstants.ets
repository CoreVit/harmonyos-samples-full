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

import { BreakpointType } from '../utils/BreakpointType';

export class CommonConstants {
  /**
   * AppStorage key
   */
  public static readonly KEY_PREFIX: string = 'multiFinancialManagement';
  public static readonly WINDOW_UTIL_KEY: string = CommonConstants.KEY_PREFIX + 'WindowUtil';
  /**
   * Page name.
   */
  public static readonly HOME_PAGE_NAME: string = 'HomePage';
  public static readonly ASSET_PAGE_NAME: string = 'AssetPage';
  public static readonly FINANCIAL_DETAIL_PAGE_NAME: string = 'FinancialDetailPage';
  public static readonly PAY_PAGE_NAME: string = 'Buy';
  /**
   * Product code.
   */
  public static readonly PRODUCT_CODE_TEMPLATE: string = 'LC************1';
  /**
   * Product rate.
   */
  public static readonly PRODUCT_RATE: string = '2.60%';
  /**
   * Product timeline date.
   */
  public static readonly TIMELINE_DATE: string = '5/20';
  /**
   * Product perpetual.
   */
  public static readonly TIMELINE_PERPETUAL: string = '';
  /**
   * Common padding.
   */
  public static readonly COMMON_PADDING: BreakpointType<number>[] =
    [new BreakpointType(16, 24, 0, 0), new BreakpointType(16, 24, 24, 24), new BreakpointType(16, 24, 32, 32),
      new BreakpointType(0, 0, 32, 32), new BreakpointType(24, 72, 86, 96)];
}
