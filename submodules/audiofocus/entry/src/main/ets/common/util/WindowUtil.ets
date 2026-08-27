/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import Logger from './Logger';
import { CommonConstants } from '../constants/CommonConstants';

const TAG: string = '[WindowUtil]';
const uiContext: UIContext | undefined = AppStorage.get(CommonConstants.KEY_UI_CONTEXT);

export class WindowUtil {
  private static instance: WindowUtil;
  private windowStage?: window.WindowStage;
  private mainWindowClass?: window.Window;

  public static getInstance() {
    if (!WindowUtil.instance) {
      WindowUtil.instance = new WindowUtil();
    }
    return WindowUtil.instance;
  }

  public setWindowStage(windowStage: window.WindowStage): void {
    this.windowStage = windowStage;
    this.windowStage.getMainWindow((err: BusinessError, windowClass: window.Window) => {
      if (err.code) {
        Logger.error(TAG, `Failed to obtain the main window. Code:${err.code}, message:${err.message}`);
        return;
      }
      this.mainWindowClass = windowClass;
      try {
        const properties = windowClass.getWindowProperties();
        let area: window.AvoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
        let naviBarArea: window.AvoidArea =
          windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
        AppStorage.setOrCreate(CommonConstants.KEY_DEVICE_WIDTH, properties.windowRect.width);
        AppStorage.setOrCreate(CommonConstants.KEY_DEVICE_HEIGHT, properties.windowRect.height);
        AppStorage.setOrCreate(CommonConstants.KEY_STATUS_BAR_HEIGHT, uiContext?.px2vp(area.topRect.height));
        AppStorage.setOrCreate(CommonConstants.KEY_NAV_BAR_HEIGHT, uiContext?.px2vp(naviBarArea.bottomRect.height));
      } catch (error) {
        Logger.error(TAG, `Failed to obtain the main window. Code:${err.code}, message:${err.message}`);
      }
    });
  }

  setMainWindowOrientation(orientation: window.Orientation, callback?: Function): void {
    if (this.mainWindowClass === undefined) {
      Logger.error(TAG, 'MainWindowClass is undefined');
      return;
    }
    this.mainWindowClass.setPreferredOrientation(orientation).then(() => {
      callback?.();
    }).catch((err: BusinessError) => {
      Logger.error(TAG,
        `Failed to set the ${orientation} of main window. Code:${err.code}, message:${err.message}`);
    });
  }

  disableWindowSystemBar(): void {
    if (this.mainWindowClass === undefined) {
      Logger.error(TAG, 'MainWindowClass is undefined');
      return;
    }
    this.mainWindowClass.setWindowSystemBarEnable([]).catch(() => {
      Logger.error(TAG, 'setWindowSystemBarEnable fail')
    });
  }

  enableWindowSystemBar(): void {
    if (this.mainWindowClass === undefined) {
      Logger.error(TAG, 'MainWindowClass is undefined');
      return;
    }
    this.mainWindowClass.setWindowSystemBarEnable(['status', 'navigation']).catch(() => {
      Logger.error(TAG, 'setWindowSystemBarEnable fail')
    });
  }

  setLandscapeMultiWindow(enable: boolean) {
    if (this.mainWindowClass === undefined) {
      Logger.error(TAG, 'MainWindowClass is undefined');
      return;
    }
    if (enable) {
      this.mainWindowClass?.enableLandscapeMultiWindow().catch(() => {
        Logger.error(TAG,'enableLandscapeMultiWindow fail')
      });
    } else {
      this.mainWindowClass?.disableLandscapeMultiWindow().catch(() => {
        Logger.error(TAG,'disableLandscapeMultiWindow fail')
      });
    }
  }

  registerOnWindowSizeChange(callback?: (size: window.Size) => void) {
    if (this.mainWindowClass === undefined) {
      Logger.error(TAG, 'MainWindowClass is undefined');
      return;
    }
    this.mainWindowClass.on('windowSizeChange', (size) => {
      AppStorage.setOrCreate(CommonConstants.KEY_DEVICE_HEIGHT, size.height);
      callback?.(size);
    });
  }

  registerOffWindowSizeChange() {
    if (this.mainWindowClass === undefined) {
      Logger.error(TAG, 'MainWindowClass is undefined');
      return;
    }
    this.mainWindowClass.off('windowSizeChange');
  }

  //full screen mode back to normal mode
  public handleFullScreenExit(isLandscape: boolean) {
    if (!isLandscape) {
      this.enableWindowSystemBar();
      this.setLandscapeMultiWindow(false);
      this.setMainWindowOrientation(window.Orientation.USER_ROTATION_PORTRAIT);
    }
  }

  public handleFullScreen(isLandscape: boolean) {
    if (isLandscape) {
      this.disableWindowSystemBar();
      this.setLandscapeMultiWindow(true);
      this.setMainWindowOrientation(window.Orientation.USER_ROTATION_LANDSCAPE);
    }
  }
}