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

import {
  ConfirmHorizontalDialogBuilder,
  PresetTemplate
} from '../../../../common/been/option/base/preset/PresetBuilderContent';
import {
  ButtonItemParams,
  ConfirmHorizontalDialogContent
} from '../../../../common/been/option/base/preset/PresetContent';
import { ConfirmHorizontalDialogOption } from '../../../../common/been/option/base/preset/PresetOption';
import { DialogType } from '../../../../common/constant/DialogType';
import { CommonUtils } from '../../../../common/util/CommonUtils';
import { InfDialog } from '../../../dialog/interface/InfDialog';
import { CustomProxy } from '../base/CustomProxy';

export class ConfirmHorizontalDialogProxy extends CustomProxy {
  protected builderOptions: ConfirmHorizontalDialogOption = new ConfirmHorizontalDialogOption();

  constructor(uiContext: UIContext, builderOptions?: ConfirmHorizontalDialogOption) {
    super(uiContext);
    this.builderOptions.type = DialogType.CUSTOM;

    this.setStyle({
      radius: 32,
      backgroundColor: $r('app.color.dialogContainerBackground'),
      shadow: {
        radius: $r('app.float.shadowRadius'),
        color: $r('app.color.shadowColor')
      }
    })
    this.setConfig({
      dialogBehavior: {
        isModal: false,
        autoDismiss: false
      }
    })

    if (builderOptions) {
      CommonUtils.copyOptions(this.builderOptions, builderOptions, true, true);
    }
  }

  protected setDialog(dialog: InfDialog) {
    this.builderOptions.customContentParam.dialog = dialog;
  }

  setTitle(title: string) {
    this.builderOptions.customContentParam.title = title;
    return this;
  }

  setTextAlign(textAlign: TextAlign) {
    this.builderOptions.customContentParam.textAlign = textAlign;
    return this;
  }

  setText(text: string) {
    if (text) {
      this.builderOptions.customContentParam.text = text;
      this.builderOptions.customContentParam.textBuilder = null;
      this.builderOptions.customContentParam.textBuilderParams = null;
    }
    return this;
  }

  setTextBuilder(textBuilder: WrappedBuilder<ESObject>, params: ESObject) {
    if (textBuilder) {
      this.builderOptions.customContentParam.textBuilder = textBuilder;
      this.builderOptions.customContentParam.textBuilderParams = params;
      this.builderOptions.customContentParam.text = '';
    }
    return this;
  }

  setButtons(buttons: Array<ButtonItemParams>) {
    // merge buttonStyleMode and buttonBackgroundColor/buttonFontColor/buttonBorder style
    for (let i = 0; i < buttons.length; i++) {
      let button = buttons[i];
      button.buttonStyleMode = button.buttonStyleMode ?? ButtonStyleMode.EMPHASIZED;
      if (button.buttonStyleMode == ButtonStyleMode.EMPHASIZED) {
        button.backgroundColor = button.backgroundColor ?? $r('app.color.primaryButtonBackground');
        button.fontColor = button.fontColor ?? $r('app.color.primaryButtonFontColor');
        if (!button.border) {
          button.border = {
            radius: 20
          }
        } else {
          if (button.border.radius == undefined) {
            button.border.radius = 20;
          }
        }
      } else if (button.buttonStyleMode == ButtonStyleMode.TEXTUAL) {
        button.backgroundColor = button.backgroundColor ?? Color.Transparent;
        button.fontColor = button.fontColor ?? $r('app.color.normalButtonFontColor');
      } else {
        button.backgroundColor = button.backgroundColor ?? $r('app.color.normalButtonBackground');
        button.fontColor = button.fontColor ?? $r('app.color.normalButtonFontColor');
        if (!button.border) {
          button.border = {
            radius: 20
          }
        } else {
          if (button.border.radius == undefined) {
            button.border.radius = 20;
          }
        }
      }
    }
    this.builderOptions.customContentParam.buttons = buttons;
    return this;
  }

  setButtonSpace(space: number) {
    this.builderOptions.customContentParam.buttonSpace = space;
    return this;
  }

  setButtonAlign(flexAlign: FlexAlign) {
    this.builderOptions.customContentParam.buttonAlign = flexAlign;
    return this;
  }

  getTemplateBuilder(): PresetTemplate<ConfirmHorizontalDialogContent> {
    return {
      builder: wrapBuilder(ConfirmHorizontalDialogBuilder),
      param: this.builderOptions.customContentParam as ConfirmHorizontalDialogContent
    }
  }
}