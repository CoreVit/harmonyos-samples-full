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

import { MenuPopupContent } from '../../../../common/been/option/base/preset/PresetContent';
import { MenuPopupOption } from '../../../../common/been/option/base/preset/PresetOption';
import { CommonUtils } from '../../../../common/util/CommonUtils';
import { ObjectUtils } from '../../../../common/util/ObjectUtils';
import { DHubLogger } from '../../../../log/DHubLogger';
import { DialogError } from '../../../../log/ErrorCode';
import { PopupDialog } from '../../../dialog/base/PopupDialog';
import { InfPopup } from '../../../dialog/interface/InfPopup';
import { MenuPopupProxy } from '../../proxy/preset/MenuPopupProxy';

export class PresetMenuPopupBuilder extends MenuPopupProxy {

  private constructor(uiContext: UIContext, builderOptions?: MenuPopupOption) {
    super(uiContext, builderOptions);
  }

  public static getInstance(uiContext: UIContext, builderOptions?: MenuPopupOption): PresetMenuPopupBuilder {
    return new PresetMenuPopupBuilder(uiContext, builderOptions);
  }

  build(params?: string | MenuPopupContent): InfPopup {
    if (params) {
      if (!ObjectUtils.areSameClassPrototype(params, this.builderOptions.customContentParam)) {
        if ((typeof (params) === 'string')) {
          this.builderOptions.customContentParam = new MenuPopupContent(params);
        } else {
          DHubLogger.error(DialogError.PARAMETER_INCONSISTENCY);
          throw new Error('The params and WrappedBuilder entries are inconsistent.');
        }
      } else {
        CommonUtils.copyOptions(this.builderOptions.customContentParam, params);
      }
    }
    let param = this.builderOptions.customContentParam;
    if (!param.text && !param.popupList) {
      DHubLogger.warn("MenuPopupDialog doesn't contains anything, it may show nothing in dialog");
    }
    let dialog = new PopupDialog(this.uiContext, this.builderOptions, this.builderOptions.lifeCycleConfig);
    this.setDialog(dialog);
    return dialog;
  }
}