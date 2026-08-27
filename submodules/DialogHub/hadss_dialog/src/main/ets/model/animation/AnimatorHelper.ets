/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
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
import { CustomOption } from '../../common/been/option/base/CustomOption';
import { AnimationType } from '../../common/constant/AnimationType';
import { DHubLogger } from '../../log/DHubLogger';

export class AnimatorHelper {
  private builderOptions: CustomOption;
  private onStartListener?: (builderOptions: CustomOption) => void;
  private isNeedAnimation: boolean = false;;

  constructor(builderOptions: CustomOption) {
    this.builderOptions = builderOptions;
    this.isNeedAnimation =
      (builderOptions.animation?.dialogAnimation !== undefined &&
        builderOptions.animation?.dialogAnimation !== AnimationType.NONE) ||
        (builderOptions.animation?.customMaskAnimation !== undefined &&
          builderOptions.animation?.customMaskAnimation !== AnimationType.NONE);
  }

  public open(onFinishListener?: () => void) {
    this.builderOptions.isShow = true;
    this.onStartListener?.(this.builderOptions);
    setTimeout(() => {
      onFinishListener?.()
      DHubLogger.debug(`End Animation`);
    }, this.builderOptions.animation?.duration);
  }

  public close(onFinishListener?: () => void) {
    this.builderOptions.isShow = false;
    this.onStartListener?.(this.builderOptions);
    setTimeout(() => {
      onFinishListener?.()
    }, this.builderOptions.animation?.duration);
  }

  public isUseAnimation() {
    return this.isNeedAnimation;
  }

  public setOnStartListener(listener: (builderOptions: CustomOption) => void) {
    this.onStartListener = listener;
  }
}