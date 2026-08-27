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
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { DiscoverPage } from '../view/DiscoverPage';

@Builder
export function DoubleNestingTabTwoBuilder() {
  DoubleNestingTabTwo();
}

@Component
struct DoubleNestingTabTwo {
  @State topTabData: Array<string | Resource> = CommonConstants.TOP_TAB_DATA;
  @State currentIndex: number = 0;
  private controller: TabsController = new TabsController();
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @Consume(CommonConstants.AS_KEY_PATH_STACK) pathStack: NavPathStack;

  @Builder
  tabBuilder(index: number, name: string | Resource) {
    Column() {
      Text(name)
        .fontColor($r('sys.color.font_primary'))
        .fontSize(this.currentIndex === index ? $r('app.float.current_text_size') : $r('app.float.double_text_size'))
        .fontWeight(this.currentIndex === index ? CommonConstants.FONT_WEIGHT_TAB : FontWeight.Normal)
    }
    .width(CommonConstants.FULL_WIDTH)
  }

  @Builder
  contentBuilder(index: number, text: string | Resource) {
    TabContent() {
      Column() {
        Row() {
          Text(text)
            .height(CommonConstants.CONTENT_HEIGHT)
            .fontSize($r('app.float.content_font_size'))
            .fontColor($r('sys.color.font_primary'))
        }
        .width(CommonConstants.FULL_WIDTH)
        .height(CommonConstants.FULL_HEIGHT)
        .justifyContent(FlexAlign.Center)
      }
      .width(CommonConstants.FULL_WIDTH)
    }
    .tabBar(this.tabBuilder(index, text))
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.TopStart }) {
        Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
          TabContent() {
            DiscoverPage({ controller: this.controller })
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
        .onAnimationStart((_index: number, targetIndex: number) => {
          this.currentIndex = targetIndex;
        })
        .width(CommonConstants.FULL_WIDTH)
        .height(CommonConstants.FULL_HEIGHT)

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
          sm: $r('sys.float.padding_level8'), md: $r('sys.float.padding_level12'),
          lg: $r('sys.float.padding_level16')
        }).getValue(this.curBp),
        right: new BreakpointType({
          sm: $r('sys.float.padding_level8'), md: $r('sys.float.padding_level12'),
          lg: $r('sys.float.padding_level16')
        }).getValue(this.curBp)
      })
      .width(CommonConstants.FULL_WIDTH)
    }
    .hideTitleBar(true)
    .padding({
      top: this.statusBarHeight,
    })
    .backgroundColor($r('sys.color.background_secondary'))
  }
}