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
import { AdjustType, CropType, MirrorType, FilterType } from '../viewModel/OptionViewModel';
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
  private editMode: EditType = EditType.CROP;
  private notifyPreviewUpdate: (previewPixelMap: PixelMap) => void;
  private adjustWorker: worker.ThreadWorker =
    new worker.ThreadWorker(CommonConstants.ADJUST_WORKER_FILE);
  private adjustLock: Promise<void> = Promise.resolve();

  constructor(pixelMap: PixelMap, notifyPreviewUpdate: (previewPixelMap: PixelMap) => void) {
    this.originPixelMap = pixelMap;
    this.originCropPixelMap = pixelMap;
    this.notifyPreviewUpdate = notifyPreviewUpdate;
    this.updatePreviewPixelMap(pixelMap);
  }

  destroyPixelMapManager() {
    const pixelMaps: (PixelMap | undefined)[] = [
      this.originPixelMap,
      this.originCropPixelMap,
      this.startEditPixelMap,
      this.finalEditPixelMap
    ];
    for (const pm of pixelMaps) {
      if (pm !== null && pm !== undefined) {
        try {
          pm.release();
        } catch (err) {
          let error = err as BusinessError;
          Logger.error(TAG, `release pixelMap failed: ${error.code}, ${error.message}`);
        }
      }
    }
    this.originPixelMap = undefined;
    this.originCropPixelMap = undefined;
    this.startEditPixelMap = undefined;
    this.finalEditPixelMap = undefined;
    this.adjustWorker.onmessage = undefined;
    try {
      this.adjustWorker.terminate();
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `terminate worker failed: ${error.code}, ${error.message}`);
    }
  }

  getInitPixelMap(): PixelMap | undefined {
    return this.originPixelMap;
  }

  getInitCropPixelMap(): PixelMap | undefined {
    return this.originCropPixelMap;
  }

  updateCropPixelMap(pixelMap: image.PixelMap): void {
    this.originCropPixelMap = this.clonePixelMap(pixelMap);
  }

  updateCropPixelMapSilent(pixelMap: image.PixelMap): void {
    this.originCropPixelMap = pixelMap;
  }

  updatePreviewPixelMap(pixelMap: image.PixelMap): void {
    this.startEditPixelMap = pixelMap;
    this.finalEditPixelMap = pixelMap;
    this.notifyPreviewUpdate(this.clonePixelMap(pixelMap));
  }

  async handleFilter(type: FilterType): Promise<void> {
    const startMap = this.getStartEditPixelMap(EditType.FILTER);
    if (startMap === null || startMap === undefined) {
      return;
    }
    let px: PixelMap = startMap;
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

  getStartEditPixelMap(mode: EditType): PixelMap | undefined {
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
    if (target !== null && target !== undefined) {
      return this.clonePixelMap(target);
    }
    return undefined;
  }


  async cropImage(proportion: CropType): Promise<void> {
    let pxTemp: image.PixelMap | undefined = this.getStartEditPixelMap(EditType.CROP);
    if (pxTemp === null || pxTemp === undefined) {
      return;
    }
    let px: image.PixelMap = pxTemp;
    const imageInfo = await px.getImageInfo();
    const size = imageInfo.size;
    const imageWidth = size?.width;
    const imageHeight = size?.height;

    try {
      switch (proportion) {
        case CropType.ORIGINAL_IMAGE:
          const initCrop = this.getInitCropPixelMap();
          if (initCrop) {
            px = initCrop;
            this.notifyPreviewUpdate(initCrop);
          }
          break;
        case CropType.SQUARE:
          square(px, imageWidth, imageHeight).then(() => {
            this.notifyPreviewUpdate(px);
          });
          break;
        case CropType.BANNER:
          banner(px, imageWidth, imageHeight).then(() => {
            this.notifyPreviewUpdate(px);
          });
          break;
        case CropType.RECTANGLE:
          rectangle(px, imageWidth, imageHeight).then(() => {
            this.notifyPreviewUpdate(px);
          });
          break;
        case undefined:
        case null:
          Logger.error(TAG, `proportion is undefined.`);
          break;
        default:
          break;
      }
      this.finalEditPixelMap = px;
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Image crop failed, ${err.code}: ${err.message}`);
    }

  }

  mirrorImage(mirrorType: MirrorType): void {
    const px = this.getStartEditPixelMap(EditType.MIRROR);
    if (px === null || px === undefined) {
      return;
    }
    if (mirrorType === MirrorType.HORIZONTAL) {
      try {
        px.flipSync(true, false);
      } catch (error) {
        Logger.error(TAG, `there is a error in mirror process with ${error?.code}`);
      }
    } else if (mirrorType === MirrorType.VERTICAL) {
      try {
        px.flipSync(false, true);
      } catch (error) {
        Logger.error(TAG, `there is a error in mirror process with ${error?.code}`);
      }
    }
    this.notifyPreviewUpdate(px);
    this.finalEditPixelMap = px;
  }

  rotateImage(): void {
    const px = this.getStartEditPixelMap(EditType.ROTATION);
    if (px === null || px === undefined) {
      return;
    }
    try {
      px.rotate(CommonConstants.ANTI_CLOCK)
        .then(() => {
          this.notifyPreviewUpdate(px);
        });
    } catch (error) {
      Logger.error(TAG, `there is a error in rotate process with ${error?.code}`);
    }

    this.finalEditPixelMap = px;
  }

  async adjustImage(currentAdjustData: number[]): Promise<void> {
    const px = this.getStartEditPixelMap(EditType.ADJUST);
    if (px === null || px === undefined) {
      return;
    }
    let buffer = new ArrayBuffer(px.getPixelBytesNumber());
    px.readPixelsToBuffer(buffer);
    if (!buffer) {
      return;
    }

    buffer = await this.processAdjustWorker(
      currentAdjustData[AdjustType.BRIGHTNESS],
      buffer,
      AdjustType.BRIGHTNESS
    );
    Logger.info(TAG, `adjusting brightness, slider value=${currentAdjustData[AdjustType.BRIGHTNESS]}`);

    buffer = await this.processAdjustWorker(
      currentAdjustData[AdjustType.SATURATION],
      buffer,
      AdjustType.SATURATION
    );
    Logger.info(TAG, `adjusting saturation, slider value=${currentAdjustData[AdjustType.SATURATION]}`);

    buffer = await this.processAdjustWorker(
      currentAdjustData[AdjustType.OPACITY],
      buffer,
      AdjustType.OPACITY
    );
    Logger.info(TAG, `adjusting opacity, slider value=${currentAdjustData[AdjustType.OPACITY]}`);

    try {
      px.writeBufferToPixelsSync(buffer);
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `${error.code}, ${error.message}`);
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
        this.adjustWorker.onmessage = (event: MessageEvents) : void => {
          resolve(event.data);
          release();
        };
      });
    });
  }

  async translateImage(moveValue: TranslateValue): Promise<void> {
    const px = this.getStartEditPixelMap(EditType.TRANSLATION);
    if (px === null || px === undefined) {
      return;
    }
    await px.translate(moveValue.x, moveValue.y);
    this.finalEditPixelMap = px;
    try {
      this.notifyPreviewUpdate(px);
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `${error.code}, ${error.message}`);
    }
  }

  async editImageScale(scale: number): Promise<void> {
    const px = this.getStartEditPixelMap(EditType.SCALE);
    if (px === null || px === undefined) {
      return;
    }
    try {
      await px.scale(scale, scale);
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `${error.code}, ${error.message}`);
    }
    this.finalEditPixelMap = px;
    this.notifyPreviewUpdate(px);
  }

  static logPixelMetrics(pixelMap: PixelMap, tag: string): void {
    try {
      const bytesPerPixel = 4;
      const buffer = new ArrayBuffer(pixelMap.getPixelBytesNumber());
      pixelMap.readPixelsToBufferSync(buffer);
      const pixelData = new Uint8ClampedArray(buffer);
      const pixelCount = pixelData.length / bytesPerPixel;

      let totalAlpha = 0;
      let totalLuminance = 0;
      let totalSaturation = 0;

      const sampleStep = Math.max(1, Math.floor(pixelCount / 10000));

      for (let i = 0; i < pixelData.length; i += bytesPerPixel * sampleStep) {
        const r = pixelData[i] / 255;
        const g = pixelData[i + 1] / 255;
        const b = pixelData[i + 2] / 255;
        const a = pixelData[i + 3];

        totalAlpha += a;

        const luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b;
        totalLuminance += luminance;

        const maxC = Math.max(r, g, b);
        const minC = Math.min(r, g, b);
        const saturation = maxC === 0 ? 0 : (maxC - minC) / maxC;
        totalSaturation += saturation;
      }

      const sampledCount = Math.ceil(pixelCount / sampleStep);
      const avgAlpha = totalAlpha / sampledCount / 255;
      const avgBrightness = totalLuminance / sampledCount * 100;
      const avgSaturation = totalSaturation / sampledCount * 100;

      Logger.info(TAG, `[${tag}] avg opacity=${avgAlpha.toFixed(2)}, avg brightness=${avgBrightness.toFixed(
        1)}, avg saturation=${avgSaturation.toFixed(1)}`);
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `Failed to log pixel metrics: ${error.code}, ${error.message}`);
    }
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
