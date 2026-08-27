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

import { BottomTabModel } from '../viewmodel/TabItem';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/CommonConstants';
import { initTabTuData } from '../viewmodel/TabViewModel';

@Builder
export function RudderStyleTabBuilder() {
  RudderStyleTab();
}

@Component
struct RudderStyleTab {
  @State tabArray: Array<BottomTabModel> = initTabTuData();
  @State currentIndex: number = 0;
  @State iconOffset: number = 0;
  @State initNumber: number = 0;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  private controller: TabsController = new TabsController();

  @Builder
  Tab(icon: Resource, title: string | Resource, middleMode: boolean, index: number) {
    Column() {
      if (index === CommonConstants.TAB_INDEX_TWO) {
        SymbolGlyph($r('sys.symbol.plus_circle_fill'))
          .fontColor([$r('sys.color.brand')])
          .fontSize(56)
          .offset({ y: -15 })
      } else {
        SymbolGlyph(icon)
          .fontColor([this.currentIndex === index ? $r('sys.color.brand') : $r('sys.color.icon_tertiary')])
          .fontSize(22)
          .offset({
            y: (this.currentIndex === index && this.currentIndex !== CommonConstants.TAB_INDEX_TWO)
              ? this.iconOffset : this.initNumber
          })
          .animation({
            duration: CommonConstants.ANIMATION_DURATION,
            curve: Curve.Ease,
            playMode: PlayMode.Normal
          })
      }

      if (!middleMode) {
        Text(title)
          .fontSize(10)
          .margin({ top: 6 })
          .fontColor(this.currentIndex === index ? $r('sys.color.brand') : $r('sys.color.font_primary'))
      }
    }
    .padding({
      top: new BreakpointType({ sm: 11, md: 11, lg: 0 }).getValue(this.curBp),
      left: new BreakpointType({ sm: 0, md: 0, lg: 11 }).getValue(this.curBp)
    })
    .width(new BreakpointType({ sm: '100%', md: '100%', lg: '96vp' }).getValue(this.curBp))
    .height(new BreakpointType({ sm: 98, md: 98, lg: 100 }).getValue(this.curBp))
    .backgroundColor($r('sys.color.background_secondary'))
    .translate({ y: 40 })
    .onClick(() => {
      if (index !== CommonConstants.TAB_INDEX_TWO) {
        this.currentIndex = index;
        this.controller.changeIndex(index);
        this.iconOffset = CommonConstants.ICON_OFFSET;
      }
    })
  }

  build() {
    NavDestination() {
      if (this.curBp === 'sm' || this.curBp === 'md') {
        Column() {
          Stack({ alignContent: Alignment.BottomStart }) {
            Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
              ForEach(this.tabArray, (item: BottomTabModel, index: number) => {
                if (index === CommonConstants.TAB_INDEX_TWO) {
                  TabContent()
                    .backgroundColor($r('sys.color.background_secondary'))
                } else {
                  TabContent() {
                    Row() {
                      Text(item.title)
                        .fontColor($r('sys.color.font_primary'))
                        .fontSize(30)
                    }
                    .height(300)
                    .width('100%')
                    .justifyContent(FlexAlign.Center)
                  }
                  .backgroundColor($r('sys.color.background_secondary'))
                }
              }, (item: BottomTabModel) => JSON.stringify(item.id))
            }
            .backgroundColor($r('sys.color.background_secondary'))
            .scrollable(false)
            .barHeight(this.initNumber)
            .animationDuration(CommonConstants.ANIMATION_DURATION)

            Flex() {
              ForEach(this.tabArray, (item: BottomTabModel, index: number) => {
                this.Tab(item.selectImage, item.title, item.middleMode, index)
              }, (item: BottomTabModel) => JSON.stringify(item.id))
            }
          }
        }
        .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
        .height('100%')
      } else {
        Row() {
          Stack({ alignContent: Alignment.BottomStart }) {
            Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
              ForEach(this.tabArray, (item: BottomTabModel, index: number) => {
                if (index === CommonConstants.TAB_INDEX_TWO) {
                  TabContent()
                    .backgroundColor($r('sys.color.background_secondary'))
                } else {
                  TabContent() {
                    Row() {
                      Text(item.title)
                        .fontColor($r('sys.color.font_primary'))
                        .fontSize(30)
                    }
                    .height(300)
                    .width('100%')
                    .justifyContent(FlexAlign.Center)
                  }
                  .backgroundColor($r('sys.color.background_secondary'))
                }
              }, (item: BottomTabModel) => JSON.stringify(item.id))
            }
            .width('100%')
            .backgroundColor($r('sys.color.background_secondary'))
            .scrollable(false)
            .barHeight(this.initNumber)
            .animationDuration(CommonConstants.ANIMATION_DURATION)

            Column() {
              ForEach(this.tabArray, (item: BottomTabModel, index: number) => {
                this.Tab(item.selectImage, item.title, item.middleMode, index)
              }, (item: BottomTabModel) => JSON.stringify(item.id))
            }
            .justifyContent(FlexAlign.Center)
            .height('100%')
            .width('96vp')
          }
        }
        .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
        .width('100%')
      }
    }
    .padding({
      top: this.statusBarHeight,
      bottom: this.navigatorBarHeight
    })
    .backgroundColor($r('sys.color.background_secondary'))
  }
}