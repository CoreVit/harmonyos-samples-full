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

import { CommonConstants, getWindowInfoState, WidthBreakpointType, WindowInfo } from 'multishortvideobase';
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
  CustomTitleBuilder() {
    Column() {
      Column()
        .width(CommonConstants.FULL_PERCENT)
        .height(36)
        .linearGradient({
          direction: GradientDirection.Bottom,
          colors: [['#4D000000', 0.0], ['#00000000', 1.0]]
        })

      Row() {
        Text($r('app.string.comment_title', this.commentCount))
          .fontSize($r('sys.float.Title_S'))
          .fontWeight($r('sys.float.font_weight_bold'))
          .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.black'),
            $r('sys.color.black'), $r('sys.color.comp_background_primary_contrary'),
            $r('sys.color.comp_background_primary_contrary')).getValue(this.windowInfo.widthBp))
        Row() {
          SymbolGlyph($r('sys.symbol.xmark'))
            .fontSize(18)
            .fontColor(new WidthBreakpointType<[ResourceColor]>([$r('sys.color.icon_primary')],
              [$r('sys.color.icon_primary')], [$r('sys.color.icon_on_primary')],
              [$r('sys.color.icon_on_primary')]).getValue(this.windowInfo.widthBp))
        }
        .width(40)
        .aspectRatio(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .backgroundColor(new WidthBreakpointType<ResourceColor>($r('sys.color.comp_background_tertiary'),
          $r('sys.color.comp_background_tertiary'), $r('app.color.search_icon_bg'),
          $r('app.color.search_icon_bg')).getValue(this.windowInfo.widthBp))
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
  }

  build() {
    NavDestination() {
      Column() {
        this.CustomTitleBuilder()
        Comment()
          .height('calc(100% - 92vp)')
      }

    }
    .height(LayoutPolicy.matchParent)
    .ignoreLayoutSafeArea()
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
    .backgroundColor(new WidthBreakpointType<ResourceColor>($r('sys.color.white'),
      $r('sys.color.white'), $r('app.color.bg_dark'),
      $r('app.color.bg_dark')).getValue(this.windowInfo.widthBp))
  }
}