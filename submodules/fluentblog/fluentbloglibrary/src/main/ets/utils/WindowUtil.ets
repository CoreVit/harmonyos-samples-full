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
import type { BusinessError } from '@kit.BasicServicesKit';
import { Constants } from '../common/Constants';
import { BreakpointSystem } from './BreakpointSystem';
import Logger from './Logger';

const TAG: string = '[WindowUtil]';

export class WindowUtil {
  private static windowClass?: window.Window;

  public static initialize(windowStage: window.WindowStage): void {
    try {
      WindowUtil.windowClass = windowStage.getMainWindowSync();
      WindowUtil.registerBreakPoint(WindowUtil.windowClass);
      WindowUtil.requestFullScreen();
    } catch (err) {
      const error = err as BusinessError;
      Logger.error(TAG, `WindowUtil initialize failed. code: ${error.code}, message: ${error.message}`);
    }
  }

  public static registerBreakPoint(windowClass: window.Window): void {
    try {
      BreakpointSystem.getInstance().onWindowSizeChange(windowClass);
      windowClass.on('windowSizeChange', () => BreakpointSystem.getInstance().onWindowSizeChange(windowClass));
      const systemAvoidArea: window.AvoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      WindowUtil.setAvoidArea(window.AvoidAreaType.TYPE_SYSTEM, systemAvoidArea);
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

  // Get status bar height.
  private static setAvoidArea(type: window.AvoidAreaType, area: window.AvoidArea): void {
    try {
      if (type === window.AvoidAreaType.TYPE_SYSTEM) {
        AppStorage.setOrCreate(Constants.KEY_PREFIX + 'StatusBarHeight',
          WindowUtil.windowClass?.getUIContext().px2vp(area.topRect.height));
      }
    } catch (err) {
      const error = err as BusinessError;
      Logger.error(TAG, '%{public}s',
        `Get windowAvoidArea or Register windowSizeChange failed. code: ${error.code} message is ${error.message}`);
    }
  }

  private static requestFullScreen(): void {
    // Realize the immersive effect.
    try {
      const promise: Promise<void> | undefined = WindowUtil.windowClass?.setWindowLayoutFullScreen(true);
      promise?.then(() => {
        Logger.info(TAG, 'Succeeded in setting the window layout to full-screen mode.');
      }).catch((err: BusinessError) => {
        Logger.error(TAG,
          `Failed to set the window layout to full-screen mode. Cause: ${err.code}, ${err.message}`);
      });
    } catch (err) {
      const error = err as BusinessError;
      Logger.error(TAG, `Failed to set the window layout to full-screen mode. Cause: ${error.code}, ${error.message}`);
    }
  }
}