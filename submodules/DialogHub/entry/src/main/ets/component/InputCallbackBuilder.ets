/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import CommonConstant from '../utils/CommonConstant';
import { deviceInfo } from '@kit.BasicServicesKit';

export class InputCallbackParams {
  constructor(text: string, onCancel: (() => void), onSuccess: ((value: string) => void)) {
    this.text = text;
    this.onCancel = onCancel;
    this.onSuccess = onSuccess;
  }

  public text: string = '';
  public onCancel: (() => void);
  public onSuccess: ((value: string) => void);
  public inputValue: string = '';
}

@Builder
export function InputCallbackBuilder(params: InputCallbackParams) {
  Column() {
    Text($r('app.string.createNewDialog'))
      .fontSize($r('app.float.font_size_large'))
      .fontWeight(FontWeight.Bold)
      .fontColor($r('app.color.InputCallbackBuilderFontColor'))

    Text($r('app.string.inputNameForDialog'))
      .fontSize($r('app.float.font_size_medium'))
      .fontColor($r('app.color.InputCallbackBuilderFontColor'))
      .margin({
        top: $r('app.float.InputCallbackBuilderTextMarginTop'),
        bottom: $r('app.float.InputCallbackBuilderTextMarginBottom')
      })

    Stack({ alignContent: Alignment.End }) {
      TextInput({ placeholder: $r('app.string.pleaseInput'), text: params.inputValue })
        .onChange((value: string) => {
          params.inputValue = value;
        })
    }

    Row() {
      Button($r('app.string.Cancel'),
        { buttonStyle: deviceInfo.deviceType === '2in1' ? ButtonStyleMode.NORMAL : ButtonStyleMode.TEXTUAL })
        .width($r('app.float.InputCallbackBuilderButtonWidth'))
        .height($r('app.float.InputCallbackBuilderButtonHeight'))
        .onClick(() => {
          params.onCancel();
        })
      Button($r('app.string.Save'),
        { buttonStyle: deviceInfo.deviceType === '2in1' ? ButtonStyleMode.EMPHASIZED : ButtonStyleMode.TEXTUAL })
        .width($r('app.float.InputCallbackBuilderButtonWidth'))
        .height($r('app.float.InputCallbackBuilderButtonHeight'))
        .onClick(() => {
          params.onCancel();
          params.onSuccess(params.inputValue);
        })
    }
    .margin({ top: $r('app.float.InputCallbackBuilderRowMarginTop') })
    .width(CommonConstant.FULL_LENGTH)
    .justifyContent(FlexAlign.SpaceBetween)
  }
  .padding($r('app.float.InputCallbackBuilderPadding'))
  .width($r('app.float.InputCallbackBuilderWidth'))
  .height($r('app.float.InputCallbackBuilderHeight'))
}