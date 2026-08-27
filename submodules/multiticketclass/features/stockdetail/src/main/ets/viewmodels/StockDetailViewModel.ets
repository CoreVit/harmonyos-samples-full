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

import { StockForm, StockInForm, TransactionDetails } from '@stock/base';
import { StockDetailDataService } from '../models/DataModel';

@Observed
export class StockDetailViewModel {
  public stockFormList: StockForm[] = [];
  public stockInFormList: StockInForm[] = [];
  public cycleTitleList: ResourceStr[] = [];
  public otherTitleList: ResourceStr[] = [];
  public stockTitleList: Resource[] = [];
  public pcStockTitleList: Resource[] = [];
  public buySellSharesList: TransactionDetails[] = [];
  public currentStockForm: StockForm | undefined = undefined;
  public isLoading: boolean = false;
  private dataService: StockDetailDataService = new StockDetailDataService();

  loadData(): void {
    this.isLoading = true;
    this.stockFormList = this.dataService.getStockFormList();
    this.stockInFormList = this.dataService.getStockInFormList();
    this.cycleTitleList = this.dataService.getCycleTitleList();
    this.otherTitleList = this.dataService.getOtherTitleList();
    this.stockTitleList = this.dataService.getStockTitleList();
    this.pcStockTitleList = this.dataService.getPcStockTitleList();
    this.buySellSharesList = this.dataService.getBuySellSharesList();
    if (this.stockFormList.length > 0) {
      this.currentStockForm = this.stockFormList[0];
    }
    this.isLoading = false;
  }

  getStockForm(index: number): StockForm | undefined {
    return this.dataService.getStockFormByIndex(index);
  }

  getStockInForm(index: number): StockInForm | undefined {
    return this.dataService.getStockInFormByIndex(index);
  }

  getStockFormCount(): number {
    return this.stockFormList.length;
  }

  getStockInFormCount(): number {
    return this.stockInFormList.length;
  }

  setCurrentStockForm(index: number): void {
    if (index >= 0 && index < this.stockFormList.length) {
      this.currentStockForm = this.stockFormList[index];
    }
  }

  setCurrentStockFormByItem(item: StockForm): void {
    this.currentStockForm = item;
  }
}