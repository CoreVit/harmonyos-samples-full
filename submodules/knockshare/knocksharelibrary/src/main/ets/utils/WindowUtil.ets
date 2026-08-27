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

import { window } from '@kit.ArkUI';
import type { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { CommonConstants } from '../common/Constants';
import { BreakpointSystem } from './BreakpointSystem';
import Logger from './Logger';

const TAG = '[KnockShareSample]';

export class WindowUtil {
  private static windowClass: window.Window;

  public static initialize(windowStage: window.WindowStage) {
    try {
      WindowUtil.windowClass = windowStage.getMainWindowSync();
      const uiContext: UIContext = WindowUtil.windowClass.getUIContext();
      AppStorage.setOrCreate<UIContext>(CommonConstants.KEY_PREFIX + 'UIContext', uiContext);
      WindowUtil.requestFullScreen(WindowUtil.windowClass);
      WindowUtil.registerBreakPoint(WindowUtil.windowClass);
    } catch (err) {
      const error = err as BusinessError;
      Logger.error(TAG, `WindowUtil initialize failed. Cause: ${error.code} ${error.message}`);
    }
  }

  public static requestFullScreen(windowClass: window.Window): void {
    try {
      const promise: Promise<void> = windowClass.setWindowLayoutFullScreen(true);
      promise.then(() => {
        Logger.info(TAG, 'Succeeded in setting the window layout to full-screen mode.');
      }).catch((err: BusinessError) => {
        Logger.error(TAG,
          `Failed to set the window layout to full-screen mode. Cause: ${err.code}, ${err.message}.`);
      });
    } catch (err) {
      const error = err as BusinessError;
      Logger.error(TAG, `Failed to set the window layout to full-screen mode. Cause: ${error.code}, ${error.message}`);
    }
  }

  public static registerBreakPoint(data: window.Window) {
    try {
      BreakpointSystem.getInstance().updateWidthBp(data);
      const systemAvoidArea: window.AvoidArea = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      const navIndicatorAvoidArea: window.AvoidArea =
        data.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      WindowUtil.setAvoidArea(window.AvoidAreaType.TYPE_SYSTEM, systemAvoidArea);
      WindowUtil.setAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR, navIndicatorAvoidArea);
      data.on('windowSizeChange', () => BreakpointSystem.getInstance().onWindowSizeChange(data));
      data.on('avoidAreaChange', (avoidAreaOption) => {
        WindowUtil.setAvoidArea(avoidAreaOption.type, avoidAreaOption.area);
      });
    } catch (e) {
      const error = e as BusinessError;
      Logger.error(TAG,
        `Register avoidAreaChange or windowSizeChange failed. code: ${error.code}, message: ${error.message}`);
    }
  }

  public static unregisterBreakPoint(): void {
    try {
      WindowUtil.windowClass?.off('windowSizeChange');
      WindowUtil.windowClass?.off('avoidAreaChange');
    } catch (err) {
      const error = err as BusinessError;
      Logger.error(TAG, `unRegister windowSizeChange failed. code: ${error.code}, message: ${error.message}`);
    }
  }

  // Get status bar height and indicator height.
  public static setAvoidArea(type: window.AvoidAreaType, area: window.AvoidArea) {
    try {
      if (type === window.AvoidAreaType.TYPE_SYSTEM) {
        AppStorage.setOrCreate(CommonConstants.KEY_PREFIX + 'statusBarHeight',
          WindowUtil.windowClass?.getUIContext().px2vp(area.topRect.height));
      } else {
        AppStorage.setOrCreate(CommonConstants.KEY_PREFIX + 'naviIndicatorHeight',
          WindowUtil.windowClass?.getUIContext().px2vp(area.bottomRect.height));
      }
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `setAvoidArea failed, code: ${err.code}, message: ${err.message}`);
    }
  }

  public static updateStatusBarColor(context: common.BaseContext, isDark: boolean): void {
    window.getLastWindow(context).then((windowClass: window.Window) => {
      try {
        windowClass.setWindowSystemBarProperties({
          statusBarContentColor: isDark ? StatusBarColorType.WHITE : StatusBarColorType.BLACK
        }).then(() => {
          Logger.info(TAG, 'Succeeded in setting the system bar properties.');
        }).catch((err: BusinessError) => {
          Logger.error(TAG, `Failed to set the system bar properties. Cause: ${err.code} ${err.message}`);
        });
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        Logger.error(TAG, `Failed to set the system bar properties. Cause: ${err.code}, ${err.message}`);
      }
    }).catch((error: BusinessError) => {
      Logger.error(TAG, `GetLastWindow failed. code: ${error.code}, message: ${error.message}`);
    });
  }
}

export enum StatusBarColorType {
  WHITE = '#ffffff',
  BLACK = '#E5000000',
}