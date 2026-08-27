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

import { AbilityConstant, UIExtensionContentSession, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { LiveViewLockScreenExtensionAbility } from '@kit.LiveViewKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { LiveViewLockScreenController } from '@ohos_samples/liveviewlockscreenlibrary';

const TAG: string = '[LiveViewExtAbility]';

// Main class for lock screen live view extension, handles live view presentation on lock screen.
export default class LiveViewExtAbility extends LiveViewLockScreenExtensionAbility {
  onCreate(_launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, TAG, '%{public}s', 'LiveViewLockScreenExtAbility onCreate begin.');
  }

  onForeground(): void {
    hilog.info(0x0000, TAG, '%{public}s', 'LiveViewLockScreenExtAbility onForeground begin.');
  }

  onBackground(): void {
    hilog.info(0x0000, TAG, '%{public}s', 'LiveViewLockScreenExtAbility onBackground begin.');
  }

  onDestroy(): void | Promise<void> {
    hilog.info(0x0000, TAG, '%{public}s', 'LiveViewLockScreenExtAbility onDestroy begin.');
  }

  // Core logic when creating UI session.
  onSessionCreate(_want: Want, session: UIExtensionContentSession): void {
    hilog.info(0x0000, TAG, '%{public}s', 'LiveViewLockScreenExtAbility onSessionCreate begin.');
    LiveViewLockScreenController.initLiveView(session);
    try {
      session.loadContent('pages/LockScreen');
    } catch (error) {
      hilog.error(0x0000, TAG, '%{public}s',
        `Session load content fail. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
  }

  // Cleanup operations when destroying UI session
  onSessionDestroy(): void {
    LiveViewLockScreenController.destroyLLiveView();
    hilog.info(0x0000, TAG, '%{public}s', 'LiveViewLockScreenExtAbility onSessionDestroy begin.');
  }

  onConfigurationUpdate(): void {
    hilog.info(0x0000, TAG, '%{public}s', 'LiveViewLockScreenExtAbility onConfigurationUpdate begin.');
  }
}