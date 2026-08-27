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

import { fileIo } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { bufferToString } from '../utils/StringUtils';
import { CommonConstants } from '../common/CommonConstants';
import Logger from '../utils/Logger';

const TAG = 'MediaFileUri';
// File read/write buffer size
const BUFFER_SIZE = 4096;

export default class MediaFileUri {
  private fileSizeList: Array<number> = [];
  private fileNameList: Array<string> = [];
  private fileUriList: Array<string> = [];

  readFileContent(uri: string): string {
    let content = '';
    let file: fileIo.File = null!;
    try {
      file = fileIo.openSync(uri, fileIo.OpenMode.READ_ONLY);
      let buffer = new ArrayBuffer(BUFFER_SIZE);
      fileIo.readSync(file.fd, buffer, {
        offset: 0
      });
      content = bufferToString(buffer);
    } catch (err) {
      Logger.error(TAG, 'openReadSync: open file failed.');
    } finally {
      try {
        file && fileIo.closeSync(file);
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        Logger.error(TAG, `OpenSync or writeSync file failed. Cause: code: ${err.code}, message: ${err.message}`);
      }
    }
    return content;
  }

  myGetFileSize(uri: string, mode: number): number {
    let file: fileIo.File = null!;
    try {
      file = fileIo.openSync(uri, mode);
      let stat = fileIo.statSync(file.fd);
      Logger.info(TAG, 'get file info succeed.');
      return stat.size;
    } catch (err) {
      Logger.error(TAG, 'openReadSync: open file failed.');
    } finally {
      try {
        file && fileIo.closeSync(file);
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        Logger.error(TAG, `OpenSync or writeSync file failed. Cause: code: ${err.code}, message: ${err.message}`);
      }
    }
    return 0;
  }

  writeFileContent(uri: string, content: string): void {
    Logger.info(TAG, 'writeFileContent begin');
    let file: fileIo.File = null!;
    try {
      file = fileIo.openSync(uri, fileIo.OpenMode.READ_WRITE);
      fileIo.writeSync(file.fd, content);
    } catch (err) {
      Logger.error(TAG, 'openSync file failed.');
    } finally {
      try {
        file && fileIo.closeSync(file);
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        Logger.error(TAG, `OpenSync or writeSync file failed. Cause: code: ${err.code}, message: ${err.message}`);
      }
    }
  }

  async getAllFiles(): Promise<void> {
    Logger.info(TAG, 'getAllFiles begin');
    AppStorage.setOrCreate(CommonConstants.AS_KEY_FILE_NAME_LIST, this.fileNameList);
    AppStorage.setOrCreate(CommonConstants.AS_KEY_FILE_SIZE_LIST, this.fileSizeList);
    AppStorage.setOrCreate(CommonConstants.AS_KEY_FILE_URI_LIST, this.fileUriList);
  }
}