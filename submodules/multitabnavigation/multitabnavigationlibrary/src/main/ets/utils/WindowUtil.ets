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
import { CommonConstants } from '../common/CommonConstants';
import Logger from './Logger';

const TAG: string = '[WindowUtil]';

export class WindowUtil {
  private static windowClass: window.Window;
  private static windowSizeChangeCB: () => void = () => {
    BreakpointSystem.getInstance().onWindowSizeChange(WindowUtil.windowClass);
  };
  private static avoidAreaChangeCB: (avoidAreaOption: window.AvoidAreaOptions) => void = (avoidAreaOption) => {
    WindowUtil.setAvoidArea(avoidAreaOption.type, avoidAreaOption.area);
  };

  public static initialize(windowStage: window.WindowStage): void {
    try {
      WindowUtil.windowClass = windowStage.getMainWindowSync();
      WindowUtil.requestFullScreen();
      WindowUtil.registerBreakPoint();
    } catch (err) {
      Logger.error(TAG, `WindowUtil initialize Failed. Cause: ${err.message}`);
    }
  }

  public static requestFullScreen(): void {
    // Realize the immersive effect.
    try {
      WindowUtil.windowClass.setWindowLayoutFullScreen(true).then(() => {
        Logger.info(TAG, 'Succeeded in setting the window layout to full-screen mode.');
      }).catch((err: BusinessError) => {
        Logger.error(TAG,
          `Failed to set the window layout to full-screen mode. Cause: ${err.code}, ${err.message}`);
      });
    } catch {
      Logger.error(TAG, 'Failed to set the window layout to full-screen mode. ');
    }
  }

  public static registerBreakPoint() {
    BreakpointSystem.getInstance().updateWidthBp(WindowUtil.windowClass);
    WindowUtil.updateAvoidArea(WindowUtil.windowClass);
    WindowUtil.windowClass.on('windowSizeChange', WindowUtil.windowSizeChangeCB);
    WindowUtil.windowClass.on('avoidAreaChange', WindowUtil.avoidAreaChangeCB);
  }

  public static updateAvoidArea(windowObj: window.Window) {
    try {
      WindowUtil.setAvoidArea(window.AvoidAreaType.TYPE_SYSTEM,
        windowObj.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM));
      WindowUtil.setAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR,
        windowObj.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR));
    } catch (err) {
      Logger.error(TAG, 'getWindowAvoidArea get exception');
    }
  }

  public static unregisterBreakPoint() {
    try {
      WindowUtil.windowClass.off('windowSizeChange', WindowUtil.windowSizeChangeCB);
      WindowUtil.windowClass.off('avoidAreaChange', WindowUtil.avoidAreaChangeCB);
    } catch (e) {
      const error = e as BusinessError;
      Logger.error(TAG,
        `unRegister avoidAreaChange or windowSizeChange failed. code: ${error.code}, message: ${error.message}`);
    }
  }

  // Get status bar height and indicator height.
  public static setAvoidArea(type: window.AvoidAreaType, area: window.AvoidArea) {
    let context: UIContext | undefined;
    try {
      context = WindowUtil.windowClass.getUIContext();
    } catch (err) {
      Logger.error(TAG, `getUIContext failed. code: ${err.code ?? ''}, message: ${err.message ?? ''}`);
      return;
    }
    if (!context) {
      Logger.info(TAG, `%{public}s`, `can not get uicontext`);
      return;
    }
    if (type === window.AvoidAreaType.TYPE_SYSTEM) {
      AppStorage.setOrCreate(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT, context.px2vp(area.topRect.height));
    } else if (type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
      AppStorage.setOrCreate(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT, context.px2vp(area.bottomRect.height));
    }
  }
}