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

import { window } from '@kit.ArkUI';
import type { BusinessError } from '@kit.BasicServicesKit';
import { Constants } from '../common/Constants';
import Logger from './Logger';

const TAG: string = '[BreakpointSystem]';

export enum BreakpointTypeEnum {
  XS = 'xs',
  SM = 'sm',
  MD = 'md',
  LG = 'lg',
  XL = 'xl',
}

export interface BreakpointTypes<T> {
  xs?: T;
  sm: T;
  md: T;
  lg: T;
  xl?: T;
}

export class BreakpointType<T> {
  private xs: T;
  private sm: T;
  private md: T;
  private lg: T;
  private xl: T;

  public constructor(param: BreakpointTypes<T>) {
    this.xs = param.xs || param.sm;
    this.sm = param.sm;
    this.md = param.md;
    this.lg = param.lg;
    this.xl = param.xl || param.lg;
  }

  public getValue(currentBreakpoint: string): T {
    if (currentBreakpoint === BreakpointTypeEnum.XS) {
      return this.xs;
    }
    if (currentBreakpoint === BreakpointTypeEnum.SM) {
      return this.sm;
    }
    if (currentBreakpoint === BreakpointTypeEnum.MD) {
      return this.md;
    }
    if (currentBreakpoint === BreakpointTypeEnum.XL) {
      return this.xl;
    }
    return this.lg;
  }
}

export class BreakpointSystem {
  private static instance: BreakpointSystem;
  private currentWidthBreakpoint: BreakpointTypeEnum = BreakpointTypeEnum.MD;
  private currentHeightBreakpoint: BreakpointTypeEnum = BreakpointTypeEnum.LG;

  private constructor() {
    AppStorage.setOrCreate(Constants.KEY_PREFIX + 'CurrentWidthBreakpoint', this.currentWidthBreakpoint);
    AppStorage.setOrCreate(Constants.KEY_PREFIX + 'CurrentHeightBreakpoint', this.currentHeightBreakpoint);
  }

  public static getInstance(): BreakpointSystem {
    if (!BreakpointSystem.instance) {
      BreakpointSystem.instance = new BreakpointSystem();
    }
    return BreakpointSystem.instance;
  }

  public updateCurrentWidthBreakpoint(widthBreakpoint: BreakpointTypeEnum): void {
    if (this.currentWidthBreakpoint !== widthBreakpoint) {
      this.currentWidthBreakpoint = widthBreakpoint;
      AppStorage.setOrCreate(Constants.KEY_PREFIX + 'CurrentWidthBreakpoint', this.currentWidthBreakpoint);
    }
  }

  public updateCurrentHeightBreakpoint(heightBreakpoint: BreakpointTypeEnum): void {
    if (this.currentHeightBreakpoint !== heightBreakpoint) {
      this.currentHeightBreakpoint = heightBreakpoint;
      AppStorage.setOrCreate(Constants.KEY_PREFIX + 'CurrentHeightBreakpoint', this.currentHeightBreakpoint);
    }
  }

  public onWindowSizeChange(window: window.Window): void {
    this.updateWidthHeightBp(window);
  }

  public updateWidthHeightBp(window: window.Window): void {
    try {
      const mainWindow: window.WindowProperties = window.getWindowProperties();
      const windowWidth: number = mainWindow.windowRect.width;
      const windowHeight: number = mainWindow.windowRect.height;
      const windowWidthVp = window.getUIContext().px2vp(windowWidth);
      const windowHeightVp = window.getUIContext().px2vp(windowHeight);
      const windowRatio: number = windowHeightVp / windowWidthVp;
      let widthBp: BreakpointTypeEnum = BreakpointTypeEnum.SM;
      let heightBp: BreakpointTypeEnum = BreakpointTypeEnum.LG;

      if (windowWidthVp < 320) {
        widthBp = BreakpointTypeEnum.XS;
      } else if (windowWidthVp >= 320 && windowWidthVp < 600) {
        widthBp = BreakpointTypeEnum.SM;
      } else if (windowWidthVp >= 600 && windowWidthVp < 840) {
        widthBp = BreakpointTypeEnum.MD;
      } else if (windowWidthVp >= 840 && windowWidthVp < 1440) {
        widthBp = BreakpointTypeEnum.LG;
      } else {
        widthBp = BreakpointTypeEnum.XL;
      }
      this.updateCurrentWidthBreakpoint(widthBp);
      this.updateCurrentHeightBreakpoint(heightBp)
    } catch (error) {
      Logger.error(TAG, '%{public}s',
        `UpdateBreakpoint fail. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
  }
}