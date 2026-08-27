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
import { effectKit } from '@kit.ArkGraphics2D';
import { MessageEvents, worker } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from '../utils/Logger';
import { MessageItem } from '../viewModel/MessageItem';
import { banner, rectangle, square } from '../utils/CropUtil';
import { CommonConstants } from '../common/constant/CommonConstants';
import { AdjustType, CropType, FilterType } from '../viewModel/OptionViewModel';
import { EditType } from '../types/CommonTypes';

const TAG = 'PixelMapManager';

interface TranslateValue {
  x: number;
  y: number;
}

export class PixelMapManager {
  private startEditPixelMap?: PixelMap;
  private finalEditPixelMap?: PixelMap;
  private originPixelMap?: PixelMap;
  private originCropPixelMap?: PixelMap;
  private confirmedPixelMap?: PixelMap;
  private editMode: EditType = EditType.CROP;
  private notifyPreviewUpdate: (previewPixelMap: PixelMap) => void;
  private adjustWorker: worker.ThreadWorker =
    new worker.ThreadWorker(CommonConstants.ADJUST_WORKER_FILE);
  private adjustLock: Promise<void> = Promise.resolve();

  constructor(pixelMap: PixelMap, notifyPreviewUpdate: (previewPixelMap: PixelMap) => void) {
    this.originPixelMap = pixelMap;
    this.confirmedPixelMap = pixelMap;
    this.originCropPixelMap = pixelMap;
    this.notifyPreviewUpdate = notifyPreviewUpdate;
    this.updatePreviewPixelMap(pixelMap);
  }

  destroyPixelMapManager() {
    try {
      this.adjustWorker.terminate();
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `${error.code}, ${error.message}`);
    }
  }

  getInitPixelMap() {
    return this.originPixelMap!;
  }

  getInitCropPixelMap() {
    return this.originCropPixelMap!;
  }

  getConfirmedPixelMap() {
    return this.confirmedPixelMap!;
  }

  updateConfirmed(pixelMap: PixelMap) {
    this.confirmedPixelMap = this.clonePixelMap(pixelMap);
  }

  resetToConfirmed() {
    const confirmed = this.confirmedPixelMap!;
    this.finalEditPixelMap = confirmed;
    this.notifyPreviewUpdate(this.clonePixelMap(confirmed));
  }

  resetToOrigin() {
    const origin = this.originPixelMap!;
    this.confirmedPixelMap = origin;
    this.originCropPixelMap = origin;
    this.startEditPixelMap = origin;
    this.finalEditPixelMap = origin;
    this.notifyPreviewUpdate(this.clonePixelMap(origin));
  }

  getStartPixelMap() {
    return this.startEditPixelMap!;
  }

  getFinalPixelMap() {
    return this.finalEditPixelMap!;
  }

  updateCropPixelMap(pixelMap: image.PixelMap) {
    this.originCropPixelMap = this.clonePixelMap(pixelMap);
  }

  updateCropPixelMapSilent(pixelMap: image.PixelMap) {
    this.originCropPixelMap = pixelMap;
  }

  updatePreviewPixelMap(pixelMap: image.PixelMap) {
    this.startEditPixelMap = pixelMap;
    this.finalEditPixelMap = pixelMap;
    this.notifyPreviewUpdate(this.clonePixelMap(pixelMap));
  }

  async handleFilter(type: FilterType) {
    let px: PixelMap = this.getStartEditPixelMap(EditType.FILTER);
    let filter = effectKit.createEffect(px);

    switch (type) {
      case FilterType.GRAYSCALE:
        px = await filter.grayscale().getEffectPixelMap();
        break;
      case FilterType.BRIGHTNESS:
        px = await filter.brightness(0.7).getEffectPixelMap();
        break;
      case FilterType.INVERT:
        px = await filter.invert().getEffectPixelMap();
        break;
      case FilterType.BLUR:
        px = await filter.blur(5).getEffectPixelMap();
        break;
      default:
        break;
    }
    this.notifyPreviewUpdate(px);
    this.finalEditPixelMap = px;
  }

  getStartEditPixelMap(mode: EditType): PixelMap {
    if (this.editMode !== mode) {
      this.editMode = mode;
      this.startEditPixelMap = this.finalEditPixelMap;
    }
    let target: PixelMap | undefined;
    switch (mode) {
      case EditType.CROP:
        target = this.startEditPixelMap;
        break;
      case EditType.MIRROR:
        target = this.finalEditPixelMap;
        break;
      case EditType.ROTATION:
        target = this.finalEditPixelMap;
        break;
      case EditType.FILTER:
        target = this.startEditPixelMap;
        break;
      case EditType.ADJUST:
        target = this.startEditPixelMap;
        break;
      case EditType.TRANSLATION:
        target = this.finalEditPixelMap;
        break;
      case EditType.SCALE:
        target = this.startEditPixelMap;
        break;
      default:
        target = this.finalEditPixelMap;
        break;
    }
    return this.clonePixelMap(target!);
  }


  async cropImage(proportion: CropType, rotationAngle: number, isMirrored: boolean) {
    let px = this.clonePixelMap(this.originCropPixelMap!);
    const imageInfo = await px.getImageInfo();
    const size = imageInfo.size;
    const imageWidth = size?.width;
    const imageHeight = size?.height;

    switch (proportion) {
      case CropType.ORIGINAL_IMAGE:
        px = this.clonePixelMap(this.getInitCropPixelMap());
        break;
      case CropType.SQUARE:
        await square(px, imageWidth, imageHeight);
        break;
      case CropType.BANNER:
        await banner(px, imageWidth, imageHeight);
        break;
      case CropType.RECTANGLE:
        await rectangle(px, imageWidth, imageHeight);
        break;
      default:
        break;
    }

    await this.applyTransforms(px, rotationAngle, isMirrored);
    this.finalEditPixelMap = px;
    this.notifyPreviewUpdate(px);
  }

  private async applyTransforms(px: PixelMap, rotationAngle: number, isMirrored: boolean): Promise<void> {
    if (rotationAngle !== 0) {
      try {
        await px.rotate(rotationAngle);
      } catch (error) {
        Logger.error(TAG, `there is a error in rotate process with ${error?.code}`);
      }
    }
    if (isMirrored) {
      try {
        px.flipSync(true, false);
      } catch (error) {
        Logger.error(TAG, `there is a error in mirror process with ${error?.code}`);
      }
    }
  }

  async adjustImage(currentAdjustData: number[]) {
    const px = this.getStartEditPixelMap(EditType.ADJUST);
    let buffer = new ArrayBuffer(px.getPixelBytesNumber());
    px.readPixelsToBuffer(buffer);
    if (!buffer) {
      return;
    }
    if (currentAdjustData[AdjustType.BRIGHTNESS] !== CommonConstants.SLIDER_MAX) {
      buffer = await this.processAdjustWorker(
        currentAdjustData[AdjustType.BRIGHTNESS],
        buffer,
        AdjustType.BRIGHTNESS
      );
      try {
        px.writeBufferToPixelsSync(buffer);
      } catch (err) {
        let error = err as BusinessError;
        Logger.error(TAG, `${error.code}, ${error.message}`);
      }
    }
    if (currentAdjustData[AdjustType.SATURATION] !== CommonConstants.SLIDER_MAX) {
      try {
        buffer = await this.processAdjustWorker(
          currentAdjustData[AdjustType.SATURATION],
          buffer,
          AdjustType.SATURATION
        );
        px.writeBufferToPixelsSync(buffer);
      } catch (err) {
        let error = err as BusinessError;
        Logger.error(TAG, `${error.code}, ${error.message}`);
      }
    }
    if (currentAdjustData[AdjustType.OPACITY] !== CommonConstants.SLIDER_MAX) {
      const opacity = currentAdjustData[AdjustType.OPACITY] / CommonConstants.SLIDER_MAX;
      try {
        px.opacitySync(opacity);
      } catch (err) {
        let error = err as BusinessError;
        Logger.error(TAG, `${error.code}, ${error.message}`);
      }
    }
    this.finalEditPixelMap = px;
    this.notifyPreviewUpdate(px);
  }

  private async processAdjustWorker(value: number, buffer: ArrayBuffer, adjustType: AdjustType): Promise<ArrayBuffer> {
    await this.adjustLock;

    return new Promise((resolve) => {
      this.adjustLock = new Promise<void>((release) => {
        const message = new MessageItem(buffer, CommonConstants.SLIDER_MAX, value, adjustType);
        try {
          this.adjustWorker.postMessage(message);
        } catch (error) {
          Logger.error(TAG, `postMessage failed, code is ${error.code}, message is ${error.message}`);
          release();
        }
        this.adjustWorker.onmessage = (event: MessageEvents) => {
          resolve(event.data);
          release();
        };
      });
    });
  }

  async translateImage(moveValue: TranslateValue) {
    const px = this.getStartEditPixelMap(EditType.TRANSLATION);
    await px.translate(moveValue.x, moveValue.y);
    this.finalEditPixelMap = px;
    try {
      this.notifyPreviewUpdate(px);
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `${error.code}, ${error.message}`);
    }
  }

  async editImageScale(scale: number) {
    const px = this.getStartEditPixelMap(EditType.SCALE);
    try {
      await px.scale(scale, scale);
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `${error.code}, ${error.message}`);
    }
    this.finalEditPixelMap = px;
    this.notifyPreviewUpdate(px);
  }

  clonePixelMap(pixelMap: PixelMap): PixelMap {
    try {
      return pixelMap.cloneSync();
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `${error.code}, ${error.message}`);
      return pixelMap;
    }
  }
}
