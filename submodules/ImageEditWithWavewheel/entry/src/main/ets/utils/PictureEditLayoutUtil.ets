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

import { image } from '@kit.ImageKit';
import { EditStateViewModel } from '../viewModel/EditStateViewModel';
import { EditMode } from '../types/CommonTypes';
import { getValueByBreakpointSync } from './MultiDeviceUtil';
import type { BreakpointType } from './MultiDeviceUtil';
import Logger from './Logger';

const TAG = 'PictureEditLayoutUtil';

export interface ImageFitConfig {
  fit: ImageFit;
  clip: boolean;
}

export interface BaseDisplaySize {
  width: number;
  height: number;
}

export function calculateBaseDisplaySize(
  containerWidth: number,
  containerHeight: number,
  editState: EditStateViewModel,
  previewPixelMap: image.PixelMap | undefined,
  currentBreakpoint: BreakpointType,
  px2vp: (px: number) => number
): BaseDisplaySize {
  const size: BaseDisplaySize = { width: containerWidth, height: containerHeight };

  if (editState.baseDisplayWidth > 0 && editState.baseDisplayHeight > 0) {
    size.width = editState.baseDisplayWidth;
    size.height = editState.baseDisplayHeight;
    return size;
  }

  if (!previewPixelMap || containerWidth <= 0 || containerHeight <= 0) {
    return size;
  }

  try {
    const info = previewPixelMap.getImageInfoSync();
    const pixelWidth = info.size.width;
    const pixelHeight = info.size.height;
    const vpWidth = px2vp(pixelWidth);
    const vpHeight = px2vp(pixelHeight);
    const aspectRatio = vpWidth / vpHeight;

    if (currentBreakpoint === 'sm') {
      const widthBasedWidth = containerWidth;
      const widthBasedHeight = widthBasedWidth / aspectRatio;

      const heightBasedHeight = containerHeight;
      const heightBasedWidth = heightBasedHeight * aspectRatio;

      if (widthBasedHeight <= containerHeight) {
        size.width = widthBasedWidth;
        size.height = widthBasedHeight;
      } else {
        size.width = heightBasedWidth;
        size.height = heightBasedHeight;
      }
    } else {
      size.height = containerHeight;
      size.width = size.height * aspectRatio;
    }
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    Logger.error(`${TAG} getImageInfoSync failed, error ${err.code}: ${err.message}`);
  }

  return size;
}

export function getImageWidth(
  editState: EditStateViewModel,
  containerWidth: number,
  currentBreakpoint: BreakpointType
): Length {
  if (editState.currentEditMode === EditMode.TRANSLATE_MODE ||
    editState.currentEditMode === EditMode.ZOOM_MODE) {
    const baseWidth = editState.baseDisplayWidth || containerWidth;
    if (editState.currentEditMode === EditMode.ZOOM_MODE) {
      return baseWidth * (editState.currentZoom / 100);
    }
    return baseWidth;
  }

  return getValueByBreakpointSync<Length>({
    sm: '100%',
    md: 'auto',
    lg: 'auto'
  }, currentBreakpoint);
}

export function getImageHeight(
  editState: EditStateViewModel,
  containerHeight: number,
  currentBreakpoint: BreakpointType
): Length {
  if (editState.currentEditMode === EditMode.TRANSLATE_MODE ||
    editState.currentEditMode === EditMode.ZOOM_MODE) {
    const baseHeight = editState.baseDisplayHeight || containerHeight;
    if (editState.currentEditMode === EditMode.ZOOM_MODE) {
      return baseHeight * (editState.currentZoom / 100);
    }
    return baseHeight;
  }

  return getValueByBreakpointSync<Length>({
    sm: 'auto',
    md: '100%',
    lg: '100%'
  }, currentBreakpoint);
}

export function getImageFitAndClip(editState: EditStateViewModel): ImageFitConfig {
  if (editState.currentEditMode === EditMode.TRANSLATE_MODE ||
    editState.currentEditMode === EditMode.ZOOM_MODE) {
    return { fit: ImageFit.None, clip: false };
  }
  return { fit: ImageFit.Cover, clip: true };
}
