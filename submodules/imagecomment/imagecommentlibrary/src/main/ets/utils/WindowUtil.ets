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

import type { BusinessError } from '@kit.BasicServicesKit';
import { window } from '@kit.ArkUI';
import { BreakpointSystem } from './BreakpointSystem';
import { CommonConstants } from '../common/constants/CommonConstants';
import Logger from './Logger';

const TAG: string = '[WindowUtil]';

export class WindowUtil {
  private static windowClass: window.Window;

  public static initialize(windowStage: window.WindowStage): void {
    try {
      WindowUtil.windowClass = windowStage.getMainWindowSync();
      WindowUtil.requestFullScreen();
      WindowUtil.registerBreakPoint();
    } catch (err) {
      Logger.error(TAG, `WindowUtil initialize Failed. Cause: ${err.code}`);
    }
  }

  public static requestFullScreen(): void {
    // Realize the immersive effect.
    try {
      const promise: Promise<void> = WindowUtil.windowClass.setWindowLayoutFullScreen(true);
      promise.then(() => {
        Logger.info(TAG, 'Succeeded in setting the window layout to full-screen mode.');
      }).catch((err: BusinessError) => {
        Logger.error(TAG, `Failed to set the window layout to full-screen mode. Cause: ${err.code}`);
      });
    } catch (err) {
      const error = err as BusinessError;
      Logger.error(TAG, `Failed to set the window layout to full-screen mode. Cause: ${error.code}, ${error.message}`);
    }
  }

  private static registerBreakPoint() {
    BreakpointSystem.getInstance().updateWidthBp(WindowUtil.windowClass);
    WindowUtil.updateAvoidArea(WindowUtil.windowClass);
    WindowUtil.windowClass.on('windowSizeChange',
      () => BreakpointSystem.getInstance().onWindowSizeChange(WindowUtil.windowClass));
    WindowUtil.windowClass.on('avoidAreaChange',
      (avoidAreaOption) => WindowUtil.setAvoidArea(avoidAreaOption.type, avoidAreaOption.area));
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

  private static updateAvoidArea(windowObj: window.Window) {
    try {
      WindowUtil.setAvoidArea(window.AvoidAreaType.TYPE_SYSTEM,
        windowObj.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM));
      WindowUtil.setAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR,
        windowObj.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR));
    } catch (err) {
      Logger.error(TAG, 'getWindowAvoidArea get exception');
    }
  }

  // Get status bar height and indicator height.
  private static setAvoidArea(type: window.AvoidAreaType, area: window.AvoidArea) {
    try {
      let uiContext = WindowUtil.windowClass.getUIContext();
      if (type === window.AvoidAreaType.TYPE_SYSTEM) {
        AppStorage.setOrCreate(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT, uiContext.px2vp(area.topRect.height));
      } else if (type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
        AppStorage.setOrCreate(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT, uiContext.px2vp(area.bottomRect.height));
      }
    } catch (err) {
      Logger.error(TAG, 'getUIContext get exception');
    }
  }

  public static getWindowClass(): window.Window {
    return WindowUtil.windowClass;
  }
}