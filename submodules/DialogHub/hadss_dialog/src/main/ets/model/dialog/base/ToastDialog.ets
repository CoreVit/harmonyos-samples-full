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
import { ToastOption } from '../../../common/been/option/base/ToastOption';
import { DialogDismissReason } from '../../../common/constant/DialogDismissReason';
import { DialogLifeCycle } from '../../lifecycle/DialogLifeCycle';
import { InfToast } from '../interface/InfToast';
import { CustomDialog } from './CustomDialog';

/**
 * `customDialog` encapsulated based on the system `CommonDialog`, supports updating custom content.
 * */
export class ToastDialog extends CustomDialog implements InfToast {
  private autoHideTask: number = -1;
  protected autoHideDuration: number = 3000;

  constructor(uiContext: UIContext, options: ToastOption, lifeCycle: DialogLifeCycle) {
    super(uiContext, options, lifeCycle);
    if (options.duration) {
      this.autoHideDuration = options.duration;
    }
  }

  updateDuration(duration: number): void {
    (this.builderOptions as ToastOption).duration = duration;
    this.autoHideDuration = duration;
  }

  public show() {
    let result: boolean;
    if (this.isShow()) {
      clearTimeout(this.autoHideTask);
      result = true;
    } else {
      result = super.show();
    }
    this.autoHideTask = setTimeout(() => {
      this.dismiss();
    }, this.autoHideDuration);
    return result;
  }

  public dismiss(dismissReason?: DialogDismissReason | undefined): boolean {
    let willDismiss = super.dismiss(dismissReason);
    if (willDismiss) {
      clearTimeout(this.autoHideTask);
    }
    return willDismiss;
  }
}