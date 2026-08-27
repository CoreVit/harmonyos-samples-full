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

import { abilityAccessCtrl, bundleManager, common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { geoLocationManager } from '@kit.LocationKit';
import { CommonConstants } from '../constants/CommonConstants';
import Logger from './Logger';

const TAG = 'LocationPermissionManager';

export enum LocationPermissionStatus {
  GRANTED,
  APPROXIMATE_ONLY,
  DENIED,
  SETTING_REQUIRED,
  LOCATION_SWITCH_OFF
}

export class LocationPermissionManager {
  public static checkPermissionGrant(): LocationPermissionStatus {
    let tokenId: number = 0;
    try {
      let bundleInfo: bundleManager.BundleInfo =
        bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      tokenId = bundleInfo.appInfo.accessTokenId;
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to get bundle info. Code: ${err.code}, message: ${err.message}`);
      return LocationPermissionStatus.DENIED;
    }

    try {
      let atManager = abilityAccessCtrl.createAtManager();
      let approximatelyLocation: abilityAccessCtrl.GrantStatus =
        atManager.checkAccessTokenSync(tokenId, 'ohos.permission.APPROXIMATELY_LOCATION');
      let location: abilityAccessCtrl.GrantStatus =
        atManager.checkAccessTokenSync(tokenId, 'ohos.permission.LOCATION');

      if (approximatelyLocation !== abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        return LocationPermissionStatus.DENIED;
      }
      if (location !== abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        return LocationPermissionStatus.APPROXIMATE_ONLY;
      }
      return LocationPermissionStatus.GRANTED;
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to check access token. Code: ${err.code}, message: ${err.message}`);
      return LocationPermissionStatus.DENIED;
    }
  }

  public static async requestPermissions(context: common.UIAbilityContext): Promise<LocationPermissionStatus> {
    let atManager = abilityAccessCtrl.createAtManager();
    try {
      let result = await atManager.requestPermissionsFromUser(context, CommonConstants.PERMISSIONS);
      let approximateGranted: boolean = result.authResults[0] === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED;
      let preciseGranted: boolean = result.authResults[1] === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED;
      if (!approximateGranted) {
        let shouldOpenSetting: boolean = !result.dialogShownResults ||
          (!result.dialogShownResults[0] && !result.dialogShownResults[1]);
        return shouldOpenSetting ? await LocationPermissionManager.requestPermissionOnSetting(context) :
          LocationPermissionStatus.DENIED;
      }
      return preciseGranted ? LocationPermissionStatus.GRANTED : LocationPermissionStatus.APPROXIMATE_ONLY;
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `requestPermissionsFromUser failed. Code: ${err.code}, message: ${err.message}`);
      return LocationPermissionStatus.DENIED;
    }
  }

  public static async requestPermissionOnSetting(context: common.UIAbilityContext): Promise<LocationPermissionStatus> {
    let atManager = abilityAccessCtrl.createAtManager();
    try {
      let result: abilityAccessCtrl.GrantStatus[] =
        await atManager.requestPermissionOnSetting(context, CommonConstants.PERMISSIONS);
      if (result[0] !== abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        return LocationPermissionStatus.DENIED;
      }
      if (result[1] !== abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        return LocationPermissionStatus.APPROXIMATE_ONLY;
      }
      return LocationPermissionStatus.GRANTED;
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `requestPermissionOnSetting failed. Code: ${err.code}, message: ${err.message}`);
      return LocationPermissionStatus.DENIED;
    }
  }

  public static async ensureLocationEnabled(context: common.UIAbilityContext): Promise<boolean> {
    let isLocationEnabled: boolean = true;
    try {
      isLocationEnabled = geoLocationManager.isLocationEnabled();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `isLocationEnabled failed. Code: ${err.code}, message: ${err.message}`);
    }
    if (isLocationEnabled) {
      return true;
    }

    try {
      return await abilityAccessCtrl.createAtManager().requestGlobalSwitch(context,
        abilityAccessCtrl.SwitchType.LOCATION);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `requestGlobalSwitch failed. Code: ${err.code}, message: ${err.message}`);
      return false;
    }
  }

  public static async ensureLocationAvailable(context: common.UIAbilityContext): Promise<LocationPermissionStatus> {
    let status: LocationPermissionStatus = LocationPermissionManager.checkPermissionGrant();
    if (status === LocationPermissionStatus.DENIED || status === LocationPermissionStatus.SETTING_REQUIRED) {
      status = await LocationPermissionManager.requestPermissions(context);
    }
    if (status !== LocationPermissionStatus.GRANTED && status !== LocationPermissionStatus.APPROXIMATE_ONLY) {
      return status;
    }
    return await LocationPermissionManager.ensureLocationEnabled(context) ? status :
      LocationPermissionStatus.LOCATION_SWITCH_OFF;
  }
}
