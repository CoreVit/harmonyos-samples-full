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

import { ConfigurationConstant, UIAbility, Configuration } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import {
  ImmersiveType,
  KEY_CURRENT_COLOR_MODE,
  KEY_RESOURCE_MANAGER,
  KEY_WINDOW_UTIL,
  Logger,
  WindowUtil
} from '@stock/base';

export default class PcAbility extends UIAbility {
  public windowUtil?: WindowUtil;

  onCreate(): void {
    Logger.info('PcAbility', 'testTag', '%{public}s', 'Ability onCreate');
    AppStorage.setOrCreate<ConfigurationConstant.ColorMode>(KEY_CURRENT_COLOR_MODE, this.context.config.colorMode);
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (exception) {
      Logger.error(`Failed to setColorMode. Cause code: ${exception.code}, message: ${exception.message}`);
    }
  }

  onDestroy(): void {
    Logger.info('PcAbility', 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    Logger.info('PcAbility', 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    // Initialize window util for responsive layout
    try {
      this.windowUtil = new WindowUtil(windowStage.getMainWindowSync());
      this.windowUtil.setUIContext();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(`Failed to initialize window util for responsive layout. Cause code: ${err.code}, message: ${err.message}`);
    }

    AppStorage.setOrCreate(KEY_WINDOW_UTIL, this.windowUtil);
    AppStorage.setOrCreate(KEY_RESOURCE_MANAGER, this.context.resourceManager);

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        Logger.error('PcAbility', 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      Logger.info('PcAbility', 'testTag', 'Succeeded in loading the content.');

      // Set immersive mode and update window info
      this.windowUtil!.setUIContext();
      this.windowUtil!.setImmersiveType(ImmersiveType.IMMERSIVE);
      this.windowUtil!.updateWindowInfo();
    });
  }

  onWindowStageDestroy(): void {
    Logger.info('PcAbility', 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
    this.windowUtil?.release();
  }

  onForeground(): void {
    Logger.info('PcAbility', 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    Logger.info('PcAbility', 'testTag', '%{public}s', 'Ability onBackground');
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    const currentColorMode: ConfigurationConstant.ColorMode | undefined = AppStorage.get(KEY_CURRENT_COLOR_MODE);
    if (currentColorMode !== newConfig.colorMode) {
      AppStorage.setOrCreate<ConfigurationConstant.ColorMode>(KEY_CURRENT_COLOR_MODE, newConfig.colorMode);
    }
  }
}
