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

import { ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { DragFrameController, Logger } from '@ohos_samples/dragframeworklibrary';

const TAG = '[EntryAbility]';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want): void {
    Logger.info(TAG, `%{public}s`, `EntryAbility onCreate`);
    DragFrameController.subscribeEvent(this.context, want);
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      Logger.error(TAG, `setColorMode failed. code: ${err.code ?? ''}, message: ${err.message ?? ''}`);
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Logger.info(TAG, `%{public}s`, `Ability onWindowStageCreate`);
    windowStage.loadContent('pages/Index', (err, _) => {
      if (err?.code) {
        Logger.error(TAG, `Failed to load the content. Cause:`, err.message);
        return;
      }
      DragFrameController.initWindowConfig(windowStage);
      Logger.info(TAG, `%{public}s`, `Succeeded in loading the content`);
    });
  }

  onDestroy(): void | Promise<void> {
    Logger.info(TAG, `%{public}s`, `EntryAbility onDestroy`);
    DragFrameController.unsubscribeEvent(this.context);
  }

  onWindowStageWillDestroy(): void {
    Logger.info(TAG, `%{public}s`, `Ability onWindowStageWillDestroy`);
    DragFrameController.removeWindowConfig();
  }
}