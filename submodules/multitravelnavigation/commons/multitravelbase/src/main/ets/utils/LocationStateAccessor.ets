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

export const CURRENT_LOCATION_STORAGE_KEY: string = 'multitravelnavigationsample_currentLocation';

export class LocationStateAccessor {
  public static readonly CURRENT_LOCATION_KEY: string = CURRENT_LOCATION_STORAGE_KEY;

  public static initialize(): void {
    AppStorage.setOrCreate(CURRENT_LOCATION_STORAGE_KEY, undefined as geoLocationManager.Location | undefined);
  }

  public static getCurrentLocation(): geoLocationManager.Location | undefined {
    return AppStorage.get<geoLocationManager.Location | undefined>(CURRENT_LOCATION_STORAGE_KEY);
  }

  public static setCurrentLocation(location: geoLocationManager.Location | undefined): void {
    AppStorage.setOrCreate(CURRENT_LOCATION_STORAGE_KEY, location);
  }
}
