/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { preferences } from '@kit.ArkData';
import { CommonConstants } from '../common/constants/CommonConstants';
import Logger from '../utils/Logger';
import { DateModel } from './DateModel';

const TAG = '[DataManager]';

export class DataManager {
  static setDate(context: Context, dateModel: DateModel, callback: () => void): void {
    try {
      let preferObj = preferences.getPreferencesSync(context, { name: 'date' });
      preferObj.putSync(CommonConstants.AS_KEY_SELECTED_DATE, JSON.stringify(dateModel));
      preferObj.flushSync();
      AppStorage.setOrCreate<DateModel>(CommonConstants.AS_KEY_SELECTED_DATE, dateModel);
      callback();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `DataManager set date failed. errCode: ${err.code}, errMessage: ${err.message}.`);
      callback();
    }
  }
}