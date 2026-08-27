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
import { IndexTabsState } from 'multishoppingbase';
import { Home } from './Home';
import { Category } from './Category';
import { IndexTabItemModel } from 'multishoppingbase';

@ComponentV2
export struct RootTabsPage {
  @Local indexTabsState: IndexTabsState = new IndexTabsState();
  private pageInfo: NavPathStack = new NavPathStack();

  @Builder
  PageMap(name: string) {
    if (name === 'Home') {
      NavDestination() {
        Home()
      }
    } else if (name === 'Category') {
      NavDestination() {
        Category()
      }
    } else {
      Column()
        .width('100%')
        .height('100%')
    }
  }

  aboutToAppear(): void {
    this.pageInfo.pushPath({ name: 'Home' }, false)
  }

  private onNavItemClick(index: number): void {
    this.indexTabsState.selectTab(index);
    if (this.pageInfo.size() !== 0) {
      this.pageInfo.pop();
    }
    if (index === 0) {
      this.pageInfo.pushPath({ name: 'Home' }, false);
    } else if (index === 1) {
      this.pageInfo.pushPath({ name: 'Category' }, false);
    } else {
      this.pageInfo.pushPath({ name: 'empty' }, false);
    }
  }

  build() {
    NavDestination() {
      Navigation(this.pageInfo) {
        Row() {
          Image($r('app.media.live_vmall'))
            .width(24)
            .height(24)
            .margin({
              right: 8
            })
          Text($r('app.string.PC_NAV_TITLE'))
        }
        .padding({
          left: 10
        })
        .height(56)
        .width('100%')

        List() {
          ForEach(this.indexTabsState.items, (item: IndexTabItemModel, index: number) => {
            ListItem() {
              Row() {
                SymbolGlyph(index === this.indexTabsState.selectedIndex ? item.selectedSymbol : item.normalSymbol)
                  .fontSize(24)
                  .fontColor([$r('sys.color.font_primary')])
                Text(item.text)
                  .fontSize(16)
                  .fontColor($r('sys.color.font_primary'))
                  .margin({ left: 8 })
              }
              .borderRadius(10)
              .padding({
                left: 10
              })
              .height(48)
              .width(208)
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Start)
              .backgroundColor(index === this.indexTabsState.selectedIndex ? $r('sys.color.interactive_hover') :
                $r('sys.color.background_secondary'))
            }
            .onClick(() => {
              this.onNavItemClick(index);
            })
          }, (_item: IndexTabItemModel, index: number) => `${index}`)
        }
        .height('100%')
      }
      .backgroundColor($r('sys.color.background_secondary'))
      .padding({
        left: 10,
        right: 10
      })
      .navBarWidth(232)
      .mode(NavigationMode.Split)
      .hideToolBar(true)
      .hideTitleBar(false)
      .navDestination(this.PageMap)
    }
    .hideTitleBar(true)
  }
}
