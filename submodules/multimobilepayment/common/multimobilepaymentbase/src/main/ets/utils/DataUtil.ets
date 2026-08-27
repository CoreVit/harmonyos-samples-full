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

import { PaymentData, PaymentDataModel } from '../data/PaymentData';
import { AppDatabase } from '../db/AppDatabase';

/**
 * Data utility class for accessing application data
 * Provides methods to retrieve various data lists from the database
 */
export class DataUtil {
  private static db = AppDatabase.getInstance();

  /**
   * Get the list of business items
   * @returns Array of PaymentDataModel containing business information
   */
  static getBusinessList(): PaymentDataModel[] {
    return DataUtil.db.getBusinessList().map((item: PaymentData) => new PaymentDataModel(item.text, item.icon));
  }

  /**
   * Get the list of tab items
   * @returns Array of PaymentDataModel containing tab information
   */
  static getTabList(): PaymentDataModel[] {
    return DataUtil.db.getTabList().map((item: PaymentData) => new PaymentDataModel(item.text, item.icon));
  }

  /**
   * Get the list of quick action items
   * @returns Array of PaymentDataModel containing quick action information
   */
  static getQuickActionList(): PaymentDataModel[] {
    return DataUtil.db.getQuickActionList().map((item: PaymentData) => new PaymentDataModel(item.text, item.icon));
  }

  /**
   * Get the list of image items
   * @returns Array of PaymentDataModel containing image information
   */
  static getImageList(): PaymentDataModel[] {
    return DataUtil.db.getImageList().map((item: PaymentData) => new PaymentDataModel(item.text, item.icon));
  }

  /**
   * Get the list of wealth image items
   * @returns Array of PaymentDataModel containing image information
   */
  static getWealthList(): PaymentDataModel[] {
    return DataUtil.db.getWealthList().map((item: PaymentData) => new PaymentDataModel(item.text, item.icon));
  }

  /**
   * Get the list of scan mode items
   * @returns Array of PaymentDataModel containing scan mode information
   */
  static getScanList(): PaymentDataModel[] {
    return DataUtil.db.getScanList().map((item: PaymentData) => new PaymentDataModel(item.text, item.icon));
  }
}