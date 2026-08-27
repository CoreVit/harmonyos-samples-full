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
import { DialogConfig, DialogMode } from '../../../../common/been/config/DialogConfig';
import { DialogAnimation } from '../../../../common/been/DialogAnimation';
import { CustomOption } from '../../../../common/been/option/base/CustomOption';
import { DialogType } from '../../../../common/constant/DialogType';
import { CommonUtils } from '../../../../common/util/CommonUtils';
import { AnimatorFactory } from '../../../animation/AnimatorFactory';
import { DialogAdaptorProxy } from './DialogAdaptorProxy';
import { LevelMode } from '@kit.ArkUI';
import { DialogHub } from '../../../DialogHub';


/**
 * Builder of OverlayManager, based on DialogBuilder
 * */
export abstract class CustomProxy extends DialogAdaptorProxy {
  protected builderOptions: CustomOption = new CustomOption();

  constructor(uiContext: UIContext, builderOptions?: CustomOption) {
    super(uiContext)
    if (builderOptions) {
      CommonUtils.copyOptions(this.builderOptions, builderOptions, true, true);
    }
    this.builderOptions.type = DialogType.CUSTOM;
  }

  setLayerIndex(layerIndex: number) {
    this.builderOptions.layerIndex = layerIndex;
    return this;
  }

  setLevelMode(levelMode: LevelMode) {
    this.builderOptions.levelMode = levelMode;
    return this;
  }

  setLevelUniqueId(levelUniqueId: number) {
    this.builderOptions.levelUniqueId = levelUniqueId;
    return this;
  }

  setAnimation(dialogAnimation: DialogAnimation) {
    let animationCopy: DialogAnimation = {}
    animationCopy.duration = dialogAnimation.duration ?? this.builderOptions.animation.duration ?? 300;
    if (dialogAnimation.dialogAnimation && !(dialogAnimation.dialogAnimation instanceof TransitionEffect)) {
      animationCopy.dialogAnimation =
        AnimatorFactory.getAnimationEffect(dialogAnimation.dialogAnimation, animationCopy.duration);
    } else {
      animationCopy.dialogAnimation = dialogAnimation.dialogAnimation;
    }
    if (dialogAnimation.customMaskAnimation && !(dialogAnimation.customMaskAnimation instanceof TransitionEffect)) {
      animationCopy.customMaskAnimation =
        AnimatorFactory.getAnimationEffect(dialogAnimation.customMaskAnimation, animationCopy.duration);
    } else {
      animationCopy.customMaskAnimation = dialogAnimation.customMaskAnimation;
    }
    this.builderOptions.animation = animationCopy;
    return this
  }

  setConfig(config: DialogConfig) {
    if (config.dialogBehavior) {
      CommonUtils.copyOptions(this.builderOptions, config.dialogBehavior, true, true);
    }
    if (config.dialogPosition) {
      if (config.dialogPosition.alignment !== undefined) {
        this.builderOptions.alignment = config.dialogPosition.alignment;
      }
      if (config.dialogPosition.offset !== undefined) {
        this.builderOptions.offset = config.dialogPosition.offset;
      }
    }
    if (config.dialogMode != undefined) {
      this.builderOptions.dialogMode = config.dialogMode;
    } else {
      this.builderOptions.dialogMode = DialogHub.getMode();
    }
    return this;
  }
}