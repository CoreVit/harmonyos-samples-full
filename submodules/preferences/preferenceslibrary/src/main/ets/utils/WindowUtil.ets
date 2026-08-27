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
import { CommonConstants } from '../common/CommonConstants';
import { BreakpointSystem } from './BreakpointSystem';
import Logger from './Logger';

const TAG: string = '[WindowUtil]';

export class WindowUtil {
  private static windowClass?: window.Window;

  public static initialize(windowStage: window.WindowStage) {
    try {
      WindowUtil.windowClass = windowStage.getMainWindowSync();
      const uiContext: UIContext = WindowUtil.windowClass.getUIContext();
      AppStorage.setOrCreate<UIContext>(CommonConstants.KEY_PREFIX + 'UIContext', uiContext);
      WindowUtil.registerBreakPoint(WindowUtil.windowClass);
      WindowUtil.requestFullScreen();
    } catch (err) {
      Logger.error(TAG, `WindowUtil initialize failed. Cause: ${err.code} ${err.message}`);
    }
  }

  public static requestFullScreen(): void {
    // Realize the immersive effect.
    try {
      const promise: Promise<void> | undefined = WindowUtil.windowClass?.setWindowLayoutFullScreen(true);
      promise?.then(() => {
        Logger.info(TAG, 'Succeeded in setting the window layout to full-screen mode.');
      }).catch((err: BusinessError) => {
        Logger.info(TAG,
          `Failed to set the window layout to full-screen mode. Cause: ${err.code}, ${err.message}`);
      });
    } catch (err) {
      const error = err as BusinessError;
      Logger.error(TAG, `Failed to set the window layout to full-screen mode. Cause: ${error.code}, ${error.message}`);
    }
  }

  public static registerBreakPoint(windowClass: window.Window) {
    try {
      BreakpointSystem.getInstance().onWindowSizeChange(windowClass);
      const systemAvoidArea: window.AvoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      const navIndicatorAvoidArea: window.AvoidArea =
        windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      WindowUtil.setAvoidArea(window.AvoidAreaType.TYPE_SYSTEM, systemAvoidArea);
      WindowUtil.setAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR, navIndicatorAvoidArea);
      windowClass.on('windowSizeChange', () => BreakpointSystem.getInstance().onWindowSizeChange(windowClass));
      windowClass.on('avoidAreaChange', (avoidAreaOption) => {
        WindowUtil.setAvoidArea(avoidAreaOption.type, avoidAreaOption.area);
      });
    } catch (e) {
      const error = e as BusinessError;
      Logger.error(TAG,
        `Get windowAvoidArea or Register windowSizeChange failed. code: ${error.code}, message: ${error.message}`);
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
      const uiContext: UIContext | undefined = WindowUtil.windowClass?.getUIContext();
      if (!uiContext) {
        Logger.error(TAG, 'can not get ui context');
      } else {
        if (type === window.AvoidAreaType.TYPE_SYSTEM) {
          AppStorage.setOrCreate(CommonConstants.KEY_PREFIX + 'StatusBarHeight', uiContext.px2vp(area.topRect.height));
        } else if (type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          AppStorage.setOrCreate(CommonConstants.KEY_PREFIX + 'NaviIndicatorHeight',
            uiContext.px2vp(area.bottomRect.height));
        }
      }
    } catch (err) {
      const error = err as BusinessError;
      Logger.error(TAG, `getUIContext get exception. error code: ${error.code}, message: ${error.message}`);
    }
  }
}