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

import { geoLocationManager } from '@kit.LocationKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { CommonConstants } from '../constants/CommonConstants';
import { LocationPermissionManager, LocationPermissionStatus } from './LocationPermissionManager';
import Logger from './Logger';

const TAG = 'LocationUtil';

export interface LocationRequestResult {
  location?: geoLocationManager.Location;
  status: LocationPermissionStatus;
}

export class LocationUtil {
  public async getLocationWithPermission(
    context: common.UIAbilityContext): Promise<geoLocationManager.Location | undefined> {
    let result: LocationRequestResult = await this.getLocationWithPermissionResult(context);
    return result.location;
  }

  public async getLocationWithPermissionResult(context: common.UIAbilityContext): Promise<LocationRequestResult> {
    let status: LocationPermissionStatus = await LocationPermissionManager.ensureLocationAvailable(context);
    if (status !== LocationPermissionStatus.GRANTED && status !== LocationPermissionStatus.APPROXIMATE_ONLY) {
      Logger.info(TAG, 'location unavailable, status: ' + status.toString());
      return { status };
    }
    return {
      location: await this.getLocation(),
      status
    };
  }

  public async getLocation(): Promise<geoLocationManager.Location | undefined> {
    return geoLocationManager.getCurrentLocation(CommonConstants.locationRequest).then(
      async (location: geoLocationManager.Location) => {
        Logger.info(TAG, 'getCurrentLocation success');
        return location;
      }).catch((error: BusinessError) => {
        Logger.error(TAG, `getCurrentLocation failed, error code=${error.code}, message=${error.message}`);
        return undefined;
      });
  }
}

export default new LocationUtil();
