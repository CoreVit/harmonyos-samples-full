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

import { BusinessError } from '@kit.BasicServicesKit';
import { RegionItem } from '../viewModel/RegionItem';
import { CommonConstants } from '../common/constant/CommonConstants';
import Logger from './Logger';

const TAG: string = '[CropUtil]'

/**
 * Crop image to 1:1 square ratio. The crop region is centered.
 *
 * @param pixelMap - The image to crop.
 * @param width - Original image width.
 * @param height - Original image height.
 */
export async function square(pixelMap: PixelMap, width: number, height: number): Promise<void> {
  if (!pixelMap) {
    return;
  }
  try {
    if (width < height) {
      await pixelMap.crop({
        size: {
          width: width,
          height: width
        },
        x: 0,
        y: Math.round((height - width) / CommonConstants.AVERAGE_WEIGHT_WIDTH)
      });
    } else {
      await pixelMap.crop({
        size: {
          width: height,
          height: height
        },
        x: Math.round((width - height) / CommonConstants.AVERAGE_WEIGHT_WIDTH),
        y: 0
      });
    }
  } catch (err) {
    Logger.error(TAG, `Error happend @square pixelMap.crop, ${err.code}: ${err.message}`);
    return;
  }
}

/**
 * Common crop function with specified dimensions and position.
 *
 * @param pixelMap - The image to crop.
 * @param cropWidth - Width of the crop region.
 * @param cropHeight - Height of the crop region.
 * @param cropPosition - Top-left position of the crop region.
 */
export async function cropCommon(pixelMap: PixelMap, cropWidth: number,
  cropHeight: number, cropPosition: RegionItem): Promise<void> {
  if (!pixelMap) {
    return;
  }
  try {
    await pixelMap.crop({
      size: {
        width: cropWidth,
        height: cropHeight
      },
      x: cropPosition.x,
      y: cropPosition.y
    });
  } catch (err) {
    Logger.error(TAG, `Error happend @cropCommon pixelMap.crop, ${err.code}: ${err.message}`);
  }
}

/**
 * Crop image to 4:3 ratio. The crop region is centered.
 *
 * @param pixelMap - The image to crop.
 * @param width - Original image width.
 * @param height - Original image height.
 */
export async function banner(pixelMap: PixelMap, width: number, height: number): Promise<void> {
  if (width <= height) {
    const cropWidth = width;
    const cropHeight = Math.floor(width * CommonConstants.CROP_RATE_4_3);
    const cropPosition = new RegionItem(0, Math.floor((height - cropHeight) / CommonConstants.AVERAGE_WEIGHT_WIDTH));
    await cropCommon(pixelMap, cropWidth, cropHeight, cropPosition);
    return;
  }
  if (width * CommonConstants.CROP_RATE_4_3 >= height) {
    const cropWidth = Math.floor(height / CommonConstants.CROP_RATE_4_3);
    const cropHeight = height;
    const cropPosition = new RegionItem(Math.floor((width - cropWidth) / CommonConstants.AVERAGE_WEIGHT_WIDTH), 0);
    await cropCommon(pixelMap, cropWidth, cropHeight, cropPosition);
    return;
  }

  const cropWidth = width;
  const cropHeight = Math.floor(width * CommonConstants.CROP_RATE_4_3);
  const cropPosition = new RegionItem(0, Math.floor((height - cropHeight) / CommonConstants.AVERAGE_WEIGHT_WIDTH));
  await cropCommon(pixelMap, cropWidth, cropHeight, cropPosition);
}

/**
 * Crop image to 16:9 ratio. The crop region is centered.
 *
 * @param pixelMap - The image to crop.
 * @param width - Original image width.
 * @param height - Original image height.
 */
export async function rectangle(pixelMap: PixelMap, width: number, height: number): Promise<void> {
  if (width <= height) {
    const cropWidth = width;
    const cropHeight = Math.floor(width * (CommonConstants.CROP_RATE_9_16));
    const cropPosition = new RegionItem(0, Math.floor((height - cropHeight) / CommonConstants.AVERAGE_WEIGHT_WIDTH));
    await cropCommon(pixelMap, cropWidth, cropHeight, cropPosition);
    return;
  }
  if (width * (CommonConstants.CROP_RATE_9_16) >= height) {
    const cropWidth = Math.floor(height / (CommonConstants.CROP_RATE_9_16));
    const cropHeight = height;
    const cropPosition = new RegionItem(Math.floor((width - cropWidth) / CommonConstants.AVERAGE_WEIGHT_WIDTH), 0);
    await cropCommon(pixelMap, cropWidth, cropHeight, cropPosition);
    return;
  }

  const cropWidth = width;
  const cropHeight = Math.floor(width * (CommonConstants.CROP_RATE_9_16));
  const cropPosition = new RegionItem(0, Math.floor((height - cropHeight) / CommonConstants.AVERAGE_WEIGHT_WIDTH));
  await cropCommon(pixelMap, cropWidth, cropHeight, cropPosition);
}