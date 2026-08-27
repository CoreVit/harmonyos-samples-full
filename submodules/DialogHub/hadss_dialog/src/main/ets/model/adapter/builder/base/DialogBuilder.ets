/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import { CustomDialog } from '../../../dialog/base/CustomDialog';
import { CustomOption } from '../../../../common/been/option/base/CustomOption';
import { InfCustomDialog } from '../../../dialog/interface/InfCustomDialog';
import { CustomProxy } from '../../proxy/base/CustomProxy';
import { InfBuilder } from '../../interface/InfBuilder';
import { ObjectUtils } from '../../../../common/util/ObjectUtils';
import { DHubLogger } from '../../../../log/DHubLogger';
import { DialogError } from '../../../../log/ErrorCode';
import { DialogAction } from '../../../../common/been/DialogAction';
import { CommonUtils } from '../../../../common/util/CommonUtils';
import { DialogMode } from '../../../../common/been/config/DialogConfig';
import { LevelMode } from '@kit.ArkUI';
import { catchError } from '../../../../common/util/catchError';

class Param {
  public text: string = '';
  constructor(text: string) {
    this.text = text;
  }
}

@Builder
function errorPage(param: Param) {
  Column() {
    Text('error params')
      .fontSize(18)
      .fontColor(Color.Red)
    Text(param.text)
      .fontSize(14)
      .fontColor(Color.Red)
  }
}

/**
 * Builder of OverlayManager, based on DialogBuilder
 * */
export class DialogBuilder extends CustomProxy implements InfBuilder {
  constructor(uiContext: UIContext, builderOptions?: CustomOption) {
    super(uiContext, builderOptions);
  }

  setDialogLevel(dialogLevel: number) {
    this.builderOptions.layerIndex = dialogLevel;
    return this;
  }

  @catchError()
  build<T extends Object>(params?: T): InfCustomDialog {
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

    // check dialogMode and settings whether contains conflicts
    if (this.builderOptions.dialogMode == DialogMode.OVERLAY_MANAGER) {
      if (this.builderOptions.levelMode == LevelMode.EMBEDDED) {
        DHubLogger.error(DialogError.PARAMETER_INCONSISTENCY);
        DHubLogger.error('The OverlayManager mode dialog does not support embedded levelMode');
        this.builderOptions.customContent = wrapBuilder(errorPage);
        this.builderOptions.customContentParam = new Param('The OverlayManager mode dialog does not support embedded levelMode');
      }
    } else {
      if (this.builderOptions.passThroughGesture) {
        DHubLogger.error(DialogError.PARAMETER_INCONSISTENCY);
        DHubLogger.error('The CustomDialog mode dialog dose not support passThroughGesture');
        this.builderOptions.customContent = wrapBuilder(errorPage);
        this.builderOptions.customContentParam = new Param('The CustomDialog mode dialog dose not support passThroughGesture');
      }
    }
    let dialog = new CustomDialog(this.uiContext, this.builderOptions, this.builderOptions.lifeCycleConfig);
    return dialog;
  }
}