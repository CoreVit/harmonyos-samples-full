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

export class ActiveCloseParams {
  public title: string;
  public content: string;
  public leftButton: string;
  public rightButton: string;
  public onCancel: () => void
  public action?: () => void;
  public actionColor?: ResourceColor;

  constructor(title: string, content: string, leftButton: string, rightButton: string, onCancel: () => void,
    action?: () => void, actionColor?: ResourceColor) {
    this.title = title;
    this.content = content;
    this.leftButton = leftButton;
    this.rightButton = rightButton;
    this.actionColor = actionColor;
    this.onCancel = onCancel;
    this.action = action;
  }
}

@Builder
export function ActiveCloseBuilder(params: ActiveCloseParams) {

  Column() {
    Text(params.title)
      .height($r('app.float.active_close_title_height'))
      .fontWeight(FontWeight.Bold)
      .fontSize($r('app.float.font_size_large'))
      .fontColor($r('app.color.item_text_color'))

    Text(params.content)
      .fontSize($r('app.float.font_size_regular'))
      .fontColor($r('app.color.active_close_content_color'))
      .margin({ bottom: $r('app.float.active_close_content_margin') })

    Row() {
      Button(params.leftButton, {
        buttonStyle: deviceInfo.deviceType === '2in1' ? ButtonStyleMode.NORMAL : ButtonStyleMode.TEXTUAL
      })
        .commonButton($r('app.color.base_blue'))
        .onClick(() => {
          params.onCancel();
        })
      Button(params.rightButton, {
        buttonStyle: deviceInfo.deviceType === '2in1' ? ButtonStyleMode.EMPHASIZED : ButtonStyleMode.TEXTUAL,
      })
        .margin({left: $r('app.float.index_body_margin')})
        .commonButton(params.actionColor ?? (deviceInfo.deviceType === '2in1' ? Color.White : $r('app.color.base_blue')))
        .onClick(() => {
          params.action?.();
        })
    }.width(CommonConstant.FULL_LENGTH).justifyContent(FlexAlign.SpaceBetween)
  }
  .width($r('app.float.active_close_builder_width'))
  .height($r('app.float.active_close_builder_height'))
  .padding({ left: $r('app.float.active_close_builder_padding'), right: $r('app.float.active_close_builder_padding') })
}

@Extend(Button)
function commonButton(fontColor: ResourceColor) {
  .width($r('app.float.active_close_action_width'))
  .height($r('app.float.active_close_action_height'))
  .fontSize($r('app.float.font_size_medium'))
  .fontWeight(FontWeight.Medium)
  .fontColor(fontColor)
  .layoutWeight(1)
}