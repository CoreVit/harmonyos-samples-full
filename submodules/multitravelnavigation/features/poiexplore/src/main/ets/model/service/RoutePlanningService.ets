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
import { i18n } from '@kit.LocalizationKit';
import { map, mapCommon, navi } from '@kit.MapKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Common, CommonConstants, Logger, SelectedSite } from 'multitravelbase/Index';

const TAG = 'RoutePlanningService';

export class RoutePlanningService {
  public async getDrivingRoutes(beginPoint: geoLocationManager.Location,
    terminalPoint: SelectedSite): Promise<navi.RouteResult | undefined> {
    if (!terminalPoint.location) {
      return undefined;
    }

    try {
      let origin: mapCommon.LatLng = {
        latitude: beginPoint.latitude,
        longitude: beginPoint.longitude
      };
      let originPosition: mapCommon.LatLng =
        map.convertCoordinateSync(mapCommon.CoordinateType.WGS84, mapCommon.CoordinateType.GCJ02, origin);
      let params: navi.DrivingRouteParams = {
        origins: [originPosition],
        destination: terminalPoint.location,
        language: CommonConstants.languageMap.get(i18n.System.getSystemLanguage()),
        alternatives: true,
        avoids: Common.AVOIDS
      };
      let result = await navi.getDrivingRoutes(params);
      Logger.info(TAG, `Driving routes plan success, route count=${result.routes?.length ?? 0}`);
      return result;
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `Driving routes plan fail, error code=${error.code}, message=${error.message}`);
      return undefined;
    }
  }

  public getTotalTime(route: navi.Route): number {
    if (!route || !route.steps) {
      return 0;
    }
    let time: number = 0;
    route.steps.forEach((step) => {
      time += step.duration ?? 0;
    });
    return time / 60;
  }

  public getTotalDistance(route: navi.Route): number {
    if (!route || !route.steps) {
      return 0;
    }
    let distance: number = 0;
    route.steps.forEach((step) => {
      distance += step.distance ?? 0;
    });
    return distance / 1000;
  }
}
