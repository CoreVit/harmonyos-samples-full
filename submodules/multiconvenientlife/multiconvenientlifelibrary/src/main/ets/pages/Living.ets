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
import { LivingComments } from '../view/LivingComments';
import { LivingHome } from '../view/LivingHome';

@Builder
export function LivingBuilder() {
  Living();
}

@Component
export struct Living {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      SideBarContainer(SideBarContainerType.Embed) {
        LivingComments()
          .width(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
            this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL ?
            CommonConstants.FORTY_PERCENT_STRING : CommonConstants.THIRTY_SEVEN_PERCENT)
        LivingHome({
          handleBackPress: () => {
            this.pathStack?.pop();
          }
        })
      }
      .width(CommonConstants.FULL_PERCENT)
      .backgroundImage($r('app.media.fm2_img'))
      .backgroundBlurStyle(BlurStyle.BACKGROUND_THICK, {
        colorMode: ThemeColorMode.DARK,
        adaptiveColor: AdaptiveColor.DEFAULT
      })
      .backgroundImageSize({
        width: CommonConstants.FULL_PERCENT,
        height: CommonConstants.FULL_PERCENT
      })
      .sideBarPosition(SideBarPosition.End)
      .sideBarWidth(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
        this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL ?
        CommonConstants.THIRTY_SEVEN_PERCENT : CommonConstants.FORTY_PERCENT_STRING)
      .showControlButton(false)
    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}