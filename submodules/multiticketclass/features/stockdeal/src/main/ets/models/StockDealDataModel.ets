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
import { TransactionDetails } from '@stock/base';

const BUY_SELL_SHARES_DATA: TransactionDetails[] = [
  new TransactionDetails($r('app.string.text_buy'), '20.05', 11),
  new TransactionDetails($r('app.string.text_buy'), '20.04', 22),
  new TransactionDetails($r('app.string.text_buy'), '20.03', 33),
  new TransactionDetails($r('app.string.text_buy'), '20.02', 55),
  new TransactionDetails($r('app.string.text_buy'), '20.01', 66)
];

const SELL_SHARES_DATA: TransactionDetails[] = [
  new TransactionDetails($r('app.string.sell'), '20.10', 69),
  new TransactionDetails($r('app.string.sell'), '20.09', 12),
  new TransactionDetails($r('app.string.sell'), '20.08', 66),
  new TransactionDetails($r('app.string.sell'), '20.07', 55),
  new TransactionDetails($r('app.string.sell'), '20.06', 33)
];

const SUBMISSION_TIME_DATA: TransactionDetails[] = [
  new TransactionDetails('10:02', '20.07', 11),
  new TransactionDetails('10:02', '20.07', 22),
  new TransactionDetails('10:02', '20.07', 33),
  new TransactionDetails('10:02', '20.08', 55),
  new TransactionDetails('10:02', '20.08', 66),
  new TransactionDetails('10:01', '20.07', 33),
  new TransactionDetails('10:01', '20.07', 22),
  new TransactionDetails('10:01', '20.07', 66),
  new TransactionDetails('10:01', '20.07', 99),
  new TransactionDetails('10:01', '20.07', 77),
  new TransactionDetails('10:00', '20.06', 33),
  new TransactionDetails('10:00', '20.06', 22),
  new TransactionDetails('10:00', '20.06', 66),
  new TransactionDetails('10:00', '20.05', 99),
  new TransactionDetails('10:00', '20.05', 77)
];

const DEFAULT_PURCHASE_QUANTITY_VALUE = 100;

export class StockDealDataService {
  private buySellSharesList: TransactionDetails[] = BUY_SELL_SHARES_DATA;
  private sellSharesList: TransactionDetails[] = SELL_SHARES_DATA;
  private submissionTimeList: TransactionDetails[] = SUBMISSION_TIME_DATA;
  private defaultPurchaseQuantity: number = DEFAULT_PURCHASE_QUANTITY_VALUE;

  getBuySellSharesList(): TransactionDetails[] {
    return this.buySellSharesList;
  }

  getSellSharesList(): TransactionDetails[] {
    return this.sellSharesList;
  }

  getSubmissionTimeList(): TransactionDetails[] {
    return this.submissionTimeList;
  }

  getDefaultPurchaseQuantity(): number {
    return this.defaultPurchaseQuantity;
  }
}