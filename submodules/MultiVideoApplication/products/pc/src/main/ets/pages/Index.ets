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

import { BusinessError } from '@kit.BasicServicesKit';
import { CommonConstants, Logger, WindowUtil } from 'multivideobase';
import { VideoDetail } from 'multivideodetail';
import { SearchView } from 'multivideosearch';
import { PcConstants } from '../constants/PcConstants';
import { HomeView } from '../view/HomeView';

const TAG = '[Index]';

@Entry
@Component
struct Index {
  @StorageLink(CommonConstants.WINDOW_UTIL) windowUtil: WindowUtil | undefined = undefined;
  @Provide('pageInfo') pageInfo: NavPathStack = new NavPathStack();
  @Provide('currentTopIndex') currentTopIndex: number = 0;
  @Provide('inOnTv') isOnTv: boolean = false;
  @Provide('inOnPc') isOnPc: boolean = true;

  @Builder
  PageMap(name: string) {
    if (name === PcConstants.PAGE_NAME_FOR_VIDEO) {
      VideoDetail({ mainWindowInfo: this.windowUtil?.mainWindowInfo })
    } else if (name === PcConstants.PAGE_NAME_FOR_SEARCH) {
      SearchView({ mainWindowInfo: this.windowUtil?.mainWindowInfo })
    }
  }

  aboutToAppear(): void {
    try {
      this.windowUtil?.mainWindow.setWindowDecorVisible(false);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `setWindowDecorVisible failed, errCode = ${err.code}, errMessage = ${err.message}.`);
    }
  }

  aboutToDisappear(): void {
    AppStorage.delete(CommonConstants.WINDOW_UTIL);
    AppStorage.delete(CommonConstants.SYSTEM_COLOR_MODE_VERSION);
    AppStorage.delete(CommonConstants.AVPLAYER_STATE);
    AppStorage.delete(CommonConstants.IS_HALF_FOLDED);
    AppStorage.delete(CommonConstants.IS_FULL_SCREEN);
    AppStorage.delete(CommonConstants.CREASE_REGION);
    AppStorage.delete(CommonConstants.DETAIL_SURFACE_ID);
    AppStorage.delete(CommonConstants.APPLICATION_COLOR_MODE);
  }

  build() {
    Navigation(this.pageInfo) {
      HomeView({ mainWindowInfo: this.windowUtil?.mainWindowInfo })
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
