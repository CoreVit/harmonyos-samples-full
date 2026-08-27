/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { BusinessError } from '@kit.BasicServicesKit';
import { KeyConstants } from '../constants/KeyConstants';
import Logger from './Logger';

const TAG: string = '[ResourceConversion]';

export class ResourceConversion {
  private context: UIContext | undefined = undefined;

  constructor() {
    this.context = AppStorage.get<UIContext>(KeyConstants.KEY_UI_CONTEXT);
  }

  getStringValueFromResource(res: Resource) {
    try {
      if (!this.context) {
        return;
      }
      if (!(this.context.getHostContext())) {
        return;
      }
      return this.context.getHostContext()!.resourceManager.getStringSync(res.id);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `getStringSync failed: cause the code ${err.code}, the message is ${err.message}`);
      return;
    }
  }
}