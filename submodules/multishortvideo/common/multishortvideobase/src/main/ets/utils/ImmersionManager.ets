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

import { Size } from '@kit.ArkUI';
import { DEFAULT_IMMERSION_CALCULATION_FUNC, DEFAULT_IMMERSION_RULES } from './ImmersionRules';

export interface AdaptiveImmersionRule {
  videoRatio: number[][],
  windowWidthRange: number[][],
  windowRatioRange: number[][],
  immersionCalculationFunc: (
    videoSize: Size,
    windowSize: Size,
    bottomTabHeight: number,
    statusBarHeight: number
  ) => ImmersionInfo;
}

export interface InputInfo {
  videoRatio: number,
  windowWidth: number,
  windowRatio: number
}

export interface ImmersionSetting {
  isStatusBarImmersive: boolean,
  isBottomTabImmersive: boolean
}

export interface ImmersionInfo {
  videoSize: Size,
  videoPosition: Position,
  immersionSetting: ImmersionSetting
}

export class ImmersionManager {
  private static instance: ImmersionManager;
  private readonly tag: string = ImmersionManager.name;

  private constructor() {
  }

  public static getInstance(): ImmersionManager {
    if (!ImmersionManager.instance) {
      ImmersionManager.instance = new ImmersionManager();
    }
    return ImmersionManager.instance;
  }

  public getImmersionRules(): AdaptiveImmersionRule[] {
    return DEFAULT_IMMERSION_RULES;
  }

  public getImmersionRuleCalFunc(inputInfo: InputInfo) {
    if (inputInfo) {
      return DEFAULT_IMMERSION_RULES.find((item: AdaptiveImmersionRule) => {
        return (this.inRanges(inputInfo.videoRatio, item.videoRatio) &&
          this.inRanges(inputInfo.windowWidth, item.windowWidthRange) &&
          this.inRanges(inputInfo.windowRatio, item.windowRatioRange))
      })?.immersionCalculationFunc || DEFAULT_IMMERSION_CALCULATION_FUNC;
    } else {
      return DEFAULT_IMMERSION_CALCULATION_FUNC;
    }
  }

  private inRanges(value: number, ranges: number[][]): boolean {
    for (let i = 0; i < ranges.length; i++) {
      let left = ranges[i][0];
      let right = ranges[i][1];
      if (left <= value && value < right) {
        return true;
      }
    }
    return false;
  }
}
