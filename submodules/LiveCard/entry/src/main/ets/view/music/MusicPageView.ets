/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { Constants } from '../../common/CommonConstants';
import { Logger } from '../../utils/Logger';
import RouterUtil from '../../utils/RouterUtil';
import { WindowInfo, WindowUtil } from '../../utils/WindowUtil';
import { PlayerView } from './PlayerView';

const TAG = 'MusicPageView';

@Builder
export function MusicPageViewBuilder() {
  MusicPageView();
}

@Component
struct MusicPageView {
  @StorageProp(Constants.KEY_WINDOW_UTIL) windowUtil?: WindowUtil = undefined;
  @StorageProp(Constants.KEY_WINDOW_INFO) windowInfo?: WindowInfo = undefined;
  @State imageColor: string = 'rgba(0, 0, 2, 1.00)';

  aboutToAppear(): void {
    Logger.info(TAG, `MusicPageView aboutToAppear success`);
  }

  build() {
    NavDestination() {
      PlayerView({ imageColor: this.imageColor, mainWindowInfo: this.windowInfo })
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .height('100%')
        .width('100%');
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundColor(this.imageColor)
    .hideTitleBar(true)
    .onBackPressed(() => {
      RouterUtil.getInstance().closeApp();
      return false;
    });
  }
}