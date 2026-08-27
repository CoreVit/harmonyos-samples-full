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
import { PixelMapManager } from '../pages/PixelMapManager';
import { EditStateViewModel } from '../viewModel/EditStateViewModel';
import { CropType, MirrorType } from '../viewModel/OptionViewModel';
import Logger from './Logger';

const TAG: string = '[EditController]';

export class EditController {
  private pixelMapManager: PixelMapManager;
  private editState: EditStateViewModel;

  constructor(pixelMapManager: PixelMapManager, editState: EditStateViewModel) {
    this.pixelMapManager = pixelMapManager;
    this.editState = editState;
  }

  cropImage(proportion: CropType): void {
    this.pixelMapManager.cropImage(proportion);
  }

  rotateImage(): void {
    this.pixelMapManager.rotateImage();
  }

  mirrorImage(): void {
    this.pixelMapManager.mirrorImage(MirrorType.HORIZONTAL);
  }

  async handleTranslateChange(value: number, mode: SliderChangeMode): Promise<void> {
    if (this.editState.currentTranslateMode >= this.editState.currentTranslateData.length) {
      Logger.error(TAG, `unvalid param :this.getState.currentTranslateMode`);
      return;
    }
    if (mode === SliderChangeMode.End &&
      value !== this.editState.currentTranslateData[this.editState.currentTranslateMode]) {
      const moveValue = Math.round(value) - this.editState.currentTranslateData[this.editState.currentTranslateMode];
      this.editState.updateTranslateData(this.editState.currentTranslateMode, Math.round(value));
      if (this.editState.currentTranslateMode === 0) {
        await this.pixelMapManager.translateImage({ x: moveValue, y: 0 });
      } else {
        await this.pixelMapManager.translateImage({ x: 0, y: moveValue });
      }
    }
  }

  async handleZoomChange(value: number, mode: SliderChangeMode): Promise<void> {
    if (mode === SliderChangeMode.End && value !== this.editState.currentZoom) {
      await this.pixelMapManager.editImageScale(value / 100);
      this.editState.currentZoom = value;
    }
  }

  confirmEdit(previewPixelMap: image.PixelMap): void {
    this.pixelMapManager.updatePreviewPixelMap(previewPixelMap);
  }

  resetEdit(): void {
    const originalPixelMap = this.pixelMapManager.getInitPixelMap();
    if (originalPixelMap) {
      this.pixelMapManager.updateCropPixelMapSilent(originalPixelMap);
      this.pixelMapManager.updatePreviewPixelMap(originalPixelMap);
    }
    this.editState.reset();
  }
}