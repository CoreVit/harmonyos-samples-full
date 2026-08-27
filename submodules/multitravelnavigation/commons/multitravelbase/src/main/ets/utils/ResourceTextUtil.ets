/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { UIContext } from '@kit.ArkUI';

export class ResourceTextUtil {
  public static getString(uiContext: UIContext, resource: Resource): string {
    try {
      return uiContext.getHostContext()?.resourceManager.getStringSync(resource.id) ?? '';
    } catch (_) {
      return '';
    }
  }

  public static formatString(uiContext: UIContext, resource: Resource,
    placeholder: string, value: string | number): string {
    let text: string = ResourceTextUtil.getString(uiContext, resource);
    return text.replace(`{${placeholder}}`, String(value));
  }
}
