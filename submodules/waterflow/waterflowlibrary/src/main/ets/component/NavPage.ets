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

import { CommonConstants } from '../common/constants/CommonConstants';
import DataModel from '../model/DataModel';
import { GoodsDetailComponent } from '../view/GoodsDetailComponent';
import { GoodsNavComponent } from '../view/GoodsNavComponent';
import ToolBarData from '../model/ToolBarData';

@Extend(Navigation)
function setNavStyle() {
  .hideTitleBar(true)
  .width(CommonConstants.FULL_WIDTH)
  .height(CommonConstants.FULL_HEIGHT)
  .mode(NavigationMode.Stack)
}

@Component
export struct NavPage {
  @Provide(CommonConstants.AS_KEY_SUB_PATH_STACK) pageInfos: NavPathStack = new NavPathStack();
  @State toolBarConfigs: ToolBarData[] = []; // bottom navigation data.

  aboutToAppear() {
    this.toolBarConfigs = DataModel.TOOL_BAR;
  }

  @Builder
  PagesMap(name: string, _: number) {
    if (name === 'GoodsDetailComponent') {
      GoodsDetailComponent()
    }
  }

  build() {
    NavDestination() {
      Navigation(this.pageInfos) {
        GoodsNavComponent()
      }
      .backgroundColor($r('sys.color.gray_01'))
      .setNavStyle()
      .navDestination(this.PagesMap)
    }
    .hideTitleBar(true)
  }
}