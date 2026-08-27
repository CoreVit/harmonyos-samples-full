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

import { ConfigurationConstant, UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { Logger, WaterFlowController } from '@ohos_samples/waterflowlibrary';

const TAG = '[EntryAbility]';

/**
 * Lift cycle management of Ability.
 */
export default class EntryAbility extends UIAbility {
  onCreate(): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      Logger.error(TAG, `Failed to setColorMode. Cause: code: ${err.code}, message: ${err.message}}.`);
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err, __) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content, code: ${err.code}, message: ${err.message}}.`);
        return;
      }
      WaterFlowController.initWindowConfig(windowStage);
      Logger.info(TAG, '%{public}s', 'Succeeded in loading the content. ');
    });
  }
}