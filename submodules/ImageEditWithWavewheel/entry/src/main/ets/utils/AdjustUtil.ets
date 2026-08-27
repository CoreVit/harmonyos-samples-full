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

import { AdjustType } from '../viewModel/OptionViewModel';
import Logger from './Logger';

const TAG = `AdjustUtil`;

/**
 * Exec color transform.
 *
 * @param bufferArray.
 * @param last.
 * @param cur.
 * @param hsvIndex.
 * @return arrayBuffer.
 */
export function execColorInfo(bufferArray: ArrayBuffer, last: number, cur: number,
  hsvIndex: number): ArrayBuffer | null {
  if (!bufferArray || bufferArray.byteLength === 0) {
    return null;
  }

  if (last <= 0 || cur < 0) {
    return null;
  }
  Logger.debug(TAG, `execColorInfo last=${last} cur=${cur} hsvIndex=${hsvIndex}`);
  try {
    const pixelData = new Uint8ClampedArray(bufferArray);
    const adjustedData = new Uint8ClampedArray(pixelData.length);
    const bytesPerPixel = 4;
    const factor = cur / 100; // Regulatory factor
    for (let i = 0; i < pixelData.length; i += bytesPerPixel) {
      // Reserve the alpha channel
      adjustedData[i + 3] = pixelData[i + 3];

      // Skip the pixels that are completely transparent
      if (pixelData[i + 3] < 1) {
        continue;
      }

      if (hsvIndex === AdjustType.BRIGHTNESS) {
        let r = pixelData[i] * factor;
        let g = pixelData[i + 1] * factor;
        let b = pixelData[i + 2] * factor;

        adjustedData[i] = Math.max(0, Math.min(255, Math.round(r)));
        adjustedData[i + 1] = Math.max(0, Math.min(255, Math.round(g)));
        adjustedData[i + 2] = Math.max(0, Math.min(255, Math.round(b)));

        if (i === 0) {
          Logger.info(TAG,
            `[Brightness] factor=${factor}, pixel[0] RGB=(${pixelData[0]},${pixelData[1]},${pixelData[2]})
            -> (${adjustedData[0]},${adjustedData[1]},${adjustedData[2]})`);
        }
      }
      if (hsvIndex === AdjustType.SATURATION) {
        const r = pixelData[i] / 255;
        const g = pixelData[i + 1] / 255;
        const b = pixelData[i + 2] / 255;

        const luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b;

        const adjustedR = luminance + (r - luminance) * factor;
        const adjustedG = luminance + (g - luminance) * factor;
        const adjustedB = luminance + (b - luminance) * factor;

        adjustedData[i] = Math.max(0, Math.min(255, Math.round(adjustedR * 255)));
        adjustedData[i + 1] = Math.max(0, Math.min(255, Math.round(adjustedG * 255)));
        adjustedData[i + 2] = Math.max(0, Math.min(255, Math.round(adjustedB * 255)));

        if (i === 0) {
          Logger.info(TAG,
            `[Saturation] factor=${factor}, pixel[0] RGB=(${pixelData[0]},${pixelData[1]},${pixelData[2]})
            -> (${adjustedData[0]},${adjustedData[1]},${adjustedData[2]})`);
        }
      }
      if (hsvIndex === AdjustType.OPACITY) {
        adjustedData[i] = pixelData[i];
        adjustedData[i + 1] = pixelData[i + 1];
        adjustedData[i + 2] = pixelData[i + 2];
        adjustedData[i + 3] = Math.round(pixelData[i + 3] * factor);

        if (i === 0) {
          Logger.info(TAG,
            `[Opacity] factor=${factor}, pixel[0] RGBA=(${pixelData[0]},${pixelData[1]},${pixelData[2]},${pixelData[3]})
            -> (${adjustedData[0]},${adjustedData[1]},${adjustedData[2]},${adjustedData[3]})`);
        }
      }
    }
    return adjustedData.buffer;
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    Logger.error(TAG, `Failed to set adjustedData, error ${err.code}: ${err.message}`);
    return null;
  }
}
