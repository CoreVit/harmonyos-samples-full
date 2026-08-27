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

import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger, AppStorageCleaner, LocationStateAccessor, ImmersiveType, WindowUtil } from 'multitravelbase/Index';

const TAG = 'PcAbility';

export default class PcAbility extends UIAbility {
  private windowUtil?: WindowUtil;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Logger.info(TAG, '%{public}s', 'Ability onCreate');
    LocationStateAccessor.initialize();
  }

  onDestroy(): void {
    Logger.info(TAG, '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Logger.info(TAG, '%{public}s', 'Ability onWindowStageCreate');

    try {
      this.windowUtil = new WindowUtil(windowStage.getMainWindowSync());
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to get main window. Code: ${err.code}, message: ${err.message}`);
    }
    AppStorage.setOrCreate('multitravelnavigationsample_windowUtil', this.windowUtil)

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content. Code: ${err.code}, message: ${err.message}`);
        return;
      }
      Logger.info(TAG, 'Succeeded in loading the content.');

      try {
        AppStorage.setOrCreate('multitravelnavigationsample_uiContext', windowStage.getMainWindowSync().getUIContext());
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `Failed to set uiContext. Code: ${err.code}, message: ${err.message}`);
      }
      this.windowUtil!.setUiContext();
      this.windowUtil!.setImmersiveType(ImmersiveType.IMMERSIVE);
      this.windowUtil!.setPcDecorButtonStyle();
      this.windowUtil!.updateWindowInfo();
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, '%{public}s', 'Ability onWindowStageDestroy');
    this.clearAppStorage();
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info(TAG, '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info(TAG, '%{public}s', 'Ability onBackground');
  }

  private clearAppStorage(): void {
    const failedKeys: string[] = AppStorageCleaner.clearSampleStorage();
    if (failedKeys.length > 0) {
      Logger.warn(TAG, 'Failed to clear AppStorage keys: %{public}s', failedKeys.join(','));
    }
  }
}
