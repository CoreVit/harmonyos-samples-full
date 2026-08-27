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


export interface EntranceStyle {
  buttonTextMaxLine: number;
  buttonFontFamily: Resource;
  buttonFontColor: ResourceColor;
  buttonCircleColorNormal: ResourceColor;
  buttonCircleBorderColor: ResourceColor;
  buttonCircleColorHover: ResourceColor;
  buttonImgFillColor: ResourceColor;
  buttonDisableAlpha: Resource;
  buttonEnableAlpha: Resource;
  buttonCircleSize: number;
  buttonCircleMargin: number;
  buttonCirclePadding: number;
  buttonImgSize: number;
  buttonWidth: number;
  buttonHeight: number;
  buttonFontSize: number;
  buttonCircleBorderSizeNormal: number;
  buttonCircleBorderSizeFocus: number;
  windowsWidth?: number;
  windowsHeight?: number;
  context?: UIContext;

  setWindowSize(width: number, height: number): void;
}

export enum WindowState {
  SHOWING,
  BEFORE_DESTROY_ANIMATION,
  START_DESTROY,
  DESTROYED,
}