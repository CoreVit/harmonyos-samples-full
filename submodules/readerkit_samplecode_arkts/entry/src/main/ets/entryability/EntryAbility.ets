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

import { AbilityConstant, Configuration, UIAbility, Want } from '@kit.AbilityKit';
import { display, window } from '@kit.ArkUI';
import { WindowAbility } from './WindowAbility';
import { deviceInfo } from '@kit.BasicServicesKit';
import Logger from '../utils/Logger';
import CommonConstants from '../constants/CommonConstants';

const TAG: string = 'EntryAbility';

export default class EntryAbility extends UIAbility {
  private windowStage: window.WindowStage | null = null;
  private curBp: string = '';
  private isWide: boolean = false;

  private updateBreakpoint(windowWidth: number): void {
    try {
      let windowWidthVp = windowWidth / display.getDefaultDisplaySync().densityPixels;
      let newBp: string = '';
      if (windowWidthVp < 600) {
        newBp = 'sm';
      } else if (windowWidthVp < 840) {
        newBp = 'md';
      } else if (windowWidthVp < 1440) {
        newBp = 'lg';
      } else {
        newBp = 'xl'
      }
      if (this.curBp !== newBp) {
        this.curBp = newBp;
        AppStorage.setOrCreate(CommonConstants.KEY_CURRENT_BREAKPOINT, this.curBp);
        if (this.curBp === 'md' || this.curBp === 'lg' || this.curBp === 'xl') {
          this.isWide = true;
        } else {
          this.isWide = false;
        }
        AppStorage.setOrCreate(CommonConstants.KEY_IS_WIDE, this.isWide);
      }
    } catch (error) {
      Logger.error('testTag', 'Execution failed, code = %{public}d, message = %{public}s',
        error.code, error.message);
    }
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    Logger.info(TAG, '%{public}s', 'Ability onCreate');
    WindowAbility.getInstance().initContext(this.context)
  }

  onDestroy() {
    Logger.info(TAG, '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    Logger.info(TAG, '%{public}s', 'Ability onWindowStageCreate');
    WindowAbility.getInstance().setWindowStage(windowStage);
    this.initWindowProcess(windowStage);
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code !== 0) {
        Logger.error(TAG, `Failed to load the content. Code: ${err.code}, message: ${err.message}`);
        return;
      }

      Logger.info(TAG, 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });

  }

  onConfigurationUpdate(newConfig: Configuration): void {
    AppStorage.setOrCreate(CommonConstants.KEY_COLOR_MODE, newConfig.colorMode);
  }

  initWindowProcess(windowStage: window.WindowStage): void {
    windowStage.getMainWindow((err, windowClass: window.Window) => {
      if (err.code) {
        Logger.error(TAG, 'getMainWindow failed.');
        return;
      }
      try {
        this.updateBreakpoint(windowClass.getWindowProperties().windowRect.width);
      } catch (error) {
        Logger.error(TAG, 'getWindowProperties failed.');
      }
      windowClass.on('windowSizeChange', (windowSize) => {
        this.updateBreakpoint(windowSize.width);
      })
      WindowAbility.getInstance().initAvoidArea(windowClass);
      let systemBarProperties: window.SystemBarProperties = {
        statusBarContentColor: this.context.config.colorMode ? '#000000' : '#FFFFFF'
      };
      windowClass.setWindowSystemBarProperties(systemBarProperties).catch(() => {
        Logger.error(TAG, 'setWindowSystemBarProperties failed.');
      });
    });
    WindowAbility.getInstance().setWindowLayoutFullScreen(true);
    if (deviceInfo.deviceType === 'tablet') {
      WindowAbility.getInstance().setOrientation(windowStage, window.Orientation.AUTO_ROTATION_RESTRICTED);
    }
    WindowAbility.getInstance().initWindowSize();
  }


  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info(TAG, '%{public}s', 'Ability onForeground');
    if (this.windowStage) {
      WindowAbility.getInstance().setWindowStage(this.windowStage);
    }
  }

  onBackground() {
    // Ability has back to background
    Logger.info(TAG, '%{public}s', 'Ability onBackground');
  }
}
