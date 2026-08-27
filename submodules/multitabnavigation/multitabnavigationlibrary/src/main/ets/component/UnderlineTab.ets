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
export function UnderlineTabBuilder() {
  UnderlineTab();
}

@Component
struct UnderlineTab {
  @State tabArray: Array<TabItem> = initTabDataNew();
  @State currentIndex: number = 0;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @Consume(CommonConstants.AS_KEY_PATH_STACK) pathStack: NavPathStack;

  @Builder
  tabBuilder(index: number, name: string | Resource) {
    Column() {
      Text(name)
        .fontColor(this.currentIndex === index ? $r('sys.color.brand') : $r('sys.color.font_primary'))
        .fontSize(16)
        .fontWeight(this.currentIndex === index ? FontWeight.Normal : FontWeight.Medium)
        .lineHeight(22)
        .margin({ bottom: 7 })
      Divider()
        .width(48)
        .strokeWidth(CommonConstants.STROKE_WIDTH)
        .color($r('sys.color.brand'))
        .opacity(this.currentIndex === index ? 1 : 0)
    }
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
                  .fontSize(30)
                  .fontColor($r('sys.color.font_primary'))
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .height('100%')
            }.tabBar(this.tabBuilder(item.id, item.name))
          }, (item: TabItem) => JSON.stringify(item.id))
        }
        .vertical(false)
        .barMode(BarMode.Fixed)
        .barWidth('70%')
        .barHeight(52)
        .animationDuration(CommonConstants.ANIMATION_DURATION)
        .onAnimationStart((index: number, targetIndex: number) => {
          if (index === targetIndex) {
            return;
          }
          this.currentIndex = targetIndex;
        })
        .backgroundColor($r('sys.color.background_secondary'))
        .width('100%')
        .height('100%')

        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.chevron_backward'))
            .fontColor([$r('sys.color.icon_primary')])
            .fontSize($r('sys.float.Title_M'))
        }
        .height(CommonConstants.INDEX_TITLE_HEIGHT)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .aspectRatio(1)
        .margin({
          top: $r('sys.float.padding_level4'),
          left: $r('sys.float.padding_level6')
        })
        .onClick(() => {
          this.pathStack.pop();
        })
      }
      .width('100%')
    }
    .hideTitleBar(true)
    .padding({
      top: this.statusBarHeight,
    })
    .backgroundColor($r('sys.color.background_secondary'))
  }
}