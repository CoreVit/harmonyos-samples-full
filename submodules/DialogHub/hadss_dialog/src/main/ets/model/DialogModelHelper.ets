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
import { BaseOption } from '../common/been/option/base/BaseOption';
import { CommonUtils } from '../common/util/CommonUtils';
import { DHubLogger } from '../log/DHubLogger';
import { DEFINED_ERROR, DialogError, DialogErrorInfo } from '../log/ErrorCode';
import { PresetCustom } from './adapter/template/preset/PresetCustom';
import { PresetPopup } from './adapter/template/preset/PresetPopup';
import { PresetSheet } from './adapter/template/preset/PresetSheet';
import { PresetToast } from './adapter/template/preset/PresetToast';

export class DialogModelHelper {
  private static models: Map<string, BaseOption> = new Map<string, BaseOption>();

  public static set(modelName: string, builderOptions: BaseOption) {
    let newValue = new BaseOption();
    CommonUtils.copyOptions(newValue, builderOptions);
    DialogModelHelper.models.set(modelName, newValue);
  }

  public static create(modelName: string, builderOptions: BaseOption): DialogErrorInfo {
    if (DialogModelHelper.query(modelName)) {
      DHubLogger.error(DialogError.ERR_TEMPLATE_ALREADY_EXIST, modelName);
      return {
        errorCode: DEFINED_ERROR[DialogError.ERR_TEMPLATE_ALREADY_EXIST].errorCode,
        errorMsg: 'The template with the name ' + modelName + ' already exist.'
      };
    }

    DialogModelHelper.set(modelName, builderOptions);
    return {
      errorCode: 0,
      errorMsg: 'The template with the name ' + modelName + ' create success.'
    };
  }

  public static update(modelName: string, builderOptions: BaseOption): DialogErrorInfo {
    if (!DialogModelHelper.query(modelName)) {
      DHubLogger.error(DialogError.ERR_TEMPLATE_WITHOUT, modelName);
      return {
        errorCode: DEFINED_ERROR[DialogError.ERR_TEMPLATE_ALREADY_EXIST].errorCode,
        errorMsg: 'The template with the name ' + modelName + ' does not exist.'
      };
    }

    DialogModelHelper.set(modelName, builderOptions);
    return {
      errorCode: 0,
      errorMsg: 'The template with the name ' + modelName + ' update success.'
    };
  }

  public static get(modelName: string | PresetToast | PresetPopup | PresetSheet | PresetCustom): BaseOption | null {
    // Copy operation.
    let model = DialogModelHelper.models.get(modelName.toString());
    if (model) {
      let res = new BaseOption();
      CommonUtils.copyOptions(res, model);
      return res;
    }
    DHubLogger.error(DialogError.ERR_TEMPLATE_WITHOUT, modelName);
    return null;
  }

  public static remove(modelName: string): boolean {
    if (DialogModelHelper.query(modelName)) {
      DialogModelHelper.models.delete(modelName);
      DHubLogger.info('The template with the name %s remove success.', modelName);
      return true;
    }
    DHubLogger.error(DialogError.ERR_TEMPLATE_WITHOUT, modelName);
    return false;
  }

  public static query(modelName: string): boolean {
    if (DialogModelHelper.models.has(modelName)) {
      return true;
    }
    return false;
  }
}
