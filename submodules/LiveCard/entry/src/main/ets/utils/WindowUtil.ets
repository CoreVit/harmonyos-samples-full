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

import { display, UIContext, window } from '@kit.ArkUI';
import type { BusinessError } from '@kit.BasicServicesKit';
import { resourceManager } from '@kit.LocalizationKit';
import { Logger } from './Logger';
import { Constants } from '../common/CommonConstants';

const TAG = '[WindowUtil]';

export enum ImmersiveType {
  NORMAL,
  IMMERSIVE,
  FULLSCREEN_IMMERSIVE
}

@Observed
export class WindowUtil {
  public uiContext?: UIContext;
  public mainWindow: window.Window;
  public mainWindowInfo: WindowInfo = new WindowInfo();
  public onStatusTypeChange: (statusType: window.WindowStatusType) => void =
    (statusType: window.WindowStatusType) => {
      this.mainWindowInfo.windowStatusType = statusType;
    };
  public onWindowSizeChange: (windowSize: window.Size) => void = (windowSize: window.Size) => {
    this.mainWindowInfo.windowSize = windowSize;
    if (this.uiContext) {
      this.mainWindowInfo.widthBp = this.uiContext.getWindowWidthBreakpoint();
      this.mainWindowInfo.heightBp = this.uiContext.getWindowHeightBreakpoint();
    }
    AppStorage.setOrCreate(Constants.KEY_WIDTH_BP, this.mainWindowInfo.widthBp);
    AppStorage.setOrCreate(Constants.KEY_HEIGHT_BP, this.mainWindowInfo.heightBp);
  };
  public onAvoidAreaChange: (avoidOptions: window.AvoidAreaOptions) => void =
    (avoidOptions: window.AvoidAreaOptions) => {
      if (avoidOptions.type === window.AvoidAreaType.TYPE_SYSTEM) {
        this.mainWindowInfo.avoidSystem = avoidOptions.area;
      } else if (avoidOptions.type === window.AvoidAreaType.TYPE_CUTOUT) {
        this.mainWindowInfo.avoidCutout = avoidOptions.area;
      } else if (avoidOptions.type === window.AvoidAreaType.TYPE_SYSTEM_GESTURE) {
        this.mainWindowInfo.avoidSystemGesture = avoidOptions.area;
      } else if (avoidOptions.type === window.AvoidAreaType.TYPE_KEYBOARD) {
        this.mainWindowInfo.avoidKeyboard = avoidOptions.area;
      } else if (avoidOptions.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
        this.mainWindowInfo.avoidNavigationIndicator = avoidOptions.area;
      }
    };

  constructor(mainWindow: window.Window) {
    this.mainWindow = mainWindow;
  }

  setUIContext(): void {
    try {
      this.uiContext = this.mainWindow.getUIContext();
    } catch (err) {
      Logger.error(TAG, `Failed to get UIContext. Code: ${err.code}, message: ${err.message}`);
    }
  }

  setSystemBarEnabled(isVisible: boolean): void {
    this.mainWindow.setSpecificSystemBarEnabled('status', isVisible)
      .then(() => {
        Logger.info(TAG, `Succeeded in setting status bar to be invisible ` +
          `${isVisible ? 'visible' : 'invisible'}.`);
      })
      .catch((err: BusinessError) => {
        Logger.error(TAG, `Failed to set status bar to be invisible. Code: ${err.code}, message: ${err.message}`);
      });
    this.mainWindow.setSpecificSystemBarEnabled('navigationIndicator', isVisible)
      .then(() => {
        Logger.info(TAG, 'Succeeded in setting navigation indicator to be invisible.');
      })
      .catch((err: BusinessError) => {
        Logger.error(TAG, `Failed to set navigation indicator to be invisible. ` +
          `Code: ${err.code}, message: ${err.message}`);
      });
  }

  recover(): void {
    try {
      if (this.mainWindow.getWindowStatus() === window.WindowStatusType.FULL_SCREEN) {
        this.mainWindow.recover()
          .then(() => {
            Logger.info(TAG, 'Succeeded in recovering the window.');
          })
          .catch((err: BusinessError) => {
            Logger.error(TAG, `Failed to recover the window. Code: ${err.code}, message: ${err.message}`);
          });
      }
    } catch (err) {
      Logger.error(TAG, `Failed to get WindowStatus. Code: ${err.code}, message: ${err.message}`);
    }
  }

  setWindowOrientation(orientation: window.Orientation): void {
    this.mainWindow.setPreferredOrientation(orientation)
      .then(() => {
        Logger.info(TAG, 'Succeeded in setting window orientation.');
        this.mainWindowInfo.orientation = orientation;
      })
      .catch((err: BusinessError) => {
        Logger.error(TAG, `Failed to set window orientation. Code: ${err.code}, message: ${err.message}`);
      });
  }

  updateWindowInfo(): void {
    try {
      this.mainWindowInfo.windowStatusType = this.mainWindow.getWindowStatus();
      this.mainWindow.on('windowStatusChange', this.onStatusTypeChange);
      let width: number = this.mainWindow.getWindowProperties().windowRect.width;
      let height: number = this.mainWindow.getWindowProperties().windowRect.height;
      let windowSize: window.Size = {
        width: width,
        height: height
      };
      this.mainWindowInfo.windowSize = windowSize;
      if (this.uiContext) {
        this.mainWindowInfo.widthBp = this.uiContext.getWindowWidthBreakpoint();
        this.mainWindowInfo.heightBp = this.uiContext.getWindowHeightBreakpoint();
      }
      AppStorage.setOrCreate(Constants.KEY_WIDTH_BP, this.mainWindowInfo.widthBp);
      AppStorage.setOrCreate(Constants.KEY_HEIGHT_BP, this.mainWindowInfo.heightBp);
      this.mainWindow.on('windowSizeChange', this.onWindowSizeChange);

      this.mainWindowInfo.avoidSystem = this.mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      this.mainWindowInfo.avoidNavigationIndicator =
        this.mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      this.mainWindowInfo.avoidCutout = this.mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_CUTOUT);
      this.mainWindowInfo.avoidSystemGesture =
        this.mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM_GESTURE);
      this.mainWindowInfo.avoidKeyboard = this.mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_KEYBOARD);
      AppStorage.setOrCreate(Constants.KEY_WINDOW_INFO, this.mainWindowInfo);
      this.mainWindow.on('avoidAreaChange', this.onAvoidAreaChange);
    } catch (err) {
      Logger.error(TAG, `Failed to update WindowInfo. Code: ${err.code}, message: ${err.message}`);
    }
  }

  release(): void {
    try {
      this.mainWindow.off('windowStatusChange');
      this.mainWindow.off('windowSizeChange');
      this.mainWindow.off('avoidAreaChange');
    } catch (err) {
      Logger.error(TAG, `Failed to off mainWindow events. Code: ${err.code}, message: ${err.message}`);
    }
  }

  resize(width: number, height: number): void {
    this.mainWindow.resize(width, height, (err: BusinessError) => {
      const errCode: number = err.code;
      if (errCode) {
        Logger.error(TAG, `Failed to change the window size. Cause code: ${err.code}, message: ${err.message}`);
        return;
      }
      Logger.info(TAG, 'Succeeded in changing the window size.');
    });
  }

  queryOrientationByDisplay(): void {
    try {
      let displayClass: display.Display | null = display.getDefaultDisplaySync();
      Logger.info(TAG, `The Orientation is ${displayClass.orientation}`);
    } catch (err) {
      Logger.error(TAG, `Failed to get DefaultDisplaySync. Code: ${err.code}, message: ${err.message}`);
    }
  }

  queryOrientationByResourceManager(): void {
    let info: resourceManager.Direction | undefined =
      this.uiContext?.getHostContext()?.resourceManager.getConfigurationSync().direction;
    Logger.info(TAG, `The Orientation is ${info}`);
  }
}

@Observed
export class WindowInfo {
  public windowStatusType: window.WindowStatusType = window.WindowStatusType.UNDEFINED;
  public isImmersive: ImmersiveType = ImmersiveType.NORMAL;
  public orientation: window.Orientation = window.Orientation.UNSPECIFIED;
  public windowSize: window.Size = { width: 0, height: 0 };
  public widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_XS;
  public heightBp: HeightBreakpoint = HeightBreakpoint.HEIGHT_SM;
  public avoidSystem?: window.AvoidArea;
  public avoidNavigationIndicator?: window.AvoidArea;
  public avoidCutout?: window.AvoidArea;
  public avoidSystemGesture?: window.AvoidArea;
  public avoidKeyboard?: window.AvoidArea;
}