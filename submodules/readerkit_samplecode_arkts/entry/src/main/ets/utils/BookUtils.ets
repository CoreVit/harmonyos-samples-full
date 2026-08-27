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

import Logger from '../utils/Logger';

enum BookFileType {
  UNKNOWN = -1,
  TXT = 1,
  EPUB = 2,
  MOBI = 3,
  AZW = 4,
  AZW3 = 5
}

const EXTENSION_FILE_TXT = 'txt';

const EXTENSION_FILE_EPUB = 'epub';

const EXTENSION_FILE_MOBI = 'mobi';

const EXTENSION_FILE_AZW = 'azw';

const EXTENSION_FILE_AZW3 = 'azw3';


const SUPPORT_EXTENSION_FILE =
  [EXTENSION_FILE_TXT, EXTENSION_FILE_EPUB, EXTENSION_FILE_MOBI, EXTENSION_FILE_AZW, EXTENSION_FILE_AZW3];

const SUPPORT_BOOK_FILE_TYPES =
  [BookFileType.TXT, BookFileType.EPUB, BookFileType.MOBI, BookFileType.AZW, BookFileType.AZW3];

export class BookUtils {
  /**
   * Convert book types based on suffix
   * @param suffixName - Book file name extension
   * @returns {BOOK_FILE_TYPE}
   */
  public static convertSuffixToSourceType(suffixName: string): number {
    switch (suffixName) {
      case EXTENSION_FILE_TXT:
        return BookFileType.TXT;
      case EXTENSION_FILE_EPUB:
        return BookFileType.EPUB;
      case EXTENSION_FILE_MOBI:
        return BookFileType.MOBI;
      case EXTENSION_FILE_AZW:
        return BookFileType.AZW;
      case EXTENSION_FILE_AZW3:
        return BookFileType.AZW3;
      default:
        return BookFileType.UNKNOWN;
    }
  }

  /**
   * Convert the suffix of a book file based on the book type
   * @param sourceType - {BOOK_FILE_TYPE}
   * @returns Book File Suffix
   */
  public static convertSourceTypeToSuffix(sourceType: number): string {
    switch (sourceType) {
      case BookFileType.TXT:
        return EXTENSION_FILE_TXT;
      case BookFileType.EPUB:
        return EXTENSION_FILE_EPUB;
      case BookFileType.MOBI:
        return EXTENSION_FILE_MOBI;
      case BookFileType.AZW:
        return EXTENSION_FILE_AZW;
      case BookFileType.AZW3:
        return EXTENSION_FILE_AZW3;
      default:
        return '';
    }
  }

  public static getBookFileBasePath(workPath: string, bookId: string): string {
    return `${workPath}${bookId}/`;
  }

  public static getBookFileLocalBookPath(workPath: string): string {
    return `${workPath}import/`;
  }

  public static isSupportFromSuffix(suffixName: string): boolean {
    return SUPPORT_EXTENSION_FILE.includes(suffixName);
  }

  public static isSupportFromType(bookFileType: number): boolean {
    return SUPPORT_BOOK_FILE_TYPES.includes(bookFileType);
  }

  public static getString(context: Context | undefined, name: string): string {
    try {
      return context?.resourceManager.getStringByNameSync(name) || '';
    } catch (error) {
      Logger.error(`getStringSync failed, error code: ${error.code}, message: ${error.message}.`);
    }
    return '';
  }
}
