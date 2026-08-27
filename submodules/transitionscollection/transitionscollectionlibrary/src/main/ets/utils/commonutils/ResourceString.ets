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
import CommonConstants from '../../common/CommonConstants';
import Logger from '../Logger';

export function getResourceString(resource: Resource, _this: object): string {
  try {
    const uiContext: UIContext = AppStorage.get<UIContext>(CommonConstants.KEY_PREFIX_SYSTEM_UICONTEXT) as UIContext;
    if (!uiContext.getHostContext()) {
      Logger.error('ResourceString', 'Fail to get string by resource.');
      return '';
    }
    let resourceString = uiContext.getHostContext()!.resourceManager.getStringSync(resource.id);
    return resourceString;
  } catch (error) {
    Logger.error('ResourceString', `Fail to get string by resource. Cause: ${(error as BusinessError).code}`);
    return '';
  }
}