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

import type { BusinessError } from '@kit.BasicServicesKit';
import { fileIo } from '@kit.CoreFileKit';
import { util } from '@kit.ArkTS';
import { Logger } from '../utils/Logger';

const TAG = 'FileStore';

export abstract class FileStore {
  abstract getFileName(): string;

  writeJsonSync(context: Context, data: object): void {
    let filePath = context.filesDir + '/' + this.getFileName();
    let content = JSON.stringify(data);
    let file: fileIo.File | undefined;
    try {
      file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE | fileIo.OpenMode.TRUNC);
      fileIo.writeSync(file.fd, content);
      Logger.info(TAG, `writeJsonSync: ${this.getFileName()}`);
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `writeJsonSync err, code: ${error.code}, message: ${error.message}`);
    } finally {
      if (file) {
        this.closeFile(file);
      }
    }
  }

  readJsonSync(context: Context): object | undefined {
    try {
      let filePath = context.filesDir + '/' + this.getFileName();
      let file = fileIo.openSync(filePath, fileIo.OpenMode.READ_ONLY);
      let stat = fileIo.statSync(filePath);
      let content = new ArrayBuffer(stat.size);
      fileIo.readSync(file.fd, content);
      fileIo.closeSync(file);
      let textDecoder = util.TextDecoder.create('utf-8');
      let str = textDecoder.decodeToString(new Uint8Array(content));
      if (str) {
        return JSON.parse(str) as object;
      }
      return undefined;
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `readJsonSync no file or err: ${this.getFileName()}, ${error.message}`);
      return undefined;
    }
  }

  deleteFileSync(context: Context): void {
    try {
      let filePath = context.filesDir + '/' + this.getFileName();
      fileIo.unlinkSync(filePath);
      Logger.info(TAG, `deleteFileSync: ${this.getFileName()}`);
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `deleteFileSync no file: ${this.getFileName()}, ${error.message}`);
    }
  }

  closeFile(file: fileIo.File): void {
    try {
      fileIo.closeSync(file);
    } catch (e) {
      Logger.error(TAG, `close file error`);
    }
  }
}