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

import { IconHorizontalToastBuilder,
  PresetTemplate } from '../../../../common/been/option/base/preset/PresetBuilderContent';
import { IconHorizontalToastContent } from '../../../../common/been/option/base/preset/PresetContent';
import { IconHorizontalToastOption } from '../../../../common/been/option/base/preset/PresetOption';
import { DialogType } from '../../../../common/constant/DialogType';
import { CommonUtils } from '../../../../common/util/CommonUtils';
import { InfDialog } from '../../../dialog/interface/InfDialog';
import { ToastProxy } from '../base/ToastProxy';

export class IconHorizontalToastProxy extends ToastProxy {
  protected builderOptions: IconHorizontalToastOption = new IconHorizontalToastOption();
  public dialog: InfDialog | undefined = undefined;

  constructor(uiContext: UIContext, builderOptions?: IconHorizontalToastOption) {
    super(uiContext);
    this.builderOptions.type = DialogType.TOAST;
    this.setStyle({
      radius: 18,
      backgroundColor: $r('app.color.dialogContainerBackground'),
      height: 36,
      shadow: {
        radius: $r('app.float.shadowRadius'),
        type: ShadowType.COLOR,
        color: '#CCCCCC',
        fill: false
      }
    })
    if (builderOptions) {
      CommonUtils.copyOptions(this.builderOptions, builderOptions, true, true);
    }

  }

  setTextContent(text: string) {
    this.builderOptions.customContentParam.text = text;
    return this;
  }

  setIcon(iconPath: string) {
    this.builderOptions.customContentParam.icon = iconPath;
    return this;
  }

  setButton(text: string) {
    if (text) {
      this.builderOptions.customContentParam.button = text;
      this.builderOptions.customContentParam.buttonBuilder = null;
    }
    return this;
  }

  setButtonBuilder(builder: WrappedBuilder<[]>) {
    if (builder) {
      this.builderOptions.customContentParam.buttonBuilder = builder;
      this.builderOptions.customContentParam.button = '';
    }
    return this;
  }

  setButtonCallback(buttonCallback: (dialog: InfDialog) => void) {
    this.builderOptions.customContentParam.buttonCallback = buttonCallback;
    return this;
  }

  protected setDialog(dialog: InfDialog) {
    this.builderOptions.customContentParam.dialog = dialog;
  }

  getTemplateBuilder(): PresetTemplate<IconHorizontalToastContent> {
    return {
      builder: wrapBuilder(IconHorizontalToastBuilder),
      param: this.builderOptions.customContentParam as IconHorizontalToastContent
    }
  }

}