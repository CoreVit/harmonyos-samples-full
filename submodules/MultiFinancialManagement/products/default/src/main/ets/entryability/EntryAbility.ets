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

import { ConfigurationConstant, UIAbility } from '@kit.AbilityKit';
import { AppStorageV2, window } from '@kit.ArkUI';
import { CommonConstants, Logger, WindowUtil } from 'financialbase';

export default class EntryAbility extends UIAbility {
  private windowUtil?: WindowUtil;

  onCreate(): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      Logger.error('testTag', `Failed to set colorMode. Code: ${err.code}, message: ${err.message}`)
    }
    Logger.info('testTag', 'Ability onCreate')
  }

  onDestroy(): void {
    Logger.info('testTag', 'Ability onDestroy')
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Logger.info('testTag', 'Ability onWindowStageCreate')

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        Logger.error('testTag', `Failed to load the content. Code: ${err.code}, message: ${err.message}`);
        return;
      }
      Logger.info('testTag', 'Succeeded in loading the content.');
      try {
        const mainWindow = windowStage.getMainWindowSync();
        this.windowUtil =
          AppStorageV2.connect(WindowUtil, CommonConstants.WINDOW_UTIL_KEY, () => new WindowUtil(mainWindow))!;
        this.windowUtil.setUIContext();
        this.windowUtil.updateWindowInfo();
      } catch (error) {
        let err = error as BusinessError;
        Logger.error('testTag', `Failed to get main window. Code: ${err.code}, message: ${err.message}`);
      }
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info('testTag', 'Ability onWindowStageDestroy');
    this.windowUtil?.release();
    AppStorageV2.remove(CommonConstants.WINDOW_UTIL_KEY);
    this.windowUtil = undefined;
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info('testTag', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info('testTag', 'Ability onBackground');
  }
}
