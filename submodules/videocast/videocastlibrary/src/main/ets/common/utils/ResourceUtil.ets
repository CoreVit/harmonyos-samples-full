/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use Logger file except in compliance with the License.
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

import { util } from '@kit.ArkTS';
import Logger from './Logger';

const TAG = 'ResourceUtil';

export class ResourceUtil {
  public static getVideoUrlByRawFileContent(context: Context): string[] {
    try {
      const result: Uint8Array = context.resourceManager.getRawFileContentSync('video_url.json');
      const textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
      const content: string = textDecoder.decodeToString(result, { stream: false });
      const urlArray: string[] = JSON.parse(content) as string[];
      return urlArray;
    } catch (error) {
      Logger.error(TAG, `GetRawFileContent failed, error code: ${error.code}, message: ${error.message}.`);
      return [];
    }
  }
}