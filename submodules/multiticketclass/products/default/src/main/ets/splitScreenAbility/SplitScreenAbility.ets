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
import { resourceManager } from '@kit.LocalizationKit';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { window } from '@kit.ArkUI';
import {
  ImmersiveType,
  WindowUtil,
  Logger,
  KEY_IS_SPLIT_SCREEN,
  KEY_RESOURCE_MANAGER,
  KEY_WINDOW_UTIL,
  KEY_SYSTEM_COLOR_MODE,
  KEY_IS_HIDE_SPLIT_SCREEN
} from '@stock/base';

// [Start SplitAbility]
let eventData: emitter.EventData = {
  data: {
    'isStart': 1,
    'id': 1
  }
};
let innerEvent: emitter.InnerEvent = {
  eventId: 1,
  priority: emitter.EventPriority.HIGH
};

export default class SplitScreenAbility extends UIAbility {
  // [StartExclude SplitAbility]
  private windowUtil?: WindowUtil;
  private windowClass?: window.Window;
  private windowStatusChange: (statusType: window.WindowStatusType) => void =
    (statusType: window.WindowStatusType) => {
      const isSplitScreen = statusType === window.WindowStatusType.FLOATING ||
        statusType === window.WindowStatusType.SPLIT_SCREEN;
      if (isSplitScreen || statusType === window.WindowStatusType.FULL_SCREEN) {
        AppStorage.setOrCreate(KEY_IS_SPLIT_SCREEN, isSplitScreen);
      } else {
        Logger.info(`Window status changed: ${statusType}`);
      }
    };

  // [EndExclude SplitAbility]

  onCreate(): void {
    // [StartExclude SplitAbility]
    Logger.info('SplitScreenAbility', '%{public}s', 'Ability onCreate');
    AppStorage.setOrCreate(KEY_SYSTEM_COLOR_MODE, this.context.config.colorMode);
    AppStorage.setOrCreate(KEY_IS_HIDE_SPLIT_SCREEN, true);
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(`Failed to setColorMode. Cause code: ${err.code}, message: ${err.message}`);
    }
    // [EndExclude SplitAbility]
    emitter.emit(innerEvent, eventData);
  }

  onNewWant(): void {
    // [StartExclude SplitAbility]
    Logger.info('SplitScreenAbility', '%{public}s', 'Ability onNewWant');
    AppStorage.setOrCreate(KEY_SYSTEM_COLOR_MODE, this.context.config.colorMode);
    AppStorage.setOrCreate(KEY_IS_HIDE_SPLIT_SCREEN, true);
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(`Failed to setColorMode. Cause code: ${err.code}, message: ${err.message}`);
    }
    // [EndExclude SplitAbility]
    emitter.emit(innerEvent, eventData);
  }

  // [StartExclude SplitAbility]
  onDestroy(): void {
    Logger.info('SplitScreenAbility', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Logger.info('SplitScreenAbility', '%{public}s', 'Ability onWindowStageCreate');

    // [Start mainWindow]
    try {
      this.windowUtil = new WindowUtil(windowStage.getMainWindowSync());
    } catch (error) {
      let err = error as BusinessError;
      Logger.error('EntryAbility', `Failed to get main window. Code: ${err.code}, message: ${err.message}`);
    }
    // [End mainWindow]
    AppStorage.setOrCreate(KEY_WINDOW_UTIL, this.windowUtil);

    let context = this.context;
    let resourceManager: resourceManager.ResourceManager = context.resourceManager;
    AppStorage.setOrCreate(KEY_RESOURCE_MANAGER, resourceManager);
    let storage: LocalStorage = new LocalStorage(false);
    storage.setOrCreate(KEY_IS_SPLIT_SCREEN, false);
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error('SplitScreenAbility', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      Logger.info('SplitScreenAbility', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data));


      const isWindowAvailable = canIUse('SystemCapability.Window.SessionManager');
      if (isWindowAvailable) {
        // Determine the current application window mode.
        // 1: Full-screen split-screen mode, 5: Split-screen mode, 4: Panoramic multi-window mode
        try {
          this.windowClass = windowStage.getMainWindowSync();
          this.windowClass.on('windowStatusChange', this.windowStatusChange);
        } catch (error) {
          let err = error as BusinessError;
          Logger.error(`Failed to register window status callback. Cause code: ${err.code}, message: ${err.message}`);
        }
      } else {
        Logger.info('Window not by this device.');
      }
    });
    if (this.windowUtil) {
      this.windowUtil.setUIContext();
      this.windowUtil.setImmersiveType(ImmersiveType.IMMERSIVE);
      this.windowUtil.setWindowOrientation(window.Orientation.FOLLOW_DESKTOP);
      this.windowUtil.updateWindowInfo();
    }
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info('SplitScreenAbility', '%{public}s', 'Ability onWindowStageDestroy');
    if (this.windowClass) {
      try {
        this.windowClass.off('windowStatusChange', this.windowStatusChange);
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(`Failed to off windowStatusChange. Cause code: ${err.code}, message: ${err.message}`);
      }
    }
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info('SplitScreenAbility', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info('SplitScreenAbility', '%{public}s', 'Ability onBackground');
  }

  // [EndExclude SplitAbility]
}

// [End SplitAbility]