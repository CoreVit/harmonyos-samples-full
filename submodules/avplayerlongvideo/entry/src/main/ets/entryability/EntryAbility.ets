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

import { UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { WindowUtil } from '../common/utils/WindowUtil';
import { KeyConstants } from '../common/constants/KeyConstants';
import Logger from '../common/utils/Logger';

const TAG = '[EntryAbility]';

export default class EntryAbility extends UIAbility {
  onCreate(): void {
    AppStorage.setOrCreate(KeyConstants.KEY_CONTEXT, this.context);
    Logger.info(TAG, 'Ability onCreate');
  }

  onDestroy(): void {
    Logger.info(TAG, 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    Logger.info(TAG, 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/IndexPage', (err: BusinessError) => {
      try {
        AppStorage.setOrCreate(KeyConstants.KEY_UI_CONTEXT, windowStage.getMainWindowSync().getUIContext());
        if (err && err.code) {
          Logger.error(TAG, `Failed to load the content. code is ${err.code}, message is ${err.message}`);
          return;
        }
        Logger.info(TAG, 'Succeeded in loading the content.');
        let windowClass: window.Window = windowStage.getMainWindowSync();
        WindowUtil.getInstance().setWindowStage(windowStage);
        AppStorage.setOrCreate(KeyConstants.KEY_WINDOW_STAGE, windowStage);
        windowClass.setWindowLayoutFullScreen(true).catch((err: BusinessError) => {
          Logger.error(TAG, `setWindowLayoutFullScreen failed, code is ${err.code}, message is ${err.message}`);
        });
        windowClass.setWindowSystemBarProperties({
          statusBarContentColor: '#e6ffffff'
        }).catch((err: BusinessError) => {
          Logger.error(TAG, `setWindowSystemBarProperties failed, code is ${err.code}, message is ${err.message}`);
        });
      } catch (exception) {
        Logger.error(TAG, `onWindowStageCreate failed, Code:${exception.code}, message:${exception.message}`);
      }
    });
  }

  onWindowStageDestroy(): void {
    Logger.info(TAG, 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    Logger.info(TAG, 'Ability onForeground');
  }

  onBackground(): void {
    Logger.info(TAG, 'Ability onBackground');
  }
}
