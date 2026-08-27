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

import { avSession } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo } from '@kit.CoreFileKit';
import { media } from '@kit.MediaKit';
import { CommonConstants } from '../common/constants/CommonConstants';
import { getPixmapFromMedia } from '../common/utils/ImageUtil';
import Logger from '../common/utils/Logger';
import { VideoData } from '../model/VideoData';

const TAG = '[AVCastController]';

@Observed
export class AVCastController {
  @Track public state: avSession.PlaybackState = avSession.PlaybackState.PLAYBACK_STATE_INITIAL;
  @Track public elapsedTime: number = 0;
  @Track public duration: number = 0;
  @Track public volume: number = 0;
  @Track public maxVolume: number = 0;
  @Track public castIndex: number = -1;
  public avCastController: avSession.AVCastController;
  private videoDataArray: VideoData[] = [];
  private videoType: string = '';
  private imgPixel?: PixelMap;

  constructor(avCastController: avSession.AVCastController) {
    this.avCastController = avCastController;
  }

  /**
   * Sets and casts the specified video resource for playback.
   * @param videoIndex Index of the video in videoDataArray.
   * @param startPosition Starting position for playback in milliseconds.
   */
  async setCastResource(videoIndex: number, startPosition: number) {
    if (videoIndex < 0 || videoIndex >= this.videoDataArray.length) {
      Logger.error(TAG, `Invalid videoIndex: ${videoIndex}, array length: ${this.videoDataArray.length}`);
      return;
    }
    this.imgPixel?.release()
    this.imgPixel = await getPixmapFromMedia(this.videoDataArray[videoIndex].head);
    this.castIndex = videoIndex;
    if (this.videoType === 'network') {
      this.handleNetworkResource(videoIndex, startPosition);
    } else {
      this.handleLocalResource(videoIndex, startPosition);
    }
  }

  async handleNetworkResource(videoIndex: number, startPosition: number) {
    try {
      let playItem: avSession.AVQueueItem = {
        itemId: videoIndex,
        description: {
          assetId: 'VIDEO-' + JSON.stringify(videoIndex),
          title: this.videoDataArray[videoIndex].name,
          artist: 'ExampleArtist11',
          mediaUri: this.videoDataArray[videoIndex].url as string,
          mediaType: 'VIDEO',
          mediaImage: this.imgPixel,
          mediaSize: 1000,
          startPosition: startPosition,
          duration: this.videoDataArray[videoIndex].duration
        }
      };
      await this.avCastController.prepare(playItem);
      await this.avCastController.start(playItem);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `handleNetworkResource failed, cause: ${err.code}, ${err.message}`);
    }
  }

  async handleLocalResource(videoIndex: number, startPosition: number) {
    const uiContext: UIContext = AppStorage.get<UIContext>(CommonConstants.KEY_PREFIX + 'UiContext')!;
    let file: fileIo.File | undefined;
    try {
      file = await fileIo.open(uiContext?.getHostContext()?.filesDir + '/' + this.videoDataArray[videoIndex].url);
      let avFileDescriptor: media.AVFileDescriptor = { fd: file.fd };
      let playItem: avSession.AVQueueItem = {
        itemId: videoIndex,
        description: {
          assetId: 'VIDEO-' + JSON.stringify(videoIndex),
          title: this.videoDataArray[videoIndex].name,
          subtitle: 'video',
          mediaType: 'VIDEO',
          mediaImage: this.imgPixel,
          fdSrc: avFileDescriptor,
          startPosition: startPosition,
          duration: this.videoDataArray[videoIndex].duration
        }
      };
      await this.avCastController.prepare(playItem);
      await this.avCastController.start(playItem);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `open file, error code: ${err.code}, message: ${err.message}`);
    } finally {
      if (file) {
        try {
          fileIo.closeSync(file.fd);
        } catch (error) {
          const err: BusinessError = error as BusinessError;
          Logger.error(TAG, `close file failed, cause: ${err.code}, ${err.message}`);
        }
      }
    }
  }

  /**
   * Initializes AV casting session with specified video data.
   * @param videoDataArray Array of video data objects.
   * @param videoIndex Initial video index to play.
   * @param videoType Type of video source ('network' or 'local').
   * @param startPosition Initial playback position in milliseconds.
   */
  public async initAVCast(videoDataArray: VideoData[], videoIndex: number, videoType: string, startPosition: number) {
    try {
      this.videoDataArray = videoDataArray;
      this.videoType = videoType;
      this.castIndex = videoIndex;
      await this.setCastResource(videoIndex, startPosition);
      let currentItem = await this.avCastController.getCurrentItem();
      this.duration = currentItem.description!.duration!;
      this.setAVCastCallback();
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `initAVCast failed, cause: ${err.code}, ${err.message}`);
    }
  }

  /**
   * Sets up AV cast playback state change callbacks.
   * Handles playback completion, position updates, volume changes and errors.
   */
  setAVCastCallback() {
    try {
      this.avCastController.on('playbackStateChange', ['state'], async (playbackState: avSession.AVPlaybackState) => {
        if (playbackState.state) {
          this.state = playbackState.state;
        }
      });
      this.avCastController.on('playbackStateChange', ['position'], (playbackState: avSession.AVPlaybackState) => {
        if (playbackState.position) {
          this.elapsedTime = playbackState.position.elapsedTime;
        }
      });
      this.avCastController.on('playbackStateChange', ['volume'], (playbackState: avSession.AVPlaybackState) => {
        if (playbackState.volume) {
          this.volume = playbackState.volume;
        }
      });
      this.avCastController.on('playbackStateChange', ['maxVolume'], (playbackState: avSession.AVPlaybackState) => {
        if (playbackState.maxVolume) {
          this.maxVolume = playbackState.maxVolume;
        }
      });
      this.avCastController.on('playbackStateChange', ['speed'], (playbackState: avSession.AVPlaybackState) => {
        if (playbackState.speed) {
          AppStorage.setOrCreate(CommonConstants.KEY_PREFIX + 'CastSpeed', playbackState.speed);
        }
      });
      this.avCastController.on('playNext', async () => {
        if (this.castIndex < this.videoDataArray.length - 1) {
          this.castIndex = this.castIndex + 1;
        } else {
          this.castIndex = 0;
        }
      });
      this.avCastController.on('endOfStream', async () => {
        if (this.castIndex < this.videoDataArray.length - 1) {
          this.castIndex = this.castIndex + 1;
        } else {
          this.castIndex = 0;
        }
      });
      this.avCastController.on('error', (error: BusinessError) => {
        Logger.error(TAG, `error happened, error code: ${error.code}, error message : ${error.message}.`);
      })
      this.avCastController.on('playbackStateChange', 'all', (playbackState: avSession.AVPlaybackState) => {
        Logger.info(TAG, `playbackStateChange state ${playbackState}`);
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `setAVCastCallback failed, cause: ${err.code}, ${err.message}`);
    }
  }

  public async setAVCastPlay() {
    let avCommand: avSession.AVCastControlCommand = { command: 'play' };
    try {
      await this.avCastController.sendControlCommand(avCommand);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `setAVCastPlay failed, cause: ${err.code}, ${err.message}`);
    }
  }

  public async setAVCastPause() {
    let avCommand: avSession.AVCastControlCommand = { command: 'pause' };
    try {
      await this.avCastController.sendControlCommand(avCommand);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `setAVCastPause failed, cause: ${err.code}, ${err.message}`);
    }
  }

  /**
   * Sends fast forward command to AV cast controller.
   * Fast forwards playback by 15 seconds.
   */
  public async setAVCastFastForward() {
    let avCommand: avSession.AVCastControlCommand = { command: 'fastForward', parameter: 15 };
    try {
      await this.avCastController.sendControlCommand(avCommand);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `setAVCastFastForward failed, cause: ${err.code}, ${err.message}`);
    }
  }

  /**
   * Sends rewind command to AV cast controller.
   * Rewinds playback by 15 seconds.
   */
  public async setAVCastRewind() {
    let avCommand: avSession.AVCastControlCommand = { command: 'rewind', parameter: 15 };
    try {
      await this.avCastController.sendControlCommand(avCommand);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `setAVCastRewind failed, cause: ${err.code}, ${err.message}`);
    }
  }

  public async setAVCastSeek(timeMS: number) {
    let avCommand: avSession.AVCastControlCommand = { command: 'seek', parameter: timeMS };
    try {
      await this.avCastController.sendControlCommand(avCommand);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `setAVCastSeek failed, cause: ${err.code}, ${err.message}`);
    }
  }

  public async setAVCastVolume(volume: number) {
    let avCommand: avSession.AVCastControlCommand = { command: 'setVolume', parameter: volume };
    try {
      await this.avCastController.sendControlCommand(avCommand);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `setAVCastVolume failed, cause: ${err.code}, ${err.message}`);
    }
  }

  public async setAVCastSpeed(speed: media.PlaybackSpeed) {
    let avCommand: avSession.AVCastControlCommand = { command: 'setSpeed', parameter: speed };
    try {
      await this.avCastController.sendControlCommand(avCommand);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `setAVCastSpeed failed, cause: ${err.code}, ${err.message}`);
    }
  }

  /**
   * Releases AV cast controller resources and removes event listeners.
   */
  public async releaseAVCast() {
    try {
      this.avCastController.off('playbackStateChange');
      this.avCastController.off('playNext');
      this.avCastController.off('endOfStream');
      this.avCastController.off('error');
      this.imgPixel?.release();
      await this.avCastController.release();
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `releaseAVCast failed, cause: ${err.code}, ${err.message}`);
    }
  }
}