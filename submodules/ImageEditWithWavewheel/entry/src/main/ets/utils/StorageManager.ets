/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { CommonConstants } from '../common/constant/CommonConstants';
import Logger from './Logger';

const TAG = `StorageManager`;

const STORAGE_NAME = 'WaveWheelStorage';

export class StorageManager {
  private static instance: StorageManager | null = null;
  private dataPreferences: preferences.Preferences | null = null;

  public static getInstance(): StorageManager {
    if (!StorageManager.instance) {
      StorageManager.instance = new StorageManager();
    }
    return StorageManager.instance;
  }

  private constructor() {
  }

  public async init(context: Context): Promise<void> {
    try {
      this.dataPreferences = await preferences.getPreferences(context, STORAGE_NAME);
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `StorageManager init failed. Code: ${error.code}, message: ${error.message}`);
    }
  }

  public async loadSelectedIds(): Promise<string[]> {
    if (!this.dataPreferences) {
      Logger.error(TAG, `invalid dataPreferences`);
      return [];
    }

    try {
      const value = await this.dataPreferences.get(CommonConstants.KEY_SIMPLE_WAVE_WHEEL_OPTIONS, '[]');
      Logger.debug(TAG, `got value=${value}`);
      if (value && typeof value === 'string') {
        try {
          return JSON.parse(value) as string[];
        } catch {
          return [];
        }
      }
      return [];
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `Failed to load selected ids. Code: ${error.code}, message: ${error.message}`);
      return [];
    }
  }

  public async saveSelectedIds(selectedIds: string[]): Promise<void> {
    if (!this.dataPreferences) {
      Logger.error(TAG, `invalid dataPreferences`);
      return;
    }

    try {
      await this.dataPreferences.put(CommonConstants.KEY_SIMPLE_WAVE_WHEEL_OPTIONS, JSON.stringify(selectedIds));
      await this.dataPreferences.flush();
      Logger.debug(TAG, `saveValue.len: ${selectedIds.length}`);
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `Failed to save selected ids. Code: ${error.code}, message: ${error.message}`);
    }
  }
}

export default StorageManager.getInstance();
