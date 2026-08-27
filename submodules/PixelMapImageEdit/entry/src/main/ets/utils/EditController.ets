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

import { PixelMapManager } from '../pages/PixelMapManager';
import { EditStateViewModel } from '../viewModel/EditStateViewModel';
import { CropType } from '../viewModel/OptionViewModel';
import { EditMode } from '../types/CommonTypes';

export class EditController {
  private pixelMapManager: PixelMapManager;
  private editState: EditStateViewModel;

  constructor(pixelMapManager: PixelMapManager, editState: EditStateViewModel) {
    this.pixelMapManager = pixelMapManager;
    this.editState = editState;
  }

  cropImage(proportion: CropType): void {
    this.pixelMapManager.cropImage(proportion, this.editState.rotationAngle, this.editState.isMirrored);
  }

  rotateImage(): void {
    this.editState.rotationAngle = (this.editState.rotationAngle - 90 + 360) % 360;
    this.pixelMapManager.cropImage(this.editState.currentCropMode, this.editState.rotationAngle,
      this.editState.isMirrored);
  }

  mirrorImage(): void {
    this.editState.isMirrored = !this.editState.isMirrored;
    this.pixelMapManager.cropImage(this.editState.currentCropMode, this.editState.rotationAngle,
      this.editState.isMirrored);
  }

  async handleTranslateChange(value: number, mode: SliderChangeMode): Promise<void> {
    if (mode === SliderChangeMode.End &&
      value !== this.editState.currentTranslateData[this.editState.currentTranslateMode]) {
      const moveValue: number =
        Math.round(value) - this.editState.currentTranslateData[this.editState.currentTranslateMode];
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

  confirmLastEdit(): void {
    switch (this.editState.lastEditMode) {
      case EditMode.CROP_MODE:
        this.confirmCropEdit();
        break;
      case EditMode.ADJUST_MODE:
        this.confirmAdjustEdit();
        break;
      case EditMode.FILTER_MODE:
        this.confirmFilterEdit();
        break;
      default:
        break;
    }
  }

  cancelLastEdit(): void {
    switch (this.editState.lastEditMode) {
      case EditMode.CROP_MODE:
        this.cancelCropEdit();
        break;
      case EditMode.ADJUST_MODE:
        this.cancelAdjustEdit();
        break;
      case EditMode.FILTER_MODE:
        this.cancelFilterEdit();
        break;
      default:
        break;
    }
  }

  private confirmCropEdit(): void {
    this.editState.saveCropChanges();
    this.editState.rotationAngle = 0;
    this.editState.isMirrored = false;
    this.pixelMapManager.updateConfirmed(this.pixelMapManager.getFinalPixelMap());
  }

  private cancelCropEdit(): void {
    this.editState.cancelCropChanges();
    this.editState.rotationAngle = 0;
    this.editState.isMirrored = false;
    this.pixelMapManager.resetToConfirmed();
  }

  private confirmAdjustEdit(): void {
    this.editState.saveAdjustChanges();
    this.pixelMapManager.updateConfirmed(this.pixelMapManager.getFinalPixelMap());
  }

  private cancelAdjustEdit(): void {
    this.editState.cancelAdjustChanges();
    this.pixelMapManager.resetToConfirmed();
  }

  private confirmFilterEdit(): void {
    this.editState.saveFilterChanges();
    this.pixelMapManager.updateConfirmed(this.pixelMapManager.getFinalPixelMap());
  }

  private cancelFilterEdit(): void {
    this.editState.cancelFilterChanges();
    this.pixelMapManager.resetToConfirmed();
  }

  resetAll(): void {
    this.pixelMapManager.resetToOrigin();
    this.editState.resetAll();
  }
}