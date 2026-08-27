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
import { CommonConstants } from '../constants/CommonConstants';
import { BreakpointSystem } from './BreakpointSystem';
import Logger from './Logger';

const TAG: string = '[WindowUtil]';

export class WindowUtil {
  private static windowClass: window.Window;
  private static windowSizeChangeCB: () => void = () => {
    BreakpointSystem.getInstance().onWindowSizeChange(WindowUtil.windowClass);
  };
  private static avoidAreaChangeCB: (avoidAreaOption: window.AvoidAreaOptions) => void = (avoidAreaOption) => {
    if (avoidAreaOption.type === window.AvoidAreaType.TYPE_SYSTEM ||
      avoidAreaOption.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
      WindowUtil.setAvoidArea(avoidAreaOption.type, avoidAreaOption.area);
    }
  };

  public static requestFullScreen(windowStage: window.WindowStage): void {
    try {
      WindowUtil.windowClass = windowStage.getMainWindowSync();
      const uiContext: UIContext = WindowUtil.windowClass.getUIContext();
      AppStorage.setOrCreate<UIContext>(CommonConstants.LIFE_PREFIX + 'uiContext', uiContext);
      // Realize the immersive effect.
      WindowUtil.windowClass.setWindowLayoutFullScreen(true).then(() => {
        Logger.info(TAG, 'Succeeded in setting the window layout to full-screen mode.');
      }).catch((err: BusinessError) => {
        Logger.info(TAG, `Failed to set the window layout to full-screen mode. Cause: ${err.code}, ${err.message}`);
      });
    } catch (err) {
      Logger.error(TAG, `requestFullScreen failed. code: ${err.code ?? ''}, message: ${err.message ?? ''}`);
    }
  }

  public static registerBreakPoint(windowStage: window.WindowStage) {
    try {
      WindowUtil.windowClass = windowStage.getMainWindowSync();
      BreakpointSystem.getInstance().updateWidthBp(WindowUtil.windowClass);
      const uiContext: UIContext | undefined = AppStorage.get<UIContext>(CommonConstants.LIFE_PREFIX + 'uiContext');
      if (!uiContext) {
        Logger.error(TAG, '%{public}s', 'can not get ui context');
      } else {
        const systemAvoidArea: window.AvoidArea =
          WindowUtil.windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
        AppStorage.setOrCreate(CommonConstants.LIFE_PREFIX + 'statusBarHeight',
          uiContext.px2vp(systemAvoidArea.topRect.height));
        const bottomArea: window.AvoidArea =
          WindowUtil.windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
        AppStorage.setOrCreate(CommonConstants.LIFE_PREFIX + 'naviIndicatorHeight',
          uiContext.px2vp(bottomArea.bottomRect.height));
      }
      WindowUtil.windowClass.on('windowSizeChange', WindowUtil.windowSizeChangeCB);
      WindowUtil.windowClass.on('avoidAreaChange', WindowUtil.avoidAreaChangeCB);
    } catch (err) {
      Logger.error(TAG, `registerBreakPoint failed. code: ${err.code ?? ''}, message: ${err.message ?? ''}`);
    }
  }

  public static unregisterBreakPoint() {
    try {
      WindowUtil.windowClass.off('windowSizeChange', WindowUtil.windowSizeChangeCB);
      WindowUtil.windowClass.off('avoidAreaChange', WindowUtil.avoidAreaChangeCB);
    } catch (err) {
      Logger.error(TAG,
        `unRegister avoidAreaChange or windowSizeChange failed. code: ${err.code ?? ''}, message: ${err.message ??
          ''}`);
    }
  }

  // Get status bar height and indicator height.
  public static setAvoidArea(type: window.AvoidAreaType, area: window.AvoidArea) {
    const uiContext: UIContext | undefined = AppStorage.get<UIContext>(CommonConstants.LIFE_PREFIX + 'uiContext');
    if (!uiContext) {
      Logger.error(TAG, '%{public}s', 'can not get ui context');
      return;
    }
    if (type === window.AvoidAreaType.TYPE_SYSTEM) {
      AppStorage.setOrCreate(CommonConstants.LIFE_PREFIX + 'statusBarHeight', uiContext.px2vp(area.topRect.height));
    } else {
      AppStorage.setOrCreate(CommonConstants.LIFE_PREFIX + 'naviIndicatorHeight',
        uiContext.px2vp(area.bottomRect.height));
    }
  }
}