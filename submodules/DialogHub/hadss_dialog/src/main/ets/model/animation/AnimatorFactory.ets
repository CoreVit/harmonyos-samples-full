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
import { display } from '@kit.ArkUI';
import { AnimationType } from '../../common/constant/AnimationType';
import { catchError } from '../../common/util/catchError';
import { DialogHub } from '../DialogHub';

export class AnimatorFactory {
  @catchError()
  static getAnimationEffect(animationType: AnimationType, duration: number): TransitionEffect | undefined {
    switch (animationType) {
      case AnimationType.BOTTOM_UP:
        return TransitionEffect.OPACITY.animation({ duration: duration })
          .combine(TransitionEffect.translate({
            y: DialogHub.getUIContext().px2vp(display.getDefaultDisplaySync().height)
          }));
      case AnimationType.UP_DOWN:
        return TransitionEffect.OPACITY.animation({ duration: duration })
          .combine(TransitionEffect.translate({
            y: DialogHub.getUIContext().px2vp(-display.getDefaultDisplaySync().height)
          }));
      case AnimationType.LEFT_TO_RIGHT:
        return TransitionEffect.OPACITY.animation({ duration: duration })
          .combine(TransitionEffect.translate({
            x: DialogHub.getUIContext().px2vp(-display.getDefaultDisplaySync().width)
          }));
      case AnimationType.RIGHT_TO_LEFT:
        return TransitionEffect.OPACITY.animation({ duration: duration })
          .combine(TransitionEffect.translate({
            x: DialogHub.getUIContext().px2vp(display.getDefaultDisplaySync().width)
          }));
      case AnimationType.FADE_IN_AND_OUT:
        return TransitionEffect.OPACITY.animation({ duration: duration });
      case AnimationType.NONE:
      default:
        return undefined;
    }
  }
}
