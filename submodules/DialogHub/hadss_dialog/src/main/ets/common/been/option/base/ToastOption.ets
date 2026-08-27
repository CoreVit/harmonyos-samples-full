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
import { deviceInfo } from '@kit.BasicServicesKit';
import { DefaultComponent } from '../../../../components/base/DefaultComponent';
import { TopDialogPriority } from '../../../constant/TopDialogPriority';
import { CustomKeyboardAvoidMode, DialogLayerPolicy } from '../../config/DialogConfig';
import { DefaultContent } from '../DefaultContent';
import { CustomOption } from './CustomOption';

/**
 * Toast window properties, based on BuilderOption
 * */
@Observed
export class ToastOption extends CustomOption {
  public customContent: WrappedBuilder<[ESObject]> = wrapBuilder(DefaultComponent);
  public customContentParam?: ESObject = new DefaultContent('');
  public isModal: boolean = false; // there is no mask in Toast window by default
  // Whether the pop-up window itself transmits gestures such as clicking and sliding. Default off
  public passThroughGesture: boolean = true;
  public keyboardAvoidMode: CustomKeyboardAvoidMode = CustomKeyboardAvoidMode.INPUT_AVOID;
  public keyboardAvoidSpace: Dimension = '112px'; // toast default distance from bottom
  public layerPolicy: DialogLayerPolicy = { alwaysTop: true, topDialogPriority: TopDialogPriority.NEW_FIRST }; // 弹出策略
  public duration: number = 3000;
  public backgroundColor: ResourceColor = 'rgba(241,243,245,0.97)';
  public borderWidth: number = 2;
  public borderColor: ResourceColor = Color.White;
  public radius: number = 400;
  public shadow: ShadowOptions = {
    radius: 20,
    color: '#29000000',
    offsetY: 8
  };
}