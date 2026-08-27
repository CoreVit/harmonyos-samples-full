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

import { AudioNameTag, CommonConstants } from '../../../common/constants/CommonConstants';
import Logger from '../../../common/util/Logger';
import { AudioPlayItem } from './AudioPlayItem';
import { AVSessionController } from '../../../common/util/AVSessionController';
import { AudioItem } from '../viewModel/AudioItem';

@Builder
export function MultiAudioStreamPlayScenePageBuilder() {
  MultiAudioStreamPlayScene()
}

const TAG = 'MultiAudioStreamPlayScene'

// [Start MultiAudioStreamPlayScene]
@Component
struct MultiAudioStreamPlayScene {
  private avSessionController: AVSessionController = new AVSessionController();
  // Instantiate three audio streams,
  // with each AudioRender instance independently controlling the rendering of one audio stream.
  @State audioItems: AudioItem[] =
    [new AudioItem($r('app.media.ic_avatar12'), AudioNameTag.FIRST_SONG_NAME + CommonConstants.AUDIO_TYPE, false,
      AudioNameTag.FIRST_SONG_NAME, this.avSessionController),
      new AudioItem($r('app.media.ic_avatar13'), AudioNameTag.SECOND_SONG_NAME + CommonConstants.AUDIO_TYPE, false,
        AudioNameTag.SECOND_SONG_NAME, this.avSessionController),
      new AudioItem($r('app.media.ic_avatar14'), AudioNameTag.THIRD_SONG_NAME + CommonConstants.AUDIO_TYPE, false,
        AudioNameTag.THIRD_SONG_NAME, this.avSessionController)]
  // [StartExclude MultiAudioStreamPlayScene]
  @StorageLink(AudioNameTag.FIRST_SONG_NAME) @Watch('isFirstPlayingChange') isFirstPlaying: boolean | undefined =
    AppStorage.get(AudioNameTag.FIRST_SONG_NAME);
  @StorageLink(AudioNameTag.SECOND_SONG_NAME) @Watch('isSecondPlayingChange') isSecondPlaying: boolean | undefined =
    AppStorage.get(AudioNameTag.SECOND_SONG_NAME);
  @StorageLink(AudioNameTag.THIRD_SONG_NAME) @Watch('isThirdPlayingChange') isThirdPlaying: boolean | undefined =
    AppStorage.get(AudioNameTag.THIRD_SONG_NAME);
  @StorageLink(CommonConstants.KEY_IS_CHANGE_PADDING) isChangePadding: boolean = false;

  async aboutToDisappear() {
    this.avSessionController.avSessionRelease()
  }

  isFirstPlayingChange() {
    Logger.info(TAG, `isFirstPlayingChange curPlaying is:${this.isFirstPlaying}`)
    this.avSessionController.registerSessionListener(this.audioItems[0].audioRenderController!)
    if (this.isFirstPlaying) {
      this.audioItems[0].isPlaying = true;
    } else {
      this.audioItems[0].isPlaying = false;
    }
  }

  isSecondPlayingChange() {
    Logger.info(TAG, `isSecondPlayingChange curPlaying is:${this.isSecondPlayingChange}`)
    this.avSessionController.registerSessionListener(this.audioItems[1].audioRenderController!)
    if (this.isSecondPlaying) {
      this.audioItems[1].isPlaying = true;
    } else {
      this.audioItems[1].isPlaying = false;
    }
  }

  isThirdPlayingChange() {
    this.avSessionController.registerSessionListener(this.audioItems[2].audioRenderController!)
    Logger.info(TAG, `isThirdPlayingChange curPlaying is:${this.isThirdPlayingChange}`)
    if (this.isThirdPlaying) {
      this.audioItems[2].isPlaying = true;
    } else {
      this.audioItems[2].isPlaying = false;
    }
  }

  build() {
    NavDestination() {
      Scroll() {
        GridRow({
          gutter: 12,
          columns: {
            xs: 1,
            sm: 1,
            md: 2,
            lg: 2,
            xl: 2
          },
          breakpoints: {
            value: ['320vp', '600vp', '840vp', '1440vp', '1600vp'],
            reference: BreakpointsReference.WindowSize
          }
        }) {
          ForEach(this.audioItems, (audioItem: AudioItem) => {
            GridCol({ span: 1 }) {
              AudioPlayItem({ audioItem: audioItem })
            }
          })
        }
        .padding({ bottom: 16 })
        .margin({
          left: this.isChangePadding ? 24 : $r('app.float.size_16'),
          right: this.isChangePadding ? 24 : $r('app.float.size_16')
        })
      }
      .scrollBar(BarState.Off)
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .title($r('app.string.multi_audio_stream_play_scene'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }

  // [EndExclude MultiAudioStreamPlayScene]
}

// [End MultiAudioStreamPlayScene]