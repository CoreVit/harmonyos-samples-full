/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { uiObserver } from '@kit.ArkUI';
import { BreakpointType } from 'financialbase';
import { Message } from '../model/AccountModel';
import { MessageViewModel } from '../viewmodel/MessageViewModel';

@ComponentV2
export struct MessageBar {
  @Env(SystemProperties.BREAK_POINT) breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Local messageViewModel: MessageViewModel = new MessageViewModel();
  @Param count: number = 2;
  @Param isPc: boolean = false;

  build() {
    if (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_MD || this.isPc) {
      Row() {
        this.MessageList()
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .messageBarStyle()
    } else {
      Column() {
        this.MessageList()
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .messageBarStyle()
    }
  }

  @Builder
  MessageList() {
    ForEach(this.messageViewModel.getMessageList(this.count), (item: Message) => {
      this.MessageItem(item)
    }, (item: Message, index: number) => JSON.stringify(item) + index)
  }

  @Builder
  MessageItem(message: Message) {
    Row({ space: 8 }) {
      Text(message.tag)
        .fontSize(12)
        .lineHeight(16)
        .fontColor(message.tagFontColor)
        .backgroundColor(message.tagBgColor)
        .height(20)
        .padding({
          top: 2,
          bottom: 2,
          left: 4,
          right: 4
        })
        .textAlign(TextAlign.Center)
        .borderRadius(4)
      Text(message.content)
        .fontSize(14)
        .fontColor($r('app.color.font_primary'))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .layoutWeight(1)
    }
    .height(24)
    .layoutWeight(1)
  }

  @Styles
  messageBarStyle() {
    .padding({
      top: 12,
      bottom: 12,
      left: 16,
      right: 16
    })
    .backgroundColor($r('app.color.comp_background_list_card'))
    .borderRadius(this.isPc ? 8 : 16)
    .height(this.isPc ? 48 : new BreakpointType(76, 48, 116, 116).getValue(this.breakpoint.widthBreakpoint))
  }
}

