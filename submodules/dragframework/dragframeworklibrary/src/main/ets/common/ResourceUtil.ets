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
import { Constants } from './Constants';
import Logger from './utils/Logger';

const TAG: string = '[ResourceUtil]';

export class ResourceUtil {
  /**
   * Get content from the raw file resource "drag_frame_web_config.json" by key.
   * @param context The base context of an ability or an application.
   * @param key The Json key value.
   * @returns Return the value of the key.
   */
  public static getRawFileStringByKey(key: ConfigMapKey): string {
    try {
      const uiContext: UIContext | undefined = AppStorage.get<UIContext>(Constants.KEY_UI_CONTEXT);
      if (!uiContext) {
        Logger.error(TAG, `%{public}s`, `Failed to uiContext`);
        return '';
      }
      let context = uiContext.getHostContext();
      if (!context) {
        Logger.error(TAG, `%{public}s`, `Failed to context`);
        return '';
      }
      const result: Uint8Array = context.resourceManager.getRawFileContentSync('drag_frame_web_config.json');
      const textDecoder: util.TextDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
      const content: string = textDecoder.decodeToString(result, { stream: false });
      const jsonContent: ConfigMapData = JSON.parse(content) as ConfigMapData;
      if (JSON.has(jsonContent, key)) {
        const linkUrl: string = ResourceUtil.getDataByKey(jsonContent, key);
        return linkUrl;
      }
      return '';
    } catch (err) {
      Logger.error(TAG, `getRawFileContent failed. code: ${err.code ?? ''}, message: ${err.message ?? ''}`);
      return '';
    }
  }

  private static getDataByKey(content: ConfigMapData, key: ConfigMapKey): string {
    if (key === ConfigMapKey.HUAWEI_DEVELOPER_URL) {
      return content.huaweiDeveloperUrl;
    } else if (key === ConfigMapKey.HUAWEI_DEVECO_STUDIO_URL) {
      return content.huaweiDevecoStudioUrl;
    }
    Logger.error(TAG, `%{public}s`, `Failed to get uri`);
    return '';
  }
}

export class ConfigMapData {
  public huaweiDeveloperUrl: string = '';
  public huaweiDevecoStudioUrl: string = '';
}

export enum ConfigMapKey {
  HUAWEI_DEVELOPER_URL = 'huaweiDeveloperUrl',
  HUAWEI_DEVECO_STUDIO_URL = 'huaweiDevecoStudioUrl'
}