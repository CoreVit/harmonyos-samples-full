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

import { CommonConstants } from '../common/CommonConstants';
import { initDoubleTabData } from '../viewmodel/TabViewModel';
import { TabItem } from '../viewmodel/TabItem';

@Component
export struct DiscoverPage {
  @State tabArray: Array<TabItem> = initDoubleTabData();
  @State focusIndex: number = 0;
  public controller: TabsController = new TabsController();
  private listScroller: Scroller = new Scroller();
  private subController: TabsController = new TabsController();
  private panOptionRight: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Left });
  private barHeight: number = 0;

  @Builder
  subTabBuilder(tabName: string | Resource, tabIndex: number) {
    Row() {
      Text(tabName)
        .fontSize($r('app.float.text_size'))
        .fontColor(tabIndex === this.focusIndex ? $r('sys.color.brand') : $r('sys.color.font_primary'))
        .id(tabIndex.toString())
    }
    .padding({ right: 16 })
    .height(CommonConstants.SUB_TAB_HEIGHT)
    .onClick(() => {
      this.subController.changeIndex(tabIndex);
      this.focusIndex = tabIndex;
    })
  }

  build() {
    Column() {
      Column() {
        Row() {
          List({ initialIndex: CommonConstants.TAB_INDEX_ZERO, scroller: this.listScroller }) {
            ForEach(this.tabArray, (item: TabItem, index: number) => {
              this.subTabBuilder(item.name, index)
            }, (item: TabItem) => JSON.stringify(item.id))
          }
          .listDirection(Axis.Horizontal)
          .height(CommonConstants.SUB_TAB_HEIGHT)
          .scrollBar(BarState.Off)
          .width('90%')
          .friction($r('app.float.list_friction'))

          SymbolGlyph($r('sys.symbol.line_3_horizontal'))
            .fontSize(CommonConstants.MORE_IMAGE_WIDTH)
            .fontColor([$r('sys.color.font_primary')])
            .margin({ bottom: $r('sys.float.padding_level2') })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .height(CommonConstants.SUB_TAB_BOT_HEIGHT)
        .width(CommonConstants.FULL_WIDTH)
      }
      .width(CommonConstants.FULL_WIDTH)

      Tabs({ barPosition: BarPosition.Start, controller: this.subController }) {
        ForEach(this.tabArray, (item: TabItem) => {
          if (item.id === this.tabArray.length - 1) {
            TabContent() {
              Row() {
                Text(item.name)
                  .height(CommonConstants.CONTENT_HEIGHT)
                  .fontSize($r('app.float.content_font_size'))
              }
              .width(CommonConstants.FULL_WIDTH)
              .justifyContent(FlexAlign.Center)
              .gesture(
                PanGesture(this.panOptionRight)
                  .onActionEnd(() => {
                    this.controller.changeIndex(1);
                  })
              )
            }
          } else {
            TabContent() {
              Row() {
                Text(item.name)
                  .height(CommonConstants.CONTENT_HEIGHT)
                  .fontSize($r('app.float.content_font_size'))
              }
              .width(CommonConstants.FULL_WIDTH)
              .justifyContent(FlexAlign.Center)
            }
          }
        }, (item: TabItem) => JSON.stringify(item.id))
      }
      .barHeight(this.barHeight)
      .animationDuration(CommonConstants.ANIMATION_DURATION)
      .onAnimationStart((index: number, targetIndex: number) => {
        this.focusIndex = targetIndex;
        this.listScroller.scrollToIndex(targetIndex, true, ScrollAlign.CENTER);
      })
    }
    .backgroundColor($r('sys.color.background_secondary'))
  }
}