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

import { abilityAccessCtrl, bundleManager, common, Permissions } from '@kit.AbilityKit';
import Logger from './Logger';
import { CommonConstants } from '../constants/CommonConstants';

export class PermissionUtil {
  /**
   * Checks if all specified permissions are granted.
   *
   * Verifies each permission in the provided list against the current access token.
   * If any permission is not granted, initiates a user permission request flow;
   * otherwise, logs successful authorization.
   *
   * @param permissions - Array of permissions to check
   * @param context - UI context for displaying permission requests
   */
  public static async checkPermissions(permissions: Array<Permissions>): Promise<void> {
    const tokenId = await PermissionUtil.getAccessTokenId();
    const allGranted = await Promise.all(
      permissions.map(async (permission) =>
      await PermissionUtil.checkPermissionGrant(tokenId, permission) ===
        abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
      )
    );
    if (!allGranted.every(Boolean)) {
      PermissionUtil.requestPermission(permissions);
    } else {
      Logger.info(`All permissions authorized successfully.`);
    }
  }

  /**
   * Requests specified permissions from the user via system dialog
   *
   * @param permissions - Array of permissions to request
   * @param context - UIContext for getting ability context and displaying UI
   *
   * @remarks
  * This method checks permission authorization status and triggers system dialog if needed.
   * User must grant all requested permissions for Bluetooth communication to work properly.
   */
  private static requestPermission(permissions: Array<Permissions>) {
    let context = AppStorage.get<common.Context>(CommonConstants.KEY_CONTEXT);
    const atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    // requestPermissionsFromUser checks permission authorization status to determine whether to show dialog
    atManager.requestPermissionsFromUser(context, permissions).then((data) => {
      const grantStatus: number[] = data.authResults;
      const grantStatusCount: number = grantStatus.reduce((prev, curr) => prev + curr, 0);
      if (grantStatusCount === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        Logger.info(`All permissions authorized successfully.`)
      } else {
        // Second request authorization
        atManager.requestPermissionOnSetting(context, permissions)
          .then((data: Array<abilityAccessCtrl.GrantStatus>) => {
            Logger.info(`requestPermissionOnSetting success, result:${JSON.stringify(data)}`);
          })
          .catch((err: BusinessError) => {
            Logger.error(`requestPermissionOnSetting failed, error info:${JSON.stringify(err)}`);
          })
      }
    }).catch((e: Error) => {
      Logger.error(`Failed to request permissions from user, error info: ${JSON.stringify(e)}`);
    })
  }

  private static async getAccessTokenId(): Promise<number> {
    // Get the accessTokenId of the application
    let tokenId: number = 0;
    try {
      const bundleInfo: bundleManager.BundleInfo =
        await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      const appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
      tokenId = appInfo.accessTokenId;
    } catch (error) {
      Logger.error(`Failed to get bundle info for self, error info: ${error}`);
    }
    return tokenId;
  }

  private static async checkPermissionGrant(token: number,
    permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
    const atManager = abilityAccessCtrl.createAtManager();
    try {
      return await atManager.checkAccessToken(token, permission);
    } catch (err) {
      Logger.error(`Failed to check access token, error info: ${JSON.stringify(err)}`);
      return abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;
    }
  }
}

