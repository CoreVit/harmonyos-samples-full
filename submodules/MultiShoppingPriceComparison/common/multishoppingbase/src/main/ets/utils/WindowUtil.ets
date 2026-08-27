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
import { AppStorageV2, UIContext, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

/** Storage key for observable window info in AppStorageV2; used with getWindowInfoState(). */
export const windowInfoStorageKey = 'MultiShoppingWindowInfo';

export enum ImmersiveType {
  NORMAL,
  IMMERSIVE
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
  /** Top occupied height of the status bar (vp), converted from avoidSystem.topRect. */
  @Trace public statusBarTopVp: number = 0;
  /** Bottom occupied height of the navigation indicator (vp), converted from avoidNavigationIndicator.bottomRect. */
  @Trace public navigationBarBottomVp: number = 0;
  /** Current immersive mode type (normal/immersive). */
  @Trace public immersiveType: ImmersiveType = ImmersiveType.NORMAL;
  /** Rectangle info of the title bar control buttons (freeform window). */
  @Trace public titleButtonRect?: window.TitleButtonRect;
  /** Avoid-area padding info for cutout displays (vp). */
  @Trace public avoidAreaPadding: Padding = {};
}

/**
 * Gets the observable window state ({@link WindowInfo}) bound to AppStorageV2.
 * A single shared storage key is used across the process to drive UI updates
 * for breakpoints, safe areas, and related window metrics.
 */
export function getWindowInfoState(): WindowInfo {
  return AppStorageV2.connect(WindowInfo, windowInfoStorageKey, () => new WindowInfo())!;
}

export class WindowUtil {
  public static readonly transparentColor: string = '#00000000';
  public static readonly lightContentColor: string = '#FFFFFF';
  public static readonly darkContentColor: string = '#000000';
  private static instance: WindowUtil | undefined = undefined;

  /** Returns the window utility singleton; creates it on first access. */
  static getInstance(): WindowUtil {
    if (WindowUtil.instance === undefined) {
      WindowUtil.instance = new WindowUtil();
    }
    return WindowUtil.instance;
  }

  /** Prevent external construction; use {@link WindowUtil.getInstance}. */
  private constructor() {
  }

  public windowStage?: window.WindowStage;
  public uiContext?: UIContext;
  public mainWindow?: window.Window;
  public mainWindowInfo: WindowInfo = getWindowInfoState();

  /** Syncs status bar top and navigation indicator bottom heights (vp) from avoid-area data and uiContext. */
  private syncWindowInsetsVp(): void {
    const ctx = this.uiContext;
    const info = this.mainWindowInfo;
    if (ctx === undefined) {
      info.statusBarTopVp = 0;
      info.navigationBarBottomVp = 0;
      return;
    }
    const sys = info.avoidSystem;
    if (sys !== undefined) {
      info.statusBarTopVp = ctx.px2vp(sys.topRect.height);
    } else {
      info.statusBarTopVp = 0;
    }
    const nav = info.avoidNavigationIndicator;
    if (nav !== undefined) {
      info.navigationBarBottomVp = ctx.px2vp(nav.bottomRect.height);
    } else {
      info.navigationBarBottomVp = 0;
    }
  }

  /**
   * Callback for main-window status type changes; writes to {@link WindowInfo.windowStatusType}.
   * Registered to `windowStatusChange` in {@link updateWindowInfo}.
   */
  public onStatusTypeChange: (statusType: window.WindowStatusType) => void = (statusType: window.WindowStatusType) => {
    this.mainWindowInfo.windowStatusType = statusType;
    if (statusType === window.WindowStatusType.MAXIMIZE || statusType === window.WindowStatusType.FLOATING) {
      this.setImmersiveType(ImmersiveType.IMMERSIVE);
    } else {
      this.setImmersiveType(ImmersiveType.NORMAL);
    }
  };
  /**
   * Callback for main-window size changes; updates {@link WindowInfo.windowSize}
   * and refreshes width/height breakpoints.
   * Registered to `windowSizeChange` in {@link updateWindowInfo}.
   */
  public onWindowSizeChange: (windowSize: window.Size) => void = (windowSize: window.Size) => {
    this.mainWindowInfo.windowSize = windowSize;
    try {
      this.mainWindowInfo.widthBp = this.uiContext!.getWindowWidthBreakpoint();
      this.mainWindowInfo.heightBp = this.uiContext!.getWindowHeightBreakpoint();
    } catch (error) {
      let err = error as BusinessError;
      hilog.error(0x0000, 'testLog', `getWindowBreakpoint failed. Code: ${err.code}, message: ${err.message}`);
    }
  };
  /**
   * Callback for main-window avoid-area changes; writes fields in {@link WindowInfo}
   * by area type and syncs status bar/navigation indicator heights in vp.
   * Registered to `avoidAreaChange` in {@link updateWindowInfo}.
   */
  public onAvoidAreaChange: (avoidOptions: window.AvoidAreaOptions) => void =
    (avoidOptions: window.AvoidAreaOptions) => {
      if (avoidOptions.type === window.AvoidAreaType.TYPE_SYSTEM) {
        this.mainWindowInfo.avoidSystem = avoidOptions.area;
      } else if (avoidOptions.type === window.AvoidAreaType.TYPE_CUTOUT) {
        this.mainWindowInfo.avoidCutout = avoidOptions.area;
        this.updateAvoidPadding(avoidOptions.area);
      } else if (avoidOptions.type === window.AvoidAreaType.TYPE_SYSTEM_GESTURE) {
        this.mainWindowInfo.avoidSystemGesture = avoidOptions.area;
      } else if (avoidOptions.type === window.AvoidAreaType.TYPE_KEYBOARD) {
        this.mainWindowInfo.avoidKeyboard = avoidOptions.area;
      } else if (avoidOptions.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
        this.mainWindowInfo.avoidNavigationIndicator = avoidOptions.area;
      }
      this.syncWindowInsetsVp();
    };

  public onWindowButtonRectChange: (titleButtonRect: window.TitleButtonRect) => void =
    (titleButtonRect: window.TitleButtonRect) => {
      this.mainWindowInfo.titleButtonRect = titleButtonRect;
    };

  /**
   * Binds the current Ability {@link window.WindowStage} and retrieves the main window
   * {@link window.Window} synchronously.
   * Usually called in `UIAbility.onWindowStageCreate`.
   */
  setWindowStage(windowStage: window.WindowStage): void {
    this.windowStage = windowStage;
    try {
      this.mainWindow = this.windowStage.getMainWindowSync();
    } catch (error) {
      let err = error as BusinessError;
      hilog.error(0x0000, 'testLog', `getMainWindowSync failed. Code: ${err.code}, message: ${err.message}`);
    }
  }

  /**
   * Obtains {@link UIContext} from the bound main window for breakpoint conversion
   * and px2vp utilities.
   * Must be called after {@link setWindowStage} successfully gets `mainWindow`.
   */
  setUIContext(): void {
    try {
      this.uiContext = this.mainWindow!.getUIContext();
    } catch (error) {
      let err = error as BusinessError;
      hilog.error(0x0000, 'testLog', `getUIContext failed. Code: ${err.code}, message: ${err.message}`);
    }
  }

  /**
   * Sets whether the main window uses full-screen (immersive) layout.
   * Updates {@link WindowInfo.isFullScreen} on success.
   * @param isFullScreen true for full-screen layout, false for normal layout.
   */
  setFullScreen(isFullScreen: boolean): void {
    try {
      this.mainWindow!.setWindowLayoutFullScreen(isFullScreen)
        .then(() => {
          hilog.info(0x0000, 'testLog', `Succeeded in setting full-screen mode.`);
          this.mainWindowInfo.isFullScreen = isFullScreen;
        })
        .catch((err: BusinessError) => {
          hilog.error(0x0000, 'testLog', `Failed to set full-screen mode. Code: ${err.code}, message: ${err.message}`);
        });
    } catch (error) {
      let err = error as BusinessError;
      hilog.error(0x0000, 'testLog',
        `setWindowLayoutFullScreen sync error. Code: ${err.code}, message: ${err.message}`);
    }
  }

  /**
   * Sets system bar styles (status/navigation etc.) on the current mainWindow.
   * Use this wrapper in business pages to avoid repeated getLastWindow calls.
   */
  setWindowSystemBarProperties(props: window.SystemBarProperties): void {
    if (this.mainWindow === undefined) {
      hilog.error(0x0000, 'testLog', 'setWindowSystemBarProperties: mainWindow is undefined');
      return;
    }
    try {
      this.mainWindow.setWindowSystemBarProperties(props).catch((err: BusinessError) => {
        hilog.error(0x0000, 'testLog',
          `setWindowSystemBarProperties failed. Code: ${err.code}, message: ${err.message}`);
      });
    } catch (error) {
      let err = error as BusinessError;
      hilog.error(0x0000, 'testLog',
        `setWindowSystemBarProperties sync error. Code: ${err.code}, message: ${err.message}`);
    }
  }

  updateAvoidPadding(area: window.AvoidArea): void {
    const avoidAreaPadding: Padding = {};
    try {
      if (area.topRect.height > 0) {
        avoidAreaPadding.top = this.uiContext?.px2vp(area.topRect.height + area.topRect.top);
      }
      if (area.leftRect.width > 0) {
        avoidAreaPadding.left = this.uiContext?.px2vp(area.leftRect.left + area.leftRect.width);
      }
      if (area.rightRect.width > 0) {
        avoidAreaPadding.right = this.uiContext?.px2vp(area.rightRect.width);
      }
      if (area.bottomRect.height > 0) {
        avoidAreaPadding.bottom = this.uiContext?.px2vp(area.bottomRect.height);
      }
    } catch (error) {
      let err = error as BusinessError;
      hilog.error(0x0000, 'testLog', `Failed to set avoid padding. Code: ${err.code}, message: ${err.message}`);
    }
    this.mainWindowInfo.avoidAreaPadding = avoidAreaPadding;
  }

  setImmersiveType(type: ImmersiveType): void {
    if (this.mainWindow === undefined) {
      hilog.error(0x0000, 'testLog', 'setImmersiveType: mainWindow is undefined');
      return;
    }
    try {
      if (type === ImmersiveType.NORMAL) {
        this.mainWindow.setWindowDecorVisible(true);
      } else if (type === ImmersiveType.IMMERSIVE) {
        this.mainWindow.setWindowDecorVisible(false);
        this.mainWindow.setWindowDecorHeight(56);
        this.mainWindow.setDecorButtonStyle({ buttonIconSize: 24 });
      }
      this.mainWindowInfo.immersiveType = type;
    } catch (error) {
      let err = error as BusinessError;
      hilog.error(0x0000, 'testLog', `Failed to set immersive type. Code: ${err.code}, message: ${err.message}`);
    }
  }

  startWindowStatusListener(): void {
    if (this.mainWindow === undefined) {
      hilog.error(0x0000, 'testLog', 'startWindowStatusListener: mainWindow is undefined');
      return;
    }
    try {
      this.mainWindow.on('windowStatusChange', this.onStatusTypeChange);
    } catch (error) {
      let err = error as BusinessError;
      hilog.error(
        0x0000,
        'testLog',
        `Failed to start window status listener. Code: ${err.code}, message: ${err.message}`
      );
    }
  }

  /**
   * Enables immersive layout:
   * 1) Enter full-screen layout
   * 2) Make status/navigation bar backgrounds transparent
   * 3) Set status bar content color by parameter
   */
  enableImmersiveMode(useDarkStatusContent: boolean = true): void {
    this.setImmersiveType(ImmersiveType.IMMERSIVE);
    this.setFullScreen(true);
    this.setWindowSystemBarProperties({
      statusBarColor: WindowUtil.transparentColor,
      navigationBarColor: WindowUtil.transparentColor,
      statusBarContentColor: useDarkStatusContent ? WindowUtil.darkContentColor : WindowUtil.lightContentColor
    });
  }

  /**
   * Disables immersive layout and restores default opaque system bar backgrounds.
   */
  disableImmersiveMode(): void {
    this.setImmersiveType(ImmersiveType.NORMAL);
    this.setFullScreen(false);
    this.setWindowSystemBarProperties({
      statusBarColor: WindowUtil.lightContentColor,
      navigationBarColor: WindowUtil.lightContentColor,
      statusBarContentColor: WindowUtil.darkContentColor
    });
  }

  /**
   * Updates only immersive status bar content color without changing other system bar properties.
   */
  setImmersiveStatusBarContent(isDark: boolean): void {
    this.setWindowSystemBarProperties({
      statusBarContentColor: isDark ? WindowUtil.darkContentColor : WindowUtil.lightContentColor
    });
  }

  /**
   * Sets preferred screen orientation for the main window and writes
   * {@link WindowInfo.orientation} on success.
   * @param orientation enum value consistent with {@link window.Orientation}.
   */
  setWindowOrientation(orientation: window.Orientation): void {
    try {
      this.mainWindow!.setPreferredOrientation(orientation)
        .then(() => {
          hilog.info(0x0000, 'testLog', `Succeeded in setting window orientation.`);
          this.mainWindowInfo.orientation = orientation;
        })
        .catch((err: BusinessError) => {
          hilog.error(0x0000, 'testLog',
            `Failed to set window orientation. Code: ${err.code}, message: ${err.message}`);
        });
    } catch (error) {
      let err = error as BusinessError;
      hilog.error(0x0000, 'testLog', `setPreferredOrientation sync error. Code: ${err.code}, message: ${err.message}`);
    }
  }

  /**
   * Initializes or refreshes main-window state: reads initial status/size/breakpoints/avoid areas
   * and registers listeners.
   * Requires {@link setWindowStage} and {@link setUIContext} to be completed first.
   */
  updateWindowInfo(): void {
    try {
      // First time get window status.
      this.mainWindowInfo.windowStatusType = this.mainWindow!.getWindowStatus();
      this.mainWindow!.on('windowStatusChange', this.onStatusTypeChange);

      // First time get window size.
      let width: number = this.mainWindow!.getWindowProperties().windowRect.width;
      let height: number = this.mainWindow!.getWindowProperties().windowRect.height;
      let windowSize: window.Size = {
        width: width,
        height: height
      };
      this.mainWindowInfo.windowSize = windowSize;
      // First time get width/height breakpoint.
      this.mainWindowInfo.widthBp = this.uiContext!.getWindowWidthBreakpoint();
      this.mainWindowInfo.heightBp = this.uiContext!.getWindowHeightBreakpoint();
      // Register for window size change monitoring, update window size and width/height breakpoint.
      this.mainWindow?.on('windowSizeChange', this.onWindowSizeChange);

      // First time get avoid area infos.
      this.mainWindowInfo.avoidSystem = this.mainWindow?.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      this.mainWindowInfo.avoidNavigationIndicator =
        this.mainWindow?.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      this.mainWindowInfo.avoidCutout = this.mainWindow?.getWindowAvoidArea(window.AvoidAreaType.TYPE_CUTOUT);
      this.mainWindowInfo.avoidSystemGesture =
        this.mainWindow?.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM_GESTURE);
      this.mainWindowInfo.avoidKeyboard = this.mainWindow?.getWindowAvoidArea(window.AvoidAreaType.TYPE_KEYBOARD);
      this.mainWindow?.on('avoidAreaChange', this.onAvoidAreaChange);
      this.mainWindow?.on('windowTitleButtonRectChange', this.onWindowButtonRectChange);
      this.mainWindowInfo.titleButtonRect = this.mainWindow?.getTitleButtonRect();
      this.syncWindowInsetsVp();
    } catch (error) {
      let err = error as BusinessError;
      hilog.error(0x0000, 'testLog', `updateWindowInfo failed. Code: ${err.code}, message: ${err.message}`);
    }
  }

  /**
   * Unregisters listeners added by this class on the main window (status, size, avoid area)
   * to prevent leaks or duplicate callbacks.
   * Recommended during window teardown or Ability lifecycle cleanup.
   */
  release(): void {
    try {
      this.mainWindow!.off('windowStatusChange');
      this.mainWindow!.off('windowSizeChange');
      this.mainWindow!.off('avoidAreaChange');
      this.mainWindow!.off('windowTitleButtonRectChange');
    } catch (error) {
      let err = error as BusinessError;
      hilog.error(0x0000, 'testLog', `WindowUtil release failed. Code: ${err.code}, message: ${err.message}`);
    }
  }
}