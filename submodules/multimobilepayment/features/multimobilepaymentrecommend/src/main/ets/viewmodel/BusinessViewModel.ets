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
import { BusinessModel } from '../model/BusinessModel';

/**
 * ViewModel for business functionality
 * Manages business grid data
 */
export class BusinessViewModel {
  private businessList: BusinessModel[] = [];

  /**
   * Get the list of business items
   * @returns Array of BusinessModel containing business information
   */
  public getBusinessList(): BusinessModel[] {
    // Clear list to avoid duplicate additions
    this.businessList = [];
    let originalList = DataUtil.getBusinessList();

    originalList.forEach((item) => {
      this.businessList.push(new BusinessModel(item.getTitle(), item.getIcon()));
    });
    return this.businessList;
  }
}
