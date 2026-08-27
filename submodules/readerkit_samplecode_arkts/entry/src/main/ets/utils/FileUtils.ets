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

import { fileIo as fs } from '@kit.CoreFileKit';
import Logger from './Logger';

const TAG = 'FileUtils';

export class FileUtils {

  public static getExtensionFileName(filePath: string): string {
    if (!filePath || filePath.length === 0) {
      Logger.error(TAG, 'getExtensionFileName filePath is blank');
      return '';
    }
    let fn = FileUtils.getFileFullName(filePath);
    let fileNameSplit = fn.split('.');
    if (fileNameSplit.length > 1) {
      return fileNameSplit[fileNameSplit.length - 1].toLowerCase();
    } else {
      return '';
    }
  }

  public static getFileName(filePath: string): string {
    if (!filePath || filePath.length === 0) {
      Logger.error(TAG, 'getFileName filePath is blank');
      return '';
    }
    let fn = FileUtils.getFileFullName(filePath);
    let fileNameSplit = fn.split('.');
    if (fileNameSplit.length > 0) {
      return fileNameSplit[0];
    } else {
      return '';
    }
  }

  private static getFileFullName(filePath: string): string {
    if (!filePath || filePath.length === 0) {
      Logger.error(TAG, 'getFileFullName filePath is blank');
      return '';
    }
    let reg = /(\/+)/g;
    filePath = filePath.replace(reg, '#');
    let filePathArray = filePath.split('#');
    if (filePathArray.length > 0) {
      return filePathArray[filePathArray.length - 1];
    } else {
      return '';
    }
  }

  public static async copyFileToCache(srcPath: string, dstPath: string): Promise<void> {
    if (!srcPath || srcPath.length === 0 || !dstPath || dstPath.length === 0) {
      Logger.error(TAG, 'copyFileToCache srcPath or dstPath is blank');
      return Promise.reject();
    }
    let fileId = -1;
    try {
      let file = fs.openSync(srcPath, fs.OpenMode.READ_ONLY);
      fileId = file.fd;
      await fs.copyFile(fileId, dstPath, 0);
      Logger.info(TAG, 'copyFileToCache succeeded');
      return Promise.resolve();
    } catch (error) {
      Logger.info(TAG,
        `copyFileToCache failed, Code: ${error.code}, message: ${error.message}`);
      return Promise.reject();
    } finally {
      fs.close(fileId).catch(() => {
        Logger.error(TAG, 'copyFileToCache close file failed');
      });
    }
  }
}