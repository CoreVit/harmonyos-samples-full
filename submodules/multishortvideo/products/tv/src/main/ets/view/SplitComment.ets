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

import { CommonConstants, getWindowInfoState, WindowInfo } from 'multishortvideobase';
import { Comment } from 'multishortvideocomment';

@Builder
export function SplitCommentBuilder() {
  SplitComment()
}

@ComponentV2
export struct SplitComment {
  @Local windowInfo: WindowInfo = getWindowInfoState();
  @Consumer('showSideComment') showSideComment: boolean = false;
  @Consumer('pathStack') pathStack: NavPathStack = new NavPathStack();
  @Provider('commentCount') commentCount: Length = 0;

  aboutToAppear(): void {
    this.pathStack.disableAnimation(true);
  }

  @Builder
  CustomBuilder() {
    Row() {
      Text($r('app.string.comment_title', this.commentCount))
        .fontColor($r('sys.color.comp_background_primary_contrary'))
        .fontSize(32)
        .fontWeight($r('sys.float.font_weight_bold'))
      Row() {
        SymbolGlyph($r('sys.symbol.xmark'))
          .fontSize(32)
          .fontColor([$r('sys.color.icon_on_primary')])
      }
      .width(54)
      .aspectRatio(1)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .backgroundColor($r('app.color.search_icon_bg'))
      .borderRadius(CommonConstants.HALF_PERCENT)
      .onClick(() => {
        this.pathStack.pop();
        this.showSideComment = false;
      })
    }
    .width(CommonConstants.FULL_PERCENT)
    .padding({
      left: 16,
      right: 7.5
    })
    .height(56)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }

  build() {

    NavDestination() {
      Comment()
    }
    .title(this.CustomBuilder)
    .padding({
      top: 45,
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
    .backgroundColor($r('app.color.bg_dark'))
  }
}