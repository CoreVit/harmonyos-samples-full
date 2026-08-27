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

import { CustomButton } from '../../../component/CustomButton';
import { AppRouter } from '../../../common/util/AppRouter';

const TAG = '[MutePlayback]';

@Builder
export function MutePlaybackPageBuilder() {
  MutePlaybackPage()
}

@Component
export struct MutePlaybackPage {
  build() {
    NavDestination() {
      GridRow({
        gutter: 12,
        columns: {
          xs: 1,
          sm: 1,
          md: 1,
          lg: 2,
          xl: 2
        },
        breakpoints: {
          value: ['320vp', '600vp', '840vp', '1440vp', '1600vp'],
          reference: BreakpointsReference.WindowSize
        }
      }) {
        GridCol() {
          CustomButton({
            buttonName: $r('app.string.audio_render_mute_playback'),
            buttonOnClick: () => {
              AppRouter.pushByName('audioRenderMutePlaybackPage', null)
            }
          })
        }
        GridCol() {
          CustomButton({
            buttonName: $r('app.string.av_player_mute_playback'),
            buttonOnClick: () => {
              AppRouter.pushByName('aVPlayerMutePlayback', null)
            }
          })
        }
      }
      .padding({ left: 16, right: 16 })
      .width('100%')
      .height('100%')
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .title($r('app.string.mute_playback'))
  }
}