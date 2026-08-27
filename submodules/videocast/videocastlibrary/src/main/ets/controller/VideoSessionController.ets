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

import { common, wantAgent } from '@kit.AbilityKit';
import { avSession } from '@kit.AVSessionKit';
import { media } from '@kit.MediaKit';
import { BackgroundTaskManager } from '../common/utils/BackgroundTaskManager';
import { getPixmapFromMedia } from '../common/utils/ImageUtil';
import Logger from '../common/utils/Logger';
import { VideoData } from '../model/VideoData';
import { VideoPlayerController } from './VideoPlayerController';
import type { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = '[VideoSessionController]';

export class VideoSessionController {
  @Track public deviceName: string = '';
  @Track public connectionState: avSession.ConnectionState = avSession.ConnectionState.STATE_DISCONNECTED;
  public videoSession: avSession.AVSession;
  private imgPixel?: PixelMap;

  private constructor(videoSession: avSession.AVSession) {
    this.videoSession = videoSession;
  }

  /**
   * Creates and activates a new AVSession for video playback.
   * @param context The UIAbility context for session creation.
   * @returns Promise<AVSessionController> Initialized session controller instance.
   */
  static async create(context: common.UIAbilityContext) {
    try {
      let videoSession = await avSession.createAVSession(context, 'VIDEO_CAST_SESSION', 'video');
      // Set up a background task.
      BackgroundTaskManager.startContinuousTask(context);
      const wantAgentInfo: wantAgent.WantAgentInfo = {
        wants: [
          {
            bundleName: context.abilityInfo.bundleName,
            abilityName: context.abilityInfo.name
          }
        ],
        actionType: wantAgent.OperationType.START_ABILITIES,
        requestCode: 0,
        wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
      };
      let agent = wantAgent.getWantAgent(wantAgentInfo);
      await videoSession.setLaunchAbility(agent);
      await videoSession.activate();
      return new VideoSessionController(videoSession);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `create session failed: code: ${err.code}, meeeage: ${err.message}`);
    }
    return undefined;
  }

  /**
   * Sets metadata for the current video session.
   * @param curSource Video data containing index, name and head image.
   * @param duration Total duration of the video in milliseconds.
   */
  public async setAVMetadata(curSource: VideoData, duration: number) {
    if (!curSource) {
      Logger.error(TAG, 'setAVMetadata failed: curSource is null or undefined');
      return;
    }
    this.imgPixel?.release()
    this.imgPixel = await getPixmapFromMedia(curSource.head);
    let metadata: avSession.AVMetadata = {
      assetId: `${curSource.index}`,
      title: curSource.name,
      mediaImage: this.imgPixel,
      duration: duration,
      filter: avSession.ProtocolType.TYPE_DLNA | avSession.ProtocolType.TYPE_CAST_PLUS_STREAM
    };
    try {
      await this.videoSession.setAVMetadata(metadata);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `setAVMetadata failed: code: ${err.code}, meeeage: ${err.message}`);
    }
  }

  /**
   * Initializes AV session playback state from player controller.
   * @param avPlayerController The player controller providing playback state.
   */
  public initAvSessionPlayState(avPlayerController: VideoPlayerController) {
    this.videoSession.setAVPlaybackState({
      state: avPlayerController.state === 'playing' ? avSession.PlaybackState.PLAYBACK_STATE_PLAY :
      avSession.PlaybackState.PLAYBACK_STATE_PAUSE,
      position: {
        elapsedTime: avPlayerController.currentTime,
        updateTime: new Date().getTime(),
      },
      speed: 1.0,
      bufferedTime: 14000,
      duration: avPlayerController.durationTime
    }).catch((err: BusinessError) => {
      Logger.error(TAG, `setAVPlaybackState failed: code: ${err.code}, meeeage: ${err.message}`);
    });
  }

  /**
   * Updates AV session playback state.
   * @param state Current player state ('playing' or other).
   */
  public async setAvSessionState(state: string) {
    try {
      await this.videoSession.setAVPlaybackState({
        state: state === 'playing' ? avSession.PlaybackState.PLAYBACK_STATE_PLAY :
          avSession.PlaybackState.PLAYBACK_STATE_PAUSE,
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `setAvSessionState failed: code: ${err.code}, meeeage: ${err.message}`);
    }
  }

  /**
   * Updates playback speed in AV session.
   * @param speed The current playback speed (1.0 = normal speed).
   */
  public async setAvSessionSpeed(speed: number) {
    try {
      await this.videoSession.setAVPlaybackState({
        speed: speed
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `setAvSessionSpeed failed: code: ${err.code}, meeeage: ${err.message}`);
    }
  }

  /**
   * Updates playback position in AV session.
   * @param position Current playback position in milliseconds.
   */
  public async setAvSessionPosition(position: number) {
    try {
      await this.videoSession.setAVPlaybackState({
        position: {
          elapsedTime: position,
          updateTime: new Date().getTime()
        }
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `setAvSessionPosition failed: code: ${err.code}, meeeage: ${err.message}`);
    }
  }

  public async stopCasting() {
    try {
      await this.videoSession.stopCasting();
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `stopCasting failed: code: ${err.code}, meeeage: ${err.message}`);
    }
  }

  /**
   * Sets up AV session event listeners for playback control.
   * Handles play/pause/stop commands, seeking, fast forward/rewind, and device changes.
   * @param avPlayerController The player controller to manage playback.
   */
  public async setAvSessionListener(avPlayerController: VideoPlayerController) {
    try {
      this.videoSession.on('play', () => avPlayerController.setAVPlayerPlaying());
      this.videoSession.on('pause', () => avPlayerController.setAVPlayerPause());
      this.videoSession.on('stop', () => avPlayerController.setAVPlayerPause());
      this.videoSession.on('seek', (time: number) => {
        avPlayerController.avPlayerSeek(time, media.SeekMode.SEEK_CLOSEST);
      });
      this.videoSession.on('fastForward', (time?: number) => {
        if (time) {
          let forwardTime: number = avPlayerController.currentTime + time * 1000;
          if (forwardTime > avPlayerController.durationTime) {
            forwardTime = avPlayerController.durationTime;
          }
          avPlayerController.avPlayerSeek(forwardTime, media.SeekMode.SEEK_NEXT_SYNC);
        }
      });
      this.videoSession.on('rewind', (time?: number) => {
        if (time) {
          let rewindTime = avPlayerController.currentTime - time * 1000;
          if (rewindTime < 0) {
            rewindTime = 0;
          }
          avPlayerController.avPlayerSeek(rewindTime, media.SeekMode.SEEK_PREV_SYNC);
        }
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `setAvSessionListener failed: code: ${err.code}, meeeage: ${err.message}`);
    }
  }

  public releaseAvSessionListener() {
    try {
      this.videoSession.off('play');
      this.videoSession.off('pause');
      this.videoSession.off('stop');
      this.videoSession.off('playNext');
      this.videoSession.off('setLoopMode');
      this.videoSession.off('seek');
      this.videoSession.off('fastForward');
      this.videoSession.off('rewind');
      this.videoSession.off('outputDeviceChange');
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `releaseAvSessionListener failed: code: ${err.code}, meeeage: ${err.message}`);
    }
  }

  /**
   * Releases AV session resources and removes all listeners.
   * @param context The UIAbility context for cleanup tasks.
   */
  public async destroyAvSessionListener(context: common.UIAbilityContext) {
    try {
      this.releaseAvSessionListener();
      this.imgPixel?.release();
      await BackgroundTaskManager.stopContinuousTask(context);
      await this.videoSession.stopCasting();
      await this.videoSession.destroy();
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `destroyAvSessionListener failed: code: ${err.code}, meeeage: ${err.message}`);
    }
  }
}