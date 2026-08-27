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

import { AbilityConstant, Configuration, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import EnvironmentCallback from '@ohos.app.ability.EnvironmentCallback';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { CommonConstants, Logger, SetDecorButtonStyleUtil, WindowUtil } from 'multivideobase';
import { PcConstants } from '../constants/PcConstants';

const TAG = '[PcAbility]';

export default class EntryAbility extends UIAbility {
  private windowUtil?: WindowUtil;
  private lastColorMode: ConfigurationConstant.ColorMode | undefined = undefined;
  private environmentCallbackId: number = PcConstants.INVALID_ENVIRONMENT_CALLBACK_ID;
  private environmentCallback?: EnvironmentCallback;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    Logger.info(TAG, 'Ability onCreate');
    AppStorage.setOrCreate(CommonConstants.SYSTEM_COLOR_MODE_VERSION, 0);
    if (this.context.config.colorMode !== undefined) {
      this.lastColorMode = this.context.config.colorMode;
      SetDecorButtonStyleUtil.persistApplicationColorMode(this.context.config.colorMode);
    }
    this.registerApplicationEnvironmentListener();
  }

  onDestroy() {
    Logger.info(TAG, 'Ability onDestroy');
    this.unregisterApplicationEnvironmentListener();
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    Logger.info(TAG, 'Ability onWindowStageCreate');

    try {
      this.windowUtil = new WindowUtil(windowStage.getMainWindowSync());
      AppStorage.setOrCreate(CommonConstants.WINDOW_UTIL, this.windowUtil);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to get main window, errCode = ${err.code}, errMessage = ${err.message}.`);
    }
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content, errCode = ${err.code}, errMessage = ${err.message}.`);
        return;
      }
      Logger.info(TAG, 'Succeeded in loading the content.');
      if (this.windowUtil) {
        this.windowUtil.setUIContext();
        this.windowUtil.updateWindowInfo();
      }
    });
  }
  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, 'Ability onWindowStageDestroy');
    this.windowUtil?.release();
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info(TAG, 'Ability onForeground');
    this.notifyDecorButtonIfColorModeChanged(this.context.config.colorMode);
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    this.notifyDecorButtonIfColorModeChanged(newConfig.colorMode);
  }

  private notifyDecorButtonIfColorModeChanged(colorMode: ConfigurationConstant.ColorMode | undefined): void {
    if (colorMode === undefined) {
      return;
    }
    if (this.lastColorMode === colorMode) {
      return;
    }
    this.lastColorMode = colorMode;
    SetDecorButtonStyleUtil.persistApplicationColorMode(colorMode);
    const next = (AppStorage.get<number>(CommonConstants.SYSTEM_COLOR_MODE_VERSION) ?? 0) + 1;
    AppStorage.setOrCreate(CommonConstants.SYSTEM_COLOR_MODE_VERSION, next);
  }

  private registerApplicationEnvironmentListener(): void {
    try {
      this.environmentCallback = new PcDecorEnvironmentCallback(this);
      this.environmentCallbackId =
        this.context.getApplicationContext().on('environment', this.environmentCallback);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to register environment listener, errCode = ${err.code}, errMessage = ${err.message}.`);
    }
  }

  private unregisterApplicationEnvironmentListener(): void {
    if (this.environmentCallbackId === PcConstants.INVALID_ENVIRONMENT_CALLBACK_ID ||
      this.environmentCallback === undefined) {
      return;
    }
    try {
      this.context.getApplicationContext()
        .off('environment', this.environmentCallbackId)
        .catch((error: BusinessError) => {
          Logger.error(TAG,
            `Failed to unregister environment listener, errCode = ${error.code}, errMessage = ${error.message}.`);
        })
        .then(() => {
          this.environmentCallbackId = PcConstants.INVALID_ENVIRONMENT_CALLBACK_ID;
          this.environmentCallback = undefined;
        });
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG,
        `Failed to unregister environment listener, errCode = ${err.code}, errMessage = ${err.message}.`);
    }
  }

  onApplicationEnvironmentConfigurationUpdated(config: Configuration): void {
    this.notifyDecorButtonIfColorModeChanged(config.colorMode);
  }

  onBackground() {
    // Ability has back to background
    Logger.info(TAG, 'Ability onBackground');
  }
}

class PcDecorEnvironmentCallback extends EnvironmentCallback {
  private readonly ability: EntryAbility;

  constructor(ability: EntryAbility) {
    super();
    this.ability = ability;
  }

  onConfigurationUpdated(config: Configuration): void {
    this.ability.onApplicationEnvironmentConfigurationUpdated(config);
  }

  onMemoryLevel(_level: AbilityConstant.MemoryLevel): void {
  }
}