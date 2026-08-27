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

import { CustomOption } from '../../../../common/been/option/base/CustomOption';
import { DialogErrorInfo } from '../../../../log/ErrorCode';
import { DialogModelHelper } from '../../../DialogModelHelper';
import { InfTemplate } from '../../interface/InfTemplate';
import { CustomProxy } from '../../proxy/base/CustomProxy';

/**
 * Builder of OverlayManager, based on DialogBuilder
 * */
export class CustomTemplate extends CustomProxy implements InfTemplate {
  private isUpdate: boolean = false;

  constructor(uiContext: UIContext, moduleName: string, isUpdate: boolean, builderOptions?: CustomOption) {
    super(uiContext, builderOptions);
    this.builderOptions.modelName = moduleName;
    this.isUpdate = isUpdate;
  }

  register(): DialogErrorInfo {
    if (this.isUpdate) {
      return DialogModelHelper.update(this.builderOptions.modelName, this.builderOptions);
    } else {
      return DialogModelHelper.create(this.builderOptions.modelName, this.builderOptions);
    }
  }
}