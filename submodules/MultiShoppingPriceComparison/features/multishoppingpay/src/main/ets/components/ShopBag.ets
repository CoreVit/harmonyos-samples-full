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

import { ShopBagViewModel } from '../viewmodel/ShopBagViewModel';
import { ShopBagHeader } from './ShopBagHeader';
import { ShopList } from './ShopList';
import { WidthBreakpointType } from 'multishoppingbase';

@ComponentV2
export struct ShopBag {
  @Param public widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @Param public isMoreDetail: boolean = false;
  @Event public onIsMoreDetailChange: (value: boolean) => void = (_value: boolean) => {
  };
  @Local public currentIndex: number = 0;

  @Builder
  payCardBuilder() {
  }

  @BuilderParam public payCardButton: () => void = this.payCardBuilder;
  public scroller: Scroller = new Scroller();
  @Local public tabNames: string[] = [];

  aboutToAppear(): void {
    const ctx = this.getUIContext().getHostContext();
    if (ctx !== undefined) {
      this.tabNames = new ShopBagViewModel().getTabNames(ctx);
    }
  }

  @Builder
  private tabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? $r('app.color.tab_text_selected') :
          $r('app.color.tab_text_unselected'))
        .fontSize(16)
        .lineHeight(33)
        .fontWeight(FontWeight.Medium)
    }
    .margin({
      right: new WidthBreakpointType(16, 16, 24, 24).getValue(this.widthBp)
    })
  }

  build() {
    Column() {
      ShopBagHeader({
        widthBp: this.widthBp,
        isMoreDetail: this.isMoreDetail,
        onIsMoreDetailChange: this.onIsMoreDetailChange
      })
      Tabs({ barPosition: BarPosition.Start }) {
        ForEach(this.tabNames, (item: string, index: number) => {
          TabContent() {
            Scroll(this.scroller) {
              ShopList({
                widthBp: this.widthBp, payCardButton: () => {
                  this.payCardButton();
                }
              })
            }
            .align(Alignment.Top)
            .scrollBar(BarState.Off)
            .height('100%')
            .width('100%')
          }
          .tabBar(this.tabBuilder(item, index))
        }, (item: string, index: number) => `${item}-${index}`)
      }
      .onChange((index: number) => {
        this.currentIndex = index;
      })
      .layoutWeight(1)
      .barWidth('100%')
      .barHeight(56)
      .barMode(BarMode.Scrollable, { margin: 0, nonScrollableLayoutStyle: LayoutStyle.ALWAYS_AVERAGE_SPLIT })
      .fadingEdge(false)
      .margin({
        bottom: 24
      })
    }
    .width('100%')
    .height('100%')
    .padding({
      left: new WidthBreakpointType(16, 24, 32, 32).getValue(this.widthBp),
      right: new WidthBreakpointType(16, 24, 32, 32).getValue(this.widthBp)
    })
  }
}
