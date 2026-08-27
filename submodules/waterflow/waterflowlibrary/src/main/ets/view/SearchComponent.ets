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

@Component
export default struct SearchComponent {
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @State changeValue: string = '';
  controller: SearchController = new SearchController();
  @Consume(CommonConstants.AS_KEY_PATH_STACK) pathStack: NavPathStack;

  build() {
    Row() {
      Button({ type: ButtonType.Circle }) {
        SymbolGlyph($r('sys.symbol.chevron_backward'))
          .fontSize($r('sys.float.Title_M'))
          .fontColor([$r('sys.color.font_primary')])
      }
      .margin({ right: 8 })
      .focusable(true)
      .focusOnTouch(true)
      .height(40)
      .width(40)
      .aspectRatio(1)
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .onClick(() => {
        this.pathStack.pop();
      })

      Row() {
        Search({ value: this.changeValue, placeholder: '', controller: this.controller })
          .width(new BreakpointType({ sm: CommonConstants.FULL_WIDTH, md: '308vp', lg: '400vp' }).getValue(this.curBp))
          .backgroundColor($r('sys.color.comp_background_tertiary'))
      }
      .justifyContent(FlexAlign.End)
      .layoutWeight(1)
    }
    .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
    .width(CommonConstants.FULL_WIDTH)
    .padding({
      top: this.statusBarHeight,
      left: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.curBp),
      right: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.curBp)
    })
  }
}