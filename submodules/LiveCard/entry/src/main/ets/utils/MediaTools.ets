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

import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';
import { resourceManager } from '@kit.LocalizationKit';
import type { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from './Logger';

const TAG = 'MediaToolsLogTag';

export class MediaTools {
  static async getPixelMapFromResource(context: common.UIAbilityContext,
    name: resourceManager.Resource): Promise<PixelMap> {
    let resourceMgr = context.resourceManager;
    let fileData: Uint8Array = new Uint8Array();
    try {
      fileData = await resourceMgr.getMediaContent(name.id);
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `getPixelMapFromResource err, code: ${error.code}, message: ${error.message}`);
    }
    const imageSource = image.createImageSource(fileData.buffer as ArrayBuffer);
    const result = await imageSource.createPixelMap();
    imageSource.release();
    return result;
  }

  static async getPixelMapFromFile(path: string): Promise<image.PixelMap> {
    const imageSource = image.createImageSource(path);
    const result = await imageSource.createPixelMap();
    imageSource.release();
    return result;
  }

  private static fill(value: number): string {
    return value.toString().padStart(2, '0');
  }

  static msToCountdownTime(ms: number): string {
    if (ms <= 0 || !Number.isFinite(ms)) {
      return '00:00';
    }
    const days = Math.floor(ms / (1000 * 60 * 60 * 24));
    const hours = Math.floor((ms % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    const minutes = Math.floor((ms % (1000 * 60 * 60)) / (1000 * 60));
    const seconds = Math.floor((ms % (1000 * 60)) / 1000);
    const parts: string[] = [];
    if (days) {
      parts.push(MediaTools.fill(days));
    }
    if (hours || parts.length > 0) {
      parts.push(MediaTools.fill(hours));
    }
    parts.push(MediaTools.fill(minutes), MediaTools.fill(seconds));
    return parts.join(':');
  }
}
