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

import type { BusinessError } from '@kit.BasicServicesKit';
import { common, ConfigurationConstant } from '@kit.AbilityKit';
import { fileIo } from '@kit.CoreFileKit';
import Logger from './Logger';

const TAG = '[VideoUtil]';

export class VideoUtil {
  public static async initialize(context: common.UIAbilityContext) {
    AppStorage.setOrCreate<common.UIAbilityContext>('AVAbilityContext', context);
    try {
      context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
      // Writes raw file content to local storage.
      const videoList: string[] = ['kv-popup.mp4', 'kv-intro-pop.mp4']
      for (const item of videoList) {
        await VideoUtil.writeRawVideoToLocal(context, item);
      }
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `fileIO error code: ${err.code}, message: ${err.message}`);
    }
  }

  private static async writeRawVideoToLocal(context: common.UIAbilityContext, fileName: string) {
    let file: fileIo.File | undefined;
    try {
      const value = await context.resourceManager.getRawFileContent(fileName);
      const filePath = context.filesDir + '/' + fileName;
      file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
      fileIo.writeSync(file.fd, value.buffer);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `writeRawVideoToLocal failed, cause: ${err.code}, ${err.message}`);
    } finally {
      if (file) {
        try {
          fileIo.closeSync(file.fd);
        } catch (error) {
          const err: BusinessError = error as BusinessError;
          Logger.error(TAG, `close file failed, cause: ${err.code}, ${err.message}`);
        }
      }
    }
  }
}