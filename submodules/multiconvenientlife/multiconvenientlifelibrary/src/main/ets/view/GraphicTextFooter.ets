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

@Component
export struct GraphicTextFooter {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @Consume(CommonConstants.LIFE_PREFIX + 'showSideBar') showSideBar: boolean;
  private iconList = [$r('sys.symbol.square_and_pencil'), $r('sys.symbol.heart'),
    $r('sys.symbol.star'), $r('sys.symbol.ellipsis_message')];
  private textList = [$r('app.string.write_review'), '267', '193', '1593'];

  build() {
    Row() {
      ForEach(this.iconList, (item: Resource, index: number) => {
        Row() {
          SymbolGlyph(item)
            .fontSize(24)
            .fontColor([$r('sys.color.icon_primary')])
            .aspectRatio(1)
            .margin({
              right: $r('app.float.filtering_padding_lr')
            })
          Text(this.textList[index])
            .fontSize($r('app.float.delivery_font'))
            .fontWeight(CommonConstants.FONT_WEIGHT_500)
        }
        .alignItems(VerticalAlign.Center)
      }, (item: string) => item);
    }
    .width((this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
      this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL) && !this.showSideBar ?
      CommonConstants.FIFTY_PERCENT_STRING : CommonConstants.FULL_PERCENT)
    .justifyContent((this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
      this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL) && !this.showSideBar ?
      FlexAlign.SpaceBetween : FlexAlign.SpaceAround)
    .height($r('app.float.title_height'))
  }
}