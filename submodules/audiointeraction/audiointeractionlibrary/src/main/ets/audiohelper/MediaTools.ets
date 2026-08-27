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

import { util } from '@kit.ArkTS';
import { image } from '@kit.ImageKit';
import { resourceManager } from '@kit.LocalizationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { KeyConstants } from '../common/constants/KeyConstants';
import Logger from '../common/utils/Logger';
import { SECOND_BUFFER_WALK } from '../songdatacontroller/PlayerData';

const TAG: string = '[MediaTools]';

export class MediaTools {
  static async getPixelMapFromResource(name: resourceManager.Resource): Promise<PixelMap | undefined> {
    const uiContext: UIContext | undefined = AppStorage.get<UIContext>(KeyConstants.KEY_UI_CONTEXT);
    try {
      if (uiContext && uiContext.getHostContext()) {
        const resourceMgr = uiContext.getHostContext()!.resourceManager;
        const fileData: Uint8Array = await resourceMgr.getMediaContent(name.id);
        const imageSource = image.createImageSource(fileData.buffer as ArrayBuffer);
        const createPixelMap: image.PixelMap = await imageSource.createPixelMap();
        await imageSource?.release();
        return createPixelMap;
      }
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `getMediaContent failed: cause the code ${err.code}, the message is ${err.message}`);
    }
    return undefined;
  }

  static msToCountdownTime(ms: number): string {
    if (!ms) {
      return '00:00';
    }
    const days = Math.floor(ms / (1000 * 60 * 60 * 24));
    const hours = Math.floor((ms % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    const minutes = Math.floor((ms % (1000 * 60 * 60)) / (1000 * 60));
    const seconds = Math.floor((ms % (1000 * 60)) / 1000);
    return `${(days ? MediaTools.fill(days) + ':' : '')}${(hours ? MediaTools.fill(hours) + ':' : '')}
      ${MediaTools.fill(minutes)}:${MediaTools.fill(seconds)} `.trim();
  }

  // Convert bytes to seconds
  static getMsFromByteLength(byteLength: number): number {
    return 1000 * (byteLength / SECOND_BUFFER_WALK);
  }

  static getOffsetFromTime(curMs: number) {
    return (curMs / 1000) * SECOND_BUFFER_WALK;
  }

  static async getLrcFromRawFile(filename: string): Promise<string | undefined> {
    if (!filename) {
      return undefined;
    }
    const uiContext: UIContext | undefined = AppStorage.get<UIContext>(KeyConstants.KEY_UI_CONTEXT);
    if (!uiContext || !uiContext.getHostContext()) {
      return undefined;
    }
    try {
      const lyricUint8Array: Uint8Array = await uiContext.getHostContext()!.resourceManager.getRawFileContent(filename);
      const textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
      const resStr: string = textDecoder.decodeToString(lyricUint8Array, { stream: false });
      return resStr;
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `getRawFileContent failed: cause the code ${err.code}, the message is ${err.message}`);
      return undefined;
    }
  }

  /**
   * @param {string} value - data value
   * @return {string} - If the date is less than two digits, add a zero.
   */
  private static fill(value: number): string {
    return value.toString().padStart(2, '0');
  }
}