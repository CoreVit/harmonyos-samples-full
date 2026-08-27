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

import { WaveWheelController } from '../controllers/WaveWheelController';
import { curves, display, PromptAction, window } from '@kit.ArkUI';
import type { EntranceButtonModel } from '../model/EntranceButtonModel';
import {
  fixVp,
  foldPhoneEntranceStyle,
  getInnerRadiusVp,
  getRingWidthVp,
  isFoldState,
  isNovaSeries,
  phoneEntranceStyle,
  tabletEntranceStyle
} from '../utils/Style';
import { EntranceButton } from '../components/EntranceButton';
import { FloatWindowManager } from '../../../../Index';
import { Constants } from '../common/Constants';
import type { EntranceStyle } from '../model/Model';
import { WindowState } from '../model/Model';
import { commonEventManager, emitter } from '@kit.BasicServicesKit';
import { BreakPointInfo, MyHeightBreakpoint, MyWidthBreakpoint } from '../utils/BreakPointInfo';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from '../utils/Logger';


const TAG = 'WaveWheelPage';

export const LIGHT_BACKGROUND_COLOR: string = '#fcffffff';

export const DARK_BACKGROUND_COLOR: string = '#ff2f3034';

export const MENU_ANIMATION_RESPONSE: number = 0.45;

export const BTN_OFFSET_Y: number = 0;

export const BTN_OFFSET_X: number = 0;

export const MENU_ANIMATION_DURATION: number = 450;

// Numeric initial values
const DEFAULT_INIT_VALUE: number = 0;
const DEFAULT_AVOID_AREA_HEIGHT: number = 38.8;

// Shadow & rendering
const SHADOW_MARGIN: number = 30;
const SHADOW_BLUR: number = 60;

// Debug visualization
const DEBUG_LINE_WIDTH: number = 5;
const DEBUG_CIRCLE_DIAMETER: number = 6;
const DEBUG_CIRCLE_RADIUS: number = 3;

// Angle calculation
const DEFAULT_TOTAL_RADIAN: number = Math.PI / 2;
const RADIAN_DIVISOR: number = 8;
const DEGREE_TO_RADIAN_DIVISOR: number = 180;


@Builder
export function WaveWheelPageBuilder() {
  WaveWheelPage()
    .hitTestBehavior(HitTestMode.Transparent);
}


@Entry({ routeName: Constants.WAVEWHEEL_PAGE_ROUTER })
@Component
struct WaveWheelPage {
  storage: LocalStorage | undefined = this.getUIContext().getSharedLocalStorage();
  @State TOTAL_RADIAN: number = DEFAULT_TOTAL_RADIAN;
  @State ringWidth: number = getRingWidthVp(this.getUIContext()); // vp
  @State innerRadius: number = getRingWidthVp(this.getUIContext()); // vp
  textCenterR: number = this.innerRadius + this.ringWidth / 2; // vp
  private settings: RenderingContextSettings = new RenderingContextSettings(false);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  promptAction: PromptAction = this.getUIContext().getPromptAction();
  @LocalStorageLink('waveWheelController') waveWheelController: WaveWheelController | undefined = undefined;
  @LocalStorageLink('floatMgr') floatWindowManager: FloatWindowManager | undefined = undefined;
  @LocalStorageLink('currentSubWindow') currentSubWindow: window.Window | undefined = undefined;
  @State windowWidth: number = DEFAULT_INIT_VALUE; //vp
  @State windowHeight: number = DEFAULT_INIT_VALUE; //vp
  @State canvasReady: boolean = false;
  private closeDelayTimer: number | null = null;
  @State centerX: number = DEFAULT_INIT_VALUE; // vp
  @State centerY: number = DEFAULT_INIT_VALUE; // vp
  @State clickRefX: number = DEFAULT_INIT_VALUE; // vp
  @State clickRefY: number = DEFAULT_INIT_VALUE; // vp
  private pencilX: number = DEFAULT_INIT_VALUE;
  private pencilY: number = DEFAULT_INIT_VALUE;
  @State darkMode: boolean = false;
  @State menuScale: number = DEFAULT_INIT_VALUE;
  @State nibX: number = DEFAULT_INIT_VALUE; // vp
  @State nibY: number = DEFAULT_INIT_VALUE; // vp
  @State penRadian: number = this.TOTAL_RADIAN / 2;
  @State entranceButtonConfigs: EntranceButtonModel[] = [];
  @State entranceStyle: EntranceStyle = phoneEntranceStyle;
  @State avoidAreaHeight: number = DEFAULT_AVOID_AREA_HEIGHT; // vp
  @State bottomAvoidAreaHeight: number = DEFAULT_INIT_VALUE; //vp
  @State dragStartX: number = DEFAULT_INIT_VALUE; // vp
  @State dragStartY: number = DEFAULT_INIT_VALUE; // vp
  private isValidDrag: boolean = false;
  @State windowsState: WindowState = WindowState.SHOWING;
  event: emitter.InnerEvent = { eventId: Constants.HANDPAN_SQUEEZE_EVENT_ID };
  private screenOffSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  defaultDisplay: display.Display | undefined = undefined;

  // Clamp dragging position to prevent exceeding window boundaries
  clampNibInWindow(): void {
    if (this.windowWidth <= 0 || this.windowHeight <= 0) {
      return;
    }
    const r = this.innerRadius + this.ringWidth;
    const maxNibX = this.centerX - this.ringWidth / 2;
    const minNibX = r - this.centerX;
    if (this.nibX > maxNibX) {
      this.nibX = maxNibX;
    } else if (this.nibX < minNibX) {
      this.nibX = minNibX;
    }

    const maxNibY = this.windowHeight - this.bottomAvoidAreaHeight - this.ringWidth / 2 - this.centerY;
    const minNibY = this.avoidAreaHeight + r - this.centerY;

    if (this.nibY > maxNibY) {
      this.nibY = maxNibY;
    } else if (this.nibY < minNibY) {
      this.nibY = minNibY;
    }

  }

  isPointInPath(x: number, y: number): boolean {
    const menuRadius = this.innerRadius;
    const menuRingW = this.ringWidth;

    let moveBeforeX = x - this.nibX; // Restore coordinates before translate
    let moveBeforeY = y - this.nibY; // Restore coordinates before translate

    let centerX = this.centerX; // Relative origin point, before translate
    let centerY = this.centerY; // Relative origin point
    const disFromCenter = Math.sqrt(Math.pow(moveBeforeX - centerX, 2) + Math.pow(moveBeforeY - centerY, 2));

    const isInRing = (disFromCenter >= menuRadius) && (disFromCenter <= menuRadius + menuRingW);
    if (centerX - moveBeforeX >= 0 && centerY - moveBeforeY >= 0) {
      const clampedValue = Math.max(Math.min(((centerX - moveBeforeX) / disFromCenter), 1), -1)
      let radian = Math.acos(clampedValue);
      if (isInRing && radian >= 0 && radian <= this.TOTAL_RADIAN) {
        // Click point is on the ring
        return true;
      }
    }

    let leftCenterX = centerX - menuRadius - this.ringWidth / 2;
    let leftCenterY = centerY;
    let leftRadius = this.ringWidth / 2;
    if (moveBeforeX >= leftCenterX - this.ringWidth / 2 && moveBeforeX <= leftCenterX + this.ringWidth / 2 &&
      moveBeforeY >= leftCenterY && moveBeforeY <= leftCenterY + this.ringWidth / 2
    ) {
      const distanceFromLeftCenter =
        Math.sqrt(Math.pow(moveBeforeX - leftCenterX, 2) + Math.pow(moveBeforeY - leftCenterY, 2));
      if (distanceFromLeftCenter <= leftRadius) {
        // Inside the semicircle at the bottom
        return true;
      }
    }

    const topCenterDistance = menuRadius + menuRingW / 2;
    const topCenterX = centerX - topCenterDistance * Math.cos(this.TOTAL_RADIAN);
    const topCenterY = centerY - topCenterDistance * Math.sin(this.TOTAL_RADIAN);
    const topRadius = this.ringWidth / 2;

    const distanceFromTopCenter =
      Math.sqrt(Math.pow(moveBeforeX - topCenterX, 2) + Math.pow(moveBeforeY - topCenterY, 2));
    if (distanceFromTopCenter <= topRadius) {
      const uX = -Math.cos(this.TOTAL_RADIAN);
      const uY = -Math.sin(this.TOTAL_RADIAN);
      const vX = moveBeforeX - topCenterX;
      const vY = moveBeforeY - topCenterY;
      if (uX * vY - uY * vX >= 0) {
        return true;
      }
    }

    return false;


  }

  // Update the wave wheel display position based on user's click location
  updateClickPosition(): void {
    if (!this.waveWheelController) {
      return;
    }
    let position = this.waveWheelController.getPosition(); // Need to convert this address to non-avoidArea coordinates
    if (position.x < 0 || position.y < 0) {
      position.x = this.centerX;
      position.y = this.centerY;
    }
    this.nibX = position.x - this.centerX;
    this.nibY = position.y - this.centerY;
    let r = this.ringWidth + this.innerRadius;
    Logger.debug(TAG, `centerX=${this.centerX} centerY=${this.centerY} avoid=${this.avoidAreaHeight} r=${r}`);
    if (this.centerX < r) {
      let ringWidthRatio = this.ringWidth / (this.ringWidth + this.innerRadius);
      // Leave space for the wave wheel shadow
      let baseLen = this.centerX - SHADOW_MARGIN;
      this.ringWidth = baseLen * ringWidthRatio;
      this.innerRadius = baseLen * (1 - ringWidthRatio);
      r = this.ringWidth + this.innerRadius;
      this.textCenterR = this.innerRadius + this.ringWidth / 2;
      Logger.debug(TAG,
        `update ringWidth because of r too large ringWidth${this.ringWidth} innerRadius=${this.innerRadius}
        r=${r} centerX=${this.centerX}`);
    }

    if (this.centerY - this.avoidAreaHeight < r) {
      let ringWidthRatio = this.ringWidth / (this.ringWidth + this.innerRadius);
      // Leave space for the wave wheel shadow
      let baseLen = (this.centerY - this.avoidAreaHeight) - SHADOW_MARGIN;
      this.ringWidth = baseLen * ringWidthRatio;
      this.innerRadius = baseLen * (1 - ringWidthRatio);
      r = this.ringWidth + this.innerRadius;
      this.textCenterR = this.innerRadius + this.ringWidth / 2;
      Logger.debug(TAG,
        `update ringWidth because of r too large ringWidth${this.ringWidth} innerRadius=${this.innerRadius}
        r=${r}  centerY=${this.centerY} avoid=${this.avoidAreaHeight}`);
    }

    Logger.debug(TAG, `nibX=${this.nibX} positionX=${position.x} centerX=${this.centerX} r=${r}`);
    if (this.nibX > this.centerX - this.ringWidth / 2) {
      this.nibX = this.centerX - this.ringWidth / 2;
    } else if (this.nibX < r - this.centerX) {
      this.nibX = r - this.centerX;
    }

    if (this.nibY > this.windowHeight - this.bottomAvoidAreaHeight - this.ringWidth / 2 - this.centerY) {
      this.nibY = this.windowHeight - this.bottomAvoidAreaHeight - this.ringWidth / 2 - this.centerY;
    } else if (this.nibY < this.avoidAreaHeight + r - this.centerY) {
      this.nibY = this.avoidAreaHeight + r - this.centerY;
    }
    Logger.debug(TAG, `updatePosition succ x=${this.nibX} y=${this.nibY}`);
  }

  updateRingSize(): void {
    this.ringWidth = fixVp(this.getUIContext(), 81, this.windowWidth, this.windowHeight);
    this.innerRadius = fixVp(this.getUIContext(), 101, this.windowWidth, this.windowHeight);
    let isFold = isFoldState() || isNovaSeries();
    if (isFold) {
      this.ringWidth = getRingWidthVp(this.getUIContext(), isFold);
      this.innerRadius = getInnerRadiusVp(this.getUIContext(), isFold);
    }
    this.textCenterR = this.innerRadius + this.ringWidth / 2;
  }

  // Get the style based on device breakpoints: 3 styles available - phone, folded phone, tablet.
  getEntryStyle(): EntranceStyle {
    let widthBreakPoint = BreakPointInfo.getWindowWidthBreakpoint(this.windowWidth);
    let heightBreakPoint = BreakPointInfo.getWindowHeightBreakpoint(this.windowWidth, this.windowHeight);
    if (widthBreakPoint >= MyWidthBreakpoint.WIDTH_LG && heightBreakPoint >= MyHeightBreakpoint.HEIGHT_LG ||
      widthBreakPoint >= MyWidthBreakpoint.WIDTH_LG && heightBreakPoint >= MyHeightBreakpoint.HEIGHT_SM
    ) {
      Logger.debug(TAG, `use pad`);
      tabletEntranceStyle.setWindowSize(this.windowWidth, this.windowHeight);
      return tabletEntranceStyle;
    } else {
      Logger.debug(TAG, `use phone`);
    }
    if (isFoldState() || isNovaSeries()) {
      Logger.debug(TAG, `use foldPhoneEntranceStyle`);
      foldPhoneEntranceStyle.setWindowSize(this.windowWidth, this.windowHeight);
      return foldPhoneEntranceStyle;
    }
    Logger.debug(TAG, `use phoneEntranceStyle`);
    phoneEntranceStyle.setWindowSize(this.windowWidth, this.windowHeight);
    return phoneEntranceStyle;

  }

  // Update button configurations
  updateEntranceButtonConfig(): void {
    if (!this.waveWheelController) {
      return;
    }
    let options = this.waveWheelController.getWaveWheelOptions();
    this.entranceButtonConfigs.splice(0);
    for (let i = 0; i < options.length; ++i) {
      let option = options[i];
      let isEnable = typeof option.enable === 'function' ? option.enable() : option.enable ?? true;
      this.entranceButtonConfigs.push({
        text: option.title,
        componentKey: option.id,
        img: option.icon,
        useSysImg: option.useSysImg,
        enable: isEnable,
        callback: option.callback,
      });
    }
    this.entranceStyle = this.getEntryStyle();

    this.TOTAL_RADIAN = Math.PI * this.entranceButtonConfigs.length / RADIAN_DIVISOR;
    this.penRadian = this.TOTAL_RADIAN / 2;
    Logger.info(TAG, `updateEntranceButtonConfig succ size=${this.entranceButtonConfigs.length}`);
  }

  // Get click position info from controller to update
  updateInfoFromWaveWheelController(): void {
    this.updateClickPosition();
    this.updateEntranceButtonConfig();
  }

  // Bind callback for custom events.
  destroyFloatWinEventCallback = async (eventData: emitter.EventData): Promise<void> => {
    Logger.debug(TAG, `destroyFloatWinEventCallback begin state=${this.windowsState}`);
    if (this.windowsState === WindowState.BEFORE_DESTROY_ANIMATION) {
      Logger.debug(TAG, `handle BEFORE_DESTROY_ANIMATION`);
      clearTimeout(this.closeDelayTimer);
      await this.hide();
      await this.create();
      this.windowsState = WindowState.SHOWING;
    } else if (this.windowsState === WindowState.SHOWING) {
      this.hideWithAnimation();
    } else {
      Logger.info(TAG, `window state is destroyed`); // Ignore animations for other transient states
    }
  };

  updateAvoidAreaHeights(): void {
    if (!this.currentSubWindow) {
      return;
    }
    try {
      let avoidArea = this.currentSubWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      if (avoidArea?.topRect.height) {
        this.avoidAreaHeight = this.getUIContext().px2vp(avoidArea.topRect.height);
      }
      if (avoidArea?.bottomRect.height) {
        this.bottomAvoidAreaHeight = this.getUIContext().px2vp(avoidArea.bottomRect.height);
      }
      let naviAvoidArea = this.currentSubWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      if (naviAvoidArea?.bottomRect.height) {
        this.bottomAvoidAreaHeight =
          Math.max(this.bottomAvoidAreaHeight, this.getUIContext().px2vp(naviAvoidArea.bottomRect.height));
      }
      Logger.debug(TAG, `updateAvoidAreaHeights succ top=${this.avoidAreaHeight} bottom=${this.bottomAvoidAreaHeight}`);
    } catch (error) {
      Logger.debug(TAG, `fail to getWindowAvoidArea`);
    }
  }

  aboutToAppear(): void {
    this.waveWheelController = this.storage?.get<WaveWheelController>('waveWheelController');
    this.floatWindowManager = this.storage?.get<FloatWindowManager>('floatMgr');
    this.currentSubWindow = this.storage?.get<window.Window>('currentSubWindow');
    phoneEntranceStyle.init(this.getUIContext());
    foldPhoneEntranceStyle.init(this.getUIContext());
    tabletEntranceStyle.init(this.getUIContext());
    try {
      this.defaultDisplay = display.getDefaultDisplaySync();
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `fail to get defaultdisplaySync, error ${err.code}: ${err.message}`);
    }
    this.windowsState = WindowState.SHOWING;
    emitter.on(this.event, this.destroyFloatWinEventCallback);
    Logger.debug(TAG, `begin aboutToAppear test1=${!this.waveWheelController}  test2=${this.waveWheelController ===
      null} isFoldState=${isFoldState()}`);
    if (!this.waveWheelController) {
      Logger.error(TAG, `waveWheelController is null`);
      return;
    }

    let isFold = isFoldState() || isNovaSeries();
    this.ringWidth = getRingWidthVp(this.getUIContext(), isFold);
    this.innerRadius = getInnerRadiusVp(this.getUIContext(), isFold);
    this.textCenterR = this.innerRadius + this.ringWidth / 2;


    try {
      // This size changes with the foldable screen's fold status
      let displayInfo = display.getDefaultDisplaySync();
      this.clickRefX = this.getUIContext().px2vp(displayInfo.width);
      this.clickRefY = this.getUIContext().px2vp(displayInfo.height);
      Logger.debug(TAG, `clickRefX=${this.clickRefX}  clickRefY=${this.clickRefY}`);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `fail to getDefaultDisplaySync, error ${err.code}: ${err.message}`);
    }

    if (this.windowWidth === 0) {
      this.windowWidth = this.clickRefX;
    }

    if (this.windowHeight === 0) {
      this.windowHeight = this.clickRefY;
    }

    this.darkMode = this.waveWheelController.getDarkMode();
    Logger.debug(TAG, `got darkmode ${this.darkMode}`);
    this.entranceStyle = this.getEntryStyle();
    this.updateRingSize();
    this.updateAvoidAreaHeights();
    this.centerX = this.windowWidth / 2;
    this.centerY = (this.windowHeight - this.avoidAreaHeight - this.bottomAvoidAreaHeight) / 2 + this.avoidAreaHeight;

    if (this.currentSubWindow) {
      this.currentSubWindow.on('windowSizeChange', (size: window.Size) => {
        this.entranceStyle = this.getEntryStyle();
        // size is { width: number, height: number }, unit: px (pixels)
        const winWidthVp = this.getUIContext().px2vp(size.width);
        const winHeightVp = this.getUIContext().px2vp(size.height);
        this.windowWidth = winWidthVp;
        this.windowHeight = winHeightVp;
        this.entranceStyle = this.getEntryStyle();
        this.updateRingSize();
        this.centerX = winWidthVp / 2;
        this.updateAvoidAreaHeights();
        this.centerY = (winHeightVp - this.avoidAreaHeight - this.bottomAvoidAreaHeight) / 2 + this.avoidAreaHeight;


        Logger.info(TAG,
          `subWin changed: px(${size.width} × ${size.height}), vp center(${this.centerX.toFixed(
            1)}, ${this.centerY.toFixed(1)})`);
        this.updateInfoFromWaveWheelController();
        // Important: size has changed, force Canvas redraw (to prevent right semicircle clipping)
        if (this.canvasReady) {
          this.drawMenu();
        }
      });
    } else {
      this.updateInfoFromWaveWheelController();
    }

    // Listen for screen off, screen on, and desktop gestures
    this.screenOffSubscriber = commonEventManager.createSubscriberSync({
      events: [
        commonEventManager.Support.COMMON_EVENT_SCREEN_OFF,
        commonEventManager.Support.COMMON_EVENT_SCREEN_ON
      ]
    });
    if (this.screenOffSubscriber) {
      commonEventManager.subscribe(this.screenOffSubscriber, this.screenOffCallback);
    }

    try {
      display.on('foldDisplayModeChange', this.hideWithAnimation);
    } catch (error) {
      Logger.error(TAG, `fail to listen foldDisplayModeChange`);
    }
  }

  private screenOffCallback =
    async (err: BusinessError, eventData: commonEventManager.CommonEventData): Promise<void> => {
      Logger.debug(TAG, `screen off`);
      if (err) {
        Logger.error(TAG, `failed to subscribe common event screen off`);
        return;
      }
      return new Promise((resolve) => {
        this.hideWithAnimation();
        return resolve();
      });
    };

  onPageHide(): void {
    Logger.debug(TAG, `onPageHide`);
    this.hide();
  }

  drawMenu(): void {
    let path2Db: Path2D = new Path2D();
    // Clear the canvas
    this.context.clearRect(0, 0, this.centerX * 2, this.centerY * 2);
    Logger.debug(TAG, `clearRect`);

    // Save the canvas state
    this.context.save();

    const menuRadius = this.innerRadius;
    const menuRingW = this.ringWidth;
    Logger.debug(TAG, `menuRadius=${menuRadius} menuRingW=${menuRingW}`);
    // Use window coordinates here, do not subtract avoidArea,
    // otherwise the click position and wave wheel display position will be inconsistent
    this.context.translate(this.centerX, this.centerY);
    let startPoint = Math.PI;
    path2Db.arc(this.pencilX, this.pencilY, menuRadius + menuRingW, startPoint, startPoint + this.TOTAL_RADIAN);

    const leftX = -1 * Math.cos(this.TOTAL_RADIAN) * (menuRadius + menuRingW / 2) + this.pencilX;
    const leftY = -1 * Math.sin(this.TOTAL_RADIAN) * (menuRadius + menuRingW / 2) + this.pencilX;

    path2Db.arc(leftX, leftY, menuRingW / 2, startPoint + this.TOTAL_RADIAN, startPoint + this.TOTAL_RADIAN + Math.PI);
    path2Db.arc(this.pencilX, this.pencilY, menuRadius, startPoint + this.TOTAL_RADIAN, startPoint, true);
    const rightX = -1 * (menuRadius + menuRingW / 2) + this.pencilX;
    const rightY = this.pencilY;
    path2Db.arc(rightX, rightY, menuRingW / 2, startPoint + Math.PI, startPoint + Math.PI * 2);

    this.context.strokeStyle = this.darkMode ? DARK_BACKGROUND_COLOR : LIGHT_BACKGROUND_COLOR;
    this.context.stroke(path2Db);
    this.context.shadowBlur = SHADOW_BLUR;
    this.context.shadowColor = this.darkMode ? '#66000000' : '#33000000';
    this.context.fillStyle = this.darkMode ? DARK_BACKGROUND_COLOR : LIGHT_BACKGROUND_COLOR;
    this.context.fill(path2Db);


    if (this.waveWheelController && this.waveWheelController.getDebug()) {
      this.drawLine();
    }
    // Restore the canvas state
    this.context.restore();
    this.getUIContext().animateTo({ delay: 0, curve: curves.springMotion(MENU_ANIMATION_RESPONSE) }, () => {
      this.menuScale = 1;
    });
  }

  drawLine(): void {
    let path2Db: Path2D = new Path2D();
    const menuRadius = this.innerRadius;
    const menuRingW = this.ringWidth;
    let startPoint = Math.PI;
    path2Db.arc(this.pencilX, this.pencilY, menuRadius + menuRingW / 2, startPoint, startPoint + this.TOTAL_RADIAN);
    this.context.lineWidth = DEBUG_LINE_WIDTH;
    this.context.strokeStyle = '#ff0000ff';
    this.context.stroke(path2Db);
    this.context.shadowBlur = SHADOW_BLUR;
    this.context.shadowColor = this.darkMode ? '#66000000' : '#33000000';
    this.context.fillStyle = '#000000ff';
    this.context.fill(path2Db);
  }

  aboutToDisappear(): void {
    emitter.off(this.event.eventId);
    clearTimeout(this.closeDelayTimer);
    commonEventManager.unsubscribe(this.screenOffSubscriber, (err: BusinessError) => {
      if (err) {
        Logger.error(TAG, `unsubscribe failed`);
      } else {
        Logger.info(TAG, `unsubcribe success`);
        this.screenOffSubscriber = null;
      }
    });
    try {
      display.off('foldDisplayModeChange', this.hideWithAnimation);
    } catch (error) {
      Logger.error(TAG, `fail to unlisten foldDisplayModeChange`);
    }

    if (this.currentSubWindow) {
      this.currentSubWindow.off('windowSizeChange');
    }
  }

  async create(): Promise<void> {
    try {
      await this.floatWindowManager?.createFloatWindow();
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Failed to destory float window, error ${err.code}: ${err.message}`);
    }
  }

  async hide(): Promise<void> {
    try {
      Logger.debug(TAG, `begin destory`);
      await this.floatWindowManager?.destroyFloatWindow();
      Logger.debug(TAG, `end destory`);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Failed to destory float window, error ${err.code}: ${err.message}`);
    }
  }

  hideWithAnimation = (): void => {
    Logger.debug(TAG, `hideWithAnimation`);
    if (this.windowsState !== WindowState.SHOWING) {
      Logger.info(TAG, `hideWithAnimation is hiding`);
      return;
    }
    Logger.debug(TAG, `hideWithAnimation start.`);
    this.windowsState = WindowState.BEFORE_DESTROY_ANIMATION;
    this.getUIContext().animateTo({ delay: 0, curve: curves.springMotion(MENU_ANIMATION_RESPONSE) }, () => {
      this.menuScale = 0;
    });
    this.closeDelayTimer = setTimeout(async () => {
      this.windowsState = WindowState.START_DESTROY;
      await this.hide();
      this.windowsState = WindowState.DESTROYED;
    }, MENU_ANIMATION_DURATION);
  };

  onCanvasReady(): void {
    this.canvasReady = true;
    this.updateClickPosition();
    this.drawMenu();
  }

  onButtonClick = (clkEvent: ClickEvent, item: EntranceButtonModel): void => {
    this.hideWithAnimation();
    item.callback(
      item.componentKey,
      this.centerX + this.nibX,
      this.centerY + this.nibY
    );
  };

  build() {
    Stack() {
      if (this.waveWheelController &&
        this.waveWheelController.getWaveWheelOptions().length >= 1
      ) {
        WithTheme({ colorMode: this.darkMode ? ThemeColorMode.DARK : ThemeColorMode.LIGHT }) {
          Stack() {
            Canvas(this.context)
              .width('100%')
              .height('100%')
              .onReady(() => {
                this.onCanvasReady();
              });


            ForEach(this.entranceButtonConfigs, (item: EntranceButtonModel, index: number) => {
              // Position calculation: why add item.entranceStyle.buttonHeight/2?
              // Because component drawing is based on the top-left corner.
              EntranceButton({
                text: item.text,
                componentKey: item.componentKey,
                img: item.img,
                useSysImg: item.useSysImg,
                enable: item.enable,
                debug: this.waveWheelController?.getDebug() ?? false,
                entranceStyle: this.getEntryStyle(),
                onButtonClick: (event: ClickEvent): void => {
                  this.onButtonClick(event, item);
                }
              })
                .position({
                  x: -1 * Math.cos(
                    (index === 0 ? 3 : index * 30) * Math.PI / DEGREE_TO_RADIAN_DIVISOR
                  ) * this.textCenterR +
                    this.getUIContext().px2vp(BTN_OFFSET_X) + this.centerX - this.entranceStyle.buttonHeight / 2,
                  y: -1 * Math.sin(
                    (index === 0 ? 3 : index * 30) * Math.PI / DEGREE_TO_RADIAN_DIVISOR
                  ) * this.textCenterR +
                    this.getUIContext().px2vp(BTN_OFFSET_Y) + this.centerY - this.entranceStyle.buttonHeight / 2
                });
            });
            if (this.waveWheelController && this.waveWheelController.getDebug()) {
              Circle()
                .fill(Color.Red)
                .size({ width: DEBUG_CIRCLE_DIAMETER, height: DEBUG_CIRCLE_DIAMETER })
                .position({ x: this.centerX - DEBUG_CIRCLE_RADIUS, y: this.centerY - DEBUG_CIRCLE_RADIUS });
            }
          }
          .scale({ x: this.menuScale, y: this.menuScale })
          .enabled(this.menuScale === 1) // Disable buttons before animation completes to prevent hover event bubbling
          .opacity(this.menuScale < 0.01 ? 0 : 1) // Hide white dot artifact that appears briefly at very small scales
          .responseRegion({
            x: this.centerX - (this.innerRadius + this.ringWidth),
            y: this.centerY - (this.innerRadius + this.ringWidth),
            width: (this.innerRadius + this.ringWidth) + SHADOW_MARGIN * 2,
            height: (this.innerRadius + this.ringWidth) + SHADOW_MARGIN * 2
          })
          .translate({ x: this.nibX, y: this.nibY })
          .gesture(
            PanGesture()
              .onActionStart((event: GestureEvent) => {
                if (event.fingerList && event.fingerList.length >= 1) {
                  let globalX = event.fingerList[0].globalX;
                  let globalY = event.fingerList[0].globalY;
                  if (this.isPointInPath(globalX, globalY)) {
                    this.isValidDrag = true;
                    this.dragStartX = this.nibX;
                    this.dragStartY = this.nibY;
                    return;
                  }
                }
                this.isValidDrag = false;
              })
              .onActionUpdate((event: GestureEvent) => {
                if (this.isValidDrag === false) {
                  return;
                }
                this.nibX = this.dragStartX + event.offsetX;
                this.nibY = this.dragStartY + event.offsetY;
                this.clampNibInWindow();
              })
              .onActionEnd(() => {
                if (this.isValidDrag === false) {
                  return;
                }
                if (this.waveWheelController) {
                  this.clampNibInWindow();
                  this.waveWheelController.updatePosition({
                    x: this.centerX + this.nibX,
                    y: this.centerY + this.nibY
                  });
                }
                this.isValidDrag = false;
              })
          );
        };
      }
    }
    .clip(true)
    .backgroundColor(Color.Transparent)
    .onHover((isHover: boolean, event: HoverEvent) => {
      if (isHover) {
        if (event.sourceTool === SourceTool.Pen) {
          let x = event.windowX;
          let y = event.windowY;
          if (x === undefined || y === undefined) {
            return;
          }
          // Check if the click position is on the wave wheel.
          // If it is on the wave wheel but not within the small circles, no action should be taken.
          if (this.isPointInPath(x, y)) {
            try {
              event.stopPropagation();
            } catch (error) {

            }
            return;
          }
          this.waveWheelController?.updatePosition({ x: x, y: y });
          return;
        }
      }
    })
    .onClick((event: ClickEvent) => {
      Logger.debug(TAG,
        `click in WaveWHeelPage pos x=${event.x} y=${event.y}  dx=${event.globalDisplayX} dy=${event.globalDisplayY} wx=${event.windowX} wy=${event.windowY}`);
      // Check if the click position is on the wave wheel.
      // If it is on the wave wheel but not within the small circles, no action should be taken.
      if (this.isPointInPath(event.x, event.y)) {
        try {
          event.preventDefault();
        } catch (error) {
          const err: BusinessError = error as BusinessError;
          Logger.error(TAG, `fail to exec preventDefault error ${err.code}: ${err.message}`);
        }
        return;
      }
      if (this.windowsState !== WindowState.SHOWING) {
        this.waveWheelController?.updatePosition({ x: event.windowX, y: event.windowY });
        return;
      }
      this.hideWithAnimation();
    });
  }
}