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

import { ConfigurationConstant, UIAbility, common, Configuration } from '@kit.AbilityKit';
import { display, window } from '@kit.ArkUI';
import { deviceInfo } from '@kit.BasicServicesKit';
import { WindowUtil } from '../common/util/WindowUtil';
import Logger from '../common/util/Logger';
import { WindowAbility } from './WindowAbility';
import { CommonConstants } from '../common/constants/CommonConstants';

const DOMAIN = 0x0000;
const TAG = 'EntryAbility'

export default class EntryAbility extends UIAbility {
  private curBp: string = '';
  private isW: boolean = false;
  private isL: boolean = false;
  private isChangeHeight: boolean = false;
  private isChangePadding: boolean = false;
  private hideSplit: boolean = false;

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
        AppStorage.setOrCreate(CommonConstants.KEY_CURRENT_BREAK_POINT, this.curBp);
        if (this.curBp === 'md' || this.curBp === 'lg' || this.curBp === 'xl') {
          this.isW = true;
        } else {
          this.isW = false;
        }
        if (this.curBp === 'lg' || this.curBp === 'xl') {
          this.isL = true;
          this.isChangePadding = true;
        } else {
          this.isL = false;
          this.isChangePadding = false;
        }
        if (this.curBp === 'md' || this.curBp === 'xl') {
          this.isChangeHeight = true;
        } else {
          this.isChangeHeight = false;
        }
        AppStorage.setOrCreate(CommonConstants.KEY_IS_W, this.isW);
        AppStorage.setOrCreate(CommonConstants.KEY_IS_L, this.isL);
        AppStorage.setOrCreate(CommonConstants.KEY_IS_CHANGE_HEIGHT, this.isChangeHeight);
        AppStorage.setOrCreate(CommonConstants.KEY_IS_CHANGE_PADDING, this.isChangePadding);
      }
    } catch (error) {
      Logger.error('testTag', 'Execution failed, code = %{public}d, message = %{public}s',
        error.code, error.message);
    }
  }

  onCreate(): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (error) {
      Logger.error(TAG, `error message is ${error.message}`);
    }
    AppStorage.setOrCreate<common.UIAbilityContext>(CommonConstants.KEY_CONTEXT, this.context);
    AppStorage.setOrCreate<ConfigurationConstant.ColorMode>(CommonConstants.KEY_CURRENT_COLOR_MODE,
      this.context.config.colorMode);
    Logger.info(TAG, 'EntryAbility onCreate');
  }

  onDestroy(): void {
    Logger.info(TAG, 'EntryAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    WindowUtil.getInstance().setWindowStage(windowStage);
    AppStorage.setOrCreate(CommonConstants.KEY_WINDOW_STAGE, windowStage);
    AppStorage.setOrCreate(CommonConstants.KEY_HIDE_SPLIT, this.hideSplit);
    Logger.info(TAG, 'EntryAbility onWindowStageCreate');
    this.initWindowProcess(windowStage);
    windowStage.loadContent('pages/Index', (err) => {
      let windowClass: window.Window = windowStage.getMainWindowSync(); // Get the main application window
      AppStorage.setOrCreate(CommonConstants.KEY_WINDOW_CLASS, windowClass);
      if (err.code) {
        Logger.error(TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      Logger.info(TAG, 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, 'EntryAbility onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info(TAG, 'EntryAbility onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info(TAG, 'EntryAbility onBackground');
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    const currentColorMode: ConfigurationConstant.ColorMode | undefined =
      AppStorage.get(CommonConstants.KEY_CURRENT_COLOR_MODE);
    if (currentColorMode !== newConfig.colorMode) {
      AppStorage.setOrCreate<ConfigurationConstant.ColorMode>(CommonConstants.KEY_CURRENT_COLOR_MODE,
        newConfig.colorMode);
    }
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
}