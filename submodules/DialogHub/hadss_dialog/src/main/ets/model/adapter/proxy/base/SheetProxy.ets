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
import { SheetBehavior } from '../../../../common/been/config/SheetBehavior';
import { SheetOption } from '../../../../common/been/option/base/SheetOption';
import { SheetStyle } from '../../../../common/been/style/SheetStyle';
import { DialogType } from '../../../../common/constant/DialogType';
import { CommonUtils } from '../../../../common/util/CommonUtils';
import { SheetLifeCycle } from '../../../lifecycle/SheetLifeCycle';
import { DialogAdaptorProxy } from './DialogAdaptorProxy';


/**
 * BindSheet builder, based on DialogBuilder.
 * */
export abstract class SheetProxy extends DialogAdaptorProxy {
  protected builderOptions: SheetOption = new SheetOption();
  protected lifeCycleConfig: SheetLifeCycle = {};

  constructor(uiContext: UIContext, builderOptions?: SheetOption) {
    super(uiContext);
    if (builderOptions) {
      CommonUtils.copyOptions(this.builderOptions, builderOptions, true, true);
    }
    this.builderOptions.type = DialogType.SHEET;
  }

  setStyle(sheetStyle: SheetStyle) {
    super.setStyle(sheetStyle);
    return this;
  }

  setConfig(config: SheetBehavior) {
    CommonUtils.copyOptions(this.builderOptions, config, true, true);
    return this;
  }

  setComponentTargetId(targetCompId: string) {
    this.builderOptions.targetCompId = targetCompId;
    return this;
  }

  setLifeCycleListener(lifeCycle: SheetLifeCycle) {
    super.setLifeCycleListener(lifeCycle);
    return this;
  }
}