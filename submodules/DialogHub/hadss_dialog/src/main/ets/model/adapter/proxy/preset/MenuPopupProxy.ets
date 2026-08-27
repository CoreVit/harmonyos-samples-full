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

import { MenuPopupBuilder, PresetTemplate } from '../../../../common/been/option/base/preset/PresetBuilderContent';
import { IconPosition, MenuPopupContent, PopupItem } from '../../../../common/been/option/base/preset/PresetContent';
import { MenuPopupOption } from '../../../../common/been/option/base/preset/PresetOption';
import { DialogType } from '../../../../common/constant/DialogType';
import { CommonUtils } from '../../../../common/util/CommonUtils';
import { InfDialog } from '../../../dialog/interface/InfDialog';
import { PopupProxy } from '../base/PopupProxy';

export class MenuPopupProxy extends PopupProxy {
  protected builderOptions: MenuPopupOption = new MenuPopupOption();

  constructor(uiContext: UIContext, builderOptions?: MenuPopupOption) {
    super(uiContext);
    this.builderOptions.type = DialogType.POPUP;

    this.setStyle({
      radius: 20,
      backgroundColor: $r('app.color.dialogContainerBackground'),
      shadow: {
        radius: $r('app.float.shadowRadius'),
        color: $r('app.color.shadowColor')
      }
    })

    if (builderOptions) {
      CommonUtils.copyOptions(this.builderOptions, builderOptions, true, true);
    }
  }

  protected setDialog(dialog: InfDialog){
    this.builderOptions.customContentParam.dialog = dialog;
  }

  setPopupList(popupList: Array<PopupItem>) {
    this.builderOptions.customContentParam.popupList = popupList;
    return this;
  }

  setIconStatus(isShow: boolean){
    this.builderOptions.customContentParam.showIcon = isShow;
    return this;
  }

  setIconPosition(position: IconPosition){
    this.builderOptions.customContentParam.iconPosition = position;
    return this;
  }

  setWidth(width: Length) {
    this.builderOptions.customContentParam.width = width;
    return this;
  }

  getTemplateBuilder(): PresetTemplate<MenuPopupContent> {
    return {
      builder: wrapBuilder(MenuPopupBuilder),
      param: this.builderOptions.customContentParam as MenuPopupContent
    }
  }
}