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

import { EditMode } from '../types/CommonTypes';
import { AdjustType, CropType, FilterType, TranslateType } from './OptionViewModel';
import { CommonConstants } from '../common/constant/CommonConstants';

export class EditStateViewModel {
  public currentEditMode: EditMode = EditMode.CROP_MODE;
  public lastEditMode: EditMode = EditMode.CROP_MODE;
  public currentCropMode: number = CropType.ORIGINAL_IMAGE;
  public confirmedCropMode: number = CropType.ORIGINAL_IMAGE;
  public currentFilterMode: number = FilterType.ORIGIN;
  public confirmedFilterMode: number = FilterType.ORIGIN;
  public currentAdjustData: number[] = CommonConstants.ADJUST_SLIDER_VALUE.map((item: number) => item);
  public confirmedAdjustData: number[] = CommonConstants.ADJUST_SLIDER_VALUE.map((item: number) => item);
  public currentTranslateData: number[] = [0, 0];
  public currentTranslateMode: number = TranslateType.HORIZONTAL;
  public currentZoom: number = 100;
  public rotationAngle: number = 0;
  public isMirrored: boolean = false;

  updateTranslateData(index: number, value: number): void {
    const newData: number[] = [...this.currentTranslateData];
    newData[index] = value;
    this.currentTranslateData = newData;
  }

  hasCropChanges(): boolean {
    return this.currentCropMode !== this.confirmedCropMode;
  }

  hasFilterChanges(): boolean {
    return this.currentFilterMode !== this.confirmedFilterMode;
  }

  hasAdjustChanges(): boolean {
    return this.currentAdjustData[AdjustType.BRIGHTNESS] !== this.confirmedAdjustData[AdjustType.BRIGHTNESS] ||
      this.currentAdjustData[AdjustType.OPACITY] !== this.confirmedAdjustData[AdjustType.OPACITY] ||
      this.currentAdjustData[AdjustType.SATURATION] !== this.confirmedAdjustData[AdjustType.SATURATION];
  }

  saveCropChanges(): void {
    this.confirmedCropMode = this.currentCropMode;
  }

  cancelCropChanges(): void {
    this.currentCropMode = this.confirmedCropMode;
  }

  saveFilterChanges(): void {
    this.confirmedFilterMode = this.currentFilterMode;
  }

  cancelFilterChanges(): void {
    this.currentFilterMode = this.confirmedFilterMode;
  }

  saveAdjustChanges(): void {
    this.confirmedAdjustData = [...this.currentAdjustData];
  }

  cancelAdjustChanges(): void {
    this.currentAdjustData = [...this.confirmedAdjustData];
  }

  resetAll(): void {
    this.currentCropMode = CropType.ORIGINAL_IMAGE;
    this.confirmedCropMode = CropType.ORIGINAL_IMAGE;
    this.currentFilterMode = FilterType.ORIGIN;
    this.confirmedFilterMode = FilterType.ORIGIN;
    this.currentAdjustData = CommonConstants.ADJUST_SLIDER_VALUE.map((item: number) => item);
    this.confirmedAdjustData = CommonConstants.ADJUST_SLIDER_VALUE.map((item: number) => item);
    this.currentTranslateData = [0, 0];
    this.currentZoom = 100;
    this.rotationAngle = 0;
    this.isMirrored = false;
  }
}