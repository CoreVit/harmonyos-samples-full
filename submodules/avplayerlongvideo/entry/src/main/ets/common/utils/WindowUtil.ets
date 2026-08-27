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
import { deviceInfo } from '@kit.BasicServicesKit';
import { KeyConstants } from '../constants/KeyConstants';
import Logger from './Logger';

const TAG: string = '[WindowUtil]';

export class WindowUtil {
  private uiContext: UIContext | undefined = AppStorage.get(KeyConstants.KEY_UI_CONTEXT);
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
      this.uiContext = AppStorage.get(KeyConstants.KEY_UI_CONTEXT);
      try {
        // First time get window size.
        const properties = this.mainWindowClass.getWindowProperties();
        AppStorage.setOrCreate(KeyConstants.KEY_DEVICE_WIDTH, properties.windowRect.width);
        AppStorage.setOrCreate(KeyConstants.KEY_DEVICE_HEIGHT, properties.windowRect.height);
        // First time get avoid area infos.
        let area: window.AvoidArea = this.mainWindowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
        let naviBarArea: window.AvoidArea =
          windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
        AppStorage.setOrCreate(KeyConstants.KEY_STATUS_BAR_HEIGHT, this.uiContext?.px2vp(area.topRect.height));
        AppStorage.setOrCreate(KeyConstants.KEY_NAV_BAR_HEIGHT, this.uiContext?.px2vp(naviBarArea.bottomRect.height));
        // First time get width/height breakpoint.
        AppStorage.setOrCreate(KeyConstants.KEY_WIDTH_BREAKPOINT, this.uiContext?.getWindowWidthBreakpoint());
        AppStorage.setOrCreate(KeyConstants.KEY_HEIGHT_BREAKPOINT, this.uiContext?.getWindowHeightBreakpoint());
        AppStorage.setOrCreate(KeyConstants.KEY_TITLE_BTN_HEIGHT, this.getDecorHeight());
        this.mainWindowClass.on('avoidAreaChange', this.onAvoidAreaChange);
        this.mainWindowClass.on('windowTitleButtonRectChange', this.onWindowButtonRectChange);
      } catch (exception) {
        Logger.error(TAG, `Get windowClass data failed, code is ${exception.code}, message is ${exception.message}`);
      }
    });
  }

  // [Start SetMainWindowOrientation]
  setMainWindowOrientation(orientation: window.Orientation, callback?: Function): void {
    if (this.mainWindowClass === undefined) {
      Logger.error(TAG, 'MainWindowClass is undefined');
      return;
    }
    this.mainWindowClass.setPreferredOrientation(orientation).then(() => {
      callback?.();
    }).catch((err: BusinessError) => {
      Logger.error(TAG, `Failed to set the ${orientation} of main window. Code:${err.code}, message:${err.message}`);
    });
  }

  // [End SetMainWindowOrientation]

  disableWindowSystemBar(): void {
    if (this.mainWindowClass === undefined) {
      Logger.error(TAG, 'MainWindowClass is undefined');
      return;
    }
    this.mainWindowClass.setWindowSystemBarEnable([]).catch((err: BusinessError) => {
      Logger.error(TAG, `setWindowSystemBarEnable Failed. Code:${err.code}, message:${err.message}`);
    });
  }

  enableWindowSystemBar(): void {
    if (this.mainWindowClass === undefined) {
      Logger.error(TAG, 'MainWindowClass is undefined');
      return;
    }
    this.mainWindowClass.setWindowSystemBarEnable(['status', 'navigation']).catch((err: BusinessError) => {
      Logger.error(TAG, `setWindowSystemBarEnable Failed. Code:${err.code}, message:${err.message}`);
    });
  }

  setLandscapeMultiWindow(enable: boolean) {
    if (this.mainWindowClass === undefined) {
      Logger.error(TAG, 'MainWindowClass is undefined');
      return;
    }
    if (enable) {
      this.mainWindowClass?.enableLandscapeMultiWindow().catch((err: BusinessError) => {
        Logger.error(TAG, `enableLandscapeMultiWindow Failed. Code:${err.code}, message:${err.message}`);
      });
    } else {
      this.mainWindowClass?.disableLandscapeMultiWindow().catch((err: BusinessError) => {
        Logger.error(TAG, `disableLandscapeMultiWindow Failed. Code:${err.code}, message:${err.message}`);
      });
    }
  }

  registerOnWindowSizeChange(callback?: (size: window.Size) => void) {
    if (this.mainWindowClass === undefined) {
      Logger.error(TAG, 'MainWindowClass is undefined');
      return;
    }
    this.mainWindowClass.on('windowSizeChange', (size) => {
      AppStorage.setOrCreate(KeyConstants.KEY_DEVICE_WIDTH, size.width);
      AppStorage.setOrCreate(KeyConstants.KEY_DEVICE_HEIGHT, size.height);
      AppStorage.setOrCreate(KeyConstants.KEY_WIDTH_BREAKPOINT, this.uiContext?.getWindowWidthBreakpoint());
      AppStorage.setOrCreate(KeyConstants.KEY_HEIGHT_BREAKPOINT, this.uiContext?.getWindowHeightBreakpoint());
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

  private onAvoidAreaChange: (avoidOptions: window.AvoidAreaOptions) => void =
    (avoidOptions: window.AvoidAreaOptions) => {
      if (avoidOptions.type === window.AvoidAreaType.TYPE_SYSTEM) {
        AppStorage.setOrCreate(KeyConstants.KEY_STATUS_BAR_HEIGHT,
          this.uiContext?.px2vp(avoidOptions.area.topRect.height));
      } else if (avoidOptions.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
        AppStorage.setOrCreate(KeyConstants.KEY_NAV_BAR_HEIGHT,
          this.uiContext?.px2vp(avoidOptions.area.bottomRect.height));
      } else {
        return;
      }
    };

  setDecorVisible(visible: boolean) {
    if (this.mainWindowClass === undefined) {
      Logger.error(TAG, 'MainWindowClass is undefined');
      return;
    }
    try {
      this.mainWindowClass.setWindowDecorVisible(visible);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to set WindowDecorVisible, errCode = ${err.code}, errMessage = ${err.message}.`);
    }
  }

  setDecorHeight(height: number) {
    if (this.mainWindowClass === undefined) {
      Logger.error(TAG, 'MainWindowClass is undefined');
      return;
    }
    try {
      this.mainWindowClass.setWindowDecorHeight(height);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to set WindowDecorHeight, errCode = ${err.code}, errMessage = ${err.message}.`);
    }
  }

  getDecorHeight(): number {
    if (this.mainWindowClass === undefined) {
      Logger.error(TAG, 'MainWindowClass is undefined');
      return 0;
    }
    let decorHeight: number = 0;
    try {
      decorHeight = this.mainWindowClass.getTitleButtonRect().height;
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to get decorHeight, errCode = ${err.code}, errMessage = ${err.message}.`);
    }
    return decorHeight;
  }

  public onWindowButtonRectChange: (titleButtonRect: window.TitleButtonRect) => void =
    (titleButtonRect: window.TitleButtonRect) => {
      // Update the rectangle information of the title bar button.
      AppStorage.setOrCreate(KeyConstants.KEY_TITLE_BTN_HEIGHT, titleButtonRect.height);
    };

  release(): void {
    if (this.mainWindowClass === undefined) {
      Logger.error(TAG, 'MainWindowClass is undefined');
      return;
    }
    try {
      this.mainWindowClass.off('avoidAreaChange', this.onAvoidAreaChange);
      this.mainWindowClass.off('windowTitleButtonRectChange', this.onWindowButtonRectChange);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to off. errCode = ${err.code}, errMessage = ${err.message}.`);
    }
  }

  isPhoneDevice(): boolean {
    let deviceType: string = deviceInfo.deviceType;
    return deviceType === deviceInfo.DeviceTypes.TYPE_PHONE;
  }

  isPCDevice(): boolean {
    let deviceType: string = deviceInfo.deviceType;
    return deviceType === deviceInfo.DeviceTypes.TYPE_2IN1;
  }
}