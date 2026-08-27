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

/**
 * Crop type.
 */
export enum CropType {
  ORIGINAL_IMAGE = 0,
  SQUARE = 1,
  BANNER = 2,
  RECTANGLE = 3
}

/**
 * Rotate type
 */
export enum RotateType {
  CLOCKWISE = 0,
  ANTI_CLOCK = 1
}

/**
 * Mirror type
 */
export enum MirrorType {
  HORIZONTAL = 0,
  VERTICAL = 1
}

/**
 * Adjust type.
 */
export enum AdjustType {
  BRIGHTNESS = 0,
  OPACITY = 1,
  SATURATION = 2
}

/**
 * Filter type
 */
export enum FilterType {
  ORIGIN = 0,
  GRAYSCALE = 1,
  BRIGHTNESS = 2,
  INVERT = 3,
  BLUR = 4,
}

/**
 * Translate type
 */
export enum TranslateType {
  HORIZONTAL = 0,
  VERTICAL = 1
}

/**
 * Main page tab type.
 */
export enum MainTabId {
  CROP = 0,
  ADJUST = 1,
  FILTER = 2,
  TRANSLATE = 3,
  ZOOM = 4,
  MIRROR = 5,
  ROTATE = 6
}

/**
 * RGB color, red,green and blue.
 */
export enum RGBIndex {
  RED = 0,
  GREEN = 1,
  BLUE = 2
}

/**
 * HSV type.
 */
export enum HSVIndex {
  HUE = 0,
  SATURATION = 1,
  VALUE = 2
}

/**
 * Angle range.
 */
export enum AngleRange {
  ANGLE_0_60 = 0,
  ANGLE_60_120 = 1,
  ANGLE_120_180 = 2,
  ANGLE_180_240 = 3,
  ANGLE_240_300 = 4,
  ANGLE_300_360 = 5
}