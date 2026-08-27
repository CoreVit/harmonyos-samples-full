/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { JSON, util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { Constants } from './Constants';
import Logger from './utils/Logger';

const TAG: string = '[ResourceUtil]';

export class ResourceUtil {
  /**
   * Obtains the character string corresponding to the specified resource ID.
   *
   * @param resource resource.
   */
  public static getResourceString(resource: Resource): string {
    if (ResourceUtil.isEmptyObj(resource)) {
      return '';
    }
    const context: UIContext | undefined = AppStorage.get(Constants.KEY_UI_CONTEXT);
    if (!context || !(context.getHostContext())) {
      return '';
    }
    let resourceString: string = '';
    try {
      resourceString = context.getHostContext()!.resourceManager.getStringSync(resource.id);
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `Failed to get resource. Cause :${err.code},  Message: ${err.message}.`);
    }
    return resourceString;
  }

  /**
   * Check whether the object is empty.
   *
   * @param obj Objects to be checked.
   * @returns Return true if the object is empty or has no properties; Otherwise return false.
   */
  private static isEmptyObj(obj: Object): boolean {
    if (obj === null || typeof obj !== 'object') {
      return true;
    }
    return Object.keys(obj).length === 0;
  }

  /**
   * Get content from the raw file resource "web_prerender_config.json" by key.
   * @param key The Json key value.
   * @returns Return the value of the key.
   */
  public static getRawFileStringByKey(key: ConfigMapKey): string {
    try {
      const context: UIContext | undefined = AppStorage.get(Constants.KEY_UI_CONTEXT);
      if (!context || !(context.getHostContext())) {
        return '';
      }
      const result: Uint8Array =
        context.getHostContext()!.resourceManager.getRawFileContentSync('web_prerender_config.json');
      const textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
      const content: string = textDecoder.decodeToString(result, { stream: false });
      const jsonContent: ConfigMapData = JSON.parse(content) as ConfigMapData;
      if (JSON.has(jsonContent, key)) {
        const linkUrl: string = ResourceUtil.getDataByKey(jsonContent, key);
        return linkUrl;
      }
      return '';
    } catch (err) {
      const error = err as BusinessError;
      Logger.error(TAG, `Get RawFile failed. Cause code: ${error.code}, message: ${error.message}`);
      return '';
    }
  }

  private static getDataByKey(content: ConfigMapData, key: ConfigMapKey): string {
    if (key === ConfigMapKey.GALLERY_URL) {
      return content.url;
    }
    return '';
  }
}

export class ConfigMapData {
  public url: string = '';
}

export enum ConfigMapKey {
  GALLERY_URL = 'url',
}