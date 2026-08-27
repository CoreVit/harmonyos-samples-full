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
import { CommonConstants, WindowUtil } from 'financialbase';
import { BuyPanel } from 'investment';

@ComponentV2
export struct BuyPage {
  @Local windowUtil: WindowUtil = AppStorageV2.connect(WindowUtil, CommonConstants.WINDOW_UTIL_KEY)!;
  @Consumer('navPathStack') navPathStack: NavPathStack = new NavPathStack();
  @Consumer('navigationMode') navigationMode: NavigationMode = NavigationMode.Stack;

  build() {
    NavDestination() {
      BuyPanel({
        radius: [8, 4, 8],
        onClose: () => {
          this.navigationMode = NavigationMode.Stack;
          if (this.navPathStack.size() > 0) {
            this.navPathStack.pop()
          }
        }
      })
    }
    .safeAreaPadding({
      top: this.windowUtil.mainWindowInfo.titleButtonRect?.height ?? 0,
    })
    .hideTitleBar(true)
  }
}