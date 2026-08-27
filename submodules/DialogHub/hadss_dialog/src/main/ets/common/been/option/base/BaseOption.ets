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
import { BaseDialogComponent } from '../../../../components/base/BaseDialogComponent';
import { DialogLifeCycle } from '../../../../model/lifecycle/DialogLifeCycle';
import { DialogType } from '../../../constant/DialogType';

/**
 * Base class for dialog properties
 **/
@Observed
export class BaseOption {
  public customContent: WrappedBuilder<[ESObject]> = wrapBuilder(BaseDialogComponent);
  public customContentParam?: ESObject;
  public isOperableContent: boolean = false;
  public type: DialogType = DialogType.CUSTOM;
  public modelName: string = ''; // Use template names
  public dialogId: string = ''; // Click the pop-up mask to close automatically
  public lifeCycleConfig: DialogLifeCycle = {};
  public height?: Dimension; // height, do not configure this property when it's empty
  public width?: Dimension; // width, do not configure this property when it's empty
  // Rounded corners, note: Native bindSheet does not support rounded corners property configuration
  public radius?: Dimension | BorderRadiuses;
  public shadow?: ShadowOptions | ShadowStyle; // Border shadow
  public borderWidth?: Dimension | EdgeWidths; // Border width
  public borderColor?: ResourceColor | EdgeColors; // Border color
  public borderStyle?: BorderStyle | EdgeStyles; // Border style, solid line, dotted line, etc
  public maskColor?: ResourceColor; // Mask color
  public maskBackgroundEffect?: BackgroundEffectOptions; // Mask backgroundEffect
  // Popup content background color, the background color of the developer configuration content takes precedence.
  public backgroundColor: ResourceColor = Color.White;
}