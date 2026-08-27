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
import { SheetBehavior } from '../../../common/been/config/SheetBehavior';
import { SheetStyle } from '../../../common/been/style/SheetStyle';
import { SheetLifeCycle } from '../../lifecycle/SheetLifeCycle';
import { InfDialog } from './InfDialog';

export interface InfSheet extends InfDialog {
  addLifeCycleListener(listener: SheetLifeCycle): void;

  removeLifeCycleListener(listener: SheetLifeCycle): void;

  resetHeight(height: SheetSize | Length): void;

  updateStyle(param: SheetStyle): void;

  updateConfig(config: SheetBehavior): void;
}