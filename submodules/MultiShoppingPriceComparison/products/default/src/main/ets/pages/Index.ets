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
/**
 * Index is the entry of application and Here is a list showing three buttons,
 * click the button to jump to different pages.
 */
import { uiObserver } from '@kit.ArkUI';
import { RootTabsPage } from './RootTabsPage';
import { ProductDetail } from './ProductDetail';
import { HdsNavigation } from '@kit.UIDesignKit';
import { LiveBroadCastPage } from './LiveBroadCastPage';
import { deviceInfo } from '@kit.BasicServicesKit';

@Entry
@ComponentV2
struct Index {
  private static readonly liveNavigationId: string = 'navid';
  /** Provides breakpoint context to the subtree; child components consume it via @Env(SystemProperties.BREAK_POINT). */
  @Env(SystemProperties.BREAK_POINT) breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Provider('mainPageMap') mainPageMap: NavPathStack = new NavPathStack();

  @Builder
  PageMap(name: string) {
    if (name === 'RootTabsPage'){
      RootTabsPage() 
    }else if (name === 'ProductDetail') {
      ProductDetail()
    }else if (name === 'LiveBroadCastPage'){
      LiveBroadCastPage()
    }
  }

  build() {
    if(deviceInfo.distributionOSApiVersion >= 60100){
      HdsNavigation(this.mainPageMap) {
        RootTabsPage()
      }
      .hideTitleBar(true)
      .navDestination(this.PageMap)
      .mode(NavigationMode.Stack)
      .id(Index.liveNavigationId)
      .backgroundColor($r('app.color.start_window_background'))
      .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.BOTTOM])
    } else {
      Navigation(this.mainPageMap) {
        RootTabsPage()
      }
      .hideTitleBar(true)
      .navDestination(this.PageMap)
      .mode(NavigationMode.Stack)
      .id(Index.liveNavigationId)
      .backgroundColor($r('app.color.start_window_background'))
      .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.BOTTOM])
    }
  }
}