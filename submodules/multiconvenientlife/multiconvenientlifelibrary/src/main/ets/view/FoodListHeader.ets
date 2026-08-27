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
import { FoodListConstants } from '../constants/FoodListConstants';
import { BreakpointType } from '../utils/BreakpointSystem';

@Component
export struct FoodListHeader {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @Consume(CommonConstants.LIFE_PREFIX + 'ifShowSides') ifShowSides: boolean;
  handleBackPress?: Function;

  build() {
    Row() {
      Button({ type: ButtonType.Circle }) {
        SymbolGlyph($r('sys.symbol.chevron_backward'))
          .fontColor([$r('sys.color.icon_primary')])
          .fontSize($r('sys.float.Title_M'))
      }
      .height(40)
      .aspectRatio(1)
      .margin({ right: $r('sys.float.padding_level4') })
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .onClick(() => this.handleBackPress?.())

      Blank()
      Row() {
        Search({ placeholder: $r('app.string.food_name') })
          .height($r('app.float.food_name_height'))
          .placeholderFont({
            size: $r('app.float.food_data_font'),
            weight: FontWeight.Normal
          })
          .backgroundColor(Color.Transparent)
          .layoutWeight(1)
          .padding({
            left: $r('app.float.food_padding_left'),
            top: $r('app.float.food_padding_tb'),
            bottom: $r('app.float.food_padding_tb')
          })
          .enableKeyboardOnFocus(false)
        SymbolGlyph($r('sys.symbol.mic_fill'))
          .fontSize(18)
          .fontColor([$r('sys.color.font_primary')])
          .margin({ right: 7 })
        Divider()
          .vertical(true)
          .width(2)
          .height(20)
          .margin({ right: 2 })
        Row() {
          Text($r('app.string.search_tip'))
            .fontColor($r('sys.color.font_emphasize'))
            .fontSize($r('sys.float.Body_M'))
        }
        .width(56)
        .justifyContent(FlexAlign.Center)
      }
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .borderRadius($r('app.float.food_border_radius'))
      .height($r('app.float.food_height'))
      .width($r('app.float.food_width'))
      .layoutWeight(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM || this.ifShowSides ? 1 : 0)
    }
    .height($r('app.float.food_stack_height'))
    .width(CommonConstants.FULL_PERCENT)
  }
}

@Component
export struct FoodListTab {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;

  build() {
    List() {
      ForEach(FoodListConstants.TABS_LIST, () => {
        ListItem() {
          Button()
            .margin({
              right: $r('app.float.tabs_margin_right')
            })
            .width(78)
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .height($r('app.float.tabs_list_height'))
        }
      }, (item: string) => item);
    }
    .width(CommonConstants.FULL_PERCENT)
    .listDirection(Axis.Horizontal)
    .height($r('app.float.tabs_height'))
    .padding({
      top: $r('app.float.twelves_padding'),
      bottom: $r('app.float.twelves_padding'),
      left: new BreakpointType({
        sm: $r('app.float.padding_small'), md: $r('app.float.tabs_list_padding_left'),
        lg: $r('app.float.common_padding')
      }).getValue(this.currentBreakpoint)
    })
    .scrollBarWidth(0)
  }
}