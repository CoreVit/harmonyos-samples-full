/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { Configuration, UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { Logger, PageRedirectionController } from '@ohos_samples/pageredirectionlibrary';

const TAG: string = '[EntryAbility]';

let systemLanguage: string | undefined;

export default class EntryAbility extends UIAbility {

  onCreate(): void {
    Logger.info(TAG, '%{public}s', 'Ability onCreate');
    systemLanguage = this.context.config.language;
    PageRedirectionController.updatedLanguage(systemLanguage);
    PageRedirectionController.updatedColorMode(this.context);
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    if (systemLanguage !== newConfig.language) {
      systemLanguage = newConfig.language;
      PageRedirectionController.updatedLanguage(systemLanguage);
    }
  }

  onDestroy(): void {
    Logger.info(TAG, '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Logger.info(TAG, '%{public}s', 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content. ErrorCode: ${err.code},  Message: ${err.message}`);
        return;
      }
      PageRedirectionController.initWindowConfig(windowStage);
      Logger.info(TAG, 'Succeeded in loading the content. Data: %{public}s');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info(TAG, '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info(TAG, '%{public}s', 'Ability onBackground');
  }
}