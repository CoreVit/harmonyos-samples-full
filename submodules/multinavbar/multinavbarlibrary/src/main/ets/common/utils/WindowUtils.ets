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
import { BusinessError } from '@kit.BasicServicesKit';
import { Constants } from '../Constants';
import { BreakpointSystem } from './BreakpointSystem';
import Logger from './Logger';

const TAG: string = '[WindowUtil]';

export class WindowUtil {
  private static windowClass: window.Window;
  private static windowSizeChangeCallBack: () => void = () => {
    BreakpointSystem.getInstance().onWindowSizeChange(WindowUtil.windowClass);
  };
  private static avoidAreaChangeCallBack: (avoidAreaOption: window.AvoidAreaOptions) => void = (avoidAreaOption) => {
    WindowUtil.setAvoidArea(avoidAreaOption.type, avoidAreaOption.area);
  };

  public static initialize(windowStage: window.WindowStage) {
    try {
      WindowUtil.windowClass = windowStage.getMainWindowSync();
      const uiContext: UIContext = WindowUtil.windowClass.getUIContext();
      AppStorage.setOrCreate<UIContext>(Constants.KEY_UI_CONTEXT, uiContext);
      if (canIUse('SystemCapability.Window.SessionManager')) {
        WindowUtil.windowClass.setWindowDecorVisible(false);
        WindowUtil.windowClass.setWindowDecorHeight(Constants.WINDOW_DECOR_HEIGHT);
      }
      WindowUtil.requestFullScreen(WindowUtil.windowClass);
      WindowUtil.registerBreakPoint(WindowUtil.windowClass);
    } catch (err) {
      const error = err as BusinessError;
      Logger.error(TAG, `Initialize failed. Cause code: ${error.code}, message: ${error.message}`);
    }
  }

  public static requestFullScreen(windowClass: window.Window): void {
    windowClass.setWindowLayoutFullScreen(true).catch((err: BusinessError) => {
      Logger.error(TAG,
        `Failed to set the window layout to full-screen mode. Cause: ${err.code}, ${err.message}`);
    });
  }

  public static registerBreakPoint(data: window.Window) {
    try {
      BreakpointSystem.getInstance().updateWidthBp(data);
      const systemAvoidArea: window.AvoidArea = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      const navIndicatorAvoidArea: window.AvoidArea =
        data.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      WindowUtil.setAvoidArea(window.AvoidAreaType.TYPE_SYSTEM, systemAvoidArea);
      WindowUtil.setAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR, navIndicatorAvoidArea);
      data.on('windowSizeChange', WindowUtil.windowSizeChangeCallBack);
      data.on('avoidAreaChange', WindowUtil.avoidAreaChangeCallBack);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG,
        `Failed to register the windowSizeChange or the WindowAvoidArea. Cause: ${err.code}, ${err.message}`);
    }
  }

  public static unregisterBreakPoint() {
    try {
      WindowUtil.windowClass.off('windowSizeChange', WindowUtil.windowSizeChangeCallBack);
      WindowUtil.windowClass.off('avoidAreaChange', WindowUtil.avoidAreaChangeCallBack);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG,
        `Failed to unregister the windowSizeChange or the WindowAvoidArea. Cause: ${err.code}, ${err.message}`);
    }
  }

  // Get status bar height and indicator height.
  public static setAvoidArea(type: window.AvoidAreaType, area: window.AvoidArea) {
    const context: UIContext | undefined = AppStorage.get<UIContext>(Constants.KEY_UI_CONTEXT);
    if (context) {
      if (type === window.AvoidAreaType.TYPE_SYSTEM) {
        AppStorage.setOrCreate(Constants.KEY_STATUS_BAR_HEIGHT, context?.px2vp(area.topRect.height));
      } else if (type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
        AppStorage.setOrCreate(Constants.KEY_NAV_INDICATOR_HEIGHT, context?.px2vp(area.bottomRect.height));
      }
    }
  }
}