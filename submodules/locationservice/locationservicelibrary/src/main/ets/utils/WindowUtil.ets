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
  private static windowClass?: window.Window;

  public static initialize(windowStage: window.WindowStage) {
    try {
      WindowUtil.windowClass = windowStage.getMainWindowSync();
      WindowUtil.registerBreakPoint(WindowUtil.windowClass);
      WindowUtil.requestFullScreen();
    } catch (err) {
      Logger.error(TAG, `WindowUtil initialize failed. Cause: ${err.code} ${err.message}`);
    }
  }

  private static requestFullScreen(): void {
    try {
      const promise: Promise<void> | undefined = WindowUtil.windowClass?.setWindowLayoutFullScreen(true);
      promise?.then(() => {
        Logger.info(TAG, 'Succeeded in setting the window layout to full-screen mode.');
      }).catch((err: BusinessError) => {
        Logger.error(TAG, `Failed to set the window layout to full-screen mode. Cause: ${err.code}, ${err.message}`);
      });
    } catch {
      Logger.error(TAG, 'Failed to set the window layout to full-screen mode. ');
    }
  }

  private static registerBreakPoint(windowClass: window.Window) {
    windowClass.on('windowSizeChange', () => BreakpointSystem.getInstance().onWindowSizeChange(windowClass));
    windowClass.on('avoidAreaChange', (avoidAreaOption) => {
      WindowUtil.setAvoidArea(avoidAreaOption.type, avoidAreaOption.area);
    });
  }

  private static setAvoidArea(type: window.AvoidAreaType, area: window.AvoidArea) {
    try {
      if (type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
        AppStorage.setOrCreate(CommonConstants.KEY_PREFIX + 'navIndicatorHeight',
          WindowUtil.windowClass?.getUIContext().px2vp(area.bottomRect.height));
      }
    } catch (err) {
      Logger.error(TAG, `setAvoidArea error. Cause: ${err.code}, ${err.message}`);
    }
  }
}