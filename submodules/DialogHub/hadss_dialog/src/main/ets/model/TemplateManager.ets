/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { ToastOption } from '../common/been/option/base/ToastOption';
import { DialogType } from '../common/constant/DialogType';
import { DHubLogger } from '../log/DHubLogger';
import { DialogError } from '../log/ErrorCode';
import { PresetIconHorizontalToastBuilder } from './adapter/builder/preset/PresetIconHorizonalToastBuilder';
import { ToastBuilder } from './adapter/builder/base/ToastBuilder';
import { DialogAdaptorProxy } from './adapter/proxy/base/DialogAdaptorProxy';
import { PresetToast } from './adapter/template/preset/PresetToast';
import { PresetPopup } from './adapter/template/preset/PresetPopup';
import { PresetSheet } from './adapter/template/preset/PresetSheet';
import { PresetCustom } from './adapter/template/preset/PresetCustom';
import { DialogHub } from './DialogHub';
import { DialogModelHelper } from './DialogModelHelper';
import { PresetIconVerticalToastBuilder } from './adapter/builder/preset/PresetIconVerticalToastBuilder';
import { CustomBuilder } from './adapter/builder/base/CustomBuilder';
import { CustomOption } from '../common/been/option/base/CustomOption';
import { BaseOption } from '../common/been/option/base/BaseOption';
import { PopupBuilder } from './adapter/builder/base/PopupBuilder';
import { PopupOption } from '../common/been/option/base/PopupOption';
import { SheetBuilder } from './adapter/builder/base/SheetBuilder';
import { SheetOption } from '../common/been/option/base/SheetOption';
import { PresetMenuPopupBuilder } from './adapter/builder/preset/PresetMenuPopupBuilder';
import { PresetActionSheetBuilder } from './adapter/builder/preset/PresetActionSheetBuilder';
import { PresetConfirmHorizontalDialogBuilder } from './adapter/builder/preset/PresetConfirmHorizontalDialogBuilder';
import { PresetConfirmVerticalDialogBuilder } from './adapter/builder/preset/PresetConfirmVerticalDialogBuilder';

export class TemplateManager {

  isTemplateExist(modelName: string) {
    return DialogModelHelper.query(modelName.toString());
  }

  private getTemplateOptions(modelName: string, dialogType: DialogType): BaseOption | null {
    let templateOptions = DialogModelHelper.get(modelName);
    if (!templateOptions) {
      return null;
    }
    if (templateOptions.type !== dialogType) {
      DHubLogger.error(DialogError.ERR_TEMPLATE_TYPE_INCONSISTENCY, modelName, DialogType[dialogType!]);
      return null;
    }
    return templateOptions;
  }

  private getPresetTemplateBuilder(modelName: number): DialogAdaptorProxy | null {
    let customProxy: DialogAdaptorProxy | null = null;
    let uiContext = DialogHub.getUIContext();
    switch (modelName) {
      case PresetToast.ICON_HORIZONTAL_TOAST:
        customProxy =
          PresetIconHorizontalToastBuilder.getInstance(uiContext);
        break;
      case PresetToast.ICON_VERTICAL_TOAST:
        customProxy =
          PresetIconVerticalToastBuilder.getInstance(uiContext);
        break;
      case PresetPopup.MENU_POPUP:
        customProxy = PresetMenuPopupBuilder.getInstance(uiContext);
        break;
      case PresetSheet.ACTION_SHEET:
        customProxy = PresetActionSheetBuilder.getInstance(uiContext);
        break;
      case PresetCustom.CONFIRM_HORIZONTAL_DIALOG:
        customProxy = PresetConfirmHorizontalDialogBuilder.getInstance(uiContext);
        break;
      case PresetCustom.CONFIRM_VERTICAL_DIALOG:
        customProxy =
          PresetConfirmVerticalDialogBuilder.getInstance(uiContext);
        break;
      default:
        DHubLogger.warn('Unexpected template name')
        break;
    }
    return customProxy;
  }

  getCustomTemplate(preset: PresetCustom.CONFIRM_HORIZONTAL_DIALOG): PresetConfirmHorizontalDialogBuilder;
  getCustomTemplate(preset: PresetCustom.CONFIRM_VERTICAL_DIALOG): PresetConfirmVerticalDialogBuilder;
  getCustomTemplate(modelName: string): CustomBuilder | null;
  getCustomTemplate(modelName: string | PresetCustom.CONFIRM_HORIZONTAL_DIALOG | PresetCustom.CONFIRM_VERTICAL_DIALOG)
    : CustomBuilder | PresetConfirmHorizontalDialogBuilder | PresetConfirmVerticalDialogBuilder | null {
    if (typeof modelName == 'number') {
      return this.getPresetTemplateBuilder(modelName) as CustomBuilder;
    }
    let options = this.getTemplateOptions(modelName, DialogType.CUSTOM);
    return options ? new CustomBuilder(DialogHub.getUIContext(), options as CustomOption) : null;
  }

  getToastTemplate(preset: PresetToast.ICON_HORIZONTAL_TOAST): PresetIconHorizontalToastBuilder;
  getToastTemplate(preset: PresetToast.ICON_VERTICAL_TOAST): PresetIconVerticalToastBuilder;
  getToastTemplate(modelName: string): ToastBuilder | null;
  getToastTemplate(modelName: string | PresetToast.ICON_HORIZONTAL_TOAST | PresetToast.ICON_VERTICAL_TOAST)
    : ToastBuilder | PresetIconHorizontalToastBuilder | PresetIconVerticalToastBuilder | null {
    if (typeof modelName == 'number') {
      return this.getPresetTemplateBuilder(modelName) as ToastBuilder;
    }
    let options = this.getTemplateOptions(modelName, DialogType.TOAST);
    return options ? new ToastBuilder(DialogHub.getUIContext(), options as ToastOption) : null;
  }

  getPopupTemplate(preset: PresetPopup.MENU_POPUP): PresetMenuPopupBuilder;
  getPopupTemplate(modelName: string): PopupBuilder | null;
  getPopupTemplate(modelName: string | PresetPopup.MENU_POPUP): PopupBuilder | PresetMenuPopupBuilder | null {
    if (typeof modelName == 'number') {
      return this.getPresetTemplateBuilder(modelName) as PopupBuilder;
    }
    let options = this.getTemplateOptions(modelName, DialogType.POPUP);
    return options ? new PopupBuilder(DialogHub.getUIContext(), options as PopupOption) : null;
  }

  getSheetTemplate(preset: PresetSheet.ACTION_SHEET): PresetActionSheetBuilder;
  getSheetTemplate(modelName: string): SheetBuilder | null;
  getSheetTemplate(modelName: string | PresetSheet.ACTION_SHEET): SheetBuilder | PresetActionSheetBuilder | null {
    if (typeof modelName == 'number') {
      return this.getPresetTemplateBuilder(modelName) as SheetBuilder;
    }
    let options = this.getTemplateOptions(modelName, DialogType.SHEET);
    return options ? new SheetBuilder(DialogHub.getUIContext(), options as SheetOption) : null;
  }
}