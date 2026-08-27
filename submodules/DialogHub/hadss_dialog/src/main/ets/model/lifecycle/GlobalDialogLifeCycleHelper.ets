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
import { DialogDismissReason } from '../../common/constant/DialogDismissReason';
import { CommonDialog } from '../dialog/base/CommonDialog';
import { ListenerManager } from '../ListenerManager';
import { GlobalDialogLifeCycle } from './GlobalDialogLifeCycle';

/**
 * dialog life cycle description.
 */
export class GlobalDialogLifeCycleHelper extends ListenerManager<GlobalDialogLifeCycle> {
  private static instance: GlobalDialogLifeCycleHelper;

  private constructor() {
    super();
  }

  public static getInstance() {
    if (GlobalDialogLifeCycleHelper.instance == null) {
      GlobalDialogLifeCycleHelper.instance = new GlobalDialogLifeCycleHelper();
    }
    return GlobalDialogLifeCycleHelper.instance;
  }

  /**
   * dispatch dialog show life cycle.
   *
   */
  public dispatchShow(dialog: CommonDialog): void {
    this.listeners.forEach((lifecycle) => {
      lifecycle.onShow?.(dialog);
    });
  }

  /**
   * dispatch dialog willShow life cycle.
   *
   */
  public dispatchWillShow(dialog: CommonDialog): boolean {
    let willShow: boolean = true;
    this.listeners.forEach((lifecycle) => {
      if (lifecycle.onWillShow && !lifecycle.onWillShow(dialog)) {
        willShow = false;
      }
    });
    return willShow;
  }

  /**
   * dispatch dialog hide life cycle
   * @param dialog
   */
  public dispatchHide(dialog: CommonDialog): void {
    this.listeners.forEach((lifecycle) => {
      lifecycle.onHide?.(dialog);
    });
  }

  /**
   * dispatch dialog will hide life cycle
   * @param dialog
   * @returns whether the dialog will hide
   */
  public dispatchWillHide(dialog: CommonDialog): boolean {
    let willHide: boolean = true;
    this.listeners.forEach((lifecycle) => {
      if (lifecycle.onWillHide && !lifecycle.onWillHide(dialog)) {
        willHide = false;
      }
    });
    return willHide;
  }

  /**
   * dispatch dialog dismiss life cycle.
   *
   */
  public dispatchDismiss(dialog: CommonDialog): void {
    this.listeners.forEach((lifecycle) => {
      lifecycle.onDismiss?.(dialog);
    });
  }

  /**
   * dispatch dialog willDismiss life cycle.
   *
   */
  public dispatchWillDismiss(dialog: CommonDialog, reason: DialogDismissReason): boolean {
    let willDismiss: boolean = true;
    this.listeners.forEach((lifecycle) => {
      if (lifecycle.onWillDismiss && !lifecycle.onWillDismiss(dialog, reason)) {
        willDismiss = false;
      }
    });
    return willDismiss;
  }
}
