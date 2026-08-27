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

import { DataUtil } from 'multimobilepaymentbase';
import { PaymentDataModel } from 'multimobilepaymentbase/src/main/ets/data/PaymentData';
import { ScanModel } from '../model/ScanModel';

/**
 * ViewModel for scan functionality
 * Manages scan mode list data
 */
@ObservedV2
export class ScanViewModel {
  private scanList: ScanModel[] = [];

  /**
   * Get the list of available scan modes
   * @returns Array of ScanModel containing scan mode information
   */
  public getScanList(): ScanModel[] {
    this.scanList = [];
    let originalList = DataUtil.getScanList();

    originalList.forEach((item: PaymentDataModel) => {
      this.scanList.push(new ScanModel(item.getTitle()));
    });
    return this.scanList;
  }
}
