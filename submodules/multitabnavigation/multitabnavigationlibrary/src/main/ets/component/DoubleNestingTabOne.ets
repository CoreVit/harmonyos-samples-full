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
import { initDoubleTabData } from '../viewmodel/TabViewModel';
import { TabItem } from '../viewmodel/TabItem';

@Builder
export function DoubleNestingTabOneBuilder() {
  DoubleNestingTabOne();
}

@Component
struct DoubleNestingTabOne {
  @State tabArray: Array<TabItem> = initDoubleTabData();
  @State topTabData: Array<string | Resource> = CommonConstants.TOP_TAB_DATA;
  @State focusIndex: number = 0;
  @State currentIndex: number = 0;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @Consume(CommonConstants.AS_KEY_PATH_STACK) pathStack: NavPathStack;
  private controller: TabsController = new TabsController();
  private listScroller: Scroller = new Scroller();
  private subController: TabsController = new TabsController();
  private panOptionRight: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Left });

  @Builder
  tabBuilder(index: number, name: string | Resource) {
    Column() {
      Text(name)
        .fontColor($r('sys.color.font_primary'))
        .fontSize(this.currentIndex === index ? 20 : 18)
        .fontWeight(this.currentIndex === index ? 600 : FontWeight.Normal)
    }
    .width('100%')
  }

  @Builder
  subTabBuilder(tabName: string | Resource, tabIndex: number) {
    Text(tabName)
      .fontSize(16)
      .fontColor(tabIndex === this.focusIndex ? $r('sys.color.brand') : $r('sys.color.font_primary'))
      .id(tabIndex.toString())
      .width(60)
      .padding({ right: 16 })
      .height(30)
      .onClick(() => {
        this.subController.changeIndex(tabIndex);
        this.focusIndex = tabIndex;
      })
  }

  @Builder
  contentBuilder(index: number, text: string | Resource) {
    TabContent() {
      Column() {
        Row() {
          Text(text)
            .fontColor($r('sys.color.font_primary'))
            .height(300)
            .fontSize(30)
        }
        .height(30)
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
    }
    .tabBar(this.tabBuilder(index, text))
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.TopStart }) {
        Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
          TabContent() {
            Column() {
              Column() {
                Row() {
                  List({ initialIndex: CommonConstants.TAB_INDEX_ZERO, scroller: this.listScroller }) {
                    ForEach(this.tabArray, (item: TabItem, index: number) => {
                      this.subTabBuilder(item.name, index)
                    }, (item: TabItem) => JSON.stringify(item.id))
                  }
                  .width('90%')
                  .listDirection(Axis.Horizontal)
                  .height(30)
                  .scrollBar(BarState.Off)
                  .friction(0.6)

                  SymbolGlyph($r('sys.symbol.line_3_horizontal'))
                    .fontSize(20)
                    .fontColor([$r('sys.color.font_primary')])
                    .margin({ bottom: $r('sys.float.padding_level2') })
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .height(25)
                .width('100%')
              }
              .alignItems(HorizontalAlign.Center)
              .width('100%')

              Tabs({ barPosition: BarPosition.Start, controller: this.subController }) {
                ForEach(this.tabArray, (item: TabItem) => {
                  if (item.id === this.tabArray.length - 1) {
                    TabContent() {
                      Row() {
                        Text(item.name)
                          .fontColor($r('sys.color.font_primary'))
                          .height(300)
                          .fontSize(30)
                      }
                      .width('100%')
                      .justifyContent(FlexAlign.Center)
                      .gesture(
                        PanGesture(this.panOptionRight)
                          .onActionEnd(() => {
                            this.controller.changeIndex(1);
                          })
                      )
                    }
                    .backgroundColor($r('sys.color.background_secondary'))
                  } else {
                    TabContent() {
                      Row() {
                        Text(item.name)
                          .height(300)
                          .fontSize(30)
                      }
                      .width('100%')
                      .justifyContent(FlexAlign.Center)
                    }
                    .backgroundColor($r('sys.color.background_secondary'))
                  }
                }, (item: TabItem) => JSON.stringify(item.id))
              }
              .barHeight(0)
              .animationDuration(CommonConstants.ANIMATION_DURATION)
              .onAnimationStart((index: number, targetIndex: number) => {
                this.focusIndex = targetIndex;
                this.listScroller.scrollToIndex(targetIndex, true, ScrollAlign.CENTER);
              })
            }
            .width('100%')
            .height('100%')
          }
          .tabBar(this.tabBuilder(CommonConstants.TAB_INDEX_ZERO, this.topTabData[CommonConstants.TAB_INDEX_ZERO]))

          this.contentBuilder(CommonConstants.TAB_INDEX_ONE, this.topTabData[CommonConstants.TAB_INDEX_ONE])
          this.contentBuilder(CommonConstants.TAB_INDEX_TWO, this.topTabData[CommonConstants.TAB_INDEX_TWO])
          this.contentBuilder(CommonConstants.TAB_INDEX_THREE, this.topTabData[CommonConstants.TAB_INDEX_THREE])
        }
        .vertical(false)
        .barMode(BarMode.Fixed)
        .barWidth('70%')
        .barHeight($r('app.float.mainPage_barHeight'))
        .animationDuration(CommonConstants.ANIMATION_DURATION)
        .onAnimationStart((index: number, targetIndex: number) => {
          this.currentIndex = targetIndex;
        })
        .width('100%')
        .height('100%')

        Column() {
          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.chevron_backward'))
              .fontColor([$r('sys.color.icon_primary')])
              .fontSize($r('sys.float.Title_M'))
          }
          .height(CommonConstants.INDEX_TITLE_HEIGHT)
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .aspectRatio(1)
          .onClick(() => {
            this.pathStack.pop();
          })
        }
        .height($r('app.float.mainPage_barHeight'))
        .justifyContent(FlexAlign.Center)
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
        }).getValue(this.curBp),
      })
      .width('100%')
    }
    .hideTitleBar(true)
    .padding({
      top: this.statusBarHeight,
    })
    .backgroundColor($r('sys.color.background_secondary'))
  }
}