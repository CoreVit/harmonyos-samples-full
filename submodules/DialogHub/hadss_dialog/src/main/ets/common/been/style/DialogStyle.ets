/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

export interface DialogStyle {
  height?: Dimension; // height, do not configure this property when it's empty
  width?: Dimension; // width, do not configure this property when it's empty
  // Rounded corners, note: Native bindSheet does not support rounded corners property configuration
  radius?: Dimension | BorderRadiuses;
  shadow?: ShadowOptions | ShadowStyle; // Border shadow
  borderWidth?: Dimension | EdgeWidths; // Border width
  borderColor?: ResourceColor | EdgeColors; // Border color
  borderStyle?: BorderStyle | EdgeStyles; // Border style, solid line, dotted line, etc
  maskColor?: ResourceColor; // Mask color
  maskBackgroundEffect?: BackgroundEffectOptions; // Mask backgroundEffect
  // Popup content background color, the background color of the developer configuration content takes precedence.
  backgroundColor?: ResourceColor;
}