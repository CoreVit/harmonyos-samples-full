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
import { BreakpointType, ResourceConverter } from '../utils/BreakpointSystem';
import { ShopMenu } from './ShopMenu';

@Component
export struct ShopOrderList {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'naviIndicatorHeight') naviIndicatorHeight: number = 0;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'statusBarHeight') statusBarHeight: number = 0;
  @Provide(CommonConstants.LIFE_PREFIX + 'ifScroll') ifScroll: boolean = false;
  @Consume(CommonConstants.LIFE_PREFIX + 'ifShowSides') ifShowSides: boolean;
  @State topTabsIndex: number = 0;
  private topTabsController: TabsController = new TabsController();
  private tabsList: string[] = [ResourceConverter.convertToString($r('app.string.order')),
    ResourceConverter.convertToString($r('app.string.appraise')),
    ResourceConverter.convertToString($r('app.string.preferential')),
    ResourceConverter.convertToString($r('app.string.business'))];

  build() {
    Column() {
      Row() {
        ForEach(this.tabsList, (item: string, index) => {
          Column() {
            Stack({ alignContent: Alignment.Bottom }) {
              Text(item)
                .fontSize($r('app.float.food_data_font'))
                .fontWeight(CommonConstants.FONT_WEIGHT_600)
                .margin({
                  bottom: $r('app.float.eight_padding')
                })
              Divider()
                .vertical(false)
                .color($r('sys.color.ohos_id_color_alert'))
                .width($r('app.float.dish_lg'))
                .strokeWidth(2)
                .visibility(this.topTabsIndex === index ? Visibility.Visible : Visibility.None)
            }
          }
          .onClick(() => {
            this.topTabsIndex = index
            this.topTabsController.changeIndex(index)
          })
          .padding({
            right: $r('app.float.padding_small')
          })
        }, (item: string) => item);
      }
      .padding({
        left: this.ifShowSides ? new BreakpointType({
          sm: $r('app.float.padding_small'), md: $r('app.float.padding_small'),
          lg: $r('app.float.common_padding')
        }).getValue(this.currentBreakpoint) :
          new BreakpointType({
            sm: $r('app.float.padding_small'), md: $r('app.float.common_padding'),
            lg: $r('app.float.common_padding')
          }).getValue(this.currentBreakpoint)
      })

      Tabs({ controller: this.topTabsController }) {
        ForEach(this.tabsList, () => {
          TabContent() {
            ShopMenu().width(CommonConstants.FULL_PERCENT)
          }
        }, (item: string) => item);
      }
      .layoutWeight(1)
      .barHeight(0)
      .vertical(false)
      .onChange((index: number) => {
        this.topTabsIndex = index
      })
      .barMode(BarMode.Scrollable)
    }
    .alignItems(HorizontalAlign.Start)
    .margin({
      top: this.ifScroll ? this.statusBarHeight : $r('app.float.tabs_padding')
    })
  }
}