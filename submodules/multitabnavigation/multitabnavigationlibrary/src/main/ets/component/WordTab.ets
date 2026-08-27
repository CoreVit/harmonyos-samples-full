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
import { initTabDataNew } from '../viewmodel/TabViewModel';
import { TabItem } from '../viewmodel/TabItem';

@Builder
export function WordTabBuilder() {
  WordTab();
}

@Component
struct WordTab {
  @State tabArray: Array<TabItem> = initTabDataNew();
  @State currentIndex: number = 0;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @Consume(CommonConstants.AS_KEY_PATH_STACK) pathStack: NavPathStack;

  @Builder
  tabBuilder(index: number, name: string | Resource) {
    Text(name)
      .fontColor($r('sys.color.font_primary'))
      .fontSize(this.currentIndex === index ? 20 : 16)
      .fontWeight(this.currentIndex === index ? 600 : FontWeight.Normal)
      .lineHeight(22)
      .id(index.toString())
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.TopStart }) {
        Tabs({ barPosition: BarPosition.Start }) {
          ForEach(this.tabArray.slice(0, 4), (item: TabItem) => {
            TabContent() {
              Row() {
                Text(item.name)
                  .height(300)
                  .fontColor($r('sys.color.font_primary'))
                  .fontSize(30)
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .height('100%')
            }.tabBar(this.tabBuilder(item.id, item.name))
          }, (item: TabItem) => JSON.stringify(item.id))
        }
        .barWidth('70%')
        .barHeight(52)
        .width('100%')
        .height('100%')
        .animationDuration(CommonConstants.ANIMATION_DURATION)
        .onAnimationStart((index: number, targetIndex: number) => {
          if (index === targetIndex) {
            return;
          }
          this.currentIndex = targetIndex;
        })

        Column() {
          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.chevron_backward'))
              .fontColor([$r('sys.color.icon_primary')])
              .fontSize($r('sys.float.Title_M'))
          }
          .height(CommonConstants.INDEX_TITLE_HEIGHT)
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .aspectRatio(1)
          .margin({
            left: $r('sys.float.padding_level6'),
            right: $r('sys.float.padding_level3'),
          })
          .onClick(() => {
            this.pathStack.pop();
          })
        }
        .height($r('app.float.mainPage_barHeight'))
        .justifyContent(FlexAlign.Center)
      }
    }
    .hideTitleBar(true)
    .padding({
      top: this.statusBarHeight,
    })
    .backgroundColor($r('sys.color.background_secondary'))
  }
}