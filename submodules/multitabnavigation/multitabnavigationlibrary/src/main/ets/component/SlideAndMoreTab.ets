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
import { CommonConstants } from '../common/CommonConstants';
import { initTabData } from '../viewmodel/TabViewModel';
import { TabItem } from '../viewmodel/TabItem';


@Builder
export function SlideAndMoreTabBuilder() {
  SlideAndMoreTab();
}

@Component
struct SlideAndMoreTab {
  @State tabArray: Array<TabItem> = initTabData();
  @State focusIndex: number = 0;
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @Consume(CommonConstants.AS_KEY_PATH_STACK) pathStack: NavPathStack;
  private controller: TabsController = new TabsController();
  private listScroller: Scroller = new Scroller();

  @Builder
  Tab(tabName: string | Resource, tabIndex: number) {
    Row() {
      Text(tabName)
        .fontSize(16)
        .fontColor(tabIndex === this.focusIndex ? $r('sys.color.brand') : $r('sys.color.font_primary'))
        .id(tabIndex.toString())
    }
    .padding({ right: 16 })
    .height(30)
    .onClick(() => {
      this.controller.changeIndex(tabIndex);
      this.focusIndex = tabIndex;
    })
  }

  build() {
    NavDestination() {
      Column() {
        Stack({ alignContent: Alignment.TopStart }) {
          Column() {
            Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
              Button({ type: ButtonType.Circle }) {
                SymbolGlyph($r('sys.symbol.chevron_backward'))
                  .fontColor([$r('sys.color.icon_primary')])
                  .fontSize($r('sys.float.Subtitle_M'))
              }
              .height(30)
              .margin({ right: $r('sys.float.padding_level2') })
              .backgroundColor($r('sys.color.comp_background_tertiary'))
              .aspectRatio(1)
              .onClick(() => {
                this.pathStack.pop();
              })

              List({ initialIndex: 0, scroller: this.listScroller }) {
                ForEach(this.tabArray, (item: TabItem, index: number) => {
                  this.Tab(item.name, index)
                }, (item: TabItem) => JSON.stringify(item.id))
              }
              .listDirection(Axis.Horizontal)
              .height(30)
              .scrollBar(BarState.Off)
              .width('100%')
              .flexGrow(1)
              .friction(0.6)

              Button({ type: ButtonType.Circle }) {
                SymbolGlyph($r('sys.symbol.line_3_horizontal'))
                  .fontSize($r('sys.float.Subtitle_M'))
                  .fontColor([$r('sys.color.font_primary')])
              }
              .height(30)
              .margin({ left: $r('sys.float.padding_level2') })
              .backgroundColor($r('sys.color.comp_background_tertiary'))
              .aspectRatio(1)
            }
            .padding({
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
            .width('100%')
            .height(52)
          }
          .width('100%')
        }
        .width('100%')

        Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
          ForEach(this.tabArray, (item: TabItem) => {
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
            .backgroundColor($r('sys.color.background_secondary'))
          }, (item: TabItem) => JSON.stringify(item.id))
        }
        .width('100%')
        .barHeight(0)
        .animationDuration(CommonConstants.ANIMATION_DURATION)
        .onAnimationStart((index: number, targetIndex: number) => {
          this.focusIndex = targetIndex;
          this.listScroller.scrollToIndex(targetIndex, true, ScrollAlign.CENTER);
        })
      }
      .height('100%')
    }
    .hideTitleBar(true)
    .padding({
      top: this.statusBarHeight
    })
    .backgroundColor($r('sys.color.background_secondary'))
  }
}