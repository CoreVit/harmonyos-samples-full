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

import { common } from '@kit.AbilityKit';
import { fileIo } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from './Logger';

const TAG = '[KnockShareSample]';

interface FileItem {
  resourceId: number;
  fileName: string;
}

export class ImageUtil {
  /**
   * Save image to sandbox.
   * @param context UIAbility Context.
   */
  public static saveImage(context: common.UIAbilityContext) {
    const fileItems: FileItem[] = [
      { resourceId: $r('app.media.video_cover_0').id, fileName: '/video_cover_0.png' },
      { resourceId: $r('app.media.video_cover_3').id, fileName: '/video_cover_3.png' }
    ];

    for (const item of fileItems) {
      let file: fileIo.File | undefined = undefined;
      let fd: number | undefined = undefined;
      try {
        const mediaContent = context.resourceManager.getMediaContentSync(item.resourceId);
        const filePath = context.filesDir + item.fileName;
        file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
        fd = file.fd;
        const writeLen = fileIo.writeSync(fd, (mediaContent as Uint8Array).buffer);
        Logger.info(TAG, `write data to file ${item.fileName} succeed and size is: ${writeLen}`);
      } catch (error) {
        const err = error as BusinessError;
        Logger.error(TAG, `saveImage failed for ${item.fileName}, code: ${err.code}, message: ${err.message}`);
        continue;
      } finally {
        if (file && fd !== undefined) {
          try {
            fileIo.closeSync(fd);
          } catch (closeError) {
            const err = closeError as BusinessError;
            Logger.error(TAG, `close file ${item.fileName} failed, code: ${err.code}, message: ${err.message}`);
          }
        }
      }
    }
  }
}