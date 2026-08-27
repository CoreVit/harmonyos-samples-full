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

@Component
export struct GoodsDetailComponent {
  @Consume(CommonConstants.AS_KEY_SUB_PATH_STACK) pageInfos: NavPathStack;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;

  build() {
    NavDestination() {
      Column() {
        Text(`${this.pageInfos.getParamByName('GoodsDetailComponent')}`)
          .fontSize($r('app.float.detail_font_size'))
          .height(CommonConstants.FULL_HEIGHT)
          .width(CommonConstants.FULL_WIDTH)
          .textAlign(TextAlign.Center)
      }
      .justifyContent(FlexAlign.Center)
    }
    .padding({
      top: this.statusBarHeight
    })
  }
}
