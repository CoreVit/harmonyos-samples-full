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
import { common, ConfigurationConstant } from '@kit.AbilityKit';
import { CommonConstants } from '../constants/CommonConstants';
import { BreakpointSystem } from './BreakpointSystem';
import Logger from './Logger';

const TAG: string = '[WindowUtil]';

export class WindowUtil {
  private static windowClass?: window.Window;
  private static uiContext: UIContext;

  public static initialize(windowStage: window.WindowStage) {
    try {
      WindowUtil.windowClass = windowStage.getMainWindowSync();
      const uiContext: UIContext = WindowUtil.windowClass.getUIContext();
      WindowUtil.uiContext = uiContext;
      AppStorage.setOrCreate<UIContext>(CommonConstants.KEY_PREFIX_SYSTEM_UICONTEXT, uiContext);
      WindowUtil.registerBreakPoint(windowStage);
      WindowUtil.requestFullScreen(windowStage);
    } catch (err) {
      Logger.error(TAG, `WindowUtil initialize failed. Cause: ${err.code} ${err.message}`);
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
        Logger.error(TAG, 'Failed to set the window layout to full-screen mode.');
      }
    });
  }

  public static registerBreakPoint(windowStage: window.WindowStage) {
    windowStage.getMainWindow((err: BusinessError, data: window.Window) => {
      if (err.code) {
        Logger.error(TAG, `Failed to get main window: ${err.message}`);
        return;
      }
      BreakpointSystem.getInstance().updateBp();
      let avoidArea = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      AppStorage.setOrCreate(CommonConstants.KEY_PREFIX_NAVIGATOR_BAR_HEIGHT,
        WindowUtil.uiContext.px2vp(avoidArea.bottomRect.height));
      avoidArea = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      AppStorage.setOrCreate(CommonConstants.KEY_PREFIX_STATUS_BAR_HEIGHT,
        WindowUtil.uiContext.px2vp(avoidArea.topRect.height));
      data.on('windowSizeChange', () => BreakpointSystem.getInstance().updateBp());
      data.on('avoidAreaChange', (avoidAreaOption) => {
        WindowUtil.setAvoidArea(avoidAreaOption.type, avoidAreaOption.area);
        if (avoidAreaOption.type === window.AvoidAreaType.TYPE_SYSTEM ||
          avoidAreaOption.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          WindowUtil.setAvoidArea(avoidAreaOption.type, avoidAreaOption.area);
        }
      });
    })
  }

  // Get status bar height and indicator height.
  public static setAvoidArea(type: window.AvoidAreaType, area: window.AvoidArea) {
    if (type === window.AvoidAreaType.TYPE_SYSTEM) {
      AppStorage.setOrCreate(CommonConstants.KEY_PREFIX_STATUS_BAR_HEIGHT,
        WindowUtil.uiContext.px2vp(area.topRect.height));
    } else {
      AppStorage.setOrCreate(CommonConstants.KEY_PREFIX_NAVIGATOR_BAR_HEIGHT,
        WindowUtil.uiContext.px2vp(area.bottomRect.height));
    }
  }

  public static updatedColorMode(context: common.UIAbilityContext): void {
    context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
  }
}