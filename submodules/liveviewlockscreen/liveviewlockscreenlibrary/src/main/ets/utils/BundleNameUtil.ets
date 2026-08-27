/*
* Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { bundleManager } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Constants } from '../common/Constants';
import Logger from './Logger';

const TAG: string = '[BundleNameUtil]';

export class BundleNameUtil {
  public static saveBundleName(): void {
    try {
      bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).then((data) => {
        Logger.info(TAG, 'getBundleInfoForSelf successfully.');
        AppStorage.setOrCreate(Constants.KEY_PREFIX + 'BundleName', data.name);
      }).catch((error: BusinessError) => {
        Logger.error(TAG,
          `getBundleInfoForSelf failed. code is ${error.code} message is ${error.message}`);
      });
    } catch (error) {
      Logger.error(TAG,
        `getBundleInfoForSelf failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
    Logger.info(TAG, 'Ability onCreate');
  }
}