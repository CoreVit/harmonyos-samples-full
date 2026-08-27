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

import { ActionSheetBuilder, PresetTemplate } from '../../../../common/been/option/base/preset/PresetBuilderContent';
import { ActionSheetContent, SheetItem } from '../../../../common/been/option/base/preset/PresetContent';
import { ActionSheetOption } from '../../../../common/been/option/base/preset/PresetOption';
import { SheetStyle } from '../../../../common/been/style/SheetStyle';
import { DialogType } from '../../../../common/constant/DialogType';
import { CommonUtils } from '../../../../common/util/CommonUtils';
import { InfDialog } from '../../../dialog/interface/InfDialog';
import { SheetProxy } from '../base/SheetProxy';

export class ActionSheetProxy extends SheetProxy {
  protected builderOptions: ActionSheetOption = new ActionSheetOption();

  constructor(uiContext: UIContext, builderOptions?: ActionSheetOption) {
    super(uiContext);
    this.builderOptions.type = DialogType.SHEET;
    this.setStyle({
      height: SheetSize.FIT_CONTENT,
      backgroundColor: this.builderOptions.customContentParam.isTransparent ? Color.Transparent :
      $r('app.color.sheetContainerBackground')
    })
    if (builderOptions) {
      CommonUtils.copyOptions(this.builderOptions, builderOptions, true, true);
    }
  }

  protected setDialog(dialog: InfDialog) {
    this.builderOptions.customContentParam.dialog = dialog;
  }

  setStyle(sheetStyle: SheetStyle) {
    super.setStyle(sheetStyle);
    // check whether the title value has been transferred.
    if (this.builderOptions.customContentParam.isTransparent) {
      this.builderOptions.title = undefined;
      this.builderOptions.showClose = false;
    } else {
      this.builderOptions.customContentParam.title = this.builderOptions.title;
    }
    console.log('aaa', this.builderOptions.customContentParam.isTransparent)
    return this;
  }

  setSheetList(sheetList: Array<SheetItem>) {
    this.builderOptions.customContentParam.sheetList = sheetList;
    return this;
  }

  setBottomButtonStatus(isShow: boolean) {
    this.builderOptions.customContentParam.showBtnButton = isShow;
    return this;
  }

  setBackgroundTransparent(isTransparent: boolean) {
    this.builderOptions.customContentParam.isTransparent = isTransparent;
    this.builderOptions.backgroundColor = this.builderOptions.customContentParam.isTransparent ? Color.Transparent :
    $r('app.color.sheetContainerBackground')
    return this;
  }

  getTemplateBuilder(): PresetTemplate<ActionSheetContent> {
    return {
      builder: wrapBuilder(ActionSheetBuilder),
      param: this.builderOptions.customContentParam as ActionSheetContent
    }
  }
}