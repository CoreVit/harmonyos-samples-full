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
import { fileIo as fs, ReadOptions, WriteOptions } from '@kit.CoreFileKit';
import Logger from './Logger';

const TAG: string = '[FileUtil]';

export class FileUtil {
  public static accessFileSync(path: string): boolean {
    try {
      return fs.accessSync(path);
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `Operate file failed. Cause code: ${err.code}, message: ${err.message}`);
    }
    return false;
  }

  public static getFilePath(context: Context, docUri: string): string {
    return context.filesDir + '/' + FileUtil.getFileName(docUri);
  }

  public static getFileName(path: string): string {
    const normalizedPath = path.replace(/\\/g, '/');
    const lastSlashIndex = normalizedPath.lastIndexOf('/');
    const fullName = lastSlashIndex >= 0 ? normalizedPath.substring(lastSlashIndex + 1) : normalizedPath;
    return fullName;
  }

  public static getFileSize(path: string): number {
    try {
      if (fs.accessSync(path)) {
        return Math.floor(fs.lstatSync(path).size / 1024 / 1024 * 100) / 100;
      }
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `Operate file failed. Cause code: ${err.code}, message: ${err.message}`);
    }
    return 0;
  }

  public static readWriteFile(srcFilePath: string, dstFilePath: string): void {
    let srcFile: fs.File = null!;
    let destFile: fs.File = null!;
    try {
      if (fs.accessSync(dstFilePath)) {
        fs.unlink(dstFilePath)
      }
      srcFile = fs.openSync(srcFilePath, fs.OpenMode.READ_ONLY);
      destFile = fs.openSync(dstFilePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      // Reads the content of the source file and writes it to the destination file
      let bufSize = 4096;
      let readSize = 0;
      let buf = new ArrayBuffer(bufSize);
      let readOptions: ReadOptions = {
        offset: readSize,
        length: bufSize
      };
      let readLen = fs.readSync(srcFile.fd, buf, readOptions);
      while (readLen > 0) {
        readSize += readLen;
        let writeOptions: WriteOptions = {
          length: readLen
        };
        fs.writeSync(destFile.fd, buf, writeOptions);
        readOptions.offset = readSize;
        readLen = fs.readSync(srcFile.fd, buf, readOptions);
      }
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `Write file failed. Cause code: ${err.code}, message: ${err.message}`);
    } finally {
      try {
        fs.close(srcFile);
        fs.close(destFile);
      } catch (error) {
        const err = error as BusinessError;
        Logger.error(TAG, `Close file failed. Cause code: ${err.code}, message: ${err.message}`);
      }
    }
  }
}