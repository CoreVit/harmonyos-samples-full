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

import { Permissions } from '@kit.AbilityKit';
import { geoLocationManager } from '@kit.LocationKit';

export class CommonConstants {
  /**
   * Permissions.
   */
  public static readonly PERMISSIONS: Permissions[] = ['ohos.permission.APPROXIMATELY_LOCATION',
    'ohos.permission.LOCATION'];
  public static readonly locationRequest: geoLocationManager.CurrentLocationRequest = {
    'priority': geoLocationManager.LocationRequestPriority.ACCURACY,
    'scenario': geoLocationManager.LocationRequestScenario.UNSET,
    'maxAccuracy': 20
  };

  /**
   * Full width.
   */
  public static readonly FULL_WIDTH: string = '100%';

  /**
   * Full height.
   */
  public static readonly FULL_HEIGHT: string = '100%';

  /**
   * Panel low height.
   */
  public static readonly LOW_PANEL_HEIGHT: number = 156;

  /**
   * Panel half height.
   */
  public static readonly HALF_PANEL_HEIGHT: number = 304;

  /**
   * Panel high height.
   */
  public static readonly HIGH_PANEL_HEIGHT: number = 699;

  /**
   * Column margin left of md.
   */
  public static readonly LEFT_MD: number = 24;

  /**
   * Route avoidance feature array.
   */
  public static readonly AVOIDS: number[] = [0, 4, 32];

  /**
   * Camera duration.
   */
  public static readonly DURATION: number = 100;

  /**
   * LatLng zoom.
   */
  public static readonly ZOOM: number = 15;

  /**
   * Languages.
   */
  public static readonly languageMap: ReadonlyMap<string, string> = new Map([
    ['en-Latn-US', 'en'],
    ['zh-Hant', 'zh'],
    ['zh-Hans', 'zh_CN']
  ]);
}
