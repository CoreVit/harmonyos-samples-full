/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { relationalStore } from '@kit.ArkData';
import type { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '../utils/Logger';
import utils from '@arkts.utils';

const TAG = 'RdbUtils';

const STORE_CONFIG: relationalStore.StoreConfig = {
  name: 'database.db',
  securityLevel: relationalStore.SecurityLevel.S1,
};

export class RdbUtils {
  private rdbStore?: relationalStore.RdbStore;
  private tableName: string = '';
  private sqlCreateTable: string = '';
  private context: Context;
  private lock: utils.locks.AsyncLock;

  constructor(context: Context, tableName: string, sqlCreateTable: string) {
    this.context = context;
    this.tableName = tableName;
    this.sqlCreateTable = sqlCreateTable;
    this.lock = utils.locks.AsyncLock.request(`lock_${this.tableName}`);
  }

  /**
   * @throws lockAsync error
   * @returns
   */
  public getRdbStoreLocked(): Promise<relationalStore.RdbStore> {
    return this.lock.lockAsync((): Promise<relationalStore.RdbStore> => {
      return this.getRdbStore();
    }).catch((e: Error) => {
      Logger.error(TAG, `getRdbStoreLocked failed, name is ${e.name}, message is ${e.message}`);
      throw e;
    });
  }

  public insertData(valuesBucket: relationalStore.ValuesBucket): Promise<number> {
    return new Promise<number>(async (resolve, reject) => {
      try {
        let rdbStore = await this.getRdbStoreLocked();
        rdbStore
          .insert(this.tableName, valuesBucket)
          .then((rowId: number) => {
            Logger.info(TAG, `insertData successfully. rowId: ${rowId}`);
            resolve(rowId);
          })
          .catch((err: BusinessError) => {
            Logger.error(TAG, `insertData failed, code is ${err.code},message is ${err.message}`);
            reject(err);
          });
      } catch (err) {
        Logger.error(TAG, `insertData failed, code is ${err.code},message is ${err.message}`);
        reject(err);
      }
    });
  }

  public batchInsert(valueBucketArray: relationalStore.ValuesBucket[]): Promise<number> {
    return new Promise<number>(async (resolve, reject) => {
      try {
        let rdbStore = await this.getRdbStoreLocked();
        rdbStore
          .batchInsert(this.tableName, valueBucketArray)
          .then((rowId: number) => {
            Logger.info(TAG, `batchInsert successfully. rowId: ${rowId}`);
            resolve(rowId);
          })
          .catch((err: BusinessError) => {
            Logger.error(TAG, `batchInsert failed, code is ${err.code},message is ${err.message}`);
            reject(err);
          });
      } catch (err) {
        Logger.error(TAG, `batchInsert failed, code is ${err.code},message is ${err.message}`);
        reject(err);
      }
    });
  }

  public deleteData(predicates: relationalStore.RdbPredicates): Promise<number> {
    return new Promise<number>(async (resolve, reject) => {
      try {
        let rdbStore = await this.getRdbStoreLocked();
        rdbStore
          .delete(predicates)
          .then((rows: number) => {
            Logger.info(TAG, `deleteData successfully. rows: ${rows}`);
            resolve(rows);
          })
          .catch((err: BusinessError) => {
            Logger.error(TAG, `deleteData failed, code is ${err.code},message is ${err.message}`);
            reject(err);
          });
      } catch (err) {
        Logger.error(TAG, `deleteData failed, code is ${err.code},message is ${err.message}`);
        reject(err);
      }
    });
  }

  public updateData(predicates: relationalStore.RdbPredicates,
    data: relationalStore.ValuesBucket): Promise<number> {
    return new Promise<number>(async (resolve, reject) => {
      try {
        let rdbStore = await this.getRdbStoreLocked();
        rdbStore
          .update(data, predicates)
          .then((rows: number) => {
            Logger.info(TAG, `updateData successfully. rows: ${rows}`);
            resolve(rows);
          })
          .catch((err: BusinessError) => {
            Logger.error(TAG, `updateData failed, code is ${err.code},message is ${err.message}`);
            reject(err);
          });
      } catch (err) {
        Logger.error(TAG, `updateData failed, code is ${err.code},message is ${err.message}`);
        reject(err);
      }

    });
  }

  public async query(predicates: relationalStore.RdbPredicates): Promise<relationalStore.ResultSet> {
    return new Promise<relationalStore.ResultSet>(async (resolve, reject) => {
      try {
        let rdbStore = await this.getRdbStoreLocked();
        rdbStore
          .query(predicates)
          .then((resultSet: relationalStore.ResultSet) => {
            Logger.info(TAG, `query successfully. rowCount: ${resultSet.rowCount}`);
            resolve(resultSet);
          })
          .catch((err: BusinessError) => {
            Logger.error(TAG, `query failed, code is ${err.code},message is ${err.message}`);
            reject(err);
          });
      } catch (err) {
        Logger.error(TAG, `query failed, code is ${err.code},message is ${err.message}`);
        reject(err);
      }
    });
  }

  private getRdbStore(): Promise<relationalStore.RdbStore> {
    Logger.info(TAG, `getRdbStore`);
    return new Promise<relationalStore.RdbStore>((resolve, reject) => {
      if (this.rdbStore) {
        Logger.info(TAG, 'getRdbStore The rdbStore exists.');
        resolve(this.rdbStore);
        return;
      }
      relationalStore
        .getRdbStore(this.context, STORE_CONFIG)
        .then((rdbStore: relationalStore.RdbStore) => {
          Logger.info(TAG, 'getRdbStore successfully.');
          try {
            rdbStore.executeSync(this.sqlCreateTable);
          } catch (error) {
            Logger.error(TAG, `getRdbStore failed, code is ${error.code},message is ${error.message}`);
            reject(error);
            return;
          }
          this.rdbStore = rdbStore;
          resolve(rdbStore);
        })
        .catch((err: BusinessError) => {
          Logger.error(TAG, `getRdbStore failed, code is ${err.code},message is ${err.message}`);
          reject(err);
        });
    });
  }

  public close(): void {
    this.rdbStore?.close().then(() => {
      this.rdbStore = undefined;
    }).catch((e: BusinessError) => {
      Logger.error(TAG, `rdbStore close error, code is ${e.code}, message is ${e.message}`);
    });
  }
}
