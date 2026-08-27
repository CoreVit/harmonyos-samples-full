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

import { CategoryHeader, WidthBreakpointType } from 'multishoppingbase';
import { MobilePhoneList, ProductCategory } from 'multishoppingproduct';
import { uiObserver } from '@kit.ArkUI';
import { CategoryBanner } from 'multishoppingrecommend';
import { HdsNavigation } from '@kit.UIDesignKit';
import { deviceInfo } from '@kit.BasicServicesKit';

@ComponentV2
export struct Category {
  @Env(SystemProperties.BREAK_POINT) breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  private pageInfo: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    this.pageInfo.pushPath({ name: '' }, false)
  }

  @Builder
  PageMap(name: string) {
    NavDestination() {
      Scroll() {
        Column() {
          Row() {
            CategoryBanner()
          }
          .width('100%')
          .padding({
            right: new WidthBreakpointType(16, 24, 32, 32).getValue(this.breakpoint.widthBreakpoint)
          })

          MobilePhoneList()
        }
      }
      .padding({
        top: 12,
        left: new WidthBreakpointType(16, 24, 32, 32).getValue(this.breakpoint.widthBreakpoint)
      })
      .scrollBar(BarState.Off)
      .background($r('app.color.page_background'))
      .height('100%')
      .align(Alignment.Top)
    }
    .width('100%')
    .height('100%')
    .hideBackButton(true)
    .hideTitleBar(true)
    .background($r('app.color.page_background'))
  }

  build() {
    Column() {
      CategoryHeader()
        .padding({
          right: 100
        })
      if(deviceInfo.distributionOSApiVersion >= 60100){
        HdsNavigation(this.pageInfo) {
          ProductCategory()
        }
        .navBarWidth(new WidthBreakpointType('96vp', '144vp', '200vp', '200vp').getValue(this.breakpoint.widthBreakpoint))
        .layoutWeight(1)
        .mode(NavigationMode.Split)
        .hideToolBar(true)
        .hideTitleBar(true)
        .navDestination(this.PageMap)
        .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.START, LayoutSafeAreaEdge.TOP])
      }else {
        Navigation(this.pageInfo) {
          ProductCategory()
        }
        .navBarWidth(new WidthBreakpointType('96vp', '144vp', '200vp', '200vp').getValue(this.breakpoint.widthBreakpoint))
        .layoutWeight(1)
        .mode(NavigationMode.Split)
        .hideToolBar(true)
        .hideTitleBar(true)
        .navDestination(this.PageMap)
        .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.START, LayoutSafeAreaEdge.TOP])
      }
    }
    .width('100%')
    .height('100%')
    .background($r('app.color.page_background'))
  }
}
