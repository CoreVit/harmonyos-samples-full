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

import { DialogMode } from '../../../common/been/config/DialogConfig';
import { DialogStyle } from '../../../common/been/style/DialogStyle';
import { DialogStatus } from '../../../common/constant/DialogStatus';
import { DialogType } from '../../../common/constant/DialogType';
import { DialogErrorInfo } from '../../../log/ErrorCode';
import { DialogLifeCycle } from '../../lifecycle/DialogLifeCycle';

export interface InfDialog {

  readonly type: DialogType;
  readonly dialogId: string;
  readonly modelName: ResourceStr;

  show(): boolean;

  hide(): boolean;

  dismiss(): boolean;

  getStatus(): DialogStatus;

  addLifeCycleListener(listener: DialogLifeCycle): void;

  removeLifeCycleListener(listener: DialogLifeCycle): void;

  updateContent<T extends Object>(params: T): DialogErrorInfo;

  updateStyle(style: DialogStyle): void;

  getMode(): DialogMode;
}