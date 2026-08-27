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
import { WidthBreakpointType } from 'multishoppingbase';
import { LiveCommentState } from '../viewmodel/LiveCommentState';

/** Component migrated from detail/Comment.ets. */
@ComponentV2
export struct LiveComment {
  @Env(SystemProperties.BREAK_POINT) private breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Param public widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @Local private state: LiveCommentState = new LiveCommentState(this.getUIContext().getHostContext()!);

  build() {
    List() {
      ForEach(this.state.comments, (item: string, index: number) => {
        ListItem() {
          Row() {
            Text(this.state.officialLabel)
              .fontColor($r('sys.color.font_on_primary'))
              .fontSize(12)
              .linearGradient({
                angle: 0,
                direction: GradientDirection.Left,
                colors: [['#CF0A2C', 0], ['#FF6354', 1]]
              })
              .border({ radius: 4 })
              .padding(4)
              .margin({ right: 6 })
              .visibility(index === this.state.comments.length - 1 ? Visibility.Visible : Visibility.None)
            Text(item)
              .layoutWeight(1)
              .fontColor($r('sys.color.font_on_primary'))
              .lineHeight(20)
              .fontSize(12)
          }
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Top)
          .margin({ bottom: 8 })
          .border({ radius: 8 })
          .backgroundColor($r('app.color.live_comment_bubble'))
          .padding({
            left: 8,
            top: 6,
            bottom: 6,
            right: 6
          })
        }
        .visibility(this.breakpoint.heightBreakpoint === HeightBreakpoint.HEIGHT_MD &&
          index < this.state.comments.length - 2 ? Visibility.None : Visibility.Visible)
      }, (item: string, index: number) => `${item}-${index}`)
    }
    .width(new WidthBreakpointType(228, 400, 420, 420).getValue(this.widthBp))
    .stackFromEnd(true)
    .syncLoad(true)
  }
}
