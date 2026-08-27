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
import Logger from './Logger';

const TAG = '[KnockShareSample]';

export class ResourceUtil {
  /**
   * Obtains the character string corresponding to the specified resource ID.
   *
   * @param resource resource.
   */
  public static getResourceString(context: Context, resource: Resource): string {
    if (ResourceUtil.isEmptyObj(resource)) {
      Logger.error(TAG, 'getResourceString failed, resource is empty.');
      return '';
    }
    let resourceString: string = '';
    try {
      resourceString = context.resourceManager.getStringSync(resource.id);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `getStringSync failed, error: ${err.code}, ${err.message}.`);
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
   * Get content from the raw file resource "web_knock_config.json" by key.
   * @param context The base context of an ability or an application.
   * @param key The Json key value.
   * @returns Return the value of the key.
   */
  public static getRawFileStringByKey(context: Context, key: ConfigMapKey): string {
    const configStr: string | undefined = AppStorage.get(key);
    if (configStr) {
      return configStr;
    }
    try {
      const result: Uint8Array = context.resourceManager.getRawFileContentSync('web_knock_config.json5');
      if (!result || result.length === 0) {
        return '';
      }
      const textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
      const content: string = textDecoder.decodeToString(result, { stream: false });
      const jsonContent: ConfigMapData = JSON.parse(content) as ConfigMapData;
      if (JSON.has(jsonContent, key)) {
        const linkUrl: string = ResourceUtil.getDataByKey(jsonContent, key);
        AppStorage.setOrCreate(key, linkUrl);
        return linkUrl;
      }
      Logger.error(TAG, `GetRawFileContent failed, cause: no ${key} value is configured.`);
      return '';
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `GetRawFileContent failed, error code: ${err.code}, message: ${err.message}.`);
      return '';
    }
  }

  private static getDataByKey(content: ConfigMapData, key: ConfigMapKey): string {
    if (key === ConfigMapKey.KV_POPUP) {
      return content.kvPopup;
    } else if (key === ConfigMapKey.BRAND_AMBASSADOR) {
      return content.brandAmbassador;
    } else if (key === ConfigMapKey.KV_INTRO_POP) {
      return content.kvIntroPop;
    } else if (key === ConfigMapKey.CAMERA_INTRO_POPUP) {
      return content.cameraIntroPopup;
    }
    return '';
  }
}

export class ConfigMapData {
  public kvPopup: string = '';
  public brandAmbassador: string = '';
  public kvIntroPop: string = '';
  public cameraIntroPopup: string = '';
}

export enum ConfigMapKey {
  KV_POPUP = 'kvPopup',
  BRAND_AMBASSADOR = 'brandAmbassador',
  KV_INTRO_POP = 'kvIntroPop',
  CAMERA_INTRO_POPUP = 'cameraIntroPopup',
}