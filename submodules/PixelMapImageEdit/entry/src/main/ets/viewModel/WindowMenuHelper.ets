/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { HdsNavigationMenuItemOptions, IconStyleMode } from '@kit.UIDesignKit';
import Logger from '../utils/Logger';
import { CommonConstants } from '../common/constant/CommonConstants';

interface WindowControlParams {
  context: common.UIAbilityContext;
  onFullScreenChange: () => void;
}

export class WindowMenuHelper {
  private static windowClass: window.Window | null = null;

  static async init(context: common.UIAbilityContext, onReady: () => void): Promise<void> {
    try {
      WindowMenuHelper.windowClass = await window.getLastWindow(context);
      WindowMenuHelper.syncWindowState();
      WindowMenuHelper.windowClass.on('windowSizeChange', () => {
        WindowMenuHelper.syncWindowState();
      });
      onReady();
    } catch (err) {
      Logger.error(`getLastWindow failed: ${JSON.stringify(err)}`);
    }
  }

  static syncWindowState(): void {
    if (!WindowMenuHelper.windowClass) {
      return;
    }
    try {
      const status = WindowMenuHelper.windowClass.getWindowStatus();
      const isFullScreen =
        status === window.WindowStatusType.FULL_SCREEN ||
          status === window.WindowStatusType.MAXIMIZE;
      AppStorage.setOrCreate(CommonConstants.IS_FULLSCREEN, isFullScreen);
    } catch (err) {
      Logger.error(`syncWindowState failed: ${JSON.stringify(err)}`);
    }
  }

  static getIsFullScreen(): boolean {
    return AppStorage.get<boolean>(CommonConstants.IS_FULLSCREEN) ?? false;
  }

  static appendTo(items: HdsNavigationMenuItemOptions[], params: WindowControlParams): void {
    const isFullScreen = WindowMenuHelper.getIsFullScreen();
    items.push({
      content: {
        icon: isFullScreen ? $r('sys.symbol.exit_full_screen') : $r('sys.symbol.full_screen'),
        type: IconStyleMode.SMALL,
        isEnabled: true,
        action: () => {
          if (isFullScreen) {
            WindowMenuHelper.windowClass?.recover()
              .then(() => {
                AppStorage.setOrCreate(CommonConstants.IS_FULLSCREEN, false);
                params.onFullScreenChange();
              })
              .catch((err: BusinessError) => {
                Logger.error(`recover failed: ${JSON.stringify(err)}`);
              });
          } else {
            WindowMenuHelper.windowClass?.maximize(window.MaximizePresentation.EXIT_IMMERSIVE)
              .then(() => {
                AppStorage.setOrCreate(CommonConstants.IS_FULLSCREEN, true);
                params.onFullScreenChange();
              })
              .catch((err: BusinessError) => {
                Logger.error(`maximize failed: ${JSON.stringify(err)}`);
              });
          }
        }
      }
    });

    items.push({
      content: {
        icon: $r('sys.symbol.minus'),
        type: IconStyleMode.SMALL,
        isEnabled: true,
        action: () => {
          WindowMenuHelper.windowClass?.minimize()
            .catch((err: BusinessError) => {
              Logger.error(`minimize failed: ${JSON.stringify(err)}`);
            });
        }
      }
    });

    items.push({
      content: {
        icon: $r('sys.symbol.xmark'),
        type: IconStyleMode.SMALL,
        isEnabled: true,
        action: () => {
          params.context?.terminateSelf()
            .catch((err: BusinessError) => {
              Logger.error(`terminateSelf failed: ${JSON.stringify(err)}`);
            });
        }
      }
    });
  }
}