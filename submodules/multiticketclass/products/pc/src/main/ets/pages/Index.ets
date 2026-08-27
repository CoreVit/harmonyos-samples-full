/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { OptionPage } from './OptionPage';
import { CommonModifier } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State currentTabIndex: number = 2;
  tabBarModifier: CommonModifier = new CommonModifier();

  getTabBarColor(index: number, currentTabIndex: number): ResourceColor {
    return currentTabIndex === index ? $r('app.color.tab_selected_color') : $r('app.color.tab_unselected_color');
  }

  @Builder
  BuildTabs(icon: Resource, title: ResourceStr, index: number): void {
    Row() {
      Image(icon)
        .width(24)
        .height(24)
        .fillColor(this.getTabBarColor(index, this.currentTabIndex))
        .margin({ left: 8, bottom: 8, top: 8 })
      Text(title)
        .fontSize(18)
        .lineHeight(22)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.getTabBarColor(index, this.currentTabIndex))
        .margin({ left: 8 })
    }
    .borderRadius(8)
    .margin({ left: 16, right: 16 })
    .padding({ top: index === 0 ? 64 : 8, bottom: 8 })
    .backgroundColor(this.currentTabIndex === index ? $r('app.color.tab_selected_background') : '')
    .width(208)
    .height(index === 0 ? 96 : 40)
    .justifyContent(FlexAlign.Start)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  OverlayTabAppName(): void {
    Row() {
      Image($r('app.media.startIcon'))
        .width(24)
        .height(24)
      Text($r('app.string.tab_app_name'))
        .fontSize(18)
        .lineHeight(22)
        .fontWeight(FontWeight.Medium)
        .margin({ left: 8 })
    }
    .padding({
      top: 20, left: 24
    })
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(VerticalAlign.Top)
    .hitTestBehavior(HitTestMode.Transparent);
  }

  build() {
    GridRow({
      columns: { lg: 12 },
      direction: GridRowDirection.Row
    }) {
      GridCol({
        span: { lg: 12 }
      }) {
        Column() {
          Tabs({
            barPosition: BarPosition.Start,
            index: this.currentTabIndex,
            barModifier: this.tabBarModifier.align(Alignment.Top)
          }) {
            TabContent() {
            }
            .tabBar(this.BuildTabs($r('app.media.house_fill'), $r('app.string.home_page'), 0))
            .backgroundColor($r('app.color.tab_content_background'))

            TabContent() {
            }
            .tabBar(this.BuildTabs($r('app.media.doc_text_fill'), $r('app.string.information'), 1))
            .backgroundColor($r('app.color.tab_content_background'))

            TabContent() {
              OptionPage()
            }
            .tabBar(this.BuildTabs($r('app.media.square_and_pencil_fill'), $r('app.string.optional'), 2))
            .backgroundColor($r('app.color.tab_content_background'))

            TabContent() {
            }
            .tabBar(this.BuildTabs($r('app.media.doc_plaintext_fill'), $r('app.string.market'), 3))
            .backgroundColor($r('app.color.tab_content_background'))
          }
          .vertical(true)
          .barWidth(240)
          .barHeight('100%')
          .barMode(BarMode.Scrollable)
          .backgroundColor($r('app.color.tabs_background'))
          .scrollable(false)
          .onChange((index: number) => {
            this.currentTabIndex = index;
          })
          .overlay(this.OverlayTabAppName(), { align: Alignment.TopStart });
        }
        .width('100%')
        .height('100%')
      }
    }
  }
}
