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
import { DishComments } from '../view/DishComments';
import { DishDetailsView } from '../view/DishDetailsView';
import { DishHead, DishSideBar } from '../view/DishInformation';

@Component
export struct DishDetails {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @Consume(CommonConstants.LIFE_PREFIX + 'ifShowSides') ifShowSides: boolean;
  @State ifPictureExpansion: Boolean = false;
  @State imageHeightExtension: number = 0;
  @State imageHeightFold: number = 0;
  @State imageHeight: number = 0;
  private informationScroller: Scroller = new Scroller();
  private detailScroller: Scroller = new Scroller();
  pathStack?: NavPathStack;

  build() {
    NavDestination() {
      Scroll(this.informationScroller) {
        GridRow({
          columns: (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
            this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL) && !this.ifShowSides ?
            BreakpointConstants.GRID_ROW_COLUMNS[2] : 1
        }) {
          GridCol({
            span: (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
              this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL) && !this.ifShowSides ?
              BreakpointConstants.GRID_COLUMN_SPANS[7] : 1
          }) {
            if ((this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_LG &&
              this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_XL) || this.ifShowSides) {
              DishHead({
                ifPictureExpansion: this.ifPictureExpansion,
                imageHeightExtension: this.imageHeightExtension,
                imageHeightFold: this.imageHeightFold,
                imageHeight: this.imageHeight,
                handleBackPress: () => {
                  this.pathStack?.pop();
                }
              })
            } else {
              DishSideBar({
                handleBackPress: () => {
                  this.pathStack?.pop();
                },
              })
            }
          }

          GridCol({
            span: (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
              this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL) && !this.ifShowSides ?
              BreakpointConstants.GRID_COLUMN_SPANS[7] : 1
          }) {
            Scroll(this.detailScroller) {
              DishDetailsView()
            }
            .height((this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
              this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL) && !this.ifShowSides ?
              CommonConstants.FULL_PERCENT : CommonConstants.SELF_ADAPTING)
            .width(CommonConstants.FULL_PERCENT)
            .nestedScroll({
              scrollForward: NestedScrollMode.PARENT_FIRST,
              scrollBackward: NestedScrollMode.PARENT_FIRST
            })
            .scrollBar(BarState.Off)
          }

          if (this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_LG &&
            this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_XL) {
            GridCol({
              span: 1
            }) {
              DishComments()
                .height(CommonConstants.SELF_ADAPTING)
            }
          }
        }
      }
      .scrollBar(BarState.Off)
      .scrollBarWidth(0)
      .height(CommonConstants.FULL_PERCENT)
      .backgroundColor($r('sys.color.background_secondary'))
      .onScrollFrameBegin((offset: number) => {
        if (!this.ifPictureExpansion && offset < 0) {
          this.imageHeight = this.imageHeightExtension;
          this.ifPictureExpansion = true;
          return { offsetRemain: 0 };
        } else if (this.ifPictureExpansion && offset > 0) {
          this.imageHeight = this.imageHeightFold;
          this.ifPictureExpansion = false;
          return { offsetRemain: 0 };
        } else {
          return { offsetRemain: offset };
        }
      })
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}