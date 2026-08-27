/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { CommonConstants } from '../common/constant/CommonConstants';
import { execColorInfo } from '../utils/AdjustUtil';
import { AdjustType } from '../viewModel/OptionViewModel';
import Logger from '../utils/Logger';

const TAG = 'AdjustBrightnessWork';
let workerPort: ThreadWorkerGlobalScope = worker.workerPort;

interface AdjustMessageData {
  buf: ArrayBuffer;
  last: number;
  cur: number;
  adjustType: AdjustType;
}

/**
 * Defines the event handler to be called when the worker thread receives a message sent by the host thread.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessage = (event: MessageEvents): void => {
  if (!event || !event.data) {
    Logger.error(TAG, 'event or event.data is null');
    return;
  }
  if ((event.data?.buf as ArrayBuffer).byteLength > CommonConstants.MAX_ALLOWED_IMAGE_SIZE) {
    Logger.error(TAG, 'buf over-sized.');
    return;
  }
  const data: AdjustMessageData = event.data as AdjustMessageData;
  if (data.buf === undefined || data.buf === null) {
    Logger.error(TAG, 'buf is null or undefined');
    return;
  }
  if (data.last === undefined || data.last === null) {
    Logger.error(TAG, 'last is null or undefined');
    return;
  }
  if (data.cur === undefined || data.cur === null) {
    Logger.error(TAG, 'cur is null or undefined');
    return;
  }
  if (data.adjustType === undefined || data.adjustType === null) {
    Logger.error(TAG, 'adjustType is null or undefined');
    return;
  }
  let bufferArray: ArrayBuffer = data.buf;
  let last: number = data.last;
  let cur: number = data.cur;
  let adjustType: AdjustType = data.adjustType;
  let buffer = execColorInfo(bufferArray, last, cur, adjustType);
  try {
    workerPort.postMessage(buffer);
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    Logger.error(TAG, `post message, error ${err.code}: ${err.message}`);
  }
};

/**
 * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessageerror = (event: MessageEvents): void => {
  Logger.error(TAG, `workerPort message error ${event.type} on ${event.timeStamp}`);
};

/**
 * Defines the event handler to be called when an exception occurs during worker execution.
 * The event handler is executed in the worker thread.
 *
 * @param e error message
 */
workerPort.onerror = (error: ErrorEvent): void => {
  Logger.error(TAG, `workerPort error ${error.message}, ${error.type}, ${error.filename}`);
};
