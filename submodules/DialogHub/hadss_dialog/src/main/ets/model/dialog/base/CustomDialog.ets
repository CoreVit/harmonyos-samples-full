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
import { CustomOption } from '../../../common/been/option/base/CustomOption';
import { DialogDismissReason } from '../../../common/constant/DialogDismissReason';
import { TopDialogPriority } from '../../../common/constant/TopDialogPriority';
import { DialogLimitPolicyHelper } from '../../DialogLimitPolicyHelper';
import { DialogLifeCycle } from '../../lifecycle/DialogLifeCycle';
import { InfCustomDialog } from '../interface/InfCustomDialog';
import { CommonDialog } from './CommonDialog';
import { componentUtils, display } from '@kit.ArkUI';
import { KEYBOARD_ANIMATION_INTERVAL, KEYBOARD_ANIMATION_TIME } from '../../../common/constant/Consntant';
import { OverlayExecutor } from '../executor/OverlayExecutor';
import { CustomKeyboardAvoidMode, DialogConfig, DialogMode } from '../../../common/been/config/DialogConfig';
import { CommonUtils } from '../../../common/util/CommonUtils';
import { DHubLogger } from '../../../log/DHubLogger';
import { DialogHub } from '../../DialogHub';
import { CustomDialogExecutor } from '../executor/CustomDialogExecutor';
import { KeyboardAvoidHelper } from '../../KeyboardAvoidHelper';
import { DimensionUtils } from '../../../common/util/DimensionUtils';
import { catchError } from '../../../common/util/catchError';

/**
 * Encapsulated bindSheet instances, based on systematic BindSheet
 * */
export class CustomDialog extends CommonDialog implements InfCustomDialog {
  private dialogLimitPolicyHelper: DialogLimitPolicyHelper | null = null;
  private needRestoreAlwaysTop: boolean = false;
  private originalPosition: Length | undefined = undefined;
  private spaceNotEnough: boolean = false;
  // When the keyboard is pulled up, it defaults to maintaining a 16vp distance from the dialog.
  private static DEFAULT_SPACE: number = 16;
  private animationSpace: number = 0;
  private initOffset: Offset = (this.builderOptions as CustomOption).offset;

  constructor(uiContext: UIContext, options: CustomOption, lifeCycle: DialogLifeCycle) {
    super(uiContext, options, lifeCycle);
    this.dialogLimitPolicyHelper = DialogLimitPolicyHelper.getInstance(uiContext);
    if (options.dialogMode === undefined) {
      options.dialogMode = DialogHub.getMode();
    }
    if (options.dialogMode == DialogMode.CUSTOM_DIALOG) {
      this.dialogExecutor = new CustomDialogExecutor(uiContext, options as CustomOption, (reason) => {
        this.dismiss(reason);
      });
    } else {
      this.dialogExecutor = new OverlayExecutor(uiContext, options as CustomOption);
    }
  }

  // Execute the popup avoidance animation for the keyboard.
  private startKeyboardAnimation(startPos: number, space: number) {
    let count = 1;
    let animationSplitTimes = KEYBOARD_ANIMATION_TIME / KEYBOARD_ANIMATION_INTERVAL;
    let changeSpace = space / animationSplitTimes;
    let pos = startPos - changeSpace;
    let interval = setInterval(() => {
      if (count >= animationSplitTimes) {
        clearInterval(interval);
      }
      (this.builderOptions as CustomOption).offset = {
        dx: 0, dy: pos
      }
      pos = pos - changeSpace;
      count++;
      this.update(['offset']);
    }, KEYBOARD_ANIMATION_INTERVAL)
  }

  /**
   *
   * @param height  Keyboard height
   * @param processAnimation Whether to execute the dialog avoidance animation for the keyboard.
   */
  @catchError()
  public avoidKeyboard(height: number, processAnimation: boolean = false) {
    if (!this.isShow() ||
      (this.builderOptions as CustomOption).keyboardAvoidMode !== CustomKeyboardAvoidMode.CONTENT_AVOID) {
      return;
    }
    if (height > 0) { // Determine when the keyboard is pulled up.
      DHubLogger.debug('start judge');
      let rectInfo = DialogHub.getUIContext().getComponentUtils().getRectangleById(this.dialogId);
      let rectHeight = rectInfo.size.height;
      let rectOffsetY = rectInfo.screenOffset.y;
      let displayClass = display.getDefaultDisplaySync();
      // Handle spacing.
      let avoidSpace = (this.builderOptions as CustomOption).keyboardAvoidSpace;
      DHubLogger.debug('avoidSpace: %s', avoidSpace.toString());
      let avoidSpaceNum = 0;
      if (avoidSpace == null) { // The default avoidance distance for the keyboard is 16vp.
        avoidSpaceNum = CustomDialog.DEFAULT_SPACE;
      } else {
        if (typeof avoidSpace == 'string') {
          if (avoidSpace.endsWith('vp')) {
            avoidSpaceNum = parseInt(avoidSpace.substring(0, avoidSpace.length - 2));
          } else if (avoidSpace.endsWith('px')) {
            avoidSpaceNum = DialogHub.getUIContext().px2vp(parseInt(avoidSpace.substring(0, avoidSpace.length - 2)));
          }
        } else {
          avoidSpaceNum = avoidSpace as number;
        }
      }
      DHubLogger.debug('height: %d %d %d %d', rectOffsetY, rectHeight, displayClass.height, avoidSpaceNum);
      this.animationSpace =
        DialogHub.getUIContext().px2vp(rectOffsetY + rectHeight + height - displayClass.height) + avoidSpaceNum;
      const currentOffset = (this.builderOptions as CustomOption).offset.dy;
      if (this.animationSpace > 0 && (DimensionUtils.length2vp(currentOffset) + this.animationSpace) > 1) {
        // Handle the situation when the keyboard obstructs the popup.
        this.spaceNotEnough = true;
        DHubLogger.debug('offset.y: %s', currentOffset.toString());
        if (this.originalPosition == undefined) {
          this.originalPosition = currentOffset ?? 0;
        }
        DHubLogger.debug('originalPosition: %s', this.originalPosition.toString());
        DHubLogger.debug('animationSpace: %s', this.animationSpace.toString());
        if (processAnimation) {
          this.startKeyboardAnimation(this.originalPosition as number, this.animationSpace);
        } else {
          (this.builderOptions as CustomOption).offset = {
            dx: 0, dy: ((this.originalPosition as number) - this.animationSpace)
          }
          this.update(['offset']);
        }
      }
    } else if (this.spaceNotEnough) {
      this.startKeyboardAnimation((this.originalPosition as number) - this.animationSpace, -this.animationSpace);
    }
  }

  public resetIndex(index: number);

  public resetIndex(index: number,
    isInsideCall: boolean); // When `isInsideCall` is true, only internal calls are made to avoid circular dependencies.

  public resetIndex(index: number, isInsideCall?: boolean) {
    (this.builderOptions as CustomOption).layerIndex = index;
    if (!isInsideCall) {
      this.dialogLimitPolicyHelper?.adjustLayerIndex(this);
    }
    if (this.isShow()) {
      this.dialogExecutor?.resetIndex()
    }
  }

  public getLayerIndex() {
    return (this.builderOptions as CustomOption).layerIndex;
  }

  public getLimitPolicy() {
    return (this.builderOptions as CustomOption).layerPolicy ??
      { alwaysTop: false, topDialogPriority: TopDialogPriority.NEW_FIRST };
  }

  /**
   * This function is for internal calls only.
   */
  public setAlwaysTopToFalse() {
    const layerPolicy = (this.builderOptions as CustomOption)?.layerPolicy;

    if (layerPolicy) {
      if (!layerPolicy.topDialogPriority) {
        layerPolicy.topDialogPriority = TopDialogPriority.NEW_FIRST;
      }
      layerPolicy.alwaysTop = false;
      this.needRestoreAlwaysTop = true;
    }
  }

  updateConfig(config: DialogConfig): void {
    if (config.dialogBehavior) {
      CommonUtils.copyOptions((this.builderOptions as CustomOption), config.dialogBehavior, true, true);
    }
    if (config.dialogPosition) {
      CommonUtils.copyOptions((this.builderOptions as CustomOption), config.dialogPosition, true, true);
    }
    let updateKeys = Reflect.ownKeys(config).filter((value) => value !== undefined) as string[];
    super.update(updateKeys);
    this.initOffset = (this.builderOptions as CustomOption).offset;
  }

  public dismiss(dismissReason?: DialogDismissReason | undefined): boolean {
    let res = super.dismiss(dismissReason);
    if (res) {
      if (this.needRestoreAlwaysTop) {
        (this.builderOptions as CustomOption)!.layerPolicy!.alwaysTop = true;
        this.needRestoreAlwaysTop = false;
      }
      (this.builderOptions as CustomOption).focusable = false;
      this.update(['focusable']);
      // waitFor animation
      CommonUtils.doSomethingNextFrame(() => {
        (this.builderOptions as CustomOption).offset = this.initOffset;
      });
    }
    return res;
  }

  public hide(isInsideCall?: boolean): boolean {
    let res = super.hide(isInsideCall);
    if (res) {
      (this.builderOptions as CustomOption).focusable = false;
      this.update(['focusable']);
      // waitFor animation
      CommonUtils.doSomethingNextFrame(() => {
        (this.builderOptions as CustomOption).offset = this.initOffset;
      });
    }
    return res;
  }

  public show(isInsideCall?: boolean | undefined): boolean {
    let res = super.show(isInsideCall);
    //`requestFocusWhenShow`: When true, the popup requests focus immediately upon showing;
    // when false, it does not request focus by default. Uses `setTimeout` for implementation.
    if (res && (this.builderOptions as CustomOption).requestFocusWhenShow) {
      (this.builderOptions as CustomOption).focusable = true;
      this.update(['focusable']);
    } else {
      CommonUtils.doSomethingNextFrame(() => {
        // If the popup does not request focus by default when opened, first make the popup container non-focusable.
        // After the popup is displayed, modify it to be focusable so that the input field can be clicked to gain focus.
        (this.builderOptions as CustomOption).focusable = true;
        this.update(['focusable']);
      }, () => {
        let needExit = true;
        if (KeyboardAvoidHelper.getInstance().getKeyboardHeight() !== 0) {
          this.avoidKeyboard(KeyboardAvoidHelper.getInstance().getKeyboardHeight(), false);
          needExit = (this.builderOptions as CustomOption).offset.dy !== this.initOffset.dy;
        }
        return needExit;
      })
    }
    return res;
  }

  public getMode(): DialogMode {
    return (this.builderOptions as CustomOption).dialogMode!;
  }
}
