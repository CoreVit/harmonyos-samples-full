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

import { BreakpointConstants } from '../constants/BreakpointConstants';
import { CommonConstants } from '../constants/CommonConstants';
import { BreakpointType } from '../utils/BreakpointSystem';
import { FoodItem } from '../view/FoodItem';
import { FoodListHeader, FoodListTab } from '../view/FoodListHeader';
import { FoodData, FoodDataList } from '../viewmodel/FoodListViewModel';
import { ShopDisplay } from './ShopDisplay';

@Builder
export function FoodListBuilder() {
  FoodList();
}

@Component
export struct FoodList {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') @Watch('changeBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'naviIndicatorHeight') naviIndicatorHeight: number = 0;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'statusBarHeight') statusBarHeight: number = 0;
  pageInfo: NavPathStack = new NavPathStack();
  @Provide(CommonConstants.LIFE_PREFIX + 'ifShowSides') ifShowSides: boolean = false;
  @Provide(CommonConstants.LIFE_PREFIX + 'ifShowShopDisplay') ifShowShopDisplay: boolean = false;
  @State foodDataList: FoodData[] = new FoodDataList().getFoodDataList();
  @State chooseIndex: number = 0;
  private scroller: Scroller = new Scroller();
  private pathStack?: NavPathStack;

  @Builder
  PageMap() {
    ShopDisplay();
  }

  changeBreakpoint() {
    if (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM) {
      this.ifShowSides = false;
    }
  }

  build() {
    NavDestination() {
      Row() {
        Navigation(this.pageInfo) {
          Column() {
            FoodListHeader({
              handleBackPress: () => {
                this.pathStack?.pop();
              }
            })
              .padding({
                left: new BreakpointType({
                  sm: $r('app.float.padding_small'), md: $r('app.float.padding_food_md'),
                  lg: $r('app.float.common_padding')
                }).getValue(this.currentBreakpoint),
                right: new BreakpointType({
                  sm: $r('app.float.padding_small'), md: $r('app.float.padding_food_md'),
                  lg: $r('app.float.common_padding')
                }).getValue(this.currentBreakpoint)
              })
            FoodListTab()
            Scroll(this.scroller) {
              GridRow({
                columns: (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
                  this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL) && !this.ifShowSides ?
                  BreakpointConstants.GRID_ROW_COLUMNS[5] : 1,
                gutter: { x: BreakpointConstants.GRID_ROW_GUTTER, y: BreakpointConstants.GRID_ROW_GUTTER }
              }) {
                ForEach(this.foodDataList, (item: FoodData, index: number) => {
                  GridCol() {
                    FoodItem({ foodData: item, listIndex: index, chooseIndex: this.chooseIndex })
                  }
                  .onClick(() => {
                    this.ifShowSides = true;
                    this.ifShowShopDisplay = true;
                    this.pageInfo.replacePath({ name: CommonConstants.DEFAULT_ROUTE }, false);
                    this.chooseIndex = index;
                  })
                }, (item: FoodData) => item.getName());
              }
              .padding({
                left: this.ifShowSides ? $r('app.float.padding_small') :
                  new BreakpointType({
                    sm: $r('app.float.padding_small'), md: $r('app.float.padding_food_md'),
                    lg: $r('app.float.common_padding')
                  }).getValue(this.currentBreakpoint),
                right: this.ifShowSides ?
                  new BreakpointType({
                    sm: $r('app.float.padding_small'), md: $r('app.float.padding_small'),
                    lg: $r('app.float.common_padding')
                  }).getValue(this.currentBreakpoint) :
                  new BreakpointType({
                    sm: $r('app.float.padding_small'), md: $r('app.float.common_padding'),
                    lg: $r('app.float.common_padding')
                  }).getValue(this.currentBreakpoint)
              })
              .layoutWeight(1)
            }
            .scrollBarWidth(0)
            .align(Alignment.Top)
            .layoutWeight(1)
          }
          .padding({
            top: this.statusBarHeight,
            bottom: this.naviIndicatorHeight
          })
        }
        .height(CommonConstants.FULL_PERCENT)
        .hideTitleBar(true)
        .navBarWidthRange(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD ?
          [CommonConstants.FIFTY_PERCENT, CommonConstants.FIFTY_PERCENT] :
          [CommonConstants.FORTY_PERCENT, CommonConstants.FORTY_PERCENT])
        .navDestination(this.PageMap)
        .mode(this.ifShowSides && this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_SM ?
          NavigationMode.Split : NavigationMode.Stack)
      }
      .height(CommonConstants.FULL_PERCENT)
    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}