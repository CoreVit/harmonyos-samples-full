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
import { DialogStyle } from '../../../../common/been/style/DialogStyle';
import { BaseOption } from '../../../../common/been/option/base/BaseOption';
import { DialogAction } from '../../../../common/been/DialogAction';
import { CommonUtils } from '../../../../common/util/CommonUtils';
import { DialogLifeCycle } from '../../../lifecycle/DialogLifeCycle';


export abstract class DialogAdaptorProxy {
  protected uiContext: UIContext;
  protected builderOptions: BaseOption;

  constructor(uiContext: UIContext) {
    this.uiContext = uiContext;
    this.builderOptions = new BaseOption();
  }

  setContent<T extends Object>(customContent: WrappedBuilder<[param: T]>, customParam?: T) {
    this.builderOptions.customContent = customContent;
    this.builderOptions.customContentParam = customParam;
    return this;
  }

  setLifeCycleListener(lifeCycle: DialogLifeCycle) {
    CommonUtils.copyOptions(this.builderOptions.lifeCycleConfig, lifeCycle, true);
    return this;
  }

  setOperableContent<T extends Object>(customContent: WrappedBuilder<[param: T]>,
    interactiveParam: (dialogAction: DialogAction) => T) {
    // judge whether interactiveParam has a value first
    this.builderOptions.customContent = customContent;
    this.builderOptions.customContentParam = interactiveParam;
    this.builderOptions.isOperableContent = true;
    return this;
  }

  setStyle(style: DialogStyle) {
    CommonUtils.copyOptions(this.builderOptions, style, true, true);
    return this;
  }
}