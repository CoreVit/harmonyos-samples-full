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
import { StockDealDataService } from '../models/StockDealDataModel';

@Observed
export class StockDealViewModel {
  public buySellSharesList: TransactionDetails[] = [];
  public sellSharesList: TransactionDetails[] = [];
  public submissionTimeList: TransactionDetails[] = [];
  private defaultPurchaseQuantity: number = 100;
  public isLoading: boolean = false;
  private dataService: StockDealDataService = new StockDealDataService();

  loadData(): void {
    this.isLoading = true;
    this.buySellSharesList = this.dataService.getBuySellSharesList();
    this.sellSharesList = this.dataService.getSellSharesList();
    this.submissionTimeList = this.dataService.getSubmissionTimeList();
    this.defaultPurchaseQuantity = this.dataService.getDefaultPurchaseQuantity();
    this.isLoading = false;
  }

  getDefaultPurchaseQuantity(): number {
    return this.defaultPurchaseQuantity;
  }

  resetPurchaseQuantity(): void {
    this.defaultPurchaseQuantity = this.dataService.getDefaultPurchaseQuantity();
  }
}