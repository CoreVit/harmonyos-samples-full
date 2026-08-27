/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { window } from '@kit.ArkUI';
import Logger from './Logger';
import { CommonConstants } from '../common/constant/CommonConstants';

const TAG = `StatusBarUtil`;

export class StatusBarUtil {
  static setWindowStatusBarProperties() {
    const TAG: string = '[setWindowStatusBarProperties]';
    const windowClass = AppStorage.get(CommonConstants.WAVE_WHEEL_WINDOW_CLASS) as window.Window;

    if (!windowClass) {
      Logger.error(TAG, `failed to get WINDOW_CLASS from AppStorage`);
      return;
    }

    try {
      Logger.info(TAG, `calling setWindowSystemBarProperties`);
      windowClass.setWindowSystemBarProperties({
        'statusBarColor': '#00000000',
        'statusBarContentColor': '#ffffffff',
      })
        .then(() => {
          Logger.info(TAG, 'setWindowSystemBarProperties succeeded.');
        }).catch((err: BusinessError) => {
        Logger.error(TAG,
          `Failed to set the system bar properties. Cause code: ${err.code}, message: ${err.message}`);
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Failed to set the system bar properties. Cause code: ${err.code}, message: ${err.message}`);
    }
  }
}