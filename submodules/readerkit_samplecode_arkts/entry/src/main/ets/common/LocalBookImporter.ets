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

import { fileIo as fs, hash } from '@kit.CoreFileKit';
import { util } from '@kit.ArkTS';
import { BookParserInfo, LocalBookImportResult } from './BookParserInfo';
import { BookUtils } from '../utils/BookUtils';
import { FileUtils } from '../utils/FileUtils';
import Logger from '../utils/Logger';

const TAG = 'LocalBookImporter';

// Algorithm used for file hash
const LOCAL_FILE_HASH_ALGORITHM = 'sha256';

// The maximum size of the import file is 300 MB
const IMPORT_FILE_SIZE_THRESHOLD = 300 * 1024 * 1024;

const LOCAL_BOOK_PREFIX: string = 'import_';

export class LocalBookImporter {
  /**
   * Import book file to the specified location
   *
   * @param filePath - Book file path
   * @param workPath - save path
   * @return {BookParserInfo}
   */
  public async importLocalBookToCache(filePath: string, workPath: string): Promise<BookParserInfo> {
    Logger.info(TAG, 'importLocalBookToCache start', filePath);
    try {
      if (!fs.accessSync(workPath)) {
        fs.mkdirSync(workPath);
      }
      const path = BookUtils.getBookFileLocalBookPath(workPath);
      if (!fs.accessSync(path)) {
        fs.mkdirSync(path);
      }
      await this.checkFileValid(filePath);

      let bookParserInfo = await this.getLocalBookBasicParserInfo(filePath);
      bookParserInfo = await this.handleLocalBookFileCache(filePath, workPath, bookParserInfo);
      return Promise.resolve(bookParserInfo);
    } catch (error) {
      Logger.info(TAG,
        `importLocalBookToCache failed, Code: ${error.code}, message: ${error.message}`);
      return Promise.reject(error);
    }
  }

  private async checkFileValid(filePath: string): Promise<LocalBookImportResult> {
    if (!filePath || filePath.length === 0) {
      Logger.error(TAG, 'checkFileValid LOCAL_BOOK_IMPORT_FILE_NOT_EXIST : ', filePath);
      return Promise.reject(LocalBookImportResult.LOCAL_BOOK_IMPORT_FILE_NOT_EXIST);
    }
    let fileFd = 0;
    try {
      const file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
      fileFd = file.fd;
      const stat = await fs.stat(file.fd);
      if (0 >= stat.size) {
        Logger.error(TAG, 'checkFileValid LOCAL_BOOK_IMPORT_FILE_EXCEPTION.');
        return Promise.reject(LocalBookImportResult.LOCAL_BOOK_IMPORT_FILE_EXCEPTION);
      } else if (IMPORT_FILE_SIZE_THRESHOLD < stat.size) {
        Logger.error(TAG, 'checkFileValid LOCAL_BOOK_IMPORT_FILE_EXCEED_THRESHOLD.', stat.size.toString());
        return Promise.reject(LocalBookImportResult.LOCAL_BOOK_IMPORT_FILE_EXCEED_THRESHOLD);
      } else {
        Logger.info(TAG, 'checkFileValid LOCAL_BOOK_IMPORT_SUCCESS.');
        return Promise.resolve(LocalBookImportResult.LOCAL_BOOK_IMPORT_SUCCESS);
      }
    } catch (error) {
      Logger.error(TAG,
        `checkFileValid LOCAL_BOOK_IMPORT_FILE_SYSTEM_ERROR, Code: ${error.code}, message: ${error.message}`);
      return Promise.reject(LocalBookImportResult.LOCAL_BOOK_IMPORT_FILE_SYSTEM_ERROR);
    } finally {
      try {
        fs.closeSync(fileFd);
      } catch (error) {
        Logger.info(TAG,
          `closeSync failed , Code: ${error.code}, message: ${error.message}`);
      }
    }
  }

  private async handleLocalBookFileCache(filePath: string, workPath: string,
    bookParserInfo: BookParserInfo): Promise<BookParserInfo> {
    try {
      const bookFilePath = BookUtils.getBookFileBasePath(workPath, bookParserInfo.getBookId());
      if (!fs.accessSync(bookFilePath)) {
        fs.mkdirSync(bookFilePath);
      }
      const dstPath = bookFilePath + bookParserInfo.getBookName() + '.' +
        BookUtils.convertSourceTypeToSuffix(bookParserInfo.getBookSourceType());
      if (!fs.accessSync(dstPath)) {
        // if this is the first import, copy the book file to the target directory
        await this.copyBookToCache(filePath, dstPath, bookParserInfo);
        const hashCode = await hash.hash(dstPath, LOCAL_FILE_HASH_ALGORITHM);
        bookParserInfo.setLocalHash(hashCode);
        bookParserInfo.setFilePath(dstPath);
        Logger.info(TAG, 'handleLocalBookFileCache dst file not exist. Copy file.');
      }
      return Promise.resolve(bookParserInfo);
    } catch (error) {
      Logger.error(TAG,
        `handleLocalBookFileCache err:, Code: ${error.code}, message: ${error.message}`);
      return Promise.reject(LocalBookImportResult.LOCAL_BOOK_IMPORT_FILE_SYSTEM_ERROR);
    }
  }

  private async copyBookToCache(filePath: string, dstPath: string, bookParserInfo: BookParserInfo): Promise<void> {
    try {
      await FileUtils.copyFileToCache(filePath, dstPath);
      Logger.info(TAG, 'copyBookToCache succeeded. bookId:', bookParserInfo.getBookId());
      return Promise.resolve();
    } catch (error) {
      Logger.error(TAG, 'copyBookToCache LOCAL_BOOK_IMPORT_FILE_SYSTEM_ERROR : ', error.message, ', error code: ',
        error.code);
      return Promise.reject();
    }
  }

  private async getLocalBookBasicParserInfo(filePath: string): Promise<BookParserInfo> {
    try {
      const extensionFileName = FileUtils.getExtensionFileName(filePath);
      const bookName = FileUtils.getFileName(filePath);
      let bookType = -1;
      if (!BookUtils.isSupportFromSuffix(extensionFileName)) {
        // This format book file is not supported
        Logger.error(TAG, 'getLocalBookBasicParserInfo LOCAL_BOOK_IMPORT_FILE_NOT_SUPPORT_TYPE : ',
          extensionFileName);
        return Promise.reject(LocalBookImportResult.LOCAL_BOOK_IMPORT_FILE_NOT_SUPPORT_TYPE);
      } else {
        bookType = BookUtils.convertSuffixToSourceType(extensionFileName);
      }
      const bookId = LOCAL_BOOK_PREFIX + util.generateRandomUUID(true);
      const bookInfo = new BookParserInfo();
      bookInfo.setBookId(bookId).setBookSourceType(bookType).setBookName(bookName);
      return Promise.resolve(bookInfo);
    } catch (error) {
      Logger.error(TAG, 'getLocalBookBasicParserInfo LOCAL_BOOK_IMPORT_FILE_SYSTEM_ERROR : ', error.message,
        ', error code: ',
        error.code);
      return Promise.reject(LocalBookImportResult.LOCAL_BOOK_IMPORT_FILE_SYSTEM_ERROR);
    }
  }
}