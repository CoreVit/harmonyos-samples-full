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

import { audio } from '@kit.AudioKit';
import { avSession } from '@kit.AVSessionKit';
import { AudioRenderController } from '../../../common/util/AudioRenderController';
import { AVSessionController } from '../../../common/util/AVSessionController';
import Logger from '../../../common/util/Logger';
import { CommonConstants } from '../../../common/constants/CommonConstants';

const TAG = 'AudioItem';

@Observed
// [Start AudioItem]
export class AudioItem {
  // [StartExclude AudioItem]
  public img: Resource | undefined = undefined;
  public audioUrl: string | undefined = undefined;
  public isPlaying: boolean = false;
  public focusMode: audio.InterruptMode = 0;
  public audioSessionManager: audio.AudioSessionManager | undefined = undefined;
  public avSessionController: AVSessionController | undefined = undefined;
  public tag: string | undefined = undefined;
  // [EndExclude AudioItem]
  public audioRenderController: AudioRenderController | undefined = undefined;

  constructor(img: Resource, audioUrl: string, isPlaying: boolean, tag: string,
    avSessionController: AVSessionController) {
    // [StartExclude AudioItem]
    this.img = img;
    this.audioUrl = audioUrl;
    this.isPlaying = isPlaying;
    this.tag = tag;
    // [EndExclude AudioItem]
    this.audioRenderController = new AudioRenderController(this.tag);
    // [StartExclude AudioItem]
    this.avSessionController = avSessionController;
    this.audioSessionManager = audio.getAudioManager().getSessionManager();
    this.initAVResource();
    // [EndExclude AudioItem]
  }

  // [StartExclude AudioItem]
  async initAVResource() {
    // Create an AVSession instance
    if (!this.avSessionController) {
      return;
    }
    if (!this.audioRenderController) {
      return;
    }
    if (!this.audioUrl) {
      return;
    }
    // Create an instance of AudioRenderer and set the audio stream type to STREAM_USAGE_MUSIC
    await this.audioRenderController.createAndInitAudioRender(this.avSessionController,
      this.audioUrl, audio.StreamUsage.STREAM_USAGE_MUSIC);
  }

  async play() {
    if (this.audioRenderController && this.audioSessionManager) {
      if (this.isPlaying) {
        // Set the audio concurrency mode
        this.audioRenderController.mediaPlay();
      } else {
        this.audioRenderController.mediaPause();
        // Deactivate an audio session
        this.audioSessionManager.deactivateAudioSession().catch(() => {
          Logger.error('deactivateAudioSession fail');
        }).then(() => {
          Logger.info('deactivateAudioSession SUCCESS');
        });
      }
    }
  }
  // [EndExclude AudioItem]
}
// [End AudioItem]