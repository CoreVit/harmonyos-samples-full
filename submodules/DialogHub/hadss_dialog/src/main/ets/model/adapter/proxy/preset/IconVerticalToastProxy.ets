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
  IconVerticalToastBuilder,
  PresetTemplate} from '../../../../common/been/option/base/preset/PresetBuilderContent';
import { IconVerticalToastContent } from '../../../../common/been/option/base/preset/PresetContent';
import { IconVerticalToastOption } from '../../../../common/been/option/base/preset/PresetOption';
import { DialogType } from '../../../../common/constant/DialogType';
import { CommonUtils } from '../../../../common/util/CommonUtils';
import { InfDialog } from '../../../dialog/interface/InfDialog';
import { ToastProxy } from '../base/ToastProxy';

export class IconVerticalToastProxy extends ToastProxy {
  protected builderOptions: IconVerticalToastOption = new IconVerticalToastOption();

  constructor(uiContext: UIContext, builderOptions?: IconVerticalToastOption) {
    super(uiContext);
    this.builderOptions.type = DialogType.TOAST;
    this.setStyle({
      backgroundColor: $r('app.color.dialogContainerBackground')
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

  getTemplateBuilder(): PresetTemplate<IconVerticalToastContent> {
    return {
      builder: wrapBuilder(IconVerticalToastBuilder),
      param: this.builderOptions.customContentParam as IconVerticalToastContent
    }
  }
}