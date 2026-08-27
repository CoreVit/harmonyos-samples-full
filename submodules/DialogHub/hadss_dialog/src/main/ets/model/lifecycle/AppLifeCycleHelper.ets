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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { uiObserver as observer, UIContext } from '@kit.ArkUI';
import { PageDialogStack, PageDialogStackInterface } from './base/PageDialogStack';
import { DialogStatus } from '../../common/constant/DialogStatus';
import { DialogType } from '../../common/constant/DialogType';
import { CommonDialog } from '../dialog/base/CommonDialog';
import { GlobalDialogLifeCycleHelper } from './GlobalDialogLifeCycleHelper';
import { CustomDialog } from '../dialog/base/CustomDialog';
import { CommonUtils } from '../../common/util/CommonUtils';

export class AppLifeCycleHelper {
  private static instance: AppLifeCycleHelper;
  private ctx: UIContext | null = null;
  private hostContext: Context | null = null;
  // current page id
  private curPageId: string = '-1';
  // Current navDestinationId, -1 indicates navBar or a pure page
  private curNavDestinationId = '-1';
  // Store the navDestination information for each page
  private dialogStack: Map<string, PageDialogStackInterface> = new Map();
  // Store the top dialog of the current page
  private curTopDialog: CommonDialog | null = null;
  private curPageDialogStack: PageDialogStackInterface | null = null;
  private routerPageUpdateCallBackFunc: (info: RouterPageInfo) => void = () => {};
  private navDestinationSwitchCallBackFunc: (info: observer.NavDestinationSwitchInfo) => void = () => {};
  private configurationUpdateCallBackId: number = -1;

  private constructor(ctx: UIContext) {
    this.ctx = ctx;
    this.pageRouteListener();
  }

  // Get the singleton instance of AppLifeCycleHelper
  // Note: The `uiContext` must be provided during the initial initialization.
  public static getInstance(ctx?: UIContext): AppLifeCycleHelper {
    if (!AppLifeCycleHelper.instance && ctx !== undefined) {
      AppLifeCycleHelper.instance = new AppLifeCycleHelper(ctx);
    }
    return AppLifeCycleHelper.instance;
  }

  private pageRouteListener() {
    this.monitorDialogsLifecycle();
    this.activeGlobalObserver();
  }

  private monitorDialogsLifecycle() {
    GlobalDialogLifeCycleHelper.getInstance().addListener({
      // Store the popup that was displayed in the target `navDestination` of the target page in the `dialogStack`.
      onShow: (dialog: CommonDialog) => {
        let tempPageDialogStack = this.dialogStack.get(this.curPageId) ?? new PageDialogStack();
        let dialogArray = tempPageDialogStack.destinationStack.get(this.curNavDestinationId) ?? [];
        if (this.existsDialogWithSameId(dialogArray, dialog.dialogId)) {
          return;
        }
        let displayedDialogArray = tempPageDialogStack.displayedDialogMap.get(this.curNavDestinationId) ?? [];
        dialogArray.push(dialog);
        displayedDialogArray.push(dialog);
        tempPageDialogStack.destinationStack.set(this.curNavDestinationId, dialogArray);
        tempPageDialogStack.displayedDialogMap.set(this.curNavDestinationId, displayedDialogArray);
        this.dialogStack.set(this.curPageId, tempPageDialogStack); // Update the topmost popup.
        if (!CommonUtils.isSheetDialog(dialog)) { // Ignore sheet dialogs.
          if ((dialog as CustomDialog).getLimitPolicy().alwaysTop) {
            this.curTopDialog = dialog;
          }
        }
      },
      onDismiss: (dialog: CommonDialog) => {
        this.removeDialog(dialog);
      }
    })
  }

  private removeDialog(dialog: CommonDialog) {
    let curPageDialogStack_ = this.dialogStack.get(this.curPageId)
    if (!curPageDialogStack_) {
      return;
    }
    let curPageDialogs = curPageDialogStack_.destinationStack.get(this.curNavDestinationId);
    const updatedDialogs = curPageDialogs?.filter(item => item.dialogId !== dialog.dialogId) ?? [];
    if (curPageDialogs && updatedDialogs.length < curPageDialogs.length) {
      curPageDialogStack_.destinationStack.set(this.curNavDestinationId, updatedDialogs);
    }

    let curDisplayedDialogs = curPageDialogStack_.displayedDialogMap.get(this.curNavDestinationId);
    if (!curDisplayedDialogs) {
      return;
    }
    const updatedDisplayedDialogs = curDisplayedDialogs.filter(item => item.dialogId !== dialog.dialogId);
    if (updatedDisplayedDialogs.length < curDisplayedDialogs.length) {
      curPageDialogStack_.displayedDialogMap.set(this.curNavDestinationId, updatedDisplayedDialogs);
    }
  }

  private monitorRouterPageUpdate(uiContext: UIContext | undefined | null) {
    this.routerPageUpdateCallBackFunc = (info: RouterPageInfo) => {
      if (info.state === observer.RouterPageState.ON_PAGE_SHOW) {
        let curPageDialogStack_ = this.dialogStack.get(this.curPageId);
        if (!curPageDialogStack_) {
          this.curPageId = info.pageId;
          this.curNavDestinationId = '-1';
          this.dialogStack.set(this.curPageId, new PageDialogStack());
          return;
        }
        this.curPageDialogStack = curPageDialogStack_;
        if (this.curPageId != info.pageId) {
          this.updateCurPageDisplayedDialogs();
          // Hide the popup on the current page based on `curPageId` + `curNavDestinationId`.
          this.curPageDialogStack?.hideCurrentPageDialogs(); // update current page id
          this.curPageId = info.pageId;
          this.curPageDialogStack = this.dialogStack.get(this.curPageId) ?? null;
          this.curPageDialogStack?.showNavDestinationDialogs(this.curPageDialogStack?.topNavDestinationId);
          this.curNavDestinationId = this.curPageDialogStack?.topNavDestinationId ?? '-1';
        } else {
          // Resolve the issue of triggering this lifecycle
          // when the application switches between the foreground and background.
          return;
        }
      } else if (info.state === observer.RouterPageState.ABOUT_TO_DISAPPEAR) {
        const tempPageDialogStack = this.dialogStack.get(info.pageId);
        tempPageDialogStack?.destroyCurrentPageDialogs();
        this.dialogStack.delete(info.pageId)
      } else {
        return; // Do Nothing
      }
    }
    uiContext?.getUIObserver().on('routerPageUpdate', this.routerPageUpdateCallBackFunc)
  }

  private monitorNavDestinationSwitch(uiContext: UIContext | undefined | null) {
    this.navDestinationSwitchCallBackFunc = (info: observer.NavDestinationSwitchInfo) => {
      let curPageDialogStack_ = this.dialogStack.get(this.curPageId);

      let willShowNavDestinationId = '';
      if (info.to === 'navBar') {
        willShowNavDestinationId = '-1';
      } else {
        willShowNavDestinationId = (info.to as NavDestinationInfo).navDestinationId;
      }

      if (!curPageDialogStack_) {
        let tempPageDialogStack = new PageDialogStack();
        tempPageDialogStack.topNavDestinationId = willShowNavDestinationId; // update topNavDestinationId
        this.dialogStack.set(this.curPageId, tempPageDialogStack);
        this.curNavDestinationId = willShowNavDestinationId;
        return;
      }

      // Update the popups displayed on the current page before switching page navigation.
      if (info.operation === NavigationOperation.PUSH) {
        this.updateCurPageDisplayedDialogs();
      }

      this.curPageDialogStack = curPageDialogStack_;

      if (!this.curPageId || this.curPageId === '-1' || this.curPageId.trim().length === 0) {
        hilog.error(0x0010, 'navDestinationSwitch', 'System navigation lifecycle error.');
      } else {
        // For dialogs in the from-NavDestination, execute the hide operation when the operation is push (page entry);
        // for other operations (pop: page exit, replace: page replacement), execute the destroy operation.
        if (info.operation === NavigationOperation.PUSH) {
          this.curPageDialogStack?.hideCurrentPageDialogs();
        } else {
          this.curPageDialogStack?.destroyNavDestinationDialogs(this.curNavDestinationId);
        } // Display all dialogs in the to-navDestination
        this.curPageDialogStack?.showNavDestinationDialogs(willShowNavDestinationId);
      }
      this.curNavDestinationId =
        willShowNavDestinationId; // update navDestinationId of the top NavDestination in the stack
      this.curPageDialogStack.topNavDestinationId = willShowNavDestinationId;
    }
    uiContext?.getUIObserver().on('navDestinationSwitch', this.navDestinationSwitchCallBackFunc);
  }

  private monitorConfiguration(uiContext: UIContext | null) {
    this.hostContext = uiContext?.getHostContext() ?? null;
    this.configurationUpdateCallBackId = this.hostContext?.getApplicationContext().on('environment', {
      onConfigurationUpdated: () => {
        this.dialogStack.forEach(navStack => {
          navStack.destinationStack.forEach(dialogs => {
            dialogs.forEach(dialog => {
              if (dialog.getStatus() !== DialogStatus.DEFAULT) {
                dialog.update(['Configuration'])
              }
            })
          })
        })
      },
      onMemoryLevel: () => {}
    }) ?? -1
  }

  /**
   * Update the popups displayed on the current page
   * to distinguish whether they were actively closed by the developer or passively closed due to page navigation.
   */
  private updateCurPageDisplayedDialogs() {
    let tempPageDialogStack = this.dialogStack.get(this.curPageId) ?? new PageDialogStack();
    let displayedDialogArray = tempPageDialogStack.displayedDialogMap.get(this.curNavDestinationId) ?? [];
    displayedDialogArray = this.getCurrentPageDialogs(undefined, undefined, undefined, DialogStatus.SHOW).reverse();
    tempPageDialogStack.displayedDialogMap.set(this.curNavDestinationId, displayedDialogArray);
    this.dialogStack.set(this.curPageId, tempPageDialogStack);
  }

  private activeGlobalObserver() {
    this.monitorNavDestinationSwitch(this.ctx);
    this.monitorRouterPageUpdate(this.ctx);
    this.monitorConfiguration(this.ctx);
  }

  private deactivateGlobalObserver() {
    this.ctx?.getUIObserver().off('navDestinationSwitch', this.navDestinationSwitchCallBackFunc);
    this.ctx?.getUIObserver().off('routerPageUpdate', this.routerPageUpdateCallBackFunc);
    this.hostContext?.getApplicationContext().off('environment', this.configurationUpdateCallBackId);
  }

  /**
   * Restart global observer for page routes and navigation
   */
  restartGlobalObserver() {
    this.deactivateGlobalObserver();
    this.activeGlobalObserver();
  }

  /**
   * Filter the dialogs under the current page based on dialog ID, dialog type, dialog template name, and dialog status
   * @param dialogId Dialog id
   * @param type Dialog type
   * @param modelName Dialog model name
   * @param dialogStatus Dialog status
   * @returns CommonDialog[] , Collection of dialogs that meet the filtering criteria
   */
  getCurrentPageDialogs(dialogId?: string, type?: DialogType, modelName?: string,
    dialogStatus?: DialogStatus): CommonDialog[] { // The window in the `Default` state is not bound to the page,
    // so querying for popups in the `DialogStatus.DEFAULT` state returns an empty array.
    if (dialogStatus === DialogStatus.DEFAULT) {
      return [];
    }
    return this.dialogStack.get(this.curPageId)?.getNavDestinationDialogs(this.curNavDestinationId).slice()
      .reverse()
      .filter((dialog: CommonDialog) => {
        return ((dialogId === undefined || dialog.dialogId === dialogId) &&
          (type === undefined || dialog.type === type) && (modelName === undefined || dialog.modelName === modelName) &&
          (dialogStatus === undefined || dialog.getStatus() === dialogStatus));
      }) ?? [];
  }

  // Get the topmost popup on the current page.
  getCurPageTopDialog(): CommonDialog | null {
    return this.curTopDialog;
  }

  setCurPageTopDialog(dialog: CommonDialog) {
    this.curTopDialog = dialog;
  }

  updateCurPageTopDialogLayerIndex(layerIndex: number) {
    if (!CommonUtils.isSheetDialog(this.curTopDialog)) {
      (this.curTopDialog as CustomDialog).resetIndex(layerIndex, true);
    }
  }

  private existsDialogWithSameId(dialogs: CommonDialog[], dialogId: string): boolean {
    return dialogs.some(item => item.dialogId === dialogId);
  }
}