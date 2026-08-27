/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { media } from '@kit.MediaKit';
import { CommonConstants } from '../common/constants/CommonConstants';
import Logger from '../common/utils/Logger';

const TAG = '[AVPlayerController]';

@Observed
export class VideoPlayerController {
  @Track public state: string = 'default';
  @Track public durationTime: number = 0;
  @Track public currentTime: number = 0;
  @Track public volume: number = 0.5;
  @Track public speed: number = 1.0;
  private avPlayer: media.AVPlayer;
  private surfaceID: string;
  private stateChangeListeners: Array<(newState: string, oldState: string) => void> = [];
  private speedChangeListeners: Array<(newSpeed: number) => void> = [];
  private positionChangeListeners: Array<(newPosition: number) => void> = [];
  private fd?: number;

  private constructor(avPlayer: media.AVPlayer, surfaceID: string) {
    this.surfaceID = surfaceID;
    this.avPlayer = avPlayer;
  }

  /**
   * Creates and initializes an AVPlayerController instance.
   * @param surfaceID The surface ID for video rendering.
   * @param videoType The type of video source ('network' or 'local').
   * @param resource The video resource URL or file path.
   * @returns Promise<AVPlayerController> Initialized player controller instance.
   */
  static async create(surfaceID: string, videoType: string, resource: string) {
    try {
      const avPlayer = await media.createAVPlayer();
      let avPlayerController = new VideoPlayerController(avPlayer, surfaceID);
      if (videoType === 'network') {
        await avPlayerController.avPlayerNetUrl(resource);
      } else {
        await avPlayerController.avPlayerLocal(resource);
      }
      return avPlayerController;
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `create videoPlayerController failed, cause: ${err.code}, ${err.message}`);
      return undefined;
    }
  }

  /**
   * Sets up AVPlayer event listeners and state change handlers.
   * Handles time updates, duration changes, speed adjustments, volume changes, errors and state transitions.
   */
  setAVPlayerCallback() {
    this.avPlayer.on('timeUpdate', (currentTime: number) => {
      this.currentTime = currentTime;
    })
    this.avPlayer.on('durationUpdate', (duration: number) => {
      this.durationTime = duration;
    })
    this.avPlayer.on('speedDone', (speed: number) => {
      this.speed = speed;
      this.speedChangeListeners.forEach(listener => listener(speed));
    })
    this.avPlayer.on('error', (err: BusinessError) => {
      Logger.error(TAG, `Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`);
      this.avPlayer.reset().catch((err: BusinessError) => {
        Logger.error(TAG, `reset avPlayer failed, code is ${err.code}, message is ${err.message}`);
      });
    });
    this.avPlayer.on('volumeChange', (vol: number) => {
      this.volume = vol;
      Logger.info(TAG, `AVPlayer volumeChange succeeded, seek time is ${vol}`);
    })
    // State machine change callback function
    this.avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      this.stateChangeListeners.forEach(listener => listener(state, this.state));
      this.state = state;
      switch (state) {
        case 'idle':
          Logger.info(TAG, 'AVPlayer state idle called.');
          break;
        // Automatically call prepare after initialization.
        case 'initialized':
          Logger.info(TAG, 'AVPlayer state initialized called.');
          this.avPlayer.surfaceId = this.surfaceID;
          this.avPlayer.prepare().catch((err: BusinessError) => {
            Logger.error(TAG, `prepare avPlayer failed, code is ${err.code}, message is ${err.message}`);
          });
          break;
        // Automatically start playing after the prepare call succeeds.
        case 'prepared':
          Logger.info(TAG, 'AVPlayer state prepared called.');
          this.setAVPlayerVolume(this.volume);
          this.avPlayer.play().catch((err: BusinessError) => {
            Logger.error(TAG, `play avPlayer failed, code is ${err.code}, message is ${err.message}`);
          });
          break;
        case 'playing':
          Logger.info(TAG, 'AVPlayer state playing called.');
          break;
        case 'paused':
          Logger.info(TAG, 'AVPlayer state paused called.');
          break;
        case 'completed':
          Logger.info(TAG, 'AVPlayer state completed called.');
          this.avPlayer.stop().catch((err: BusinessError) => {
            Logger.error(TAG, `stop avPlayer failed, code is ${err.code}, message is ${err.message}`);
          });
          break;
        case 'stopped':
          Logger.info(TAG, 'AVPlayer state stopped called.');
          this.avPlayer.reset().catch((err: BusinessError) => {
            Logger.error(TAG, `reset avPlayer failed, code is ${err.code}, message is ${err.message}`);
          });;
          break;
        case 'released':
          Logger.info(TAG, 'AVPlayer state released called.');
          break;
        case 'error':
          Logger.info(TAG, 'AVPlayer state error called');
          break;
        default:
          Logger.info(TAG, 'AVPlayer state unknown called.');
          break;
      }
    });
  }

  /**
   * Configures AVPlayer for network URL playback.
   * @param netAddress The network URL of the media resource.
   */
  async avPlayerNetUrl(netAddress: string) {
    this.setAVPlayerCallback();
    this.avPlayer.url = netAddress;
  }

  /**
   * Configures AVPlayer for local file playback.
   * @param fileName The name/path of the local media file.
   */
  async avPlayerLocal(fileName: string) {
    try {
      this.setAVPlayerCallback();
      let fdPath = 'fd://';
      const uiContext: UIContext = AppStorage.get<UIContext>(CommonConstants.KEY_PREFIX + 'UiContext')!;
      let pathDir = uiContext?.getHostContext()?.filesDir;
      let path = pathDir + '/' + fileName;
      let file = await fs.open(path);
      fdPath = fdPath + '' + file.fd;
      this.fd = file.fd;
      this.avPlayer.url = fdPath;
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Close file error, code: ${err.code}, message: ${err.message}`)
    }
  }

  /**
   * Seeks to specified position in current media.
   * @param timeMs Target position in milliseconds.
   * @param mode Seeking mode (e.g., SEEK_PREV_SYNC).
   */
  async avPlayerSeek(timeMs: number, mode: media.SeekMode) {
    const validSeekStates = ['prepared', 'playing', 'paused', 'completed'];
    if (!validSeekStates.includes(this.state)) {
      Logger.error(TAG, `avPlayerSeek error,this state is ${this.state}`);
      return;
    }
    this.avPlayer.seek(timeMs, mode);
    this.positionChangeListeners.forEach(listener => listener(timeMs));
  }

  async setAVPlayerPlaying() {
    const validPlayingStates = ['prepared', 'paused', 'completed'];
    if (validPlayingStates.includes(this.state)) {
      try {
        await this.avPlayer.play();
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        Logger.error(TAG, `setAVPlayerPlaying failed, cause: ${err.code}, ${err.message}`);
      }
      return;
    } else {
      Logger.error(TAG, `setAVPlayerPlaying error,this state is ${this.state}`);
    }
  }

  async setAVPlayerPause() {
    if (this.state === 'playing') {
      try {
        await this.avPlayer.pause();
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        Logger.error(TAG, `setAVPlayerPause failed, cause: ${err.code}, ${err.message}`);
      }
      return;
    }
  }

  async setAVPlayerStop() {
    const validStopStates = ['prepared', 'paused', 'completed', 'playing'];
    if (validStopStates.includes(this.state)) {
      try {
        await this.avPlayer.stop();
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        Logger.error(TAG, `setAVPlayerStop failed, cause: ${err.code}, ${err.message}`);
      }
      return;
    } else {
      Logger.error(TAG, `setAVPlayerStop  error,this state is ${this.state}`);
    }
  }

  /**
   * Sets playback speed for AVPlayer.
   * @param speed The playback speed to set.
   */
  setAVPlayerSpeed(speed: media.PlaybackSpeed) {
    const validStopStates = ['prepared', 'paused', 'completed', 'playing'];
    if (validStopStates.includes(this.state)) {
      this.avPlayer.setSpeed(speed);
      return;
    } else {
      Logger.error(TAG, `setAVPlayerSpeed  error,this state is ${this.state}`);
    }
  }

  /**
   * Sets the volume level for AVPlayer.
   * @param volume The volume level to set.
   */
  setAVPlayerVolume(volume: number) {
    const validStopStates = ['prepared', 'paused', 'completed', 'playing'];
    if (validStopStates.includes(this.state)) {
      this.avPlayer.setVolume(volume);
      return;
    } else {
      Logger.error(TAG, `setAVPlayerVolume error,this state is ${this.state}`);
    }
  }

  /**
   * Registers a callback for player state changes.
   * @param listener Callback function receiving new and old state values.
   */
  onStateChange(listener: (newState: string, oldState: string) => void): void {
    this.stateChangeListeners.push(listener);
  }

  /**
   * Registers a callback for playback speed changes.
   * @param listener Callback function receiving the new speed value.
   */
  onSpeedChange(listener: (newSpeed: number) => void): void {
    this.speedChangeListeners.push(listener);
  }

  /**
   * Registers a callback for playback position changes.
   * @param listener Callback function receiving the new position in milliseconds.
   */
  onPositionChange(listener: (newPosition: number) => void): void {
    this.positionChangeListeners.push(listener);
  }

  offStateChange(listener: (newState: string, oldState: string) => void): void {
    this.stateChangeListeners = this.stateChangeListeners.filter(l => l !== listener);
  }

  offSpeedChange(listener: (newSpeed: number) => void): void {
    this.speedChangeListeners = this.speedChangeListeners.filter(l => l !== listener);
  }

  offPositionChange(listener: (newPosition: number) => void): void {
    this.positionChangeListeners = this.positionChangeListeners.filter(l => l !== listener);
  }

  /**
   * Releases player resources and removes all event listeners.
   * Closes file descriptor if currently playing a file.
   */
  async releasePlayer() {
    try {
      if (this.fd) {
        fs.closeSync(this.fd);
        this.fd = undefined;
      }
      this.avPlayer.off('timeUpdate');
      this.avPlayer.off('durationUpdate');
      this.avPlayer.off('speedDone');
      this.avPlayer.off('error');
      this.avPlayer.off('volumeChange');
      this.avPlayer.off('stateChange');
      await this.avPlayer.release();
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `releasePlayer failed, cause: ${err.code}, ${err.message}`);
    }
  }
}