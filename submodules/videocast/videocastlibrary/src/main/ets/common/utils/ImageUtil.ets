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
import { CommonConstants } from '../constants/CommonConstants';
import type { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '../../../../../Index';

const TAG = 'ResourceUtil';

/**
 * Converts a media resource into a PixelMap object.
 * @param resource The media resource containing bundle, module and ID references.
 * @returns Promise<image.PixelMap> with RGBA_8888 format.
 */
export async function getPixmapFromMedia(resource: Resource) {
  let imageSource: image.ImageSource | undefined;
  try {
    const uiContext: UIContext | undefined = AppStorage.get(CommonConstants.KEY_PREFIX + 'UiContext');
    let unit8Array = await uiContext?.getHostContext()?.resourceManager?.getMediaContent(resource.id);
    if (!unit8Array || unit8Array.buffer.byteLength === 0) {
      Logger.error(TAG, `getMediaContent returned empty or invalid data.`);
      return undefined;
    }
    imageSource = image.createImageSource(unit8Array?.buffer.slice(0, unit8Array?.buffer.byteLength));
    let pixelMap: image.PixelMap = await imageSource.createPixelMap({
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888
    });
    return pixelMap;
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    Logger.error(TAG, `getPixmapFromMedia failed, cause: ${err.code}, ${err.message}`);
    return undefined;
  } finally {
    if (imageSource) {
      try {
        await imageSource.release();
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        Logger.error(TAG, `close file failed, cause: ${err.code}, ${err.message}`);
      }
    }
  }
}
