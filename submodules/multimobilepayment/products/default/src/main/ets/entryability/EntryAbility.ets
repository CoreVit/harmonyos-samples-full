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

import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { AppStorageV2, window } from '@kit.ArkUI';
import { CommonConstants, Logger, WindowUtil } from 'multimobilepaymentbase';

const TAG = 'EntryAbility';

export default class EntryAbility extends UIAbility {
  private windowUtil?: WindowUtil;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      Logger.error(TAG, 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    Logger.info(TAG, 'Ability onCreate');
  }

  onDestroy(): void {
    Logger.info(TAG, 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Logger.info(TAG, 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        Logger.error(TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      try {
        const mainWindow = windowStage.getMainWindowSync();
        this.windowUtil =
          AppStorageV2.connect(WindowUtil, CommonConstants.KEY_WINDOWUTIL, () => new WindowUtil(mainWindow))!;
        this.windowUtil.setWindowStage(windowStage);
        this.windowUtil.setFullScreen(true);
        this.windowUtil!.setUIContext();
        this.windowUtil!.updateWindowInfo();
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `Failed to get main window. Code: ${err.code}, message: ${err.message}`);
      }
      Logger.info(TAG, 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, 'Ability onWindowStageDestroy');
    this.windowUtil?.release();
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info(TAG, 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info(TAG, 'Ability onBackground');
  }
}