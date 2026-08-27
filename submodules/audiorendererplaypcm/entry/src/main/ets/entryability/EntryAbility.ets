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

import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { ComponentContent, window } from '@kit.ArkUI';
import { WindowUtil } from '../common/utils/WindowUtil';
import { AppStorageKeyConstants } from '../common/constants/AppStorageKeyConstants';
import { buildText, Params, PromptActionClassNew } from '../viewmodel/PromptActionClassNew';
import Logger from '../common/utils/Logger';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  private windowObj?: window.Window;
  private windowUtil?: WindowUtil;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      AppStorage.setOrCreate(AppStorageKeyConstants.KEY_UI_ABILITY_CONTEXT, this.context)
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      Logger.error('testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
  }

  onDestroy(): void {
    Logger.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }


  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Logger.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        Logger.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      windowStage.getMainWindow().then((data: window.Window) => {
        const uiContext = data.getUIContext();
        this.windowObj = data;
        this.windowUtil = new WindowUtil(windowStage.getMainWindowSync(), data.getUIContext());
        AppStorage.setOrCreate<WindowUtil>(AppStorageKeyConstants.KEY_WINDOW_UTIL, this.windowUtil);
        PromptActionClassNew.setContext(uiContext);
        PromptActionClassNew.setContentNode(new ComponentContent(uiContext, wrapBuilder(buildText),
          new Params($r('app.string.no_operate'))));
        PromptActionClassNew.setOptions({
          alignment: DialogAlignment.Top,
          offset: { dx: 0, dy: 120 },
          autoCancel: false
        });
        this.windowUtil.setAvoidArea();
        this.windowUtil.updateWindowInfo();
        this.windowUtil.updateAvoidArea();
        if (this.windowUtil.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_SM &&
          this.windowUtil.mainWindowInfo.heightBp === HeightBreakpoint.HEIGHT_MD) {
          PromptActionClassNew.openDialog();
        }
        AppStorage.setOrCreate<window.Window>(AppStorageKeyConstants.KEY_WINDOW, data);
        data.setWindowLayoutFullScreen(true);
      })
      Logger.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}