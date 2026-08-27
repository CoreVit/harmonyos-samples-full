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

import { common } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import type { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '../../../../../Index';
import { KeyConstants } from '../constants/KeyConstants';
import { BreakpointSystem } from './BreakpointSystem';

const TAG: string = '[WindowUtil]';

export class WindowUtil {
  private static windowClass: window.Window;

  public static initialize(context: common.UIAbilityContext, windowStage: window.WindowStage) {
    try {
      WindowUtil.windowClass = windowStage.getMainWindowSync();
      AppStorage.setOrCreate<common.UIAbilityContext>(KeyConstants.KEY_ABILITY_CONTEXT, context);
      const uiContext: UIContext = WindowUtil.windowClass.getUIContext();
      AppStorage.setOrCreate<UIContext>(KeyConstants.KEY_UI_CONTEXT, uiContext);
      WindowUtil.requestFullScreen(WindowUtil.windowClass);
      WindowUtil.registerBreakPoint(WindowUtil.windowClass);
    } catch (err) {
      const error = err as BusinessError;
      Logger.error(TAG, `Initialize failed. Cause code: ${error.code}, message: ${error.message}`);
    }
  }

  public static requestFullScreen(windowClass: window.Window): void {
    try {
      windowClass.setWindowLayoutFullScreen(true)
        .then(() => {
          Logger.info(TAG, 'Succeeded in setting the window layout to full-screen mode.');
        })
        .catch((err: BusinessError) => {
          Logger.error(TAG, `Failed to set the window layout to full-screen mode. Cause: ${err.code}, ${err.message}`);
        });
      AppStorage.setOrCreate<window.Window>(KeyConstants.KEY_WINDOW, windowClass);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Failed to set the window layout to full-screen mode. Cause: ${err.code}, ${err.message} `);
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
      data.on('windowSizeChange', () => BreakpointSystem.getInstance().onWindowSizeChange(data));
      data.on('avoidAreaChange', (avoidAreaOption) => {
        WindowUtil.setAvoidArea(data, avoidAreaOption.type, avoidAreaOption.area);
      });
    } catch (e) {
      const error = e as BusinessError;
      Logger.error(TAG,
        `Register avoidAreaChange or windowSizeChange failed. code: ${error.code}, message: ${error.message}`);
    }
  }

  public static unRegisterBreakPoint() {
    try {
      WindowUtil.windowClass?.off('windowSizeChange');
      WindowUtil.windowClass?.off('avoidAreaChange');
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `windowClass off failed. code: ${err.code}, message: ${err.message}`);
    }
  }

  // Get status bar height and indicator height.
  public static setAvoidArea(data: window.Window, type: window.AvoidAreaType, area: window.AvoidArea) {
    try {
      const context: UIContext = data.getUIContext();
      if (type === window.AvoidAreaType.TYPE_SYSTEM) {
        AppStorage.setOrCreate(KeyConstants.KEY_STATUS_BAR_HEIGHT, context.px2vp(area.topRect.height));
      } else if (type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
        AppStorage.setOrCreate(KeyConstants.KEY_NAV_INDICATOR_HEIGHT, context.px2vp(area.bottomRect.height));
      }
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `getUIContext failed. code: ${err.code}, message: ${err.message}`);
    }
  }
}