/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { BreakpointConstants } from '../constants/BreakpointConstants';
import { CommonConstants } from '../constants/CommonConstants';
import { BreakpointType } from '../utils/BreakpointSystem';

@Component
export struct GraphicTextHeader {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @Consume(CommonConstants.LIFE_PREFIX + 'upDownStructure') upDownStructure: boolean;
  handleBackPress?: Function;

  build() {
    Row() {
      Button({ type: ButtonType.Circle }) {
        SymbolGlyph($r('sys.symbol.chevron_backward'))
          .fontColor([$r('sys.color.icon_primary')])
          .fontSize($r('sys.float.Title_M'))
      }
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .width(40)
      .aspectRatio(1)
      .margin({
        right: $r('app.float.padding_small')
      })
      .onClick(() => this.handleBackPress?.())

      Image($r('app.media.tx1_img'))
        .width($r('app.float.tx1_width'))
        .aspectRatio(1)
        .margin({
          right: $r('app.float.filtering_margin_right')
        })
      Text($r('app.string.lee_look'))
        .fontSize($r('app.float.delicious_font'))
        .fontWeight(CommonConstants.FONT_WEIGHT_700)
      Blank()
      Button($r('app.string.follows'))
        .margin({
          right: $r('app.float.padding_small')
        })
      Button({ type: ButtonType.Circle }) {
        SymbolGlyph($r('sys.symbol.arrowshape_turn_up_right'))
          .fontColor([$r('sys.color.icon_primary')])
          .fontSize($r('sys.float.Title_M'))
      }
      .width(40)
      .aspectRatio(1)
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .margin({
        right: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD ? $r('app.float.padding_small') : 0
      })

      Button({ type: ButtonType.Circle }) {
        SymbolGlyph($r('sys.symbol.layout_left_right'))
          .fontColor([$r('sys.color.icon_primary')])
          .fontSize($r('sys.float.Title_M'))
      }
      .height(40)
      .aspectRatio(1)
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .visibility(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD && this.upDownStructure ?
        Visibility.Visible : Visibility.None)
      .onClick(() => {
        this.upDownStructure = false;
      })

      Button({ type: ButtonType.Circle }) {
        SymbolGlyph($r('sys.symbol.layout_up_down'))
          .fontColor([$r('sys.color.icon_primary')])
          .fontSize($r('sys.float.Title_M'))
      }
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .height(40)
      .aspectRatio(1)
      .visibility(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD && !this.upDownStructure ?
        Visibility.Visible : Visibility.None)
      .onClick(() => {
        this.upDownStructure = true;
      })
    }
    .padding({
      left: new BreakpointType({
        sm: $r('app.float.padding_small'), md: $r('app.float.common_padding'),
        lg: $r('app.float.padding_header')
      }).getValue(this.currentBreakpoint),
      right: new BreakpointType({
        sm: $r('app.float.padding_small'), md: $r('app.float.common_padding'),
        lg: $r('app.float.padding_header')
      }).getValue(this.currentBreakpoint)
    })
    .width(CommonConstants.FULL_PERCENT)
    .height($r('app.float.title_height'))
  }
}