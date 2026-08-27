/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { DEFINED_ERROR } from './ErrorCode';

export enum DHubLoggerLevel {
  DEBUG = 'DEBUG',
  INFO = 'INFO',
  WARN = 'WARN',
  ERROR = 'ERROR'
}

export class DHubLogger {
  private static loggerLevel: string = 'INFO';
  private static readonly LOGGER_DOMAIN: number = 0xFF00;
  private static readonly LOGGER_TAG: string = 'DialogHub Logger';

  public static openLog(level: 'DEBUG' | 'INFO') {
    DHubLogger.loggerLevel = level;
  }

  public static isLoggable(type: DHubLoggerLevel): boolean {
    if (!hilog.isLoggable(DHubLogger.LOGGER_DOMAIN, DHubLogger.LOGGER_TAG, hilog.LogLevel[type]) ||
      (type === 'DEBUG' && DHubLogger.loggerLevel !== 'DEBUG') || (type === 'INFO' && !DHubLogger.loggerLevel)) {
      return false;
    }

    return true;
  }

  public static debug(format: string, ...args: Array<string | number>): void {
    if (!DHubLogger.isLoggable(DHubLoggerLevel.DEBUG)) {
      return;
    }

    const publicFormat =
      `[DialogHub DEBUG]${format.replaceAll('%s', '%{public}s')
        .replaceAll('%d', '%{public}d')
        .replaceAll('%i', '%{public}i')}`;
    hilog.debug(DHubLogger.LOGGER_DOMAIN, DHubLogger.LOGGER_TAG, publicFormat, ...args);
  }

  public static info(format: string, ...args: Array<string | number>): void {
    if (!DHubLogger.isLoggable(DHubLoggerLevel.INFO)) {
      return;
    }

    const publicFormat =
      `[DialogHub INFO]${format.replaceAll('%s', '%{public}s')
        .replaceAll('%d', '%{public}d')
        .replaceAll('%i', '%{public}i')}`;
    hilog.info(DHubLogger.LOGGER_DOMAIN, DHubLogger.LOGGER_TAG, publicFormat, ...args);
  }

  public static warn(format: string, ...args: Array<string | number>): void {
    if (!DHubLogger.isLoggable(DHubLoggerLevel.WARN)) {
      return;
    }

    const publicFormat =
      `[DialogHub WARN]${format.replaceAll('%s', '%{public}s')
        .replaceAll('%d', '%{public}d')
        .replaceAll('%i', '%{public}i')}`;
    hilog.warn(DHubLogger.LOGGER_DOMAIN, DHubLogger.LOGGER_TAG, publicFormat, ...args);
  }

  public static error(format: string, ...args: Array<string | number>): void {
    if (!DHubLogger.isLoggable(DHubLoggerLevel.ERROR)) {
      return;
    }
    let formatStr: string = format;
    if (DEFINED_ERROR[format]) {
      formatStr = `${format} ${DEFINED_ERROR[format]?.errorCode} ${DEFINED_ERROR[format]?.errorMsg}`;
    }

    const publicFormat =
      `[DialogHub ERROR]${formatStr.replaceAll('%s', '%{public}s')
        .replaceAll('%d', '%{public}d')
        .replaceAll('%i', '%{public}i')}`;
    hilog.error(DHubLogger.LOGGER_DOMAIN, DHubLogger.LOGGER_TAG, publicFormat, ...args);
  }
}