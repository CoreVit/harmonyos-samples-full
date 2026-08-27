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

import { UIContext } from '@kit.ArkUI';
import { DialogStatus } from '../common/constant/DialogStatus';
import { DialogType } from '../common/constant/DialogType';
import { TopDialogPriority } from '../common/constant/TopDialogPriority';
import { CommonUtils } from '../common/util/CommonUtils';
import { CommonDialog } from './dialog/base/CommonDialog';
import { CustomDialog } from './dialog/base/CustomDialog';
import { AppLifeCycleHelper } from './lifecycle/AppLifeCycleHelper';
import { GlobalDialogLifeCycleHelper } from './lifecycle/GlobalDialogLifeCycleHelper';

export class DialogLimitPolicyHelper {
  private static instance: DialogLimitPolicyHelper;
  private ctx: UIContext | null = null;
  private appLifeCycleHelper: AppLifeCycleHelper | null = null;

  private constructor(ctx: UIContext) {
    this.ctx = ctx;
    this.appLifeCycleHelper = AppLifeCycleHelper.getInstance(ctx);
    this.dialogsInterceptor(this.ctx);
  }

  public static getInstance(ctx?: UIContext) {
    if (!DialogLimitPolicyHelper.instance && ctx !== undefined) {
      DialogLimitPolicyHelper.instance = new DialogLimitPolicyHelper(ctx);
    }
    return DialogLimitPolicyHelper.instance;
  }

  adjustLayerIndex(dialog: CommonDialog) {
    // When adjusting the layer of dialogs, ensure that the topmost dialog has the highest z-index
    if (CommonUtils.isSheetDialog(dialog)) {
      return;
    }
    const topDialog = this.appLifeCycleHelper?.getCurPageTopDialog();
    if (CommonUtils.isSheetDialog(topDialog)) {
      return;
    }
    const updatedLayerIndex =
      Math.max((topDialog as CustomDialog).getLayerIndex(), (dialog as CustomDialog).getLayerIndex() + 1);
    this.appLifeCycleHelper?.updateCurPageTopDialogLayerIndex(updatedLayerIndex);
  }

  public getDialogLayerIndex(dialog: CommonDialog): number {
    // SheetDialog is the bottom layer
    if (dialog.type === DialogType.SHEET) {
      return Number.MIN_VALUE;
    } else {
      return (dialog as CustomDialog).getLayerIndex()
    }
  }

  private dialogsInterceptor(ctx: UIContext) {
    GlobalDialogLifeCycleHelper.getInstance().addListener({
      onWillShow: (dialog: CommonDialog) => {
        // If newDialog is a non pinned pop-up and there is a pinned pop-up on the current Page
        // adjust the pinned pop-up level accordingly
        if (CommonUtils.isSheetDialog(dialog)) {
          return true;
        }
        const topDialog = this.getCurrentTopDialog();
        const newCustomDialog = dialog as CustomDialog;
        if (!newCustomDialog.getLimitPolicy().alwaysTop && topDialog) {
          let topDialog_ = topDialog as CustomDialog;
          const updatedLayerIndex = Math.max(topDialog_.getLayerIndex(), newCustomDialog.getLayerIndex() + 1);
          topDialog_.resetIndex(updatedLayerIndex, true);
        }

        return this.resolveTopDialogConflicts(ctx, dialog);
      }
    }
    )
  }

  // Execute the conflict resolution strategy for multiple topmost dialogs
  private resolveTopDialogConflicts(ctx: UIContext, newDialog: CommonDialog): boolean {
    // If the new dialog or current top dialog is a SheetDialog, it will popup directly.
    const topDialog = this.getCurrentTopDialog()
    if (CommonUtils.isSheetDialog(newDialog) || CommonUtils.isSheetDialog(topDialog)) {
      return true;
    }

    const newCustomDialog = newDialog as CustomDialog;
    if (!newCustomDialog.getLimitPolicy().alwaysTop) {
      return true;
    }

    // The current page's top pop-up window is empty or not displayed
    if (!topDialog || topDialog.getStatus() !== DialogStatus.SHOW) {
      // When the current page has no topmost dialog or the top dialog is not displayed
      this.appLifeCycleHelper?.setCurPageTopDialog(newDialog);
      this.updateTopDialogLayerIndex(ctx, newCustomDialog);
    } else if (topDialog.dialogId === newDialog.dialogId) {
      // When the pop-up window is closed and then displayed again,
      // it will still go to onWillShow. In this case, the pop-up conflict strategy is not used
    } else {
      // When the current page has topmost dialog
      // Only consider the top pop ups in real-life situations,
      // and do not consider pop ups in hide, miss, or default states
      if (!this.handleDialogConflict(newCustomDialog, topDialog as CustomDialog)) {
        return false; // 拦截
      }
    }
    return true;
  }

  // Get the topmost dialog of the current page
  private getCurrentTopDialog(): CommonDialog | null | undefined {
    return this.appLifeCycleHelper?.getCurPageTopDialog();
  }

  private updateTopDialogLayerIndex(ctx: UIContext, topDialog: CustomDialog) {
    const visibleDialogs = this.getVisibleAndHiddenDialogs(ctx).filter(dialog =>!CommonUtils.isSheetDialog(dialog));
    const maxLayerIndex = visibleDialogs.length > 0
      ? Math.max(...visibleDialogs.map((dialog): number => (dialog as CustomDialog).getLayerIndex()))
      : 0;
    const updatedLayerIndex = Math.max(topDialog.getLayerIndex(), maxLayerIndex + 1);
    // Set the 'inside' property to true to avoid circular dependencies
    topDialog.resetIndex(updatedLayerIndex, true);
  }

  // Handle conflicts between new dialogs and the current topmost dialog
  private handleDialogConflict(newDialog: CustomDialog, topDialog: CustomDialog): boolean {
    const limitPolicy = topDialog.getLimitPolicy();
    if (limitPolicy.alwaysTop) {
      switch (limitPolicy.topDialogPriority) {
        case TopDialogPriority.NEW_FIRST:
          topDialog.setAlwaysTopToFalse();
          this.appLifeCycleHelper?.setCurPageTopDialog(newDialog);
          newDialog.resetIndex(Math.max(newDialog.getLayerIndex(), topDialog.getLayerIndex() + 1), true);
          break;
        case TopDialogPriority.OLD_FIRST:
          return false; // Prevent new dialogs from being displayed
      }
    } else if (newDialog.getLayerIndex() >= topDialog.getLayerIndex()) {
      // Set the 'inside' property to true to avoid circular dependencies
      topDialog.resetIndex(newDialog.getLayerIndex() + 1, true);
    }
    return true;
  }

  private getVisibleAndHiddenDialogs(ctx: UIContext): CommonDialog[] {
    return AppLifeCycleHelper.getInstance(ctx)
      .getCurrentPageDialogs()
      .filter(dialog => dialog.getStatus() === DialogStatus.SHOW || dialog.getStatus() === DialogStatus.HIDE);
  }
}