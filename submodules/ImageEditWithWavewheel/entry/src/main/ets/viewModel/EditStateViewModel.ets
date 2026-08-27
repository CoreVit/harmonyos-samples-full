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
import { EditMode } from '../types/CommonTypes';
import { CropType, FilterType, TranslateType, AdjustType } from './OptionViewModel';
import { CommonConstants } from '../common/constant/CommonConstants';
import { PixelMapManager } from '../pages/PixelMapManager';

export class EditStateViewModel {
  public currentEditMode: EditMode = EditMode.CROP_MODE;
  public currentCropMode: number = CropType.ORIGINAL_IMAGE;
  public filterCurrMode: number = FilterType.ORIGIN;
  public currentTranslateData: number[] = [0, 0];
  public currentTranslateMode: number = TranslateType.HORIZONTAL;
  public currentZoom: number = 100;
  public currentAdjustData: number[] = CommonConstants.ADJUST_SLIDER_VALUE.map((item: number) => item);
  public currentAdjustIndex: number = 0;
  public baseDisplayWidth: number = 0;
  public baseDisplayHeight: number = 0;

  isEdited(): boolean {
    return this.isCropEdited() || this.isFilterEdited() || this.isAdjustEdited() ||
      this.currentTranslateData[0] !== 0 || this.currentTranslateData[1] !== 0 ||
      this.currentZoom !== 100;
  }

  updateTranslateData(index: number, value: number): void {
    const newData = [...this.currentTranslateData];
    newData[index] = value;
    this.currentTranslateData = newData;
  }

  setBaseDisplaySize(width: number, height: number): void {
    this.baseDisplayWidth = width;
    this.baseDisplayHeight = height;
  }

  clearBaseDisplaySize(): void {
    this.baseDisplayWidth = 0;
    this.baseDisplayHeight = 0;
  }

  reset(): void {
    this.currentCropMode = CropType.ORIGINAL_IMAGE;
    this.filterCurrMode = FilterType.ORIGIN;
    this.currentTranslateData = [0, 0];
    this.currentZoom = 100;
    this.currentAdjustData = CommonConstants.ADJUST_SLIDER_VALUE.map((item: number) => item);
    this.currentAdjustIndex = 0;
    this.baseDisplayWidth = 0;
    this.baseDisplayHeight = 0;
  }

  isCropEdited(): boolean {
    return this.currentCropMode !== CropType.ORIGINAL_IMAGE;
  }

  isFilterEdited(): boolean {
    return this.filterCurrMode !== FilterType.ORIGIN;
  }

  isAdjustEdited(): boolean {
    return this.currentAdjustData[AdjustType.BRIGHTNESS] !== CommonConstants.SLIDER_MAX ||
      this.currentAdjustData[AdjustType.OPACITY] !== CommonConstants.SLIDER_MAX ||
      this.currentAdjustData[AdjustType.SATURATION] !== CommonConstants.SLIDER_MAX;
  }

  handleWaveWheelRoomChange(targetMode: EditMode, onConfirm: () => void, targetAdjustIndex?: number): void {
    if (this.currentEditMode !== targetMode) {
      onConfirm();
      this.currentEditMode = targetMode;
    }
    if (targetAdjustIndex !== undefined) {
      this.currentAdjustIndex = targetAdjustIndex;
    }
  }

  handleTabChange(index: number, pixelMapManager: PixelMapManager | undefined,
    previewPixelMap: image.PixelMap | undefined, setBaseDisplay: () => void,
    clearBaseDisplay: () => void, onConfirm: () => void): void {
    if (this.currentEditMode === EditMode.CROP_MODE && this.isCropEdited()) {
      onConfirm();
    }
    if (this.currentEditMode !== EditMode.CROP_MODE && index === EditMode.CROP_MODE && previewPixelMap) {
      pixelMapManager?.updateCropPixelMap(previewPixelMap);
    }
    if (this.currentEditMode === EditMode.ADJUST_MODE && this.isAdjustEdited()) {
      onConfirm();
    }
    if (this.currentEditMode === EditMode.FILTER_MODE && this.isFilterEdited()) {
      onConfirm();
    }
    this.currentEditMode = index;

    if (index === EditMode.TRANSLATE_MODE || index === EditMode.ZOOM_MODE) {
      setBaseDisplay();
    } else {
      clearBaseDisplay();
    }
  }
}