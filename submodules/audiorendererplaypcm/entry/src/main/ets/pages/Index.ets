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

import { AppStorageKeyConstants } from '../common/constants/AppStorageKeyConstants';
import Logger from '../common/utils/Logger';
import { MediaControlCenter } from '../common/utils/mediautils/MediaControlCenter';
import { WindowUtil } from '../common/utils/WindowUtil';
import { PlayerInfoComponent } from '../view/PlayerInfoComponent';

const TAG = '[Index]';

@Entry
@Component
struct Index {
  @StorageLink(AppStorageKeyConstants.KEY_TOP_HEIGHT) topHeight: number = 0;
  @StorageLink(AppStorageKeyConstants.KEY_BOTTOM_HEIGHT) bottomHeight: number = 0;
  @State isShowPlay: boolean = false;
  @StorageLink(AppStorageKeyConstants.KEY_WINDOW_UTIL) windowUtil: WindowUtil | undefined =
    undefined;

  async aboutToAppear() {
    try {
      await MediaControlCenter.getInstance().init();
    } catch (error) {
      Logger.info(TAG, `getInstance failed: ${error}`)
    }
  }

  aboutToDisappear(): void {
    Logger.info(TAG, 'AudioRenderScene')
    MediaControlCenter.getInstance().release();
  }

  build() {
    Stack() {
      PlayerInfoComponent({ isShowPlay: this.isShowPlay, mainWindowInfo: this.windowUtil?.mainWindowInfo });
    }

  }
}

