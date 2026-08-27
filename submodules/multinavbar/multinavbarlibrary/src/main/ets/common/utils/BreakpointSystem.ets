/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { Constants } from '../Constants';
import Logger from './Logger';

const TAG: string = '[BreakpointSystem]';

export enum BreakpointTypeEnum {
  XS = 'xs',
  SM = 'sm',
  MD = 'md',
  LG = 'lg',
  XL = 'xl',
}

export enum BreakpointWidthEnum {
  WIDTH_XS = 320,
  WIDTH_SM = 600,
  WIDTH_MD = 840,
  WIDTH_LG = 1440,
}

export interface BreakpointTypes<T> {
  xs?: T;
  sm: T;
  md: T;
  lg: T;
  xl: T;
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
    this.xl = param.xl;
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
  private currentBreakpoint: BreakpointTypeEnum = BreakpointTypeEnum.MD;

  private constructor() {
  }

  public static getInstance(): BreakpointSystem {
    if (!BreakpointSystem.instance) {
      BreakpointSystem.instance = new BreakpointSystem();
      AppStorage.setOrCreate(Constants.KEY_BREAKPOINT, BreakpointTypeEnum.MD);
    }
    return BreakpointSystem.instance;
  }

  public updateCurrentBreakpoint(breakpoint: BreakpointTypeEnum): void {
    if (this.currentBreakpoint !== breakpoint) {
      this.currentBreakpoint = breakpoint;
      AppStorage.setOrCreate(Constants.KEY_BREAKPOINT, this.currentBreakpoint);
    }
  }

  public onWindowSizeChange(window: window.Window): void {
    this.updateWidthBp(window);
  }

  public updateWidthBp(window: window.Window): void {
    try {
      const mainWindow: window.WindowProperties = window.getWindowProperties();
      const windowWidth: number = mainWindow.windowRect.width;
      const windowWidthVp: number = window.getUIContext()?.px2vp(windowWidth);
      let widthBp: BreakpointTypeEnum = BreakpointTypeEnum.MD;
      if (windowWidthVp < BreakpointWidthEnum.WIDTH_XS) {
        widthBp = BreakpointTypeEnum.XS;
      } else if (windowWidthVp >= BreakpointWidthEnum.WIDTH_XS && windowWidthVp < BreakpointWidthEnum.WIDTH_SM) {
        widthBp = BreakpointTypeEnum.SM;
      } else if (windowWidthVp >= BreakpointWidthEnum.WIDTH_SM && windowWidthVp < BreakpointWidthEnum.WIDTH_MD) {
        widthBp = BreakpointTypeEnum.MD;
      } else if (windowWidthVp >= BreakpointWidthEnum.WIDTH_MD && windowWidthVp < BreakpointWidthEnum.WIDTH_LG) {
        widthBp = BreakpointTypeEnum.LG;
      } else {
        widthBp = BreakpointTypeEnum.XL;
      }
      this.updateCurrentBreakpoint(widthBp);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `UpdateBreakpoint fail, error code: ${err.code}, message: ${err.message}`);
    }
  }
}