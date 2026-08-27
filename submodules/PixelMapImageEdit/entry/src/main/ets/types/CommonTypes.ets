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

export interface ImageRect {
  width: number;
  height: number;
  x: number;
  y: number;
}

export interface EditNavParam {
  imageRect: ImageRect;
  sourcePixelMap?: image.PixelMap;
}

export enum EditMode {
  CROP_MODE = 0,
  ADJUST_MODE = 1,
  FILTER_MODE = 2,
  TRANSLATE_MODE = 3,
  ZOOM_MODE = 4,
}

export interface ImageInfoItem {
  label: string;
  value: string | number;
}

export enum EditType {
  CROP = 0,
  FILTER = 1,
  TRANSLATION = 2,
  SCALE = 3,
  MIRROR = 4,
  ROTATION = 5,
  ADJUST = 6,
}