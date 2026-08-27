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
import { SheetOption } from '../../../../common/been/option/base/SheetOption';
import { CommonUtils } from '../../../../common/util/CommonUtils';
import { ObjectUtils } from '../../../../common/util/ObjectUtils';
import { DHubLogger } from '../../../../log/DHubLogger';
import { DialogError } from '../../../../log/ErrorCode';
import { SheetDialog } from '../../../dialog/base/SheetDialog';
import { InfSheet } from '../../../dialog/interface/InfSheet';
import { InfBuilder } from '../../interface/InfBuilder';
import { SheetProxy } from '../../proxy/base/SheetProxy';

/**
 * BindSheet builder, based on DialogBuilder.
 * */
export class SheetBuilder extends SheetProxy implements InfBuilder {
  constructor(uiContext: UIContext, builderOptions?: SheetOption) {
    super(uiContext, builderOptions);
  }

  build<T extends Object>(params?: T): InfSheet {
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
        DHubLogger.error(DialogError.PARAMETER_INCONSISTENCY);
        throw new Error('The params and WrappedBuilder entries are inconsistent.');
      }
      CommonUtils.copyOptions(this.builderOptions.customContentParam, params);
    }
    let dialog = new SheetDialog(this.uiContext, this.builderOptions, this.builderOptions.lifeCycleConfig);
    return dialog;
  }
}