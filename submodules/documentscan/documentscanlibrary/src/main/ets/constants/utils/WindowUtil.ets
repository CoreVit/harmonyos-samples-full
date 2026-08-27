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
import Constants from '../Constants';
import Logger from './Logger';

const TAG: string = '[WindowUtil]';

export class WindowUtil {
  private static windowClass: window.Window;

  public static initialize(windowStage: window.WindowStage) {
    try {
      WindowUtil.windowClass = windowStage.getMainWindowSync();
      const uiContext: UIContext = WindowUtil.windowClass.getUIContext();
      AppStorage.setOrCreate<UIContext>(Constants.KEY_UI_CONTEXT, uiContext);
      WindowUtil.requestFullScreen(WindowUtil.windowClass);
      WindowUtil.registerBreakPoint(WindowUtil.windowClass);
    } catch (err) {
      const error = err as BusinessError;
      Logger.error(0x0000, TAG, `Initialize failed. Cause code: ${error.code}, message: ${error.message}`);
    }
  }

  public static requestFullScreen(windowClass: window.Window): void {
    try {
      const promise: Promise<void> = windowClass.setWindowLayoutFullScreen(true);
      promise.then(() => {
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
      WindowUtil.onWindowSizeChange(data);
      const systemAvoidArea: window.AvoidArea = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      const navIndicatorAvoidArea: window.AvoidArea =
        data.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      WindowUtil.setAvoidArea(window.AvoidAreaType.TYPE_SYSTEM, systemAvoidArea);
      WindowUtil.setAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR, navIndicatorAvoidArea);
      data.on('windowSizeChange', () => WindowUtil.onWindowSizeChange(data));
      data.on('avoidAreaChange', (avoidAreaOption) => {
        WindowUtil.setAvoidArea(avoidAreaOption.type, avoidAreaOption.area);
      });
    } catch (e) {
      const error = e as BusinessError;
      Logger.error(TAG,
        `Get windowAvoidArea or Register windowSizeChange failed. code: ${error.code}, message: ${error.message}`);
    }
  }

  private static onWindowSizeChange(window: window.Window) {
    try {
      const uiContext: UIContext = window.getUIContext();
      const widthBp: WidthBreakpoint = uiContext.getWindowWidthBreakpoint();
      Logger.info(TAG, `WidthBreakpoint: ${widthBp}`);
      AppStorage.setOrCreate(Constants.KEY_BREAKPOINT, widthBp);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `UpdateBreakpoint fail, error code: ${err.code}, message: ${err.message}`);
    }
  }

  public static setAvoidArea(type: window.AvoidAreaType, area: window.AvoidArea) {
    const context: UIContext | undefined = AppStorage.get<UIContext>(Constants.KEY_UI_CONTEXT);
    if (type === window.AvoidAreaType.TYPE_SYSTEM) {
      AppStorage.setOrCreate(Constants.KEY_STATUS_BAR_HEIGHT, context?.px2vp(area.topRect.height));
    } else if (type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
      AppStorage.setOrCreate(Constants.KEY_NAV_INDICATOR_HEIGHT, context?.px2vp(area.bottomRect.height));
    }
  }
}