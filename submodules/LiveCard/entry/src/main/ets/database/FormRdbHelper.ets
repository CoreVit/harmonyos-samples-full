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
import { FormInfo } from '../model/common/FormInfo';
import { RdbUtils } from './RdbUtils';

const TAG = 'FormRdbHelper';

const SQL_CREATE_TABLE: string =
  'CREATE TABLE IF NOT EXISTS FormInfoTable(formId STRING PRIMARY KEY, formName STRING, formDimension STRING)';

const TABLE_NAME = 'FormInfoTable';
let rdbUtils: RdbUtils;

/**
 * 管理应用卡片
 */
export class FormRdbHelper {
  private static instance: FormRdbHelper;

  private constructor(context: Context) {
    Logger.info(TAG, `constructor`);
    rdbUtils = new RdbUtils(context, TABLE_NAME, SQL_CREATE_TABLE);
    rdbUtils.getRdbStoreLocked().catch((err: BusinessError) => {
      Logger.error(TAG, `pre-warm getRdbStore failed, code: ${err.code}, message: ${err.message}`);
    });
  }

  public static getInstance(context: Context): FormRdbHelper {
    if (!FormRdbHelper.instance) {
      FormRdbHelper.instance = new FormRdbHelper(context);
    }
    return FormRdbHelper.instance;
  }

  public insertForm(formInfo: FormInfo): Promise<number> {
    let valueBucket = this.generateBucket(formInfo);
    return rdbUtils.insertData(valueBucket);
  }

  public deleteForm(formId: string): Promise<number> {
    Logger.info(TAG, `deleteForm formId: ${formId}`);
    let predicates = new relationalStore.RdbPredicates(TABLE_NAME);
    predicates.equalTo('formId', formId);
    return rdbUtils.deleteData(predicates);
  }

  public updateForm(formInfo: FormInfo): Promise<number> {
    Logger.info(TAG, `updateForm formId: ${formInfo.formId}`);
    let valueBucket = this.generateBucket(formInfo);
    let predicates = new relationalStore.RdbPredicates(TABLE_NAME);
    predicates.equalTo('formId', formInfo.formId);
    return rdbUtils.updateData(predicates, valueBucket);
  }

  public queryAllForm(): Promise<FormInfo[]> {
    Logger.info(TAG, 'queryAllForm');
    let predicates = new relationalStore.RdbPredicates(TABLE_NAME);
    return this.queryForm(predicates);
  }

  public queryFormByName(formName: string): Promise<FormInfo[]> {
    Logger.info(TAG, 'queryFormByName');
    let predicates = new relationalStore.RdbPredicates(TABLE_NAME);
    predicates.contains('formName', formName);
    return this.queryForm(predicates);
  }

  public queryFormById(formId: string): Promise<FormInfo | undefined> {
    Logger.info(TAG, `queryFormById formId: ${formId}`);
    let predicates = new relationalStore.RdbPredicates(TABLE_NAME);
    predicates.equalTo('formId', formId);
    return new Promise<FormInfo | undefined>(async (resolve) => {
      try {
        let formInfoList = await this.queryForm(predicates);
        if (formInfoList.length > 0) {
          resolve(formInfoList[0]);
          return;
        }
        resolve(undefined);
      } catch (err) {
        Logger.error(TAG, `queryFormById err: ${err.code}, ${err.message}`);
        resolve(undefined);
      }
    });
  }

  public queryForm(predicates: relationalStore.RdbPredicates): Promise<FormInfo[]> {
    Logger.info(TAG, 'queryForm');
    return new Promise<FormInfo[]>((resolve, reject) => {
      rdbUtils.query(predicates).then((resultSet) => {
        try {
          let formInfoList: FormInfo[] = [];
          while (resultSet.goToNextRow()) {
            let formInfo: FormInfo = new FormInfo();
            formInfo.formId = resultSet.getString(resultSet.getColumnIndex('formId'));
            formInfo.formName = resultSet.getString(resultSet.getColumnIndex('formName'));
            formInfo.formDimension = resultSet.getString(resultSet.getColumnIndex('formDimension'));
            formInfoList.push(formInfo);
          }
          Logger.info(TAG, `queryForm formInfoList length: ${formInfoList.length}`);
          resolve(formInfoList);
        } catch (e) {
          Logger.error(TAG, `queryForm formInfoList error: ${e.code}, ${e.message}`);
          reject(e);
        } finally {
          resultSet.close();
        }
      }).catch((err: Error) => {
        Logger.error(TAG, `queryForm error: ${err.message}`);
        reject(err);
      });
    });
  }

  public release(): void {
    rdbUtils.close();
  }

  private generateBucket(formInfo: FormInfo): relationalStore.ValuesBucket {
    let valueBucket: relationalStore.ValuesBucket = {
      formId: formInfo.formId,
      formName: formInfo.formName,
      formDimension: formInfo.formDimension,
    };
    return valueBucket;
  }
}
