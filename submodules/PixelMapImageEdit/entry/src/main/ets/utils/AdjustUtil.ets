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

const TAG: string = 'imageEdit_Adjust';

function adjustBrightness(pixelData: Uint8ClampedArray, adjustedData: Uint8ClampedArray, i: number,
  factor: number): void {
  const r = pixelData[i] * factor;
  const g = pixelData[i + 1] * factor;
  const b = pixelData[i + 2] * factor;

  adjustedData[i] = Math.max(0, Math.min(255, Math.round(r)));
  adjustedData[i + 1] = Math.max(0, Math.min(255, Math.round(g)));
  adjustedData[i + 2] = Math.max(0, Math.min(255, Math.round(b)));
}

function adjustSaturation(pixelData: Uint8ClampedArray, adjustedData: Uint8ClampedArray, i: number,
  factor: number): void {
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
}

/**
 * Adjusts brightness or saturation of image pixel data.
 *
 * @param bufferArray - Pixel data buffer
 * @param last - Previous adjustment value
 * @param cur - Current adjustment value (0-100 range)
 * @param hsvIndex - Adjustment type (BRIGHTNESS or SATURATION)
 * @returns Adjusted pixel data buffer or null if invalid input
 */
export function execColorInfo(bufferArray: ArrayBuffer, last: number, cur: number, hsvIndex: number) {
  if (!bufferArray || bufferArray.byteLength === 0) {
    return null;
  }

  if (last <= 0 || cur < 0) {
    return null;
  }

  try {
    const pixelData = new Uint8ClampedArray(bufferArray);
    const adjustedData = new Uint8ClampedArray(pixelData.length);
    const bytesPerPixel = 4;
    const factor = cur / 100;
    for (let i = 0; i < pixelData.length; i += bytesPerPixel) {
      adjustedData[i + 3] = pixelData[i + 3];

      if (pixelData[i + 3] < 1) {
        continue;
      }

      if (hsvIndex === AdjustType.BRIGHTNESS) {
        adjustBrightness(pixelData, adjustedData, i, factor);
      }
      if (hsvIndex === AdjustType.SATURATION) {
        adjustSaturation(pixelData, adjustedData, i, factor);
      }
    }
    return adjustedData.buffer;
  } catch (error) {
    Logger.error(TAG, `Failed to set adjustedData: ${JSON.stringify(error.message)}`);
    return null;
  }
}