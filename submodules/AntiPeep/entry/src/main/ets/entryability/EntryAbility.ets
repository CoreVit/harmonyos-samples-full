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

import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { ConstValues } from '../common/CommonConstants';
import Logger from '../utils/Logger';
import { WindowUtil } from '../utils/WindowUtil';

const TAG = 'EntryAbility';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `setColorMode failed, error: ${error.code} ${error.message}`);
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    Logger.info(TAG, 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`);
        return;
      }
      WindowUtil.initialize(windowStage);
      try {
        AppStorage.setOrCreate(ConstValues.WINDOW_ID_NAME, windowStage.getMainWindowSync().getWindowProperties().id);
      } catch (error) {
        const err = error as BusinessError;
        Logger.error(TAG, `setOrCreate window id error.errorCode:${err.code},errorMessage:${err.message}`);
      }
      Logger.info(TAG, 'Succeeded in loading the content.');
    });
  }
}