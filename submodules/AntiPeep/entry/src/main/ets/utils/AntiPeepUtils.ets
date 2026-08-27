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

import { dlpAntiPeep } from '@kit.DeviceSecurityKit';
import { JSON } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from './Logger';

const TAG = 'AntiPeepUtils';

export interface AntiPeepCallback {
  onStatusChanged: (status: dlpAntiPeep.DlpAntiPeepStatus) => Promise<void>;
}

/**
 * can use screen privacy capability
 * */
// [Start 1_canUseAntiPeep]
export function canUseAntiPeep(): boolean {
  return canIUse('SystemCapability.Security.DlpAntiPeep');
}
// [End 1_canUseAntiPeep]

/**
 * is screen privacy enabled
 * */
// [Start 1_isAntiPeepOn]
export async function isAntiPeepOn(): Promise<boolean> {
  try {
    if (canUseAntiPeep()) {
      let result: boolean = await dlpAntiPeep.isDlpAntiPeepSwitchOn();
      Logger.info(TAG, `[isAntiPeepOn] isDlpAntiPeepSwitchOn success. ${result}`);
      return result;
    } else {
      return false;
    }
  } catch (err) {
    Logger.error(TAG, `[isAntiPeepOn] isDlpAntiPeepSwitchOn failed.${JSON.stringify(err)}`);
    return false;
  }
}
// [End 1_isAntiPeepOn]

/**
 * get current screen privacy status
 * */
// [Start 2_getAntiPeepInfo_2]
export function getAntiPeepInfo(): dlpAntiPeep.DlpAntiPeepStatus {
  try {
    if (canUseAntiPeep()) {
      let dlpAntiPeepStatus = dlpAntiPeep.getDlpAntiPeepInfo();
      Logger.info(TAG, `getDlpHideInfo success. ${JSON.stringify(dlpAntiPeepStatus)}`);
      return dlpAntiPeepStatus;
    } else {
      return -1;
    }
  } catch (err) {
    Logger.info(TAG, `getDlpHideInfo failed. ${JSON.stringify(err)}`);
    return -1;
  }
}
// [End 2_getAntiPeepInfo_2]

/**
 * listen on screen privacy
 * */
// [Start 4_dlpAntiPeepOn-2]
export function listenOnAntiPeepStatus(antiPeepCB: AntiPeepCallback): boolean {
  try {
    if (canUseAntiPeep()) {
      Logger.info(TAG, `start on('dlpAntiPeep')`);
      dlpAntiPeep.on('dlpAntiPeep', (dlpAntiPeepStatus: dlpAntiPeep.DlpAntiPeepStatus) => {
        Logger.info(TAG, `dlpAntiPeep callback: ${JSON.stringify(dlpAntiPeepStatus)}`);
        if (antiPeepCB) {
          antiPeepCB.onStatusChanged(dlpAntiPeepStatus);
        } else {
          Logger.warn(TAG, `antiPeepCB is empty`);
        }
      });
      Logger.info(TAG, `on('dlpAntiPeep') ok`);
      return true;
    } else {
      return false;
    }
  } catch (err) {
    Logger.error(TAG, `dlpAntiPeep.on failed. ${JSON.stringify(err)}`);
    return false;
  }
}
// [End 4_dlpAntiPeepOn-2]

/**a
 * listen off screen privacy
 * */
// [Start 6_dlpAntiPeepOff_2]
export function listenOffAntiPeepStatus() {
  try {
    if (canUseAntiPeep()) {
      Logger.info(TAG, `start off('dlpAntiPeep')`);
      dlpAntiPeep.off('dlpAntiPeep');
      Logger.info(TAG, `off('dlpAntiPeep') ok`);
    }
  } catch (err) {
    Logger.error(TAG, `dlpAntiPeep.off failed. ${JSON.stringify(err)}`);
  }
}
// [End 6_dlpAntiPeepOff_2]

/**
 * Sets the anti peep mask layer.
 * @param windowId The protection application window id.
 * */
// [Start 5_setAntiPeepMaskLayer_2]
export function showSystemMaskLayer(windowId: number): Promise<boolean> {
  return new Promise((resolve) => {
    try {
      if (canUseAntiPeep()) {
        dlpAntiPeep.setAntiPeepMaskLayer(windowId).catch((err: BusinessError) => {
          Logger.error(TAG, `Execute setAntiPeepMaskLayer failed. error code:${err.code}, error message:${err.message}`);
          resolve(false);
        }).then(() => {
          Logger.info(TAG, `setAntiPeepMaskLayer success`);
          resolve(true);
        })
      } else {
        resolve(false);
      }
    } catch (err) {
      Logger.error(TAG, `Call setAntiPeepMaskLayer failed. ${JSON.stringify(err)}`);
      resolve(false);
    }
  });
}
// [End 5_setAntiPeepMaskLayer_2]