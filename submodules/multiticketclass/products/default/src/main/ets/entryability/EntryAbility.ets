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

import { resourceManager } from '@kit.LocalizationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { window } from '@kit.ArkUI';
import {
  ImmersiveType,
  WindowUtil,
  Logger,
  KEY_IS_SPLIT_SCREEN,
  KEY_SYSTEM_COLOR_MODE,
  KEY_CURRENT_COLOR_MODE,
  KEY_WINDOW_UTIL,
  KEY_RESOURCE_MANAGER
} from '@stock/base';
import { ConfigurationConstant, UIAbility, Configuration } from '@kit.AbilityKit';

export default class EntryAbility extends UIAbility {
  public windowUtil?: WindowUtil
  private windowStatusChange: (windowStatusType: window.WindowStatusType) => void =
    (windowStatusType: window.WindowStatusType) => {
      if (windowStatusType === window.WindowStatusType.FLOATING ||
        windowStatusType === window.WindowStatusType.SPLIT_SCREEN) {
        AppStorage.setOrCreate(KEY_IS_SPLIT_SCREEN, true);
      } else if (windowStatusType === window.WindowStatusType.FULL_SCREEN) {
        AppStorage.setOrCreate(KEY_IS_SPLIT_SCREEN, false);
      } else {
        Logger.info('Succeeded in enabling the listener for window status changes. Data: ' + windowStatusType);
      }
    };

  onCreate(): void {
    Logger.info('EntryAbility', '%{public}s', 'Ability onCreate');
    AppStorage.setOrCreate(KEY_SYSTEM_COLOR_MODE, this.context.config.colorMode);
    AppStorage.setOrCreate<ConfigurationConstant.ColorMode>(KEY_SYSTEM_COLOR_MODE, this.context.config.colorMode);
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (exception) {
      Logger.error(`Failed to setColorMode. Cause code: ${exception.code}, message: ${exception.message}`);
    }
  }

  onDestroy(): void {
    Logger.info('EntryAbility', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Logger.info('EntryAbility', '%{public}s', 'Ability onWindowStageCreate');
    // [Start mainWindow]
    try {
      this.windowUtil = new WindowUtil(windowStage.getMainWindowSync());
    } catch (error) {
      let err = error as BusinessError;
      Logger.error('EntryAbility', `Failed to get main window. Code: ${err.code}, message: ${err.message}`);
    }
    // [End mainWindow]
    if (this.windowUtil) {
      AppStorage.setOrCreate(KEY_WINDOW_UTIL, this.windowUtil);
    }

    let context = this.context;
    let resourceManager: resourceManager.ResourceManager = context.resourceManager;
    AppStorage.setOrCreate(KEY_RESOURCE_MANAGER, resourceManager);
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error('EntryAbility', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      Logger.info('EntryAbility', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data));

      const isWindowAvailable = canIUse('SystemCapability.Window.SessionManager');
      if (isWindowAvailable) {
        // Determine the current application window mode.
        // 1: Full-screen split-screen mode, 5: Split-screen mode, 4: Panoramic multi-window mode
        try {
          let windowClass: window.Window = windowStage.getMainWindowSync();
          windowClass.on('windowStatusChange', this.windowStatusChange);
        } catch (exception) {
          Logger.error(`Failed to unregister callback. Cause code: ${exception.code}, message: ${exception.message}`);
        }
      } else {
        Logger.info('Window not by this device.');
      }

      // Application adaptation for horizontal and vertical screen switching.
      if (this.windowUtil) {
        this.windowUtil.setUIContext();
        this.windowUtil.setImmersiveType(ImmersiveType.IMMERSIVE);
        this.windowUtil.setWindowOrientation(window.Orientation.FOLLOW_DESKTOP);
        this.windowUtil.updateWindowInfo();
      }
    });

  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    this.windowUtil?.release();
    Logger.info('EntryAbility', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info('EntryAbility', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info('EntryAbility', '%{public}s', 'Ability onBackground');
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    const currentColorMode: ConfigurationConstant.ColorMode | undefined = AppStorage.get(KEY_CURRENT_COLOR_MODE);
    if (currentColorMode !== newConfig.colorMode) {
      AppStorage.setOrCreate<ConfigurationConstant.ColorMode>(KEY_CURRENT_COLOR_MODE, newConfig.colorMode);
    }
  }
}