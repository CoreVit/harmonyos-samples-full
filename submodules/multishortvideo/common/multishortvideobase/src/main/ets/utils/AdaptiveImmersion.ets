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
 *
 */

import { ImmersionManager } from './ImmersionManager';

export class AdaptiveImmersion {
  public static getImmersionInfo(videoSize: Size, windowSize: Size, statusBarHeight: number,
    bottomTabHeight: number): ImmersionInfo | undefined {
    if (videoSize.height === 0 || videoSize.width === 0) {
      return;
    }
    try {
      const videoRatio: number = videoSize.width / videoSize.height;
      const windowWidth = windowSize.width;
      const windowHeight = windowSize.height;
      const windowRatio = windowWidth / windowHeight;
      const adaptiveImmersionRuleCalFunc = ImmersionManager.getInstance().getImmersionRuleCalFunc({
        videoRatio: videoRatio,
        windowWidth: windowWidth,
        windowRatio: windowRatio
      });
      return adaptiveImmersionRuleCalFunc(videoSize, windowSize, bottomTabHeight, statusBarHeight!);
    } catch (err) {
      return undefined;
    }
  }
}

export interface ImmersionInfo {
  videoSize: Size,
  videoPosition: Position,
  immersionSetting: ImmersionSetting
}

export interface ImmersionSetting {
  isStatusBarImmersive: boolean,
  isBottomTabImmersive: boolean
}