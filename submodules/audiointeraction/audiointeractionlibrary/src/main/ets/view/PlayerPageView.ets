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
import { AudioRendererController } from '../audiohelper/AudioRendererController';
import { KeyConstants } from '../common/constants/KeyConstants';
import { PlayerInfoComponent } from '../components/PlayerInfoComponent';
import { songList } from '../datasource/SongListData';

@Builder
export function PlayerPageBuilder() {
  PlayerPageView();
}

@Component
struct PlayerPageView {
  @State isShowPlay: boolean = false;

  aboutToAppear(): void {
    AppStorage.setOrCreate(KeyConstants.KEY_SONG_LIST, songList);
    AudioRendererController.getInstance();
  }

  aboutToDisappear(): void {
    AudioRendererController.getInstance().release();
    AppStorage.delete(KeyConstants.KEY_BREAKPOINT);
    AppStorage.delete(KeyConstants.KEY_IS_PLAY);
    AppStorage.delete(KeyConstants.KEY_CURRENT_TIME);
    AppStorage.delete(KeyConstants.KEY_TOTAL_TIME);
    AppStorage.delete(KeyConstants.KEY_PROGRESS);
    AppStorage.delete(KeyConstants.KEY_PROGRESS_MAX);
    AppStorage.delete(KeyConstants.KEY_PAGE_SHOW_TIME);
    AppStorage.delete(KeyConstants.KEY_SONG_LIST);
    AppStorage.delete(KeyConstants.KEY_PLAY_MODE);
    AppStorage.delete(KeyConstants.KEY_SELECT_INDEX);
    AppStorage.delete(KeyConstants.KEY_IS_FAVORITE);
    AppStorage.delete(KeyConstants.KEY_IS_SILENT_MODE);
    AppStorage.delete(KeyConstants.KEY_IMAGE_COLOR);
    AppStorage.delete(KeyConstants.KEY_STATUS_BAR_HEIGHT);
    AppStorage.delete(KeyConstants.KEY_NAV_INDICATOR_HEIGHT);
    AppStorage.delete(KeyConstants.KEY_IS_FOLD_FULL);
    AppStorage.delete(KeyConstants.KEY_SYS_LANGUAGE);
    AppStorage.delete(KeyConstants.KEY_UI_CONTEXT);
    AppStorage.delete(KeyConstants.KEY_AUDIO_RENDER_CONTROLLER);
    AppStorage.delete(KeyConstants.KEY_TOTAL_MS_TIME);
    AppStorage.delete(KeyConstants.KEY_TOTAL_BYTE_LEN);
    AppStorage.delete(KeyConstants.KEY_AV_SESSION_CONTROLLER);
  }

  build() {
    NavDestination() {
      PlayerInfoComponent({ isShowPlay: this.isShowPlay });
    }
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
    .hideTitleBar(true)
  }
}