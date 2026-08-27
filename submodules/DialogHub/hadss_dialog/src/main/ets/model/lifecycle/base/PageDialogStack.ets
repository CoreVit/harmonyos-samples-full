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

import { CommonDialog } from '../../dialog/base/CommonDialog';
import { DialogDismissReason } from '../../../common/constant/DialogDismissReason';
import { CustomDialog } from '../../dialog/base/CustomDialog';
import { DialogMode } from '../../../common/been/config/DialogConfig';

export interface PageDialogStackInterface {
  /**
   * NavDestinationId of the top NavDestination in the stack
   */
  topNavDestinationId: string;

  /**
   * Store the array of dialog objects contained in each navDestination under the current page
   */
  destinationStack: Map<string, CommonDialog[]>;

  /**
   * Store the array of displayed dialog objects contained in each navDestination under the current page
   */
  displayedDialogMap: Map<string, CommonDialog[]>;

  /**
   * Destroy all dialogs under the current page
   */
  destroyCurrentPageDialogs(): void;

  /**
   * Get all dialogs under the current page
   * @returns
   */
  getCurrentPageDialogs(): CommonDialog[];

  /**
   * Get all popups in a specific navDestination under the current page
   * @returns
   */
  getNavDestinationDialogs(navDestinationId: string): CommonDialog[];

  /**
   * Destroy all dialogs contained in the navDestination corresponding to navDestinationId under the current page
   * @param navDestinationId
   */
  destroyNavDestinationDialogs(navDestinationId: string): void;

  /**
   * Hide all dialogs in the current page (in top navDestination)
   */
  hideCurrentPageDialogs(): void;

  /**
   * Show all dialogs contained in the navDestination corresponding to navDestinationId under the current page
   * @param navDestinationId
   */
  showNavDestinationDialogs(navDestinationId: string): void;
}

export class PageDialogStack implements PageDialogStackInterface {
  public topNavDestinationId: string = '-1';
  public destinationStack: Map<string, CommonDialog[]> = new Map();
  // To distinguish whether a popup was actively hidden by the developer or
  // passively hidden due to page navigation stacking,
  // it is necessary to record the currently visible popup in `navDestination`.
  public displayedDialogMap: Map<string, CommonDialog[]> = new Map(); // value: displayed dialogs array

  destroyCurrentPageDialogs(): void {
    for (let dialogArray of this.destinationStack.values()) {
      dialogArray.forEach(dialog => {
        dialog?.dismiss(DialogDismissReason.CLOSE_PAGE_DESTROY);
      })
    }
    this.destinationStack.clear(); // Clear the `destinationStack` of the current `Page`.
    this.displayedDialogMap.clear();
  }

  destroyNavDestinationDialogs(navDestinationId: string): void {
    let dialogArray: CommonDialog[] = this.destinationStack.get(navDestinationId) ?? [];
    for (let dialog of dialogArray) {
      dialog?.dismiss(DialogDismissReason.CLOSE_PAGE_DESTROY);
    }
    this.destinationStack.delete(navDestinationId); // Delete the `navDestination` with the corresponding ID.
    this.displayedDialogMap.delete(navDestinationId);
  }

  getCurrentPageDialogs(): CommonDialog[] {
    return Array.from(this.destinationStack.values()).flatMap((dialogs: CommonDialog[]) => dialogs)
  }

  getNavDestinationDialogs(navDestinationId: string): CommonDialog[] {
    return this.destinationStack.get(navDestinationId) ?? [];
  }

  hideCurrentPageDialogs(): void {
    let dialogArray: CommonDialog[] | undefined = this.destinationStack.get(this.topNavDestinationId);
    if (dialogArray === undefined) {
      return;
    }
    for (let dialog of dialogArray) {
      // when turn to another page, whether hide current dialog or not determine to the dialog mode
      if ((dialog as CustomDialog).getMode() != DialogMode.CUSTOM_DIALOG) {
        dialog?.hide(true);
      }
    }
  }

  // Note: It is important to distinguish between popups that are actively hidden by the developer and
  // those that are passively hidden due to page navigation stacking.
  // Page A -> Page B: The popup in A is hidden;
  // Page B -> Page A: The popup in A that was passively hidden due to the page stacking operation should be shown,
  // while the popup that was actively closed by the user remains hidden.
  showNavDestinationDialogs(navDestinationId: string): void {
    let dialogArray: CommonDialog[] | undefined = this.displayedDialogMap.get(navDestinationId);
    if (dialogArray === undefined) {
      return;
    }
    for (let dialog of dialogArray) {
      // when back to previous page, whether show current dialog or not determine to the dialog mode
      if ((dialog as CustomDialog).getMode() != DialogMode.CUSTOM_DIALOG) {
        dialog?.show(true);
      }
    }
  }
}