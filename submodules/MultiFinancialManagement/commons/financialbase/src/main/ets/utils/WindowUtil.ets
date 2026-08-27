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

import { ConfigurationConstant } from '@kit.AbilityKit';
import { UIContext, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from './Logger';

export class WindowUtil {
  public windowStage?: window.WindowStage;
  public uiContext?: UIContext;
  // Monitor the breakpoints and size changes of the main window.
  public onWindowSizeChange: (windowSize: window.Size) => void = async (windowSize: window.Size) => {
    this.mainWindowInfo.windowSize = windowSize;
    const uiContext = this.uiContext;
    if (!uiContext) {
      return;
    }
    this.mainWindowInfo.widthBp = uiContext.getWindowWidthBreakpoint();
    this.mainWindowInfo.heightBp = uiContext.getWindowHeightBreakpoint();
  };
  public mainWindow: window.Window;
  public mainWindowInfo: WindowInfo = new WindowInfo();

  constructor(mainWindow: window.Window) {
    this.mainWindow = mainWindow;
  }

  // Monitor the change in window status type of the main window.
  public onStatusTypeChange: (statusType: window.WindowStatusType) => void = (statusType: window.WindowStatusType) => {
    this.mainWindowInfo.windowStatusType = statusType;
  }
  // Monitor the change of avoidance zone in the main window.
  public onAvoidAreaChange: (avoidOptions: window.AvoidAreaOptions) => void =
    (avoidOptions: window.AvoidAreaOptions) => {
      if (avoidOptions.type === window.AvoidAreaType.TYPE_SYSTEM) {
        this.mainWindowInfo.avoidSystem = avoidOptions.area;
        this.mainWindowInfo.statusBarHeight = this.uiContext?.px2vp(avoidOptions.area.topRect.height) ?? 0;
      } else if (avoidOptions.type === window.AvoidAreaType.TYPE_CUTOUT) {
        this.mainWindowInfo.avoidCutout = avoidOptions.area;
      } else if (avoidOptions.type === window.AvoidAreaType.TYPE_SYSTEM_GESTURE) {
        this.mainWindowInfo.avoidSystemGesture = avoidOptions.area;
      } else if (avoidOptions.type === window.AvoidAreaType.TYPE_KEYBOARD) {
        this.mainWindowInfo.avoidKeyboard = avoidOptions.area;
      } else if (avoidOptions.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
        this.mainWindowInfo.avoidNavigationIndicator = avoidOptions.area;
        this.mainWindowInfo.naviIndicatorHeight = this.uiContext?.px2vp(avoidOptions.area.bottomRect.height) ?? 0;
      }
    };
  // Monitor the change of button rect in the main window.
  public onWindowButtonRectChange: (titleButtonRect: window.TitleButtonRect) => void =
    (titleButtonRect: window.TitleButtonRect) => {
      this.mainWindowInfo.titleButtonRect = titleButtonRect;
    }

  setUIContext() {
    try {
      this.uiContext = this.mainWindow.getUIContext();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error('testTag', `Failed to set UI context. Code: ${err.code}, message: ${err.message}`);
    }
  }

  // User the window interface to set up window immersion.
  setFullScreen(isFullScreen: boolean): void {
    if (canIUse('SystemCapability.Window.SessionManager.Extension')) {
      this.mainWindow.setWindowLayoutFullScreen(isFullScreen)
        .then(() => {
          Logger.info('testLog', `Succeeded in setting full-screen mode.`);
          // Update window isFullScreen.
          this.mainWindowInfo.isFullScreen = isFullScreen;
        })
        .catch((err: BusinessError) => {
          Logger.error('testLog', `Failed to set full-screen mode. Code: ${err.code}, message: ${err.message}`);
        });
    }
  }

  // User the window interface to set window orientation.
  setWindowOrientation(orientation: window.Orientation): void {
    this.mainWindow.setPreferredOrientation(orientation)
      .then(() => {
        Logger.info('testLog', `Succeeded in setting window orientation.`);
        // Update window orientation.
        this.mainWindowInfo.orientation = orientation;
      })
      .catch((err: BusinessError) => {
        Logger.error('testLog', `Failed to set window orientation. Code: ${err.code}, message: ${err.message}`);
      });
  }

  setImmersive() {
    try {
      this.mainWindow.setWindowDecorVisible(false);
      this.mainWindow.setWindowDecorHeight(56);
      this.mainWindow.setDecorButtonStyle({
        buttonIconSize: 24,
        spacingBetweenButtons: 16,
        colorMode: ConfigurationConstant.ColorMode.COLOR_MODE_DARK
      });
      this.recover();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error('TestLog', `Failed to set immersive type. Code: ${err.code}, message: ${err.message}`);
    }

  }

  setDecorButtonStyle(mode: ConfigurationConstant.ColorMode = ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
    try {
      this.mainWindow.setDecorButtonStyle({
        buttonIconSize: 24,
        spacingBetweenButtons: 24,
        colorMode: mode
      });
    } catch (error) {
      let err = error as BusinessError;
      Logger.error('TestLog', `Failed to set decor button style. Code: ${err.code}, message: ${err.message}`);
    }
  }

  recover(): void {
    try {
      if (this.mainWindow.getWindowStatus() === window.WindowStatusType.FULL_SCREEN) {
        this.mainWindow.recover()
          .then(() => {
            Logger.info('testLog', `Succeeded in recovering the window.`);
          })
          .catch((err: BusinessError) => {
            Logger.error('testLog', `Failed to recover the window. Code: ${err.code}, message: ${err.message}`);
          });
      }
    } catch (error) {
      let err = error as BusinessError;
      Logger.error('TestLog', `Failed to recover. Code: ${err.code}, message: ${err.message}`);
    }
  }

  updateWindowInfo(): void {
    try {
      this.mainWindowInfo.windowStatusType = this.mainWindow.getWindowStatus();
      // First time get window size.
      let width: number = this.mainWindow.getWindowProperties().windowRect.width;
      let height: number = this.mainWindow.getWindowProperties().windowRect.height;
      let windowSize: window.Size = {
        width: width,
        height: height
      }
      this.mainWindowInfo.windowSize = windowSize;
      // First time get window status.
      this.mainWindow.on('windowStatusChange', this.onStatusTypeChange);
      // First time get width/height breakpoint.
      if (!this.uiContext) {
        this.setUIContext();
      }
      const uiContext = this.uiContext;
      if (!uiContext) {
        return;
      }
      this.mainWindowInfo.widthBp = uiContext.getWindowWidthBreakpoint();
      this.mainWindowInfo.heightBp = uiContext.getWindowHeightBreakpoint();
      // Register for window size change monitoring, update window size and width/height breakpoint.
      this.mainWindow.on('windowSizeChange', this.onWindowSizeChange);
      // First time get avoid area infos.
      this.mainWindowInfo.avoidSystem = this.mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      this.mainWindowInfo.avoidNavigationIndicator =
        this.mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      this.mainWindowInfo.avoidCutout = this.mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_CUTOUT);
      this.mainWindowInfo.avoidSystemGesture =
        this.mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM_GESTURE);
      this.mainWindowInfo.avoidKeyboard = this.mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_KEYBOARD);
      this.mainWindow.on('avoidAreaChange', this.onAvoidAreaChange);

      // First time get title button rect.
      this.mainWindowInfo.titleButtonRect = this.mainWindow.getTitleButtonRect();
      this.mainWindow.on('windowTitleButtonRectChange', this.onWindowButtonRectChange);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(`testLog`, `Failed to update window info. Code: ${err.code}, message: ${err.message}`);
    }
  }

  release(): void {
    try {
      this.mainWindow.off('windowStatusChange');
      this.mainWindow.off('windowSizeChange');
      this.mainWindow.off('avoidAreaChange');
      this.mainWindow.off('windowTitleButtonRectChange');
    } catch (error) {
      let err = error as BusinessError;
      Logger.error('TestLog', `Failed to off. Code: ${err.code}, message: ${err.message}`);
    }
  }
}

@ObservedV2
export class WindowInfo {
  // Window status.
  @Trace public windowStatusType: window.WindowStatusType = window.WindowStatusType.UNDEFINED;
  // Is the window an immersive layout.
  @Trace public isFullScreen: boolean = false;
  // Window orientation.
  @Trace public orientation: window.Orientation = window.Orientation.UNSPECIFIED;
  // Window size.
  @Trace public windowSize: window.Size = { width: 0, height: 0 };
  // Width/height breakpoint.
  @Trace public widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_XS;
  @Trace public heightBp: HeightBreakpoint = HeightBreakpoint.HEIGHT_SM;
  // Avoid area info for top status bar.
  @Trace public avoidSystem?: window.AvoidArea;
  // Avoid area info for bottom navigation bar.
  @Trace public avoidNavigationIndicator?: window.AvoidArea;
  // Avoid area info for cutout zone.
  @Trace public avoidCutout?: window.AvoidArea;
  // Avoid area info for edge back gesture zone.
  @Trace public avoidSystemGesture?: window.AvoidArea;
  // Avoid area info for keyboard zone.
  @Trace public avoidKeyboard?: window.AvoidArea;
  // Title button rectangle height.
  @Trace public titleButtonRectHeight: number = 0;
  // Title button rectangle width.
  @Trace public titleButtonRectWidth: number = 0;
  @Trace public titleButtonRect?: window.TitleButtonRect;
  // Status bar height.
  @Trace public statusBarHeight: number = 0;
  // Navigation indicator height.
  @Trace public naviIndicatorHeight: number = 0;
}
