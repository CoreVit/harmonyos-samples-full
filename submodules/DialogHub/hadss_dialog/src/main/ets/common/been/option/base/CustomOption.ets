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
import { deviceInfo } from '@kit.BasicServicesKit';
import { AnimatorFactory } from '../../../../model/animation/AnimatorFactory';
import { AnimationType } from '../../../constant/AnimationType';
import { TopDialogPriority } from '../../../constant/TopDialogPriority';
import { CustomKeyboardAvoidMode, DialogLayerPolicy, DialogMode } from '../../config/DialogConfig';
import { DialogAnimation } from '../../DialogAnimation';
import { BaseOption } from './BaseOption';

@Observed
export class CustomOption extends BaseOption {
  constructor() {
    super()
    // The default animation Settings require code optimization
    this.setAnimation(this.animation);
  }

  setAnimation(dialogAnimation: DialogAnimation) {
    let animationCopy: DialogAnimation = {};
    animationCopy.duration = dialogAnimation.duration ?? 300;
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
    this.animation = animationCopy;
    return this
  }

  public animation: DialogAnimation = {
    duration: 300,
    dialogAnimation: AnimationType.FADE_IN_AND_OUT,
    customMaskAnimation: AnimationType.FADE_IN_AND_OUT
  };
  public isShow: boolean = true; // Internal properties that control popup animation
  public keyboardAvoidMode: CustomKeyboardAvoidMode = CustomKeyboardAvoidMode.INPUT_AVOID; // Keyboard avoidance mode
  public keyboardAvoidSpace: Dimension = 0; // Avoidance distance
  public autoKeyboardAvoidMode: boolean = true;
  public isModal: boolean = true; // Whether to open the enlightenment layer
  public maskRect?: Rectangle; // Size and location of the mask layer
  // Whether the pop-up window itself transmits gestures such as clicking and sliding. It is disabled by default.
  public passThroughGesture: boolean = false;
  // Eject policy
  public layerPolicy: DialogLayerPolicy = { alwaysTop: false, topDialogPriority: TopDialogPriority.NEW_FIRST };
  public autoDismiss: boolean = true; // Click whether the popup mask closes automatically, which defaults to true
  // Whether to shift the current focus to the popup when the popup pops up
  public requestFocusWhenShow: boolean = false;
  public focusable: boolean = false; // Easy to implement at runtime requestFocusWhenShow

  public alignment: DialogAlignment = DialogAlignment.Center;
  public position?: Position;
  public markAnchor?: Position;
  public offset: Offset = { dx: 0, dy: 0 };
  public layerIndex: number = 0;

  public levelMode?: LevelMode;
  public levelUniqueId?: number;

  public dialogMode?: DialogMode;
  public backgroundColor: ResourceColor = 'rgb(241,243,245)';
  public borderWidth: number = 1;
  public borderColor: ResourceColor = Color.White;
  public radius: number = deviceInfo.deviceType === '2in1' ? 16 : 32;
  public shadow: ShadowOptions = {
    radius: 20,
    color: '#29000000',
    offsetY: 8
  };
}