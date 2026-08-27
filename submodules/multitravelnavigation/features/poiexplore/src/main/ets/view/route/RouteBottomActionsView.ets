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

import { Common } from 'multitravelbase/Index';

@Component
export struct RouteBottomActionsView {
  onStartNavigate?: () => void;

  @Builder
  private ActionIcon(index: number, image: Resource, text: ResourceStr) {
    Column() {
      SymbolGlyph(image)
        .fontSize(24)
        .fontColor([$r('sys.color.icon_secondary')])
      Text(text)
        .fontSize(12)
        .fontColor($r('sys.color.font_secondary'))
        .height(16)
    }
    .margin({ left: index === 0 ? 10 : 26 })
    .width(24)
  }

  build() {
    Row() {
      this.ActionIcon(0, $r('sys.symbol.heart'), $r('app.string.favor'))
      this.ActionIcon(1, $r('sys.symbol.share'), $r('app.string.share'))
      Blank()
        .layoutWeight(1)

      Button() {
        Row() {
          Image($r('app.media.navigate'))
            .width(20)
          Text($r('app.string.start_navigate'))
            .fontSize(16)
            .fontColor($r('app.color.start_navigate'))
            .margin({ left: 8 })
        }
      }
      .width(180)
      .padding({ left: 44, right: 44 })
      .height(40)
      .borderRadius(20)
      .linearGradient({
        direction: GradientDirection.Right,
        repeating: false,
        colors: [[$r('app.color.button_left'), 0], [$r('app.color.button_right'), 1]]
      })
      .onClick(() => {
        this.onStartNavigate?.();
      })
    }
    .height(52)
    .width(Common.FULL_WIDTH)
  }
}
