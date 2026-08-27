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
import { Constants } from '../Constants';
import { BreakpointSystem } from './BreakpointSystem';
import Logger from './Logger';

const TAG: string = '[WindowUtil]';

export class WindowUtil {
  private static windowClass: window.Window;
  private static windowSizeChangeCB: () => void = () => {
    BreakpointSystem.getInstance().onWindowSizeChange(WindowUtil.windowClass);
  };
  private static avoidAreaChangeCB: (avoidAreaOption: window.AvoidAreaOptions) => void = (avoidAreaOption) => {
    WindowUtil.setAvoidArea(WindowUtil.windowClass, avoidAreaOption.type, avoidAreaOption.area);
  };

  public static initialize(windowStage: window.WindowStage) {
    try {
      WindowUtil.windowClass = windowStage.getMainWindowSync();
      const uiContext: UIContext = WindowUtil.windowClass.getUIContext();
      AppStorage.setOrCreate<UIContext>(Constants.KEY_UI_CONTEXT, uiContext);
      WindowUtil.registerBreakPoint(WindowUtil.windowClass);
    } catch (err) {
      const error = err as BusinessError;
      Logger.error(TAG, `Initialize failed. Cause code: ${error.code}, message: ${error.message}`);
    }
  }

  public static requestFullScreen(windowClass: window.Window): void {

    // Realize the immersive effect.
    try {
      windowClass.setWindowLayoutFullScreen(true).then(() => {
        Logger.info(TAG, 'Succeeded in setting the window layout to full-screen mode.');
      }).catch((err: BusinessError) => {
        Logger.error(TAG,
          `Failed to set the window layout to full-screen mode. Cause: ${err.code}, ${err.message}`);
      });
    } catch {
      Logger.error(TAG, 'Failed to set the window layout to full-screen mode. ');
    }
  }

  public static registerBreakPoint(data: window.Window) {
    try {
      BreakpointSystem.getInstance().updateWidthBp(data);
      const systemAvoidArea: window.AvoidArea = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      const navIndicatorAvoidArea: window.AvoidArea =
        data.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      WindowUtil.setAvoidArea(data, window.AvoidAreaType.TYPE_SYSTEM, systemAvoidArea);
      WindowUtil.setAvoidArea(data, window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR, navIndicatorAvoidArea);
      data.on('windowSizeChange', WindowUtil.windowSizeChangeCB);
      data.on('avoidAreaChange', WindowUtil.avoidAreaChangeCB);
    } catch (e) {
      const error = e as BusinessError;
      Logger.error(TAG,
        `Register avoidAreaChange or windowSizeChange failed. code: ${error.code}, message: ${error.message}`);
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
  public static setAvoidArea(data: window.Window, type: window.AvoidAreaType, area: window.AvoidArea) {
    let context: UIContext | undefined;
    try {
      context = data.getUIContext();
    } catch (err) {
      Logger.error(TAG, `getUIContext failed. code: ${err.code ?? ''}, message: ${err.message ?? ''}`);
      return;
    }
    if (!context) {
      Logger.info(TAG, `%{public}s`, `can not get uicontext`);
      return;
    }
    if (type === window.AvoidAreaType.TYPE_SYSTEM) {
      AppStorage.setOrCreate(Constants.KEY_STATUS_BAR_HEIGHT, context.px2vp(area.topRect.height));
    } else if (type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
      AppStorage.setOrCreate(Constants.KEY_NAV_INDICATOR_HEIGHT, context.px2vp(area.bottomRect.height));
    }
  }
}