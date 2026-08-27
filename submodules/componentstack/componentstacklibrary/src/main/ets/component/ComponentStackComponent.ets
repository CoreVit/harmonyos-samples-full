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

import type { BusinessError } from '@kit.BasicServicesKit';
import { IconList1, IconList2, IconList3 } from '../view/IconView';
import { ProductList } from '../view/ProductList';
import { CommonConstants } from '../constants/CommonConstants';
import { BreakpointTypeEnum } from '../utils/BreakpointSystem';
import Logger from '../utils/Logger';
import { WindowUtil } from '../utils/WindowUtil';

const TAG: string = '[ComponentStackComponent]';

@Component
export struct ComponentStackComponent {
  @State searchHeight: number = CommonConstants.SEARCH_HEIGHT_RAW;
  @State opacityList: number = 1;
  @State opacityList2: number = 1;
  @State ratio: number = 1;
  @State isChange: boolean = false;
  @State heightList2: number = CommonConstants.HEIGHT_LIST_2_RAW;
  @State marginSpace: number = CommonConstants.MAX_MARGIN_SPACE;
  @StorageLink(CommonConstants.KEY_PREFIX + 'statusBarHeight') statusBarHeight: number = 0;
  @StorageLink(CommonConstants.KEY_PREFIX + 'navigatorBarHeight') navigatorBarHeight: number = 0;
  @StorageLink(CommonConstants.KEY_PREFIX + 'screenHeight') screenHeight: number = 0;
  @StorageLink(CommonConstants.KEY_PREFIX + 'currentBreakpoint') curBp: string = BreakpointTypeEnum.SM;
  private scroller: Scroller = new Scroller();
  private scroller2: Scroller = new Scroller();

  aboutToDisappear(): void {
    WindowUtil.unRegisterBreakPoint();
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        SymbolGlyph($r('sys.symbol.person_crop_circle_fill_1'))
          .fontSize($r('app.integer.user_portrait_width'))
          .fontColor([$r('sys.color.icon_secondary')])
          .aspectRatio(1)

        SymbolGlyph($r('sys.symbol.line_viewfinder'))
          .fontSize($r('app.integer.user_portrait_width'))
          .fontColor([$r('sys.color.icon_secondary')])
          .aspectRatio(1)
      }
      .padding({
        top: $r('app.integer.flex_padding_top')
      })
      .width(CommonConstants.FULL_PERCENT)
      .height($r('app.integer.flex_height'))

      Scroll(this.scroller) {
        Column() {
          Row() {
            SymbolGlyph($r('sys.symbol.magnifyingglass'))
              .fontSize($r('app.integer.search_width'))
              .fontColor([$r('sys.color.icon_secondary')])
              .aspectRatio(1)
              .margin({ left: $r('app.integer.search_icon_margin_left') })

            Text($r('app.string.search_title'))
              .fontColor($r('sys.color.font_primary'))
              .fontSize($r('app.integer.search_font_size'))
              .margin({ left: $r('app.integer.search_text_margin_left') })
          }
          .width(CommonConstants.FULL_PERCENT)
          .height(this.searchHeight)
          .backgroundColor($r('sys.color.comp_background_primary'))
          .borderRadius($r('app.integer.search_border_radius'))
          .onClick(() => {
            try {
              this.getUIContext()
                .getPromptAction()
                .showToast({ message: $r('app.string.component_stack_other_function') });
            } catch (error) {
              const err: BusinessError = error as BusinessError;
              Logger.error(TAG, `showToast failed, ErrorCode: ${err.code}, Message: ${err.message}`)
            }
          });

          Stack({ alignContent: Alignment.Top }) {
            if (this.isChange) {
              Row() {
                IconList3({ marginSpace: this.marginSpace })
              }
              .backgroundColor($r('sys.color.background_secondary'))
              .width(CommonConstants.FULL_PERCENT)
              .height($r('app.integer.icon_list_height3'))
              .opacity(this.opacityList)
              .zIndex(1)
            } else {
              Row() {
                IconList1()
              }
              .width(CommonConstants.FULL_PERCENT)
              .height($r('app.integer.icon_list_height1'))
              .opacity(this.opacityList)
            }

            Scroll(this.scroller2) {
              Column() {
                Row() {
                  IconList2({ ratio: this.ratio })
                }
                .width(CommonConstants.FULL_PERCENT)
                .height($r('app.integer.icon_view_height3'))
                .opacity(this.opacityList2)

                ProductList()
                  .width(CommonConstants.FULL_PERCENT)
                  .height(this.getUIContext().px2vp(this.screenHeight - this.statusBarHeight - this.navigatorBarHeight) -
                  CommonConstants.USED_SPACE)
              }
              .margin({ top: CommonConstants.MARGIN_TOP })
            }
            .width(CommonConstants.FULL_PERCENT)
            .scrollBar(BarState.Off)
            // Sets the nested scrolling mode in the forward and backward directions to implement
            // scrolling linkage with the parent widget.
            .nestedScroll({
              // After the parent component is scrolled to the edge, the parent component is scrolled.
              scrollForward: NestedScrollMode.PARENT_FIRST,
              // The parent component is scrolled after the parent component is scrolled to the edge.
              scrollBackward: NestedScrollMode.SELF_FIRST
            })
            .onScrollFrameBegin((offset: number) => {
              // Change the values of margin and opacity to move and hide the component.
              let yOffset: number = this.scroller2.currentOffset().yOffset;
              this.heightList2 = CommonConstants.HEIGHT_LIST_2_RAW - yOffset * 0.5;

              // Set the transparency of IconList2 based on the yOffset value.
              if (1 - yOffset / CommonConstants.ICON_LIST_2_RAW >= 0) {
                this.opacityList2 = 1 - yOffset / CommonConstants.ICON_LIST_2_RAW;
              } else {
                this.opacityList2 = 0;
              }
              // Zoom with transparency settings.
              this.ratio = this.opacityList2;
              // Set the transparency of IconList1 and the margin of IconList3 based on yOffset.
              if (1 - yOffset / CommonConstants.ICON_LIST_1_RAW > 0) {
                this.isChange = false;
                this.opacityList = 1 - yOffset / CommonConstants.ICON_LIST_1_RAW;
                this.marginSpace = CommonConstants.MAX_MARGIN_SPACE;
              } else {
                this.isChange = true;
                this.opacityList = (yOffset - CommonConstants.ICON_LIST_1_RAW) / CommonConstants.MAX_MARGIN_SPACE;
                this.marginSpace = CommonConstants.ICON_LIST_3_RAW - yOffset > CommonConstants.MIN_MARGIN_SPACE ?
                                   (CommonConstants.ICON_LIST_3_RAW - yOffset) : CommonConstants.MIN_MARGIN_SPACE;
              }
              return { offsetRemain: offset };
            })
          }
        }
        .height(CommonConstants.FULL_PERCENT)
        .width(CommonConstants.FULL_PERCENT)
        .margin({ top: $r('app.integer.margin_search_view') })
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .scrollBar(BarState.Off)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      .onScrollFrameBegin((offset: number) => {
        // Obtains the sliding distance.
        const yOffset: number = this.scroller.currentOffset().yOffset;
        this.searchHeight = CommonConstants.SEARCH_HEIGHT_RAW - yOffset * 0.6;
        return { offsetRemain: offset };
      })
    }
    .width(CommonConstants.FULL_PERCENT)
    .layoutWeight(1)
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({
      top: this.statusBarHeight,
      left: this.curBp === 'sm' ? $r('sys.float.padding_level8') :
            this.curBp === 'md' ? $r('sys.float.padding_level12') : $r('sys.float.padding_level16'),
      right: this.curBp === 'sm' ? $r('sys.float.padding_level8') :
             this.curBp === 'md' ? $r('sys.float.padding_level12') : $r('sys.float.padding_level16'),
    })
  }
}