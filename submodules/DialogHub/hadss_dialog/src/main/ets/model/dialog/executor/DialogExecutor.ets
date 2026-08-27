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

import { BaseOption } from '../../../common/been/option/base/BaseOption';
import { ComponentContent } from '@kit.ArkUI';
import { BaseDialog } from '../interface/BaseDialog';

export abstract class DialogExecutor implements BaseDialog {
  protected uiContext: UIContext;
  protected contentNode?: ComponentContent<BaseOption>;
  protected builderOptions: BaseOption;

  constructor(uiContext: UIContext, builderOptions: BaseOption) {
    this.uiContext = uiContext;
    this.builderOptions = builderOptions;
  }

  abstract show(): void;

  abstract hide(): void;

  abstract resetIndex(): void;

  abstract dismiss(): void;

  abstract update(updateParams?: string[]): void;
}