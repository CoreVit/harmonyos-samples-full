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

import { WindowInfo } from 'financialbase';
import { TabItem } from '../model/TabsModel';
import { HomePage } from '../pages/HomePage';
import { TabsViewModel } from '../viewmodel/TabsViewModel';

@ComponentV2
export struct TabsView {
  @Local currentBottomIndex: number = 0;
  @Param mainWindowInfo: WindowInfo = new WindowInfo();
  private tabList: TabItem[] = new TabsViewModel().getTabList();

  build() {
    SideBarContainer() {
      this.SideBar()
      if (this.currentBottomIndex === 0) {
        HomePage({
          mainWindowInfo: this.mainWindowInfo
        })
      } else {
        Column()
      }
    }
    .showControlButton(false)
    .height('100%')
    .width('100%')
    .sideBarWidth(240)
    .divider({
      strokeWidth: 0.5,
      color: $r('app.color.comp_background_tertiary'),
    })
    .autoHide(false)
  }

  @Builder
  SideBar() {
    Column() {
      Row() {
        Image($r('app.media.startIcon'))
          .width(30)
          .height(30)
        Text($r('app.string.PcAbility_label'))
          .fontSize(18)
          .fontColor($r('app.color.font_primary'))
          .fontWeight(500)
          .padding({
            left: 12,
            right: 12
          })
          .maxLines(1)
          .layoutWeight(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .padding({
        left: 24,
        top: 16
      })
      .width('100%')
      .height(56)

      Column() {
        ForEach(this.tabList, (item: TabItem, index: number) => {
          ListItem() {
            this.SideTabBuilder(item, index)
          }
        }, (item: TabItem, index: number) => JSON.stringify(item) + index)
      }
      .margin(16)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_secondary'))
  }

  @Builder
  SideTabBuilder(item: TabItem, index: number) {
    Row() {
      this.TabIcon(item, index)
      Text(item.name)
        .fontSize(16)
        .fontWeight(500)
        .fontColor(index === this.currentBottomIndex ? $r('app.color.font_emphasize') : $r('app.color.font_primary'))
        .margin({ left: 8 })
    }
    .onClick(() => {
      this.currentBottomIndex = index;
    })
    .height(40)
    .width('100%')
    .padding(8)
    .margin({ bottom: 2 })
    .borderRadius(8)
    .backgroundColor(index === this.currentBottomIndex ? $r('app.color.brand5') : Color.Transparent)
  }

  @Builder
  TabIcon(item: TabItem, index: number) {
    SymbolGlyph(item.icon)
      .fontSize(24)
      .fontColor([index === this.currentBottomIndex ? $r('app.color.icon_emphasize') : $r('app.color.icon_primary')])
  }
}