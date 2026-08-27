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
import { CommonConstants } from '../common/constants/CommonConstants';
import { SectionsPage } from '../view/SectionsWaterFlowComponent';

interface tabArray {
  index: number,
  name: ResourceStr
}

@Component
export struct SectionsHomePage {
  @State currentIndex: number = 0;
  @State changeValue: string = '';
  @State tabsIndex: number = 0;
  @State tabsArray: tabArray[] = [
    {
      index: 0,
      name: $r('app.string.sticky_tab_all')
    },
    {
      index: 1,
      name: $r('app.string.sticky_tab_merchant')
    },
    {
      index: 2,
      name: $r('app.string.sticky_tab_note')
    },
    {
      index: 3,
      name: $r('app.string.sticky_tab_group_buy')
    },
    {
      index: 4,
      name: $r('app.string.sticky_tab_user')
    }
  ]
  @StorageProp(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  tabsController: TabsController = new TabsController();
  controller: SearchController = new SearchController();
  @Consume(CommonConstants.AS_KEY_PATH_STACK) pathStack: NavPathStack;

  @Builder
  tabBuilder(index: number, name: string | Resource) {
    Row() {
      Text(name)
        .constraintSize({ minWidth: $r('app.float.sections_tab_width') })
        .textAlign(TextAlign.Center)
        .fontSize($r('app.float.tab_font_size'))
        .fontColor(this.tabsIndex === index ? $r('sys.color.font_on_primary') : $r('sys.color.font_secondary'))
        .fontWeight(this.tabsIndex === index ? 500 : 400)
        .height(CommonConstants.FULL_HEIGHT)
        .padding({ left: $r('app.float.tab_text_padding_left'), right: $r('app.float.tab_text_padding_right') })
        .backgroundColor(this.tabsIndex === index ? $r('sys.color.comp_background_emphasize') :
        $r('sys.color.comp_background_tertiary'))
        .borderRadius($r('app.float.sections_tab_radius'))
    }
    .padding({
      top: $r('app.float.tab_padding_top'),
      bottom: $r('app.float.tab_padding_bottom'),
      left: 0,
      right: $r('app.float.tab_padding_right')
    })
    .justifyContent(FlexAlign.Center)
    .height($r('app.float.tab_height'))
    .align(Alignment.Center)
    .onClick(() => {
      this.tabsIndex = index;
      this.tabsController.changeIndex(index);
    })
  }

  build() {
    NavDestination() {
      Column() {
        Column() {
          Row() {
            Button({ type: ButtonType.Circle }) {
              SymbolGlyph($r('sys.symbol.chevron_backward'))
                .fontSize($r('sys.float.Title_M'))
                .fontColor([$r('sys.color.font_primary')])
            }
            .margin({ right: $r('sys.float.padding_level4') })
            .focusable(true)
            .focusOnTouch(true)
            .id('back2Index')
            .height(40)
            .width(40)
            .aspectRatio(1)
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .onClick(() => {
              this.pathStack.pop();
            })

            Row() {
              Search({ value: this.changeValue, placeholder: '', controller: this.controller })
                .width(new BreakpointType({
                  sm: CommonConstants.FULL_WIDTH,
                  md: CommonConstants.SEARCH_BAR_MD_WIDTH,
                  lg: CommonConstants.SEARCH_BAR_LG_WIDTH
                }).getValue(this.curBp))
                .backgroundColor($r('sys.color.comp_background_tertiary'))
            }
            .justifyContent(FlexAlign.End)
            .layoutWeight(1)
          }

          Scroll() {
            Row() {
              ForEach(this.tabsArray, (item: tabArray) => {
                this.tabBuilder(item.index, item.name)
              }, (item: tabArray) => JSON.stringify(item))
            }
          }
          .scrollable(ScrollDirection.Horizontal)
          .edgeEffect(EdgeEffect.Fade)
          .scrollBar(BarState.Off)
          .align(Alignment.Start)
          .width('100%')
        }
        .padding({
          left: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }
          ).getValue(this.curBp),
          right: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.curBp)
        })
        .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)

        Column() {
          Tabs({ index: this.currentIndex, controller: this.tabsController }) {
            ForEach(this.tabsArray, (item: tabArray) => {
              TabContent() {
                SectionsPage()
              }.tabBar(this.tabBuilder(item.index, item.name))
            }, (item: tabArray) => JSON.stringify(item))
          }
          .backgroundColor($r('sys.color.gray_01'))
          .barHeight(0)
          .barMode(BarMode.Scrollable)
          .onChange((index: number) => {
            this.tabsIndex = index;
          })
        }
      }
    }
    .padding({
      top: this.statusBarHeight
    })
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}