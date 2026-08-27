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
import { IProductItem } from '../model/ProductItem';
import { TAB_DATA, TabDataModel } from '../model/TabsData';
import { waterFlowData } from '../model/HomeViewModel';
import { WaterFlowDataSource } from '../model/WaterFlowDataSource';
import WaterFlowListComponent from './WaterFlowListComponent';

/**
 * Goods Tab Page
 */
@Preview
@Component
export struct GoodsTabComponent {
  @State tabsIndex: number = 0;
  @StorageProp(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  tabsController: TabsController = new TabsController();
  tabScroller: Scroller = new Scroller();
  tabStart: number = 0;
  tabEnd: number = 0;
  dataSource: WaterFlowDataSource = new WaterFlowDataSource(waterFlowData);

  filterData(index: number) {
    let newListData: IProductItem[] = [];
    if (index !== 0) {
      for (let i = 0; i < waterFlowData.length; i++) {
        if (index > 0 && index < TAB_DATA.length && waterFlowData[i].typeId === TAB_DATA[index].id) {
          newListData.push(waterFlowData[i]);
        }
      }
      this.dataSource = new WaterFlowDataSource(newListData);
      return this.dataSource;
    } else {
      this.dataSource = new WaterFlowDataSource(waterFlowData);
      return this.dataSource;
    }
  }

  @Builder
  tabBuilder(index: number, name: string | Resource) {
    Row() {
      Text(name)
        .constraintSize({ minWidth: this.tabsIndex === index ? 90 : 66 })
        .textAlign(TextAlign.Center)
        .fontSize($r('app.float.tab_font_size'))
        .fontColor(this.tabsIndex === index ? $r('sys.color.font_on_primary') : $r('sys.color.font_secondary'))
        .fontWeight(this.tabsIndex === index ? 500 : 400)
        .height(CommonConstants.FULL_HEIGHT)
        .padding({ left: $r('app.float.tab_text_padding_left'), right: $r('app.float.tab_text_padding_right') })
        .backgroundColor(this.tabsIndex === index ? $r('sys.color.comp_background_emphasize') :
        $r('sys.color.comp_background_tertiary'))
        .borderRadius(21)
    }
    .padding({
      bottom: $r('app.float.tab_padding_bottom'),
      left: 0,
      right: $r('app.float.tab_padding_right')
    })
    .justifyContent(FlexAlign.Center)
    .height(48)
    .align(Alignment.Center)
    .onClick(() => {
      this.tabsIndex = index;
      this.tabsController.changeIndex(index);
      this.filterData(index);
    })
  }

  build() {
    Column() {
      Column() {
        Row() {
          Stack() {
            List({ scroller: this.tabScroller }) {
              ForEach(TAB_DATA, (tabItem: TabDataModel, index: number) => {
                this.tabBuilder(index, tabItem.navData)
              }, (index: number) => JSON.stringify(index))
            }
            .width(CommonConstants.FULL_WIDTH)
            .height(CommonConstants.FULL_HEIGHT)
            .listDirection(Axis.Horizontal)
            .scrollBar(BarState.Off)
            .onScrollIndex((start, end) => {
              this.tabStart = start
              this.tabEnd = end
            })
          }
          .alignContent(Alignment.End)
          .layoutWeight(1)
          .height(48)
        }
        .padding({ right: $r('app.float.home_margin_right') })
        .direction(Direction.Rtl)
        .alignItems(VerticalAlign.Bottom)
        .width(CommonConstants.FULL_WIDTH)
      }
      .alignItems(HorizontalAlign.Start)
      .width(CommonConstants.FULL_WIDTH)

      Tabs({ controller: this.tabsController }) {
        ForEach(TAB_DATA, (_: TabDataModel, index: number) => {
          TabContent() {
            WaterFlowListComponent({ datasource: this.filterData(index) })
          }
        }, (index: number) => JSON.stringify(index))
      }
      .barMode(BarMode.Scrollable)
      .barWidth(CommonConstants.FULL_WIDTH)
      .barHeight(0)
      .onChange((index: number) => {
        this.tabsIndex = index;
        this.filterData(index);
        if (this.tabsIndex <= this.tabStart || this.tabsIndex >= this.tabEnd) {
          this.tabScroller.scrollToIndex(this.tabsIndex, true);
        }
      })
    }
    .height(CommonConstants.FULL_HEIGHT)
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
      }).getValue(this.curBp)
    })
  }
}

