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

import {
  ItemRestriction,
  SegmentButtonOptions,
  SegmentButtonTextItem
} from '@ohos.arkui.advanced.SegmentButton';
import { listArr } from '../viewmodel/InitData';
import { CommonConstants } from '../constants/CommonConstants';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { WindowUtil } from '../utils/WindowUtil';

@Component
export struct ScrollComponentNestedSlidingComponent {
  @State @Watch('onSegmentButtonChange') tabSelectedIndexes: number[] = [0];
  @State currentIndex: number = 0;
  @State tabOptions: SegmentButtonOptions = SegmentButtonOptions.tab({
    buttons: [{ text: $r('app.string.Promotional') },
      { text: $r('app.string.Travel') }] as ItemRestriction<SegmentButtonTextItem>,
    fontSize: $r('sys.float.Body_M'),
    selectedFontSize: $r('sys.float.Body_M'),
    fontColor: $r('sys.color.font_secondary'),
    selectedFontColor: $r('sys.color.font_primary'),
    backgroundColor: $r('sys.color.comp_background_tertiary'),
    selectedBackgroundColor: $r('sys.color.ohos_id_color_foreground_contrary_disable'),
    textPadding: {
      top: 8,
      bottom: 8,
      right: 16,
      left: 16
    },
  })
  @StorageLink(CommonConstants.KEY_PREFIX_BREAKPOINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(CommonConstants.KEY_PREFIX_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  private scrollerForScroll: Scroller = new Scroller();
  private scrollerForList: Scroller = new Scroller();
  private listArrCount: number = listArr.length;

  aboutToDisappear(): void {
    WindowUtil.unRegisterBreakPoint();
  }

  onSegmentButtonChange() {
    this.currentIndex = this.tabSelectedIndexes[0];
  }

  @Builder
  tabBuilder(index: number, name: ResourceStr) {
    Column() {
      Text(name)
        .fontColor(this.currentIndex === index ? $r('app.color.active_font_color') : $r('app.color.font_color'))
        .fontSize($r('app.float.middle_font_size'))
        .fontWeight(this.currentIndex === index ? CommonConstants.FONT_WEIGHT_FIVE : CommonConstants.FONT_WEIGHT_FOUR)
        .lineHeight($r('app.float.title_line_height'))
        .margin({
          top: $r('app.float.title_margin_top'),
          bottom: $r('app.float.title_margin_bottom')
        })
      Divider()
        .strokeWidth(CommonConstants.STROKE_WIDTH)
        .width($r('app.float.divider_width'))
        .color($r('app.color.active_font_color'))
        .opacity(this.currentIndex === index ? CommonConstants.FULL_OPACITY : CommonConstants.ZERO_OPACITY)
    }
  }

  @Builder
  listBuilder(listName: ResourceStr, tabName: ResourceStr, index: number) {
    TabContent() {
      List({ scroller: this.scrollerForList }) {
        ForEach(listArr, (item: string, index: number) => {
          ListItem() {
            Row() {
              Text(listName)
                .fontSize($r('app.float.middle_font_size'))
                .fontColor($r('sys.color.font_primary'))
                .fontWeight(CommonConstants.FONT_WEIGHT_FIVE)
              Text(item)
                .fontSize($r('app.float.middle_font_size'))
                .fontWeight(CommonConstants.FONT_WEIGHT_FIVE)
                .fontColor($r('sys.color.font_primary'))
            }
            .justifyContent(FlexAlign.Center)
            .borderColor($r('sys.color.comp_divider'))
            .borderWidth({ bottom: 0.5 })
            .backgroundColor($r('sys.color.comp_background_primary'))
            .width(CommonConstants.FULL_WIDTH)
            .height(CommonConstants.FULL_HEIGHT)
          }
          .borderRadius({
            bottomLeft: this.curBp === 'sm' ? ((index === this.listArrCount - 1) ? $r('app.float.list_item_radius') : 0) :
                        ((index === this.listArrCount - 2) ? $r('app.float.list_item_radius') : 0),
            bottomRight: this.curBp === 'sm' ? ((index === this.listArrCount - 1) ? $r('app.float.list_item_radius') : 0) :
                         ((index === this.listArrCount - 1) ? $r('app.float.list_item_radius') : 0)
          })
          .backgroundColor($r('sys.color.comp_background_primary'))
          .padding({ left: $r('app.float.list_item_padding'), right: $r('app.float.list_item_padding') })
          .width(CommonConstants.FULL_WIDTH)
          .height($r('app.float.list_item_height'))
        }, (item: string) => JSON.stringify(item))
      }
      .lanes(new BreakpointType(1, 2, 2).getValue(this.curBp))
      .width(CommonConstants.FULL_WIDTH)
      .height(CommonConstants.FULL_HEIGHT)
      .edgeEffect(EdgeEffect.None)
      .scrollBar(BarState.Off)
      .nestedScroll({
        scrollForward: NestedScrollMode.PARENT_FIRST,
        scrollBackward: NestedScrollMode.SELF_FIRST
      })
    }
    .tabBar(this.tabBuilder(index, tabName))
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Top }) {
        Scroll(this.scrollerForScroll) {
          Column() {
            Text($r('app.string.title'))
              .fontWeight(FontWeight.Bold)
              .fontSize($r('app.float.big_font_size'))
              .height($r('app.float.list_item_height'))
              .textAlign(TextAlign.Start)
              .width(CommonConstants.FULL_WIDTH)
              .fontColor($r('sys.color.font_primary'))
              .margin({
                left: $r('sys.float.padding_level12'),
                // bottom: $r('app.float.discover_bottom_padding'),
                top: $r('sys.float.padding_level16')
              })
            Tabs() {
              this.listBuilder($r('app.string.goods'), $r('app.string.Promotional'), 0)
              this.listBuilder($r('app.string.Itinerary'), $r('app.string.Travel'), 1)
            }
            .barWidth($r('app.float.bar_width'))
            .barHeight($r('app.float.bar_height'))
            .onAnimationStart((_index: number, targetIndex: number, _event: TabsAnimationEvent) => {
              this.currentIndex = targetIndex;
            })
          }
        }
        .scrollBar(BarState.Off)
        .width(CommonConstants.FULL_WIDTH)
        .height(CommonConstants.FULL_HEIGHT)
      }
      .width(CommonConstants.FULL_WIDTH)
      .height(CommonConstants.STACK_HEIGHT)
    }
    .height(CommonConstants.FULL_HEIGHT)
    .backgroundColor($r('sys.color.ohos_id_color_background'))
  }
}

