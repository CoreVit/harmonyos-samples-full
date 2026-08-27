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

import { CommonConstants, WindowUtil } from 'multivideobase';
import { TVMainPageContent } from 'multivideorecommended';
import { TVSearchView } from 'multivideosearch';
import { TVVideoDetail } from 'multivideodetail';
import { TvConstants } from '../constants/TvConstants';
import { TVHomeHeader } from '../view/TVHomeHeader';

@Entry
@Component
struct Index2 {
  @StorageLink(CommonConstants.WINDOW_UTIL) windowUtil: WindowUtil | undefined = undefined;
  @Provide('pageInfo') pageInfo: NavPathStack = new NavPathStack();
  @Provide('currentTopIndex') currentTopIndex: number = 0;
  @State currentBottomIndex: number = TvConstants.HOME_BOTTOM_INDEX;
  @Provide('inOnTv') isOnTv: boolean = true;
  @Provide('inOnPc') isOnPc: boolean = false;
  private sideScroller: Scroller = new Scroller();

  @Builder
  PageMap(name: string) {
    if (name === TvConstants.PAGE_NAME_FOR_VIDEO) {
      TVVideoDetail({ mainWindowInfo: this.windowUtil?.mainWindowInfo })
    }
  }

  aboutToDisappear(): void {
    AppStorage.delete(CommonConstants.WINDOW_UTIL);
    AppStorage.delete(CommonConstants.AVPLAYER_STATE);
    AppStorage.delete(CommonConstants.IS_HALF_FOLDED);
    AppStorage.delete(CommonConstants.IS_FULL_SCREEN);
    AppStorage.delete(CommonConstants.CREASE_REGION);
    AppStorage.delete(CommonConstants.DETAIL_SURFACE_ID);
    AppStorage.delete(CommonConstants.APPLICATION_COLOR_MODE);
  }

  build() {
    Navigation(this.pageInfo) {
      Stack() {
        Scroll(this.sideScroller) {
          Column() {
            TVMainPageContent()
              .visibility(this.currentBottomIndex === TvConstants.HOME_BOTTOM_INDEX ? Visibility.Visible :
                Visibility.None)

            TVSearchView()
              .visibility(this.currentBottomIndex === TvConstants.SEARCH_BOTTOM_INDEX ? Visibility.Visible :
                Visibility.None)
          }
          .width('100%')
        }
        .scrollBar(BarState.Off)

        TVHomeHeader({ currentBottomIndex: this.currentBottomIndex })
      }
      .height('100%')
      .width('100%')
      .alignContent(Alignment.Top)
      .backgroundColor($r('sys.color.gray_02'))
    }
    .mode(NavigationMode.Stack)
    .navDestination(this.PageMap)
    .hideToolBar(true)
    .hideTitleBar(true)
    .hideBackButton(true)
    .width('100%')
    .height('100%')
  }
}
