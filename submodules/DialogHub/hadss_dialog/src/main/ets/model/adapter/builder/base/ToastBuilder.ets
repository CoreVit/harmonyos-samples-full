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
import { DialogAction } from '../../../../common/been/DialogAction';
import { ToastOption } from '../../../../common/been/option/base/ToastOption';
import { DefaultContent } from '../../../../common/been/option/DefaultContent';
import { DialogMode } from '../../../../common/common';
import { CommonUtils } from '../../../../common/util/CommonUtils';
import { ObjectUtils } from '../../../../common/util/ObjectUtils';
import { DHubLogger } from '../../../../log/DHubLogger';
import { DialogError } from '../../../../log/ErrorCode';
import { ToastDialog } from '../../../dialog/base/ToastDialog';
import { InfToast } from '../../../dialog/interface/InfToast';
import { InfBuilder } from '../../interface/InfBuilder';
import { ToastProxy } from '../../proxy/base/ToastProxy';


/**
 * Popup builder, based on CommonDialogBuilder, not support custom styles.
 * */
export class ToastBuilder extends ToastProxy implements InfBuilder {
  constructor(uiContext: UIContext, builderOptions?: ToastOption) {
    super(uiContext, builderOptions);
  }

  build<T extends Object>(params?: T): InfToast {
    if (params) {
      if (typeof this.builderOptions.customContentParam === 'function') {
        this.builderOptions.customContentParam = this.builderOptions.customContentParam({
          dismiss: () => {
            dialog.dismiss();
          }, show: () => {
            dialog.show();
          }
        } as DialogAction);
      }
      if (!ObjectUtils.areSameClassPrototype(params, this.builderOptions.customContentParam)) {
        if ((typeof (params) === 'string') && (this.builderOptions.customContentParam) instanceof DefaultContent) {
          this.builderOptions.customContentParam = new DefaultContent(params);
        } else {
          DHubLogger.error(DialogError.PARAMETER_INCONSISTENCY);
          throw new Error('The params and WrappedBuilder entries are inconsistent.');
        }
      } else {
        CommonUtils.copyOptions(this.builderOptions.customContentParam, params);
      }
    }
    if (this.builderOptions.dialogMode == DialogMode.CUSTOM_DIALOG) {
      if (this.builderOptions.passThroughGesture) {
        DHubLogger.error(DialogError.PARAMETER_INCONSISTENCY);
        DHubLogger.error('The CustomDialog mode toast dose not support passThroughGesture');
      }
    }
    let dialog = new ToastDialog(this.uiContext, this.builderOptions, this.builderOptions.lifeCycleConfig);
    return dialog;
  }
}