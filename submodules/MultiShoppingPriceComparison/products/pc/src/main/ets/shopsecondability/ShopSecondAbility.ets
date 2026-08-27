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
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { UIContext, window } from '@kit.ArkUI';
import { WindowUtil } from 'multishoppingbase';
import { AppStorageV2 } from '@kit.ArkUI';

const domain = 0x0000;
const uiContextStorageKey: string = 'MultiShoppingUiContext';

export default class ShopSecondAbility extends UIAbility {
  private windowUtil?: WindowUtil;

  onCreate(): void {
    hilog.info(domain, 'testTag', '%{public}s', 'ShopSecondAbility onCreate');
  }

  onDestroy(): void {
    hilog.info(domain, 'testTag', '%{public}s', 'ShopSecondAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(domain, 'testTag', '%{public}s', 'ShopSecondAbility onWindowStageCreate');
    try {
      this.windowUtil = WindowUtil.getInstance();
      this.windowUtil.setWindowStage(windowStage);
    } catch (error) {
      let err = error as BusinessError;
      hilog.error(0x0000, 'TestLog', `Failed to get main window. Code: ${err.code}, message: ${err.message}`);
    }

    windowStage.loadContent('pages/Index', (err) => {
      try {
        AppStorageV2.connect(UIContext, uiContextStorageKey, () => windowStage.getMainWindowSync().getUIContext());
      } catch (error) {
        hilog.error(domain, 'testTag', 'Failed to get the content. Cause: %{public}s', JSON.stringify(error));
      }
      if (err.code) {
        hilog.error(domain, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(domain, 'testTag', 'Succeeded in loading the content.');
      this.windowUtil!.setUIContext();
      this.windowUtil!.updateWindowInfo();
    });
  }

  onWindowStageDestroy(): void {
    hilog.info(domain, 'testTag', '%{public}s', 'ShopSecondAbility onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(domain, 'testTag', '%{public}s', 'ShopSecondAbility onForeground');
  }

  onBackground(): void {
    hilog.info(domain, 'testTag', '%{public}s', 'ShopSecondAbility onBackground');
  }
}
