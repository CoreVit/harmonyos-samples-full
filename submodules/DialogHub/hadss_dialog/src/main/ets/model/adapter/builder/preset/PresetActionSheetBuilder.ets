/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { ActionSheetContent } from '../../../../common/been/option/base/preset/PresetContent';
import { ActionSheetOption } from '../../../../common/been/option/base/preset/PresetOption';
import { CommonUtils } from '../../../../common/util/CommonUtils';
import { ObjectUtils } from '../../../../common/util/ObjectUtils';
import { DHubLogger } from '../../../../log/DHubLogger';
import { DialogError } from '../../../../log/ErrorCode';
import { SheetDialog } from '../../../dialog/base/SheetDialog';
import { InfSheet } from '../../../dialog/interface/InfSheet';
import { ActionSheetProxy } from '../../proxy/preset/ActionSheetProxy';

export class PresetActionSheetBuilder extends ActionSheetProxy {
  private constructor(uiContext: UIContext, builderOptions?: ActionSheetOption) {
    super(uiContext, builderOptions);
  }

  public static getInstance(uiContext: UIContext, builderOptions?: ActionSheetOption): PresetActionSheetBuilder {
    return new PresetActionSheetBuilder(uiContext, builderOptions);
  }

  build(params?: string | ActionSheetContent): InfSheet {
    if (params) {
      if (!ObjectUtils.areSameClassPrototype(params, this.builderOptions.customContentParam)) {
        if ((typeof (params) === 'string')) {
          this.builderOptions.customContentParam = new ActionSheetContent(params);
        } else {
          DHubLogger.error(DialogError.PARAMETER_INCONSISTENCY);
          throw new Error('The params and WrappedBuilder entries are inconsistent.');
        }
      } else {
        CommonUtils.copyOptions(this.builderOptions.customContentParam, params);
      }
    }
    let param = this.builderOptions.customContentParam;
    if (!param.text && !param.title && !param.sheetList) {
      DHubLogger.warn("ActionSheetDialog doesn't contains anything, it may show nothing in dialog");
    }
    let dialog = new SheetDialog(this.uiContext, this.builderOptions, this.builderOptions.lifeCycleConfig);
    this.setDialog(dialog);
    return dialog;
  }
}