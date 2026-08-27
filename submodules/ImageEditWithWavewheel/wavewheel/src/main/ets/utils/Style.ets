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

import { display } from '@kit.ArkUI';
import type { EntranceStyle } from '../model/Model';
import { deviceInfo } from '@kit.BasicServicesKit';
import { BreakPointInfo, MyHeightBreakpoint, MyWidthBreakpoint } from './BreakPointInfo';
import Logger from './Logger';

export const FOLD_ENTRANCE_CIRCLE_RADIUS = 220;

export const FOLD_ENTRANCE_CIRCLE_WIDTH = 80;

export const FOLD_ENTRANCE_CIRCLE_SIZE = 36;

export const FOLD_ENTRANCE_CIRCLE_MARGIN = 4;

export const FOLD_ENTRANCE_CIRCLE_PADDING = 7;

export const FOLD_BUTTON_IMG_SIZE = 20;

export const FOLD_BUTTON_WIDTH = 64;

export const FOLD_BUTTON_HEIGHT = 64;

export const FOLD_BUTTON_FONT_SIZE = 12;

export const FOLD_QUICK_BUTTON_POSITION_X = 12;

export const FOLD_QUICK_BUTTON_POSITION_Y = 8;

export const FOLD_CAPTURE_BUTTON_POSITION_X = 42;

export const FOLD_CAPTURE_BUTTON_POSITION_Y = 70;

export const FOLD_ANNOTATION_BUTTON_POSITION_X = 94;

export const FOLD_ANNOTATION_BUTTON_POSITION_Y = 120;

export const FOLD_SEARCH_BUTTON_POSITION_X = 150;

export const FOLD_SEARCH_BUTTON_POSITION_Y = 148;

export const FOLD_BUTTON_CIRCLE_BORDER_SIZE_NORMAL = 0;

export const FOLD_BUTTON_CIRCLE_BORDER_SIZE_FOCUS = 2;

export const FOLD_TEXT_POPUP_PADDING = 10;

export const FOLD_TEXT_POPUP_BORDER_RADIUS = 16;

export const FOLD_TEXT_POPUP_SHADOW_RADIUS = 0;

export const ENTRANCE_CIRCLE_RADIUS = 245;

export const ENTRANCE_CIRCLE_WIDTH = 90;

export const ENTRANCE_CIRCLE_SIZE = 40;

export const ENTRANCE_CIRCLE_MARGIN = 4;

export const ENTRANCE_CIRCLE_PADDING = 7;

export const BUTTON_IMG_SIZE = 20;

export const BUTTON_WIDTH = 64;

export const BUTTON_HEIGHT = 64;

export const BUTTON_FONT_SIZE = 12;

export const QUICK_BUTTON_POSITION_X = 16;

export const QUICK_BUTTON_POSITION_Y = 8;

export const CAPTURE_BUTTON_POSITION_X = 46;

export const CAPTURE_BUTTON_POSITION_Y = 78;

export const ANNOTATION_BUTTON_POSITION_X = 106;

export const ANNOTATION_BUTTON_POSITION_Y = 134;

export const SEARCH_BUTTON_POSITION_X = 174;

export const SEARCH_BUTTON_POSITION_Y = 166;

export const BUTTON_CIRCLE_BORDER_SIZE_NORMAL = 0;

export const BUTTON_CIRCLE_BORDER_SIZE_FOCUS = 2;

export const TEXT_POPUP_PADDING = 10;

export const TEXT_POPUP_BORDER_RADIUS = 16;

export const TEXT_POPUP_SHADOW_RADIUS = 0;

export const DEL_PIXEL_RATIO: number = 2.65;

export const GLB_PIXEL_RATIO: number = 2.25;

// If folded, the ring width and radius will be multiplied by this coefficient
export function getFoldRatio(context: UIContext, isFold: boolean = false): number {
  if (isFold === true) {
    let pixelRatio = isDEL() ? DEL_PIXEL_RATIO : GLB_PIXEL_RATIO;
    return pixelRatio / context.vp2px(1);
  }
  return 1;
}

export function getRingWidthVp(context: UIContext, isFold: boolean = false): number {
  const RING_WIDTH_VP: number = 81;
  return RING_WIDTH_VP * getFoldRatio(context, isFold);
}

export function getInnerRadiusVp(context: UIContext, isFold: boolean): number {
  const INNER_RADIUS_VP: number = 101;
  return INNER_RADIUS_VP * getFoldRatio(context, isFold);
}


const TAG: string = 'Style';

// Cache object for storing computed results
const ratioCache: Record<string, number> = {};

// The ratio here is essentially the device's standard display ratio vp2px(1)
export function getDefaultRatio(windowWidth: number, windowHeight: number): number {
  // Return default value if no parameters are provided

  if (isDEL()) {
    // X7
    return 3.125;
  }

  if (isGRL()) {
    return 2.9;
  }
  // Generate cache key
  const cacheKey = `${windowWidth}-${windowHeight}`;

  // Check if result is already in cache
  if (ratioCache[cacheKey] !== undefined) {
    Logger.debug(TAG, `ratio=${ratioCache[cacheKey]}`);
    return ratioCache[cacheKey];
  }

  let widthBreakPoint = BreakPointInfo.getWindowWidthBreakpoint(windowWidth);
  let heightBreakPoint = BreakPointInfo.getWindowHeightBreakpoint(windowWidth, windowHeight);
  let result: number;

  if (widthBreakPoint >= MyWidthBreakpoint.WIDTH_LG && heightBreakPoint >= MyHeightBreakpoint.HEIGHT_LG ||
    widthBreakPoint >= MyWidthBreakpoint.WIDTH_LG && heightBreakPoint >= MyHeightBreakpoint.HEIGHT_SM
  ) {
    //pad
    result = 2.25;
  } else if (widthBreakPoint === MyWidthBreakpoint.WIDTH_HP && heightBreakPoint === MyHeightBreakpoint.HEIGHT_SM ||
    widthBreakPoint === MyWidthBreakpoint.WIDTH_MD && heightBreakPoint === MyHeightBreakpoint.HEIGHT_LG
  ) {
    result = 2.75;
  } else {
    result = 2.25;
  }

  // Store result to cache
  ratioCache[cacheKey] = result;
  return result;
}

export function pixel2Fp(context: UIContext | undefined, pxValue: number): number {
  const defaultRes: number = pxValue / 2.25 * 1.0;
  try {
    if (context) {
      return pxValue / context.fp2px(1);
    } else {
      return defaultRes;
    }
  } catch (e) {
    Logger.error(TAG, `pixel2Fp failed`);
    return defaultRes
  }
}

export function fpAdaptDefault(context: UIContext, fpValue: number, windowWidth: number, windowHeight: number): number {
  return pixel2Fp(context, fpValue * getDefaultRatio(windowWidth, windowHeight));
}

function glbFixFp(context: UIContext | undefined, value: number, windowWidth: number, windowHeight: number): number {
  return pixel2Fp(context, value * getDefaultRatio(windowWidth, windowHeight));
}

export function glbFixVp(context: UIContext | undefined, value: number): number {
  const vp2px: number = context ? context.vp2px(1) : 1;
  if (isFoldState()) {
    if (isDEL()) {
      return value * 2.65 / vp2px;
    }
    return value * 2.25 / vp2px;
  }
  if (isNovaSeries()) {
    return value * 2.55 / vp2px;
  }
  return value * 2.9 / vp2px;
}

export function isFoldState(): boolean {
  try {
    let status = display.getFoldStatus();
    return status === display.FoldStatus.FOLD_STATUS_FOLDED ||
      status === display.FoldStatus.FOLD_STATUS_EXPANDED_WITH_SECOND_HALF_FOLDED;
  } catch (err) {
    Logger.error(TAG, `getFoldState failed`);
    return false;
  }
}

export function isNovaSeries(): boolean {
  let series = deviceInfo.productSeries;
  return series === 'TLR' || series === 'MIA' || series === 'MRT' || series === 'TYR';
}

export function isDEL(): boolean {
  let series = deviceInfo.productSeries;
  return series === 'DEL';
}

export function isGRL(): boolean {
  let series = deviceInfo.productSeries;
  return series.startsWith('GRL');
}

export function fixFp(context: UIContext, value: number, windowWidth: number, windowHeight: number): number {
  if (isFoldState() || isNovaSeries()) {
    if (isDEL()) {
      return value * 2.65 / context.fp2px(1);
    }
    return value * 2.25 / context.fp2px(1);
  }
  return value * getDefaultRatio(windowWidth, windowHeight) / context.fp2px(1);
}

function setWindowSize(obj: EntranceStyle, width: number, height: number): void {
  obj.windowsWidth = width;
  obj.windowsHeight = height;
}

class PhoneEntranceStyle implements EntranceStyle {
  public windowsWidth: number = 0;
  public windowsHeight: number = 0;
  public context?: UIContext;
  private static instance: PhoneEntranceStyle | null = null;

  static getInstance(): PhoneEntranceStyle {
    if (PhoneEntranceStyle.instance === null) {
      PhoneEntranceStyle.instance = new PhoneEntranceStyle();
    }
    return PhoneEntranceStyle.instance;
  }

  private constructor() {
  }

  public init(context: UIContext): void {
    this.context = context;
  }

  setWindowSize(width: number, height: number): void {
    setWindowSize(this, width, height);
  }

  public buttonTextMaxLine: number = 1;
  public buttonFontFamily: Resource = $r('sys.string.ohos_id_text_font_family_regular');
  public buttonFontColor: ResourceColor = $r('sys.color.ohos_id_color_text_primary');
  public buttonCircleColorNormal: ResourceColor = $r('sys.color.ohos_id_color_button_normal');
  public buttonCircleBorderColor: ResourceColor = $r('sys.color.ohos_id_color_focused_outline');
  public buttonCircleColorHover: ResourceColor = $r('sys.color.ohos_id_color_hover');
  public buttonCircleColorPressed: ResourceColor = $r('sys.color.ohos_id_color_click_effect');
  public buttonImgFillColor: ResourceColor = $r('sys.color.ohos_id_color_primary');
  public buttonDisableAlpha: Resource = $r('sys.float.ohos_id_alpha_disabled');
  public buttonEnableAlpha: Resource = $r('sys.float.ohos_id_alpha_content_primary');

  get buttonCircleSize(): number {
    let buttonCircleSize = glbFixFp(this.context, ENTRANCE_CIRCLE_SIZE, this.windowsWidth, this.windowsHeight);
    return buttonCircleSize;
  }

  get buttonCircleMargin(): number {
    return glbFixVp(this.context, ENTRANCE_CIRCLE_MARGIN);
  }

  get buttonCirclePadding(): number {
    return glbFixVp(this.context, ENTRANCE_CIRCLE_PADDING);
  }

  get buttonImgSize(): number {
    return glbFixFp(this.context, BUTTON_IMG_SIZE, this.windowsWidth, this.windowsHeight);
  }

  get buttonWidth(): number {
    return glbFixVp(this.context, BUTTON_WIDTH);
  }

  get buttonHeight(): number {
    return glbFixVp(this.context, BUTTON_HEIGHT);
  }

  get buttonFontSize(): number {
    return glbFixFp(this.context, BUTTON_FONT_SIZE, this.windowsWidth, this.windowsHeight);
  }

  get buttonCircleBorderSizeNormal(): number {
    return glbFixVp(this.context, BUTTON_CIRCLE_BORDER_SIZE_NORMAL);
  }

  get buttonCircleBorderSizeFocus(): number {
    return glbFixVp(this.context, BUTTON_CIRCLE_BORDER_SIZE_FOCUS);
  }

  public textpopUpShadowColor: string = '#3300000';
}

export const phoneEntranceStyle = PhoneEntranceStyle.getInstance();

class FoldPhoneEtranceStyle implements EntranceStyle {
  public windowsWidth: number = 0;
  public windowsHeight: number = 0;
  public context?: UIContext;
  private static instance: FoldPhoneEtranceStyle | null = null;

  static getInstance(): FoldPhoneEtranceStyle {
    if (FoldPhoneEtranceStyle.instance === null) {
      FoldPhoneEtranceStyle.instance = new FoldPhoneEtranceStyle();
    }
    return FoldPhoneEtranceStyle.instance;
  }

  private constructor() {
  }

  public init(context: UIContext): void {
    this.context = context;
  }

  setWindowSize(width: number, height: number): void {
    setWindowSize(this, width, height);
  }

  get buttonCircleSize(): number {
    if (this.context === undefined) {
      return 1;
    }
    let foldCircleSize = glbFixVp(this.context, FOLD_ENTRANCE_CIRCLE_SIZE);
    return foldCircleSize;
  }

  get buttonCircleMargin(): number {
    if (this.context === undefined) {
      return 1;
    }
    return glbFixVp(this.context, FOLD_ENTRANCE_CIRCLE_MARGIN);
  }

  get buttonCirclePadding(): number {
    if (this.context === undefined) {
      return 1;
    }
    return glbFixVp(this.context, FOLD_ENTRANCE_CIRCLE_PADDING);
  }

  get buttonImgSize(): number {
    if (this.context === undefined) {
      return 1;
    }
    return glbFixVp(this.context, FOLD_BUTTON_IMG_SIZE);
  }

  get buttonWidth(): number {
    if (this.context === undefined) {
      return 1;
    }
    return glbFixVp(this.context, FOLD_BUTTON_WIDTH);
  }

  get buttonHeight(): number {
    if (this.context === undefined) {
      return 1;
    }
    return glbFixVp(this.context, FOLD_BUTTON_HEIGHT);
  }

  get buttonFontSize(): number {
    return glbFixFp(this.context, FOLD_BUTTON_FONT_SIZE, this.windowsWidth, this.windowsHeight);
  }

  public buttonTextMaxLine: number = 1;
  public buttonFontFamily: Resource = $r('sys.string.ohos_id_text_font_family_regular');
  public buttonFontColor: ResourceColor = $r('sys.color.ohos_id_color_text_primary');
  public buttonCircleColorNormal: ResourceColor = $r('sys.color.ohos_id_color_button_normal');

  get buttonCircleBorderSizeNormal(): number {
    return glbFixVp(this.context, FOLD_BUTTON_CIRCLE_BORDER_SIZE_NORMAL);
  }

  get buttonCircleBorderSizeFocus(): number {
    return glbFixVp(this.context, FOLD_BUTTON_CIRCLE_BORDER_SIZE_FOCUS);
  }

  public buttonCircleBorderColor: ResourceColor = $r('sys.color.ohos_id_color_focused_outline');
  public buttonCircleColorHover: ResourceColor = $r('sys.color.ohos_id_color_hover');
  public buttonCircleColorPressed: ResourceColor = $r('sys.color.ohos_id_color_click_effect');
  public buttonImgFillColor: ResourceColor = $r('sys.color.ohos_id_color_primary');
  public buttonDisableAlpha: Resource = $r('sys.float.ohos_id_alpha_disabled');
  public buttonEnableAlpha: Resource = $r('sys.float.ohos_id_alpha_content_primary');
  public textPopUpBacckgroundColorDark: Resource = $r('sys.color.ohos_id_color_dialog_bg_dark');
}

export const foldPhoneEntranceStyle = FoldPhoneEtranceStyle.getInstance();

export function fixVp(context: UIContext | undefined, value: number, windowWidth: number,
  windowHeight: number): number {
  if (!context) {
    return value * getDefaultRatio(windowWidth, windowHeight);
  }
  return value * getDefaultRatio(windowWidth, windowHeight) / context.vp2px(1);
}

class TabletEntranceStyle implements EntranceStyle {
  public windowsWidth: number = 0;
  public windowsHeight: number = 0;
  public context?: UIContext;
  private static instance: TabletEntranceStyle | null = null;

  static getInstance(): TabletEntranceStyle {
    if (TabletEntranceStyle.instance === null) {
      TabletEntranceStyle.instance = new TabletEntranceStyle();
    }
    return TabletEntranceStyle.instance;
  }

  private constructor() {
  }

  public init(context: UIContext): void {
    this.context = context;
  }

  setWindowSize(width: number, height: number): void {
    setWindowSize(this, width, height);
  }

  get buttonCircleSize(): number {
    let foldCircleSize = fixVp(this.context, ENTRANCE_CIRCLE_SIZE, this.windowsWidth, this.windowsHeight);
    return foldCircleSize;
  }

  get buttonCircleMargin(): number {
    return fixVp(this.context, ENTRANCE_CIRCLE_MARGIN, this.windowsWidth, this.windowsHeight);
  }

  get buttonCirclePadding(): number {
    return fixVp(this.context, ENTRANCE_CIRCLE_PADDING, this.windowsWidth, this.windowsHeight);
  }

  get buttonImgSize(): number {
    return fixFp(this.context!, BUTTON_IMG_SIZE, this.windowsWidth, this.windowsHeight);
  }

  get buttonWidth(): number {
    return fixVp(this.context, BUTTON_WIDTH, this.windowsWidth, this.windowsHeight);
  }

  get buttonHeight(): number {
    return fixVp(this.context, BUTTON_HEIGHT, this.windowsWidth, this.windowsHeight);
  }

  get buttonFontSize(): number {
    return fixFp(this.context!, BUTTON_FONT_SIZE, this.windowsWidth, this.windowsHeight);
  }

  public buttonTextMaxLine: number = 1;
  public buttonFontFamily: Resource = $r('sys.string.ohos_id_text_font_family_regular');
  public buttonFontColor: ResourceColor = $r('sys.color.ohos_id_color_text_primary');
  public buttonCircleColorNormal: ResourceColor = $r('sys.color.ohos_id_color_button_normal');

  get buttonCircleBorderSizeNormal(): number {
    return fixVp(this.context, BUTTON_CIRCLE_BORDER_SIZE_NORMAL, this.windowsWidth, this.windowsHeight);
  }

  get buttonCircleBorderSizeFocus(): number {
    return fixVp(this.context, BUTTON_CIRCLE_BORDER_SIZE_FOCUS, this.windowsWidth, this.windowsHeight);
  }

  public buttonCircleBorderColor: ResourceColor = $r('sys.color.ohos_id_color_focused_outline');
  public buttonCircleColorHover: ResourceColor = $r('sys.color.ohos_id_color_hover');
  public buttonCircleColorPressed: ResourceColor = $r('sys.color.ohos_id_color_click_effect');
  public buttonImgFillColor: ResourceColor = $r('sys.color.ohos_id_color_primary');
  public buttonDisableAlpha: Resource = $r('sys.float.ohos_id_alpha_disabled');
  public buttonEnableAlpha: Resource = $r('sys.float.ohos_id_alpha_content_primary');
  public textPopUpBacckgroundColorDark: Resource = $r('sys.color.ohos_id_color_dialog_bg_dark');
}

export const tabletEntranceStyle = TabletEntranceStyle.getInstance();

