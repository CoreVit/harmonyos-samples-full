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

import Constants from '../common/Constants';
import { BreakpointType, BreakpointTypeEnum } from '../common/utils/BreakpointSystem';

@Entry
@Component
struct BottomWithBar {
  @Consume(Constants.KEY_PATH_STACK) pathInfos: NavPathStack;
  @StorageProp(Constants.KEY_BREAKPOINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT)
  statusBarHeight: number = 0;
  private maxLength: number = 6;
  private strokeWidth: number = 1;

  build() {
    Column() {
      Row() {
        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.chevron_backward'))
            .fontColor([$r('sys.color.icon_primary')])
            .fontSize($r('sys.float.Title_M'))
        }
        .height($r('app.float.back_button_height'))
        .aspectRatio(1)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .onClick(() => this.pathInfos.pop())

        Text($r('app.string.bottom'))
          .margin({ left: $r('sys.float.padding_level4') })
          .font({ size: $r('app.float.bar_font_size'), weight: Constants.FONT_WEIGHT_700 })
          .fontColor($r('sys.color.font_primary'))
      }
      .width(Constants.FULL_WIDTH)
      .height($r('app.float.bar_height'))
      .zIndex(2)

      Row() {
        Text($r('app.string.enter_the_verification_code'))
          .fontSize($r('app.float.font_size_l'))
          .fontWeight(FontWeight.Medium)
      }
      .height($r('app.float.list_padding_top'))
      .margin({ top: $r('sys.float.padding_level8') })
      .alignSelf(ItemAlign.Center)

      Row() {
        Text($r('app.string.Verification_code_sent_to'))
          .fontSize($r('app.float.font_size_m'))
          .fontColor($r('app.color.phone_color'))
          .fontWeight(FontWeight.Regular)
        Text($r('app.string.phone_number1'))
          .fontSize($r('app.float.font_size_m'))
          .fontColor($r('app.color.theme_color'))
          .fontWeight(FontWeight.Regular)
      }
      .alignSelf(ItemAlign.Center)
      .margin({ bottom: $r('app.float.margin_bottom_one') })

      TextInput()
        .backgroundColor(Color.Transparent)
        .maxLength(this.maxLength)
        .type(InputType.Number)
        .translate({ x: Constants.NEGATIVE_TWELVE })
        .width(this.curBp === 'sm' ? '100%' : $r('app.float.input_width'))
        .alignSelf(ItemAlign.Center)

      Divider()
        .strokeWidth(this.strokeWidth)
        .color($r('sys.color.comp_divider'))
        .margin({
          top: $r('app.float.text_margin'),
          bottom: $r('sys.float.padding_level6')
        })
        .width(this.curBp === 'sm' ? '100%' : $r('app.float.input_width'))

      Row() {
        Text($r('app.string.reacquire'))
          .fontSize($r('app.float.font_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.brand'))
      }
      .alignSelf(ItemAlign.Center)
      .justifyContent(FlexAlign.End)
      .width(this.curBp === 'sm' ? '100%' : $r('app.float.input_width'))
      .margin({ top: $r('sys.float.padding_level6') })
    }
    .padding({
      left: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.curBp),
      right: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.curBp),
      top: this.statusBarHeight
    })
    .height(Constants.ONE_HUNDRED_PERCENT)
    .width(Constants.ONE_HUNDRED_PERCENT)
  }
}

@Builder
export function getBottomWithBar(name: string): void {
  if (name === 'BottomWithBar') {
    NavDestination() {
      BottomWithBar()
    }
    .hideTitleBar(true)
  }
}

export const wrappedBuilderBottomWithBar: WrappedBuilder<[string, number]> = wrapBuilder(getBottomWithBar);