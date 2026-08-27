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
import { DialogMode } from '../../../common/been/config/DialogConfig';
import { SheetBehavior } from '../../../common/been/config/SheetBehavior';
import { SheetOption } from '../../../common/been/option/base/SheetOption';
import { SheetStyle } from '../../../common/been/style/SheetStyle';
import { DialogStatus } from '../../../common/constant/DialogStatus';
import { CompUtils } from '../../../common/util/CompUtils';
import { DHubLogger } from '../../../log/DHubLogger';
import { DialogError } from '../../../log/ErrorCode';
import { SheetLifeCycleHelper } from '../../lifecycle/DialogLifeCycleHelper';
import { GlobalDialogLifeCycleHelper } from '../../lifecycle/GlobalDialogLifeCycleHelper';
import { SheetLifeCycle } from '../../lifecycle/SheetLifeCycle';
import { BindSheetExecutor } from '../executor/BindSheetExecutor';
import { InfSheet } from '../interface/InfSheet';
import { CommonDialog } from './CommonDialog';

/**
 * Popup instance encapsulated based on the system BindSheet.
 * Encapsulated Bind instances, based on systematic CommonDialog, support custom content.
 * */
export class SheetDialog extends CommonDialog implements InfSheet {
  protected lifeCycleHelper: SheetLifeCycleHelper = new SheetLifeCycleHelper();

  constructor(uiContext: UIContext, options: SheetOption, lifeCycle: SheetLifeCycle) {
    super(uiContext, options, lifeCycle);
    if (Reflect.ownKeys(lifeCycle).length > 0) {
      this.addLifeCycleListener(lifeCycle);
    }
    // Synchronize popup status when the built-in sheet dialog close method is called.
    this.dialogExecutor = new BindSheetExecutor(uiContext, options as SheetOption, () => {
      this.isShown = false;
      this.dialogStatus = DialogStatus.DEFAULT;
      this.lifeCycleHelper.dispatchDismiss();
      GlobalDialogLifeCycleHelper.getInstance().dispatchDismiss(this);
    });
    (this.builderOptions as SheetOption).sheetLifeCycleConfig.onWillDismiss = (reason) => {
      return this.lifeCycleHelper.dispatchWillDismiss(reason);
    };
    (this.builderOptions as SheetOption).sheetLifeCycleConfig.onWillSpringBackWhenDismiss = (action) => {
      this.lifeCycleHelper.dispatchWillSpringBackWhenDismiss(action);
    };
    (this.builderOptions as SheetOption).sheetLifeCycleConfig.onHeightDidChange = (height) => {
      this.lifeCycleHelper.dispatchHeightDidChange(height);
    };
    (this.builderOptions as SheetOption).sheetLifeCycleConfig.onDetentsDidChange = (detents) => {
      this.lifeCycleHelper.dispatchDetentsDidChange(detents);
    };
    (this.builderOptions as SheetOption).sheetLifeCycleConfig.onWidthDidChange = (width) => {
      this.lifeCycleHelper.dispatchWidthDidChange(width);
    };
    (this.builderOptions as SheetOption).sheetLifeCycleConfig.onTypeDidChange = (type) => {
      this.lifeCycleHelper.dispatchTypeDidChange(type);
    };
  }

  updateConfig(config: SheetBehavior): void {
    (this.builderOptions as SheetOption).enableOutsideInteractive = config.enableOutsideInteractive;
    (this.builderOptions as SheetOption).scrollSizeMode = config.scrollSizeMode;
    this.update(['enableOutsideInteractive', 'scrollSizeMode']);
  }

  public resetHeight(height: SheetSize | Dimension): void {
    this.builderOptions.height = height;
    this.update(['height']);
  }

  public updateStyle(style: SheetStyle): void {
    super.updateStyle(style);
  }

  public show(isInsideCall?: boolean | undefined): boolean {
    let compId = (this.builderOptions as SheetOption).targetCompId;
    if (!compId) {
      DHubLogger.error(DialogError.TARGET_COMP_ID_EMPTY);
      return false;
    } else if (!CompUtils.isIdValid(this.uiContext, compId)) {
      DHubLogger.error(DialogError.TARGET_NODE_INVALID, compId);
      return false;
    }
    (this.builderOptions as SheetOption).targetCompUniqueId = this.uiContext.getFrameNodeById(compId)?.getUniqueId();
    return super.show(isInsideCall);
  }

  getMode(): DialogMode {
    return DialogMode.CUSTOM_DIALOG;
  }
}