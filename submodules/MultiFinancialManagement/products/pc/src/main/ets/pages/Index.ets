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

import { AppStorageV2 } from '@kit.ArkUI';
import { HdsNavigation, HdsNavigationTitleMode } from '@kit.UIDesignKit';
import { CommonConstants, WindowUtil } from 'financialbase';
import { TabsView } from '../view/TabsView';
import { AssetPage } from './AssetPage';
import { FinancialDetailPage } from './FinancialDetailPage';
import { HomePage } from './HomePage';

@Entry
@ComponentV2
struct Index {
  @Provider('pageStack') pageStack: NavPathStack = new NavPathStack();
  @Local windowUtil: WindowUtil = AppStorageV2.connect(WindowUtil, CommonConstants.WINDOW_UTIL_KEY)!;

  @Builder
  PagesMap(name: string) {
    if (name === CommonConstants.ASSET_PAGE_NAME) {
      AssetPage();
    } else if (name === CommonConstants.FINANCIAL_DETAIL_PAGE_NAME) {
      FinancialDetailPage()
    } else if (name === CommonConstants.HOME_PAGE_NAME) {
      HomePage()
    }
  }

  build() {
    HdsNavigation(this.pageStack) {
      TabsView({ mainWindowInfo: this.windowUtil.mainWindowInfo })
    }
    .mode(NavigationMode.Stack)
    .titleMode(HdsNavigationTitleMode.MINI)
    .navDestination(this.PagesMap)
    .hideNavBar(false)
    .hideTitleBar(true)
  }
}
