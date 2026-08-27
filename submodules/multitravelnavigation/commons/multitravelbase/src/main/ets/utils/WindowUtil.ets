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

// [Start WindowUtil]
import { display, UIContext, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { StartOptions, AbilityConstant, Want, common } from '@kit.AbilityKit';
import { resourceManager } from '@kit.LocalizationKit';
import { sensor } from '@kit.SensorServiceKit';
import Logger from './Logger';

const TAG = 'WindowUtil';

export enum ImmersiveType {
  NORMAL,
  IMMERSIVE,
  FULLSCREEN_IMMERSIVE
}

const PC_DECOR_HEIGHT: number = 56;
const PC_DECOR_BUTTON_BACKGROUND_SIZE: number = 40;
const PC_DECOR_BUTTON_SPACING: number = 4;
const PC_DECOR_BUTTON_RIGHT_MARGIN: number = 8;
const PC_DECOR_BUTTON_ICON_SIZE: number = 16;
const PC_DECOR_BUTTON_CORNER_RADIUS: number = 12;

export class WindowUtil {
  public uiContext?: UIContext;
  public mainWindow: window.Window;
  public mainWindowInfo: WindowInfo = new WindowInfo();
  // [Start windowStatusChange]
  public onStatusTypeChange: (statusType: window.WindowStatusType) => void = (statusType: window.WindowStatusType) => {
    this.mainWindowInfo.windowStatusType = statusType;
  }
  // [StartExclude windowStatusChange]
  // [Start WindowSizeChange]
  public onWindowSizeChange: (windowSize: window.Size) => void = (windowSize: window.Size) => {
    this.mainWindowInfo.windowSize = windowSize;
    this.mainWindowInfo.widthBp = this.uiContext!.getWindowWidthBreakpoint();
    this.mainWindowInfo.heightBp = this.uiContext!.getWindowHeightBreakpoint();
    this.updateTitleButtonRect();
  };
  // [StartExclude WindowSizeChange]
  public onTitleButtonRectChange: (rect: window.TitleButtonRect) => void = (rect: window.TitleButtonRect) => {
    this.mainWindowInfo.titleButtonRect = rect;
  };
  // [Start onAvoidAreaChange]
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
  // [StartExclude onAvoidAreaChange]

  public constructor(mainWindow: window.Window) {
    this.mainWindow = mainWindow;
  }

  public setImmersiveType(type: ImmersiveType) {
    try {
      if (type === ImmersiveType.NORMAL) {
        this.mainWindow.setWindowLayoutFullScreen(false)
          .then(() => {
            Logger.info(TAG, `Succeeded in setting immersive mode.`);
          })
          .catch((err: BusinessError) => {
            Logger.error(TAG, `Failed to set immersive mode. Code: ${err.code}, message: ${err.message}`);
          });
        this.setSystemBarEnabled(true);
        // Only used after the function loadContent() or setUIContent().
        this.mainWindow.setWindowDecorVisible(true);
        this.recover();
      } else if (type === ImmersiveType.IMMERSIVE) {
        this.mainWindow.setWindowLayoutFullScreen(true)
          .then(() => {
            Logger.info(TAG, `Succeeded in setting immersive mode.`);
          })
          .catch((err: BusinessError) => {
            Logger.error(TAG, `Failed to set immersive mode. Code: ${err.code}, message: ${err.message}`);
          });
        this.setSystemBarEnabled(true);
        this.mainWindow.setWindowDecorVisible(false);
        this.recover();
      } else if (type === ImmersiveType.FULLSCREEN_IMMERSIVE) {
        this.mainWindow.setWindowLayoutFullScreen(true)
          .then(() => {
            Logger.info(TAG, `Succeeded in setting immersive mode.`);
          })
          .catch((err: BusinessError) => {
            Logger.error(TAG, `Failed to set immersive mode. Code: ${err.code}, message: ${err.message}`);
          });
        if (this.mainWindow.getWindowStatus() === window.WindowStatusType.MAXIMIZE ||
          (this.mainWindow.getWindowStatus() === window.WindowStatusType.FLOATING &&
            this.mainWindow.getWindowDecorHeight() !== 0)) {
          this.mainWindow.maximize()
            .then(() => {
              Logger.info(TAG, `Succeeded in maximizing the window.`);
            })
            .catch((err: BusinessError) => {
              Logger.error(TAG, `Failed to maximize the window. Code: ${err.code}, message: ${err.message}`);
            });
        }
        this.setSystemBarEnabled(false);
        // [Start setWindowDecorVisible]
        this.mainWindow.setWindowDecorVisible(false);
        // [End setWindowDecorVisible]
      }
      this.mainWindowInfo.isImmersive = type;
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to set immersive type. Code: ${err.code}, message: ${err.message}`);
    }
  }

  public setUiContext() {
    try {
      this.uiContext = this.mainWindow.getUIContext();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to set UI context. Code: ${err.code}, message: ${err.message}`);
    }
  }

  public setSystemBarEnabled(isVisible: boolean): void {
    this.mainWindow.setSpecificSystemBarEnabled('status', isVisible)
      .then(() => {
        Logger.info(TAG, `Succeeded in setting status bar to be invisible.`);
      })
      .catch((err: BusinessError) => {
        Logger.error(TAG, `Failed to set status bar to be invisible. Code: ${err.code}, message: ${err.message}`);
      });
    this.mainWindow.setSpecificSystemBarEnabled('navigationIndicator', isVisible)
      .then(() => {
        Logger.info(TAG, `Succeeded in setting navigation indicator to be invisible.`);
      })
      .catch((err: BusinessError) => {
        Logger.error(TAG,
          `Failed to set navigation indicator to be invisible. Code: ${err.code}, message: ${err.message}`);
      });
  }

  public setPcDecorButtonStyle(): void {
    try {
      this.mainWindow.setWindowDecorHeight(PC_DECOR_HEIGHT);
      this.mainWindow.setDecorButtonStyle({
        buttonBackgroundSize: PC_DECOR_BUTTON_BACKGROUND_SIZE,
        spacingBetweenButtons: PC_DECOR_BUTTON_SPACING,
        closeButtonRightMargin: PC_DECOR_BUTTON_RIGHT_MARGIN,
        buttonIconSize: PC_DECOR_BUTTON_ICON_SIZE,
        buttonBackgroundCornerRadius: PC_DECOR_BUTTON_CORNER_RADIUS
      });
      this.updateTitleButtonRect();
    } catch (error) {
      let err = error as BusinessError;
      Logger.warn(TAG, `Failed to set PC decor button style. Code: ${err.code}, message: ${err.message}`);
    }
  }

  public recover(): void {
    try {
      if (this.mainWindow.getWindowStatus() === window.WindowStatusType.FULL_SCREEN) {
        this.mainWindow.recover()
          .then(() => {
            Logger.info(TAG, `Succeeded in revocering the window.`);
          })
          .catch((err: BusinessError) => {
            Logger.error(TAG, `Failed to revocer the window. Code: ${err.code}, message: ${err.message}`);
          });
      }
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to recover. Code: ${err.code}, message: ${err.message}`);
    }
  }

  // [Start setPreferredOrientation]
  public setWindowOrientation(orientation: window.Orientation): void {
    this.mainWindow.setPreferredOrientation(orientation)
      .then(() => {
        Logger.info(TAG, `Succeeded in setting window orientation.`);
        // Update window orientation.
        this.mainWindowInfo.orientation = orientation;
      })
      .catch((err: BusinessError) => {
        Logger.error(TAG, `Failed to set window orientation. Code: ${err.code}, message: ${err.message}`);
      });
  }
  // [End setPreferredOrientation]

  // [Start getWindowAvoidArea]
  // [Start updateBreakpoint]
  // [EndExclude windowStatusChange]
  // [EndExclude WindowSizeChange]
  // [EndExclude onAvoidAreaChange]
  public updateWindowInfo(): void {
    try {
      // [StartExclude getWindowAvoidArea]
      // [StartExclude onAvoidAreaChange]
      // [StartExclude WindowSizeChange]
      // [StartExclude updateBreakpoint]
      // First time get window status.
      this.mainWindowInfo.windowStatusType = this.mainWindow.getWindowStatus();
      this.mainWindow.on('windowStatusChange', this.onStatusTypeChange);
      // [Start getWindowProperties]
      // [StartExclude windowStatusChange]
      // First time get window size.
      let width: number = this.mainWindow.getWindowProperties().windowRect.width;
      let height: number = this.mainWindow.getWindowProperties().windowRect.height;
      let windowSize: window.Size = {
        width: width,
        height: height
      }
      this.mainWindowInfo.windowSize = windowSize;
      // [End getWindowProperties]
      // [EndExclude updateBreakpoint]
      // First time get width/height breakpoint.
      this.mainWindowInfo.widthBp = this.uiContext!.getWindowWidthBreakpoint();
      this.mainWindowInfo.heightBp = this.uiContext!.getWindowHeightBreakpoint();
      // [StartExclude updateBreakpoint]
      // [EndExclude WindowSizeChange]
      // Register for window size change monitoring, update window size and width/height breakpoint.
      this.mainWindow.on('windowSizeChange', this.onWindowSizeChange);
      // [StartExclude WindowSizeChange]

      // [EndExclude getWindowAvoidArea]
      // First time get avoid area infos.
      this.mainWindowInfo.avoidSystem = this.mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      this.mainWindowInfo.avoidNavigationIndicator =
        this.mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      this.mainWindowInfo.avoidCutout = this.mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_CUTOUT);
      this.mainWindowInfo.avoidSystemGesture =
        this.mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM_GESTURE);
      this.mainWindowInfo.avoidKeyboard = this.mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_KEYBOARD);
      this.updateTitleButtonRect();
      // [StartExclude getWindowAvoidArea]
      // [EndExclude onAvoidAreaChange]
      this.mainWindow.on('avoidAreaChange', this.onAvoidAreaChange);
      this.registerTitleButtonRectChange();
      // [EndExclude windowStatusChange]
      // [EndExclude updateBreakpoint]
      // [EndExclude WindowSizeChange]
      // [EndExclude getWindowAvoidArea]
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to update window info. Code: ${err.code}, message: ${err.message}`);
    }
  }

  private updateTitleButtonRect(): void {
    try {
      this.mainWindowInfo.titleButtonRect = this.mainWindow.getTitleButtonRect();
    } catch (error) {
      this.mainWindowInfo.titleButtonRect = undefined;
      let err = error as BusinessError;
      Logger.warn(TAG, `Failed to get title button rect. Code: ${err.code}, message: ${err.message}`);
    }
  }

  private registerTitleButtonRectChange(): void {
    try {
      this.mainWindow.on('windowTitleButtonRectChange', this.onTitleButtonRectChange);
    } catch (error) {
      let err = error as BusinessError;
      Logger.warn(TAG, `Failed to listen title button rect. Code: ${err.code}, message: ${err.message}`);
    }
  }
  // [End onAvoidAreaChange]
  // [End windowStatusChange]
  // [End updateBreakpoint]
  // [End WindowSizeChange]
  // [End getWindowAvoidArea]

  public release(): void {
    try {
      this.mainWindow.off('windowStatusChange');
      this.mainWindow.off('windowSizeChange');
      this.mainWindow.off('avoidAreaChange');
      this.mainWindow.off('windowTitleButtonRectChange');
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to off. Code: ${err.code}, message: ${err.message}`);
    }

  }

  // [Start setSplitScreen]
  public setSplitScreen(bundleName: string, abilityName: string, moduleName: string): void {
    // [StartExclude setSplitScreen]
    // [Start getContext]
    let context = this.uiContext?.getHostContext() as common.UIAbilityContext;
    // [End getContext]
    // [EndExclude setSplitScreen]
    // Create StartOptions and set them to the main window mode.
    let option: StartOptions = { windowMode: AbilityConstant.WindowMode.WINDOW_MODE_SPLIT_PRIMARY };
    let want: Want = { bundleName: bundleName, abilityName: abilityName, moduleName: moduleName };
    context.startAbility(want, option).catch((err: BusinessError) => {
      Logger.error(TAG, `Failed to start ability. Code: ${err.code}, message: ${err.message}`);
    });
  }
  // [End setSplitScreen]

  // [Start cancelSplitScreen]
  public cancelSplitScreen(): void {
    let context = this.uiContext?.getHostContext() as common.UIAbilityContext;
    context.terminateSelf().catch((err: BusinessError) => {
      Logger.error(TAG, `Failed to terminate self. Code: ${err.code}, message: ${err.message}`);
    });
  }
  // [End cancelSplitScreen]

  // [Start setWindowLimits]
  public setWindowLimits(maxWidth: number, maxHeight: number, minWidth: number, minHeight: number): void {
    let windowLimits: window.WindowLimits = {
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      minWidth: minWidth,
      minHeight: minHeight
    }
    this.mainWindow.setWindowLimits(windowLimits).then((data: window.WindowLimits) => {
      Logger.info(TAG, `Succeeded in changing the window limits. Cause: ${JSON.stringify(data)}`);
    }).catch((err: BusinessError) => {
      Logger.error(TAG, `Failed to change the window limits. Cause code: ${err.code}, message: ${err.message}`);
    });
  }
  // [End setWindowLimits]

  // [Start resize]
  public resize(width: number, height: number): void {
    this.mainWindow.resize(width, height, (err: BusinessError) => {
      const errCode: number = err.code;
      if (errCode) {
        Logger.error(TAG, `Failed to change the window size. Cause code: ${err.code}, message: ${err.message}`);
        return;
      }
      Logger.info(TAG, 'Succeeded in changing the window size.');
    });
  }
  // [End resize]

  public queryOrientationByDisplay(): void {
    // [Start queryOrientationByDisplay]
    try {
      display.getDefaultDisplaySync();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to query display orientation. Code: ${err.code}, message: ${err.message}`);
    }
    // [End queryOrientationByDisplay]
  }

  public queryOrientationByResourceManager(): void {
    // [Start queryByByRM]
    let info: resourceManager.Direction | undefined =
      this.uiContext?.getHostContext()?.resourceManager.getConfigurationSync().direction;
    Logger.info(TAG, `The Orientation is ${info}`);
    // [End queryByByRM]
  }

  // [Start queryDegree]
  public queryDegree(): void {
    try {
      sensor.on(sensor.SensorId.GRAVITY, (data: sensor.GravityResponse) => {
        this.getCalDegree(data.x, data.y, data.z);
      })
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to query degree. Code: ${err.code}, message: ${err.message}`);
    }
  }

  public getCalDegree(x: number, y: number, z: number): number {
    let degree: number = 0;
    // three is Effective Delta Angle Threshold Coefficient.
    if ((x * x + y * y) * 3 < z * z) {
      return degree;
    }
    degree = 90 - (Number)(Math.round(Math.atan2(y, -x) / Math.PI * 180));
    return degree >= 0 ? degree % 360 : degree % 360 + 360;
  }
  // [End queryDegree]
}

// [Start WindowInfo]
@Observed
export class WindowInfo {
  // Window status.
  public windowStatusType: window.WindowStatusType = window.WindowStatusType.UNDEFINED;
  // Is the window an immersive layout.
  public isImmersive: ImmersiveType = ImmersiveType.NORMAL;
  // Window orientation.
  public orientation: window.Orientation = window.Orientation.UNSPECIFIED;
  // Window size.
  public windowSize: window.Size = { width: 0, height: 0 };
  // Width/height breakpoint.
  public widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_XS;
  public heightBp: HeightBreakpoint = HeightBreakpoint.HEIGHT_SM;
  // Avoid area infos.
  public avoidSystem?: window.AvoidArea;
  public avoidNavigationIndicator?: window.AvoidArea;
  public avoidCutout?: window.AvoidArea;
  public avoidSystemGesture?: window.AvoidArea;
  public avoidKeyboard?: window.AvoidArea;
  public titleButtonRect?: window.TitleButtonRect;
}
// [End WindowInfo]
// [End WindowUtil]
