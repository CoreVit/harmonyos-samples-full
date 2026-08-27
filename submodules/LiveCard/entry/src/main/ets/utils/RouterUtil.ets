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

import { common } from '@kit.AbilityKit';
import { Constants } from '../common/CommonConstants';
import { Logger } from './Logger';

const TAG = 'RouterUtil';

export default class RouterUtil {
  private static instance: RouterUtil | undefined = undefined;
  private pathStack: NavPathStack = new NavPathStack();

  static getInstance(): RouterUtil {
    if (RouterUtil.instance === undefined) {
      RouterUtil.instance = new RouterUtil();
    }
    return RouterUtil.instance;
  }

  getPathStack(): NavPathStack {
    return this.pathStack;
  }

  pushPage(name: string): void {
    this.pathStack.replacePath({
      name: name,
      param: []
    });
  }

  pop(): void {
    this.pathStack.pop();
  }

  clearPages(): void {
    this.pathStack.clear();
  }

  async closeApp(): Promise<void> {
    try {
      let context = AppStorage.get(Constants.KEY_CONTEXT) as common.UIAbilityContext;
      if (!context || !context.windowStage) {
        Logger.error(TAG, `closeApp error: context is undefined`);
        return;
      }
      let mainWindow = context.windowStage.getMainWindowSync();
      await mainWindow.minimize();
    } catch (error) {
      Logger.error(TAG, `closeApp error: ${error.code}, message is ${error.message}`);
    }
  }
}
