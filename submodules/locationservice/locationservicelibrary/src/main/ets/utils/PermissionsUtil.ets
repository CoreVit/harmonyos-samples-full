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

import { BusinessError } from '@kit.BasicServicesKit';
import { abilityAccessCtrl, bundleManager, Context, Permissions } from '@kit.AbilityKit';
import Logger from './Logger';

export const TAG: string = '[PermissionsUtil]';

export class PermissionsUtil {
  static requestPermissions(context: Context) {
    const atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    try {
      atManager.requestPermissionsFromUser(context,
        ['ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION'])
        .then(() => {
          Logger.info(TAG, 'Request permissions from user successfully');
        })
        .catch((error: BusinessError) => {
          Logger.error(TAG, `Request permissions from user failed. code: ${error.code}, message: ${error.message}`);
        })
    } catch (err) {
      Logger.error(TAG,
        `Request permissions. code: ${(err as BusinessError).code}, message: ${(err as BusinessError).message}`);
    }
  }

  static async checkPermissionGrant(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;

    let tokenId: number = 0;
    try {
      let bundleInfo: bundleManager.BundleInfo =
        await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
      tokenId = appInfo.accessTokenId;
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Failed to get bundle info for self, code: ${err.code}, message: ${err.message}`);
    }

    try {
      grantStatus = await atManager.checkAccessToken(tokenId, permission)
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Failed to check access token, code: ${err.code}, message: ${err.message}`);
    }
    return grantStatus;
  }

  static async checkPermissions(context: Context): Promise<boolean> {
    const grantStatus: boolean = await PermissionsUtil.checkPermissionGrant('ohos.permission.LOCATION') ===
      abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED; // Get precise location permission status
    const aboutGrantStatus: boolean =
      await PermissionsUtil.checkPermissionGrant('ohos.permission.APPROXIMATELY_LOCATION') ===
        abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED; // Get approximate location permission status

    if (aboutGrantStatus && !grantStatus) {
      // Approximate location must be enabled first to apply for precise location.
      const atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
      atManager.requestPermissionsFromUser(context, ['ohos.permission.LOCATION'])
        .then(() => {
          Logger.info(TAG, 'checkPermissions: Request permissions from user successfully');
        })
        .catch((error: BusinessError) => {
          Logger.error(TAG, `Request permissions from user failed. code: ${error.code}, message: ${error.message}`);
        })

      await PermissionsUtil.requestPermissionSecondly(context, ['ohos.permission.LOCATION']);
      return false;
    } else if (!aboutGrantStatus && !grantStatus) {
      // Request approximate and precise location permissions.
      await PermissionsUtil.requestPermissionSecondly(context,
        ['ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION']);
      return false;
    }
    return true;
  }

  static async requestPermissionSecondly(context: Context, permission: Permissions[]) {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    try {
      atManager.requestPermissionOnSetting(context, permission).then(() => {
        Logger.info(TAG, 'RequestPermissionSecondly success');
      }).catch((error: BusinessError) => {
        Logger.error(TAG, `RequestPermissionSecondly failed. code: ${error.code}, message: ${error.message}`);
      });
    } catch (err) {
      Logger.error(TAG,
        `Request permissions from user failed. code: ${(err as BusinessError).code}, message: ${(err as BusinessError).message}`);
    }
  }
}