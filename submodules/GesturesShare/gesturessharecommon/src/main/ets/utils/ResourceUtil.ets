/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { JSON, util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { resourceManager } from '@kit.LocalizationKit';
import { Constants } from '../constants/Constants';
import Logger from './Logger';

const TAG: string = '[ResourceUtil]';

export class ResourceUtil {
  /**
   * Get content from the raw file resource "gesture_url_config.json" by key.
   * @param resourceManager application resources manager
   * @param key The Json key value.
   * @returns Return the value of the key.
   */
  public static getRawFileString(resourceManager: resourceManager.ResourceManager, key: ConfigMapKey): string | object {
    try {
      if (!resourceManager) {
        return '';
      }
      const result: Uint8Array =
        resourceManager.getRawFileContentSync('gesture_url_config.json');
      const textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
      const content: string = textDecoder.decodeToString(result, { stream: false });
      const jsonContent: ConfigMapData = JSON.parse(content) as ConfigMapData;
      if (JSON.has(jsonContent, key)) {
        const linkUrl: string | object = ResourceUtil.getDataByKey(jsonContent, key);
        return linkUrl;
      }
      return '';
    } catch (err) {
      const error = err as BusinessError;
      Logger.error(TAG, `Get RawFile failed. Cause code: ${error.code}, message: ${error.message}`);
      return '';
    }
    return '';
  }

  /**
   * Get content from the raw file resource "gesture_url_config.json" by key.
   * @param key The Json key value.
   * @returns Return the value of the key.
   */
  public static getRawFileStringByKey(key: ConfigMapKey): string | object {
    const uiContext: UIContext | undefined = AppStorage.get(Constants.KEY_UI_CONTEXT);
    const context: Context | undefined = uiContext?.getHostContext()
    if (!context) {
      return '';
    }
    return ResourceUtil.getRawFileString(context.resourceManager, key);
  }

  private static getDataByKey(content: ConfigMapData, key: ConfigMapKey): string | object {
    if (key === ConfigMapKey.SHARE_URL) {
      return content.url ?? '';
    } else if (key === ConfigMapKey.CALLER_BUNDLE_NAME_WHITELIST) {
      return content.callerBundleNameWhiteList ?? [];
    }
    return '';
  }
}

export class ConfigMapData {
  public url: string = '';
  public callerBundleNameWhiteList: string[] = [];
}

export enum ConfigMapKey {
  SHARE_URL = 'url',
  CALLER_BUNDLE_NAME_WHITELIST = 'callerBundleNameWhiteList'
}