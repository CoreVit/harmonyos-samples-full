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
import Logger from '../utils/Logger';

const TAG: string = '[Index]';

interface PageInfo {
  title: Resource;
  pathName: string;
}

@Component
export struct MultiConvenientLifePage {
  pathStack: NavPathStack = new NavPathStack();
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'naviIndicatorHeight') naviIndicatorHeight: number = 0;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'statusBarHeight') statusBarHeight: number = 0;
  @State pageShow: string = 'button';
  dataList: PageInfo[] = [
    { title: $r('app.string.food_list'), pathName: 'FoodList' },
    { title: $r('app.string.graphic_text'), pathName: 'GraphicText' },
    { title: $r('app.string.living_page'), pathName: 'Living' },
  ];

  build() {
    Navigation(this.pathStack) {
      Column() {
        if (this.pageShow === CommonConstants.PAGE_ROUTER_INDEX) {
          Column() {
            Text($r('app.string.EntryAbility_label'))
              .width(CommonConstants.FULL_PERCENT)
              .fontSize(30)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('sys.color.font_primary'))
              .margin({
                top: 64
              })
          }
          .width(CommonConstants.FULL_PERCENT)
          .alignItems(HorizontalAlign.Center)
          .height(112)

          Column({ space: CommonConstants.DEFAULT_SPACE }) {
            ForEach(this.dataList, (item: PageInfo) => {
              Button(item.title)
                .width(CommonConstants.FULL_PERCENT)
                .constraintSize({
                  maxWidth: $r('app.float.max_width')
                })
                .onClick(() => {
                  try {
                    this.pathStack.pushPathByName(item.pathName, null)
                  } catch (err) {
                    Logger.error(TAG, `Failed to push url. Cause: ${err.message}`);
                  }
                })
            }, (item: PageInfo) => item.pathName)
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.End)
          .padding({
            bottom: 16
          })
        }
      }
      .padding({
        left: new BreakpointType({
          sm: $r('sys.float.padding_level8'), md: $r('sys.float.padding_level12'),
          lg: $r('sys.float.padding_level16')
        }).getValue(this.currentBreakpoint),
        right: new BreakpointType({
          sm: $r('sys.float.padding_level8'), md: $r('sys.float.padding_level12'),
          lg: $r('sys.float.padding_level16')
        }).getValue(this.currentBreakpoint),
        top: this.statusBarHeight,
        bottom: this.naviIndicatorHeight
      })
      .backgroundColor($r('sys.color.background_secondary'))
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
  }
}