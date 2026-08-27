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
import { BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { TabItem } from '../viewmodel/TabItem';
import { initTabData } from '../viewmodel/TabViewModel';

@Builder
export function BackgroundLightTabBuilder() {
  BackgroundLightTab();
}

@Component
struct BackgroundLightTab {
  @State tabArray: Array<TabItem> = initTabData();
  @State focusIndex: number = 0;
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @Consume(CommonConstants.AS_KEY_PATH_STACK) pathStack: NavPathStack;
  private controller: TabsController = new TabsController();
  private listScroller: Scroller = new Scroller();
  private barHeight: number = 0;

  @Builder
  tabBuilder(tabName: string | Resource, tabIndex: number) {
    Row() {
      Text(tabName)
        .fontSize(14)
        .fontColor(tabIndex === this.focusIndex ? $r('sys.color.font_on_primary') : $r('sys.color.font_primary'))
        .id(tabIndex.toString())
    }
    .justifyContent(FlexAlign.Center)
    .width(96)
    .backgroundColor(tabIndex === this.focusIndex ? $r('sys.color.brand') : $r('sys.color.comp_background_tertiary'))
    .borderRadius(21)
    .height(40)
    .onClick(() => {
      this.controller.changeIndex(tabIndex);
      this.listScroller.scrollToIndex(tabIndex, true, ScrollAlign.CENTER);
    })
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.chevron_backward'))
              .fontColor([$r('sys.color.icon_primary')])
              .fontSize($r('sys.float.Title_M'))
          }
          .height(CommonConstants.INDEX_TITLE_HEIGHT)
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .aspectRatio(1)
          .margin({
            right: $r('sys.float.padding_level2'),
          })
          .onClick(() => {
            this.pathStack.pop();
          })

          List({ space: CommonConstants.PADDING_8, scroller: this.listScroller }) {
            ForEach(this.tabArray.slice(0, 6),
              (item: TabItem, index: number) => {
                ListItem() {
                  this.tabBuilder(item.name, index);
                }
              }, (item: TabItem) => JSON.stringify(item.id))
          }
          .layoutWeight(1)
          .width('100%')
          .height('100%')
          .listDirection(Axis.Horizontal)
          .scrollBar(BarState.Off)
        }
        .alignItems(VerticalAlign.Top)
        .height(52)
        .margin({
          top: $r('sys.float.padding_level4'),
          left: $r('sys.float.padding_level6'),
          right: $r('sys.float.padding_level6')
        })

        Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
          ForEach(this.tabArray.slice(0, 6),
            (item: TabItem) => {
              TabContent() {
                Row() {
                  Text(item.name)
                    .fontColor($r('sys.color.font_primary'))
                    .height(300)
                    .fontSize(30)
                }
                .width('100%')
                .justifyContent(FlexAlign.Center)
              }
            }, (item: TabItem) => JSON.stringify(item.id))
        }
        .width('100%')
        .barWidth('90%')
        .barMode(BarMode.Fixed)
        .barHeight(this.barHeight)
        .animationDuration(CommonConstants.ANIMATION_DURATION)
        .onAnimationStart((index: number, targetIndex: number) => {
          this.focusIndex = targetIndex;
          this.listScroller.scrollToIndex(targetIndex, true, ScrollAlign.CENTER);
        })
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .padding({
      top: this.statusBarHeight,
    })
    .backgroundColor($r('sys.color.background_secondary'))
  }
}