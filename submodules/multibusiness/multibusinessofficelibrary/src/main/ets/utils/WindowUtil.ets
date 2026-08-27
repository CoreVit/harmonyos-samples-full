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

import { display, window } from '@kit.ArkUI';
import type { BusinessError } from '@kit.BasicServicesKit';
import { CommonConstants } from '../constants/CommonConstants';
import { BreakpointSystem } from './BreakpointSystem';
import Logger from './Logger';

const TAG: string = '[WindowUtil]';

export class WindowUtil {
  public static initialize(windowStage: window.WindowStage) {
    try {
      const uiContext: UIContext = windowStage.getMainWindowSync().getUIContext();
      AppStorage.setOrCreate<UIContext>(`${CommonConstants.KEY_PREFIX_MAIN}UIContext`, uiContext);
      WindowUtil.requestFullScreen(windowStage);
      WindowUtil.registerBreakPoint(CommonConstants.KEY_PREFIX_MAIN, windowStage);
      WindowUtil.setWindowDecor(windowStage, false, CommonConstants.WINDOW_DECOR_HEIGHT);
      WindowUtil.setWindowLimit(windowStage, { minWidth: CommonConstants.WINDOW_MIN_WIDTH });
    } catch (err) {
      const error = err as BusinessError;
      Logger.error(TAG, `Initialize failed. Cause code: ${error.code}, message: ${error.message}`);
    }
  }

  public static requestFullScreen(windowStage: window.WindowStage): void {
    windowStage.getMainWindow((err: BusinessError, data: window.Window) => {
      if (err.code) {
        return;
      }
      const windowClass: window.Window = data;
      // Realize the immersive effect.
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
    });
  }

  public static registerBreakPoint(preKey: string, windowStage: window.WindowStage) {
    windowStage.getMainWindow((err: BusinessError, data: window.Window) => {
      if (err.code) {
        Logger.error(TAG, `Failed to get main window: ${err.message}`);
        return;
      }
      try {
        BreakpointSystem.getInstance().updateWidthBp(preKey, data);
        WindowUtil.updateWindowSize(preKey, data.getWindowProperties().windowRect.width,
          data.getWindowProperties().windowRect.height);
        const systemAvoidArea: window.AvoidArea = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
        const navIndicatorAvoidArea: window.AvoidArea =
          data.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
        WindowUtil.setAvoidArea(window.AvoidAreaType.TYPE_SYSTEM, systemAvoidArea, preKey);
        WindowUtil.setAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR, navIndicatorAvoidArea, preKey);
        data.on('windowSizeChange', (windowSize: window.Size) => {
          BreakpointSystem.getInstance().onWindowSizeChange(preKey, data);
          WindowUtil.updateWindowSize(preKey, windowSize.width, windowSize.height);
        });
        data.on('avoidAreaChange', (avoidAreaOption) => {
          WindowUtil.setAvoidArea(avoidAreaOption.type, avoidAreaOption.area, preKey);
        });
      } catch (e) {
        const error = e as BusinessError;
        Logger.error(TAG,
          `Register avoidAreaChange or windowSizeChange failed. code: ${error.code}, message: ${error.message}`);
      }
    })
  }

  // Get status bar height and indicator height.
  private static setAvoidArea(type: window.AvoidAreaType, area: window.AvoidArea, preKey: string) {
    const context: UIContext | undefined = AppStorage.get<UIContext>(CommonConstants.KEY_MAIN_UI_CONTEXT);
    if (type === window.AvoidAreaType.TYPE_SYSTEM) {
      AppStorage.setOrCreate(`${preKey}StatusBarHeight`, context?.px2vp(area.topRect.height));
    } else if (type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
      AppStorage.setOrCreate(`${preKey}NavIndicatorHeight`, context?.px2vp(area.bottomRect.height));
    }
  }

  public static setWindowDecor(windowStage: window.WindowStage, visible: boolean, height?: number) {
    // Hide 2in1 title bar.
    windowStage.getMainWindow().then((data: window.Window) => {
      // Hide 2in1 title bar.
      try {
        if (canIUse('SystemCapability.Window.SessionManager')) {
          data.setWindowDecorVisible(visible);
          if (height) {
            data.setWindowDecorHeight(height);
          }
        }
      } catch (exception) {
        Logger.error(TAG, `Failed to set the window decor. Cause: ${exception.code}`);
      }
    }).catch((err: BusinessError) => {
      Logger.error(TAG, `Get main window failed. Cause: ${err.message}`);
    });
  }

  public static setWindowLimit(windowStage: window.WindowStage, windowLimits: window.WindowLimits) {
    // Hide 2in1 title bar.
    windowStage.getMainWindow().then((data: window.Window) => {
      try {
        // Set mini window.
        if (canIUse('SystemCapability.Window.SessionManager')) {
          let promise = data.setWindowLimits(windowLimits);
          promise.then(() => {
            Logger.error(TAG, 'Succeeded in changing the window limits.');
          }).catch((err: BusinessError) => {
            Logger.error(TAG, `Failed to change the window limits. Cause: ${err.code}`);
          })
        }
      } catch (exception) {
        Logger.error(TAG, `Failed to change the window limits. Cause: ${exception.code}`);
      }
    }).catch((err: BusinessError) => {
      Logger.error(TAG, `Get main window failed. Cause: ${err.message}`);
    });
  }

  private static updateWindowSize(preKey: string, windowWidth: number, windowHeight: number): void {
    try {
      AppStorage.setOrCreate(`${preKey}WindowHeight`, windowHeight / display.getDefaultDisplaySync().densityPixels);
      AppStorage.setOrCreate(`${preKey}WindowWidth`, windowWidth / display.getDefaultDisplaySync().densityPixels);
    } catch (error) {
      Logger.error(TAG, `display catch err: ${error.code}`);
    }
  }
}