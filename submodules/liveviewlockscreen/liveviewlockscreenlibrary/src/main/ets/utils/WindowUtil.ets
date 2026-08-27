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

import { window } from '@kit.ArkUI';
import type { BusinessError } from '@kit.BasicServicesKit';
import { Constants } from '../common/Constants';
import { BreakpointSystem } from './BreakpointSystem';
import Logger from './Logger';

const TAG: string = '[WindowUtil]';

export class WindowUtil {
  private static windowClass?: window.Window;

  public static initialize(windowStage: window.WindowStage): void {
    try {
      WindowUtil.windowClass = windowStage.getMainWindowSync();
      const uiContext: UIContext = WindowUtil.windowClass.getUIContext();
      AppStorage.setOrCreate<UIContext>(Constants.KEY_PREFIX + 'UIContext', uiContext);
      WindowUtil.registerBreakPoint(WindowUtil.windowClass);
      WindowUtil.requestFullScreen(WindowUtil.windowClass);
    } catch (err) {
      Logger.error(TAG, `WindowUtil initialize failed. Cause: ${err.code} ${err.message}`);
    }
  }

  private static registerBreakPoint(windowClass: window.Window): void {
    try {
      BreakpointSystem.getInstance().onWindowSizeChange(windowClass);
      windowClass.on('windowSizeChange', () => BreakpointSystem.getInstance().onWindowSizeChange(windowClass));

      const navIndicatorAvoidArea: window.AvoidArea =
        windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      WindowUtil.setAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR, navIndicatorAvoidArea);
      windowClass.on('avoidAreaChange', (avoidAreaOption) => {
        WindowUtil.setAvoidArea(avoidAreaOption.type, avoidAreaOption.area);
      });
    } catch (e) {
      const error = e as BusinessError;
      Logger.error(TAG,
        `Get windowAvoidArea or Register windowSizeChange failed. code: ${error.code}, message: ${error.message}`);
    }
  }

  // Get status indicator height.
  private static setAvoidArea(type: window.AvoidAreaType, area: window.AvoidArea): void {
    try {
      if (type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
        AppStorage.setOrCreate(Constants.KEY_PREFIX + 'NaviIndicatorHeight',
          WindowUtil.windowClass?.getUIContext().px2vp(area.bottomRect.height));
      }
    } catch (error) {
      Logger.error(TAG,
        `Get windowAvoidArea or Register windowSizeChange failed. code: ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
  }

  private static requestFullScreen(windowClass: window.Window): void {
    try {
      windowClass.setWindowSystemBarProperties({
        statusBarContentColor: '#ffffff',
      }).then(() => {
        Logger.info(TAG, 'Succeeded in setting the system bar properties.');
      }).catch((error: BusinessError) => {
        Logger.error(TAG,
          `Failed to set the window layout to full-screen mode. Cause code: ${error.code}, message: ${error.message}`);
      });

      windowClass.setWindowLayoutFullScreen(true).then(() => {
        Logger.info(TAG, 'Succeeded in setting the window layout to full-screen mode');
      }).catch((error: BusinessError) => {
        Logger.error(TAG,
          `Failed to set the window layout to full-screen mode. Cause code: ${error.code}, message: ${error.message}`);
      });
    } catch (error) {
      Logger.error(TAG, `onWindowStageCreate failed. Cause code: ${error.code}, message: ${error.message}`);
    }
  }
}