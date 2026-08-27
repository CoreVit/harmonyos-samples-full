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
import { BreakpointSystem } from './BreakpointSystem';
import { CommonConstants } from '../constants/CommonConstants';
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
      Logger.error(TAG, `WindowUtil initialize Failed. Cause: ${err.message}`);
    }
  }

  public static requestFullScreen(): void {
    try {
      AppStorage.setOrCreate<UIContext>(CommonConstants.KEY_PREFIX + 'UiContext', WindowUtil.windowClass.getUIContext());
      // Realize the immersive effect.
      const promise: Promise<void> = WindowUtil.windowClass.setWindowLayoutFullScreen(true);
      promise.then(() => {
        Logger.info(TAG, 'Succeeded in setting the window layout to full-screen mode.');
      }).catch((err: BusinessError) => {
        Logger.error(TAG, `Failed to set the window layout to full-screen mode. Cause: ${err.code}, ${err.message}`);
      });
    } catch {
      Logger.error(TAG, 'Failed to set the window layout to full-screen mode. ');
    }
  }

  public static registerBreakPoint() {
    try {
      BreakpointSystem.getInstance().updateWidthBp(WindowUtil.windowClass);
      const systemAvoidArea: window.AvoidArea =
        WindowUtil.windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      AppStorage.setOrCreate(CommonConstants.KEY_PREFIX + 'StatusBarHeight',
        WindowUtil.windowClass.getUIContext().px2vp(systemAvoidArea.topRect.height));
      const bottomArea: window.AvoidArea =
        WindowUtil.windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      AppStorage.setOrCreate(CommonConstants.KEY_PREFIX + 'NaviIndicatorHeight',
        WindowUtil.windowClass.getUIContext().px2vp(bottomArea.bottomRect.height));
      WindowUtil.windowClass.on('windowSizeChange',
        () => BreakpointSystem.getInstance().onWindowSizeChange(WindowUtil.windowClass));
      WindowUtil.windowClass.on('avoidAreaChange', (avoidAreaOption) => {
        WindowUtil.setAvoidArea(avoidAreaOption.type, avoidAreaOption.area);
      });
    } catch (e) {
      const error = e as BusinessError;
      Logger.error(TAG,
        `Get windowAvoidArea or Register windowSizeChange failed. code: ${error.code}, message: ${error.message}`);
    }
  }

  // Get status bar height and indicator height.
  public static setAvoidArea(type: window.AvoidAreaType, area: window.AvoidArea) {
    const uiContext: UIContext = AppStorage.get<UIContext>(CommonConstants.KEY_PREFIX + 'UiContext')!;
    if (type === window.AvoidAreaType.TYPE_SYSTEM) {
      AppStorage.setOrCreate(CommonConstants.KEY_PREFIX + 'StatusBarHeight', uiContext.px2vp(area.topRect.height));
    } else {
      AppStorage.setOrCreate(CommonConstants.KEY_PREFIX + 'NaviIndicatorHeight',
        uiContext.px2vp(area.bottomRect.height));
    }
  }

  public static unregisterBreakPoint() {
    try {
      WindowUtil.windowClass.off('windowSizeChange');
      WindowUtil.windowClass.off('avoidAreaChange');
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG,
        `unRegister avoidAreaChange or windowSizeChange failed, code: ${err.code} ${err.message}}`);
    }
  }
}