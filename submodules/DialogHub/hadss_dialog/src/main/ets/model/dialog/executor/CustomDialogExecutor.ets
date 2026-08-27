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

import { DialogExecutor } from './DialogExecutor';
import { ComponentContent, promptAction, PromptAction } from '@kit.ArkUI';
import { CustomOption } from '../../../common/been/option/base/CustomOption';
import { BaseDialogComponent } from '../../../components/base/BaseDialogComponent';
import { CommonUtils } from '../../../common/util/CommonUtils';
import { DialogDismissReason } from '../../../common/constant/DialogDismissReason';
import { catchError } from '../../../common/util/catchError';
import { DimensionUtils } from '../../../common/util/DimensionUtils';

export class CustomDialogExecutor extends DialogExecutor {
  private promptAction: PromptAction;
  private dialogOptions: promptAction.BaseDialogOptions = {};
  private wrappedBuilder = new WrappedBuilder<[CustomOption]>(BaseDialogComponent);
  public callBackWhenDismissSelf: Callback<DialogDismissReason>;

  constructor(uiContext: UIContext, builderOptions: CustomOption, callBack: Callback<DialogDismissReason>) {
    super(uiContext, builderOptions);
    this.promptAction = this.uiContext.getPromptAction();
    this.contentNode = new ComponentContent(this.uiContext, this.wrappedBuilder, this.builderOptions as CustomOption,
      { nestingBuilderSupported: true });
    this.callBackWhenDismissSelf = callBack;
  }

  @catchError()
  show(): void {
    CommonUtils.simpleCopy(this.builderOptions, this.dialogOptions);
    let options: CustomOption = this.builderOptions as CustomOption;
    if (!this.contentNode) {
      this.contentNode = new ComponentContent(this.uiContext, this.wrappedBuilder, options,
        { nestingBuilderSupported: true });
    }
    this.promptAction.openCustomDialog(this.contentNode, {
      isModal: options.isModal,
      maskRect: options.isModal ? options.maskRect : undefined,
      maskColor: options.isModal ? options.maskColor : undefined,
      maskTransition: options.isModal ? (options.animation.customMaskAnimation as TransitionEffect) : undefined,
      focusable: options.requestFocusWhenShow,
      levelMode: options.levelMode,
      levelUniqueId: options.levelUniqueId,
      alignment: options.alignment,
      keyboardAvoidDistance: DimensionUtils.dimension2LengthMetrics(options.keyboardAvoidSpace),
      offset: options.offset,
      autoCancel: options.autoDismiss,
      onWillDismiss: (oriAction: DismissDialogAction) => {
        let reason = DialogDismissReason.CLOSE_DIRECTLY;
        if (oriAction.reason === DismissReason.PRESS_BACK) {
          reason = DialogDismissReason.PRESS_BACK
        } else if (oriAction.reason === DismissReason.TOUCH_OUTSIDE) {
          reason = DialogDismissReason.TOUCH_OUTSIDE
        } else {
          // need do something only when DismissDialogAction.DismissReason support more action
        }
        this.callBackWhenDismissSelf(reason);
      }
    })
  }

  @catchError()
  hide(): void {
    this.promptAction.closeCustomDialog(this.contentNode);
  }

  resetIndex(): void {

  }

  @catchError()
  dismiss(): void {
    this.promptAction.closeCustomDialog(this.contentNode);
    this.contentNode?.dispose();
    this.contentNode = undefined
  }

  @catchError()
  public update(updateParams?: string[]) {
    if (updateParams && updateParams.length > 0) {
      if (updateParams.includes('Configuration')) {
        this.contentNode?.updateConfiguration();
      }
    }
    this.contentNode?.update(this.builderOptions);
  }

}