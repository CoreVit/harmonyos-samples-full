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
import { CommonConstants } from 'financialbase';

@ComponentV2
export struct RecommendNoticeBar {
  @Param radius: number = 0;
  @Env(SystemProperties.BREAK_POINT) breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;

  build() {
    Row({ space: 8 }) {
      Circle()
        .width(8)
        .height(8)
        .fill($r('app.color.alert'))
      Text($r('app.string.notice'))
        .fontSize(14)
        .lineHeight(19)
        .fontColor($r('app.color.font_primary'))
        .maxLines(1)
        .layoutWeight(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .height(46)
    .padding({
      left: CommonConstants.COMMON_PADDING[2].getValue(this.breakpoint.widthBreakpoint),
      right: CommonConstants.COMMON_PADDING[2].getValue(this.breakpoint.widthBreakpoint)
    })
    .borderRadius(this.radius)
    .backgroundColor($r('app.color.comp_background_list_card'))
  }
}