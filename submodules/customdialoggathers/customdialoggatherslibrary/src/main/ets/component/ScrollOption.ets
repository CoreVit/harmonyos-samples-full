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

import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/constants/CommonConstants';

@Builder
export function ScrollOptionBuilder() {
  ScrollOption();
}

@Component
struct ScrollOption {
  @StorageLink(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  private selectTime: Date = new Date('2024-4-17T18:30:00');
  @State select: number = 2;
  private fruits: string[] = ['apple1', 'orange2', 'peach3', 'grape4', 'banana5'];

  build() {
    NavDestination() {
      Navigation() {
        Column() {
          Button($r('app.string.button_scroll_option1'))
            .width(this.curBp === 'sm' ? CommonConstants.FULL_PERCENT : CommonConstants.WIDTH_MD_LG)
            .height($r('app.integer.button_height_small'))
            .fontSize($r('sys.float.Subtitle_M'))
            .backgroundColor($r('sys.color.brand'))
            .margin({
              bottom: $r('sys.float.padding_level6')
            })
            .onClick(() => {
              this.getUIContext().showTimePickerDialog({
                selected: this.selectTime,
                backgroundColor: $r('sys.color.background_primary'),
                onAccept: (value: TimePickerResult) => {
                  this.selectTime.setHours(value.hour, value.minute);
                }
              });
            })
          Button($r('app.string.button_scroll_option2'))
            .width(this.curBp === 'sm' ? CommonConstants.FULL_PERCENT : CommonConstants.WIDTH_MD_LG)
            .height($r('app.integer.button_height_small'))
            .fontSize($r('sys.float.Subtitle_M'))
            .backgroundColor($r('sys.color.brand'))
            .margin({
              bottom: $r('sys.float.padding_level6')
            })
            .onClick(() => {
              this.getUIContext().showTextPickerDialog({
                range: this.fruits,
                selected: this.select,
                backgroundColor: $r('sys.color.background_primary'),
                onAccept: (value: TextPickerResult) => {
                  this.select = value.index as number;
                }
              });
            })
        }
        .justifyContent(FlexAlign.End)
        .width(CommonConstants.FULL_PERCENT)
        .height(CommonConstants.FULL_PERCENT)
        .padding({
          right: this.curBp === 'sm' ? $r('sys.float.padding_level8') : $r('sys.float.padding_level0'),
          left: this.curBp === 'sm' ? $r('sys.float.padding_level8') : $r('sys.float.padding_level0')
        })
      }
      .title($r('app.string.scroll_option'))
      .titleMode(NavigationTitleMode.Mini)
      .mode(NavigationMode.Stack)

      .padding({
        top: this.statusBarHeight,
        right: new BreakpointType({
          sm: $r('sys.float.padding_level0'),
          md: $r('sys.float.padding_level4'),
          lg: $r('sys.float.padding_level8')
        }).getValue(this.curBp),
        bottom: this.navigatorBarHeight,
        left: new BreakpointType({
          sm: $r('sys.float.padding_level0'),
          md: $r('sys.float.padding_level4'),
          lg: $r('sys.float.padding_level8')
        }).getValue(this.curBp)
      })
    }
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}