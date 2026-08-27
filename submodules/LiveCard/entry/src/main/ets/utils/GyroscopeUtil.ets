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

import { sensor } from '@kit.SensorServiceKit';
import type { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from './Logger';

const TAG = 'GyroscopeUtilLogTag';

export interface GyroscopeData {
  x: number;
  y: number;
  z: number;
}

export type GyroscopeCallback = (data: GyroscopeData) => void;

export class GyroscopeUtil {
  private static callback: GyroscopeCallback | null = null;
  private static sensorCallback: ((data: sensor.GyroscopeResponse) => void) | null = null;

  // [Start gyroscope_subscribe]
  static subscribe(callback: GyroscopeCallback): void {
    try {
      GyroscopeUtil.unsubscribe();

      GyroscopeUtil.callback = callback;
      GyroscopeUtil.sensorCallback = (data: sensor.GyroscopeResponse): void => {
        if (GyroscopeUtil.callback) {
          GyroscopeUtil.callback({
            x: data.x,
            y: data.y,
            z: data.z
          });
        }
      };
      sensor.on(sensor.SensorId.GYROSCOPE, GyroscopeUtil.sensorCallback, { interval: 50000000 });
      // [StartExclude gyroscope_subscribe]
      Logger.info(TAG, 'Gyroscope subscribed successfully');
      // [EndExclude gyroscope_subscribe]
    } catch (error) {
      // [StartExclude gyroscope_subscribe]
      Logger.error(TAG, `Gyroscope subscribe failed: code ${(error as BusinessError).code}, ` +
        `message ${(error as BusinessError).message}`);
      // [EndExclude gyroscope_subscribe]
    }
  }
  // [End gyroscope_subscribe]

  // [Start gyroscope_unsubscribe]
  static unsubscribe(): void {
    if (GyroscopeUtil.sensorCallback) {
      try {
        sensor.off(sensor.SensorId.GYROSCOPE, GyroscopeUtil.sensorCallback);
        GyroscopeUtil.sensorCallback = null;
        GyroscopeUtil.callback = null;
        // [StartExclude gyroscope_unsubscribe]
        Logger.info(TAG, 'Gyroscope unsubscribed successfully');
        // [EndExclude gyroscope_unsubscribe]
      } catch (error) {
        // [StartExclude gyroscope_unsubscribe]
        Logger.error(TAG, `Gyroscope unsubscribe failed: code ${(error as BusinessError).code}, ` +
          `message ${(error as BusinessError).message}`);
        // [EndExclude gyroscope_unsubscribe]
      }
    }
  }
  // [End gyroscope_unsubscribe]

  static isSubscribed(): boolean {
    return GyroscopeUtil.sensorCallback !== null;
  }
}