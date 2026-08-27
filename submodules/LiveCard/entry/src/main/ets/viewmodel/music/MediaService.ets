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

import { common } from '@kit.AbilityKit';
import { Logger } from '../../utils/Logger';
import { SongItem } from '../../model/music/SongItem';
import { AudioPlayerState, MusicPlayMode } from '../../model/music/MusicData';
import { MediaTools } from '../../utils/MediaTools';
import { PlayActionType } from '../../model/common/FormCardConstant';
import { BackgroundUtil } from '../../utils/BackgroundUtil';
import { SongRdbHelper } from '../../database/SongRdbHelper';
import { getSongListData } from './SongListData';
import FormUtils from '../../utils/FormUtils';
import MusicFileStore from '../../database/MusicFileStore';
import { LrcEntry } from '../../lyric/LrcEntry';
import { util } from '@kit.ArkTS';
import { parseLrcLyric } from '../../lyric/LrcUtils';
import { AVPlayerService, PlayerStateData } from './AVPlayerService';
import { AVSessionService } from './AVSessionService';
import SongItemBuilder from './SongItemBuilder';
import { media } from '@kit.MediaKit';
import { Constants } from '../../common/CommonConstants';

const TAG = 'MediaService';

class SongChangedData {
  public isPlay: boolean = false;
  public totalTime: string = '';
  public progressMax: number = 0;
  public selectIndex: number = 0;
  public songItem: SongItem = new SongItem();
}

export class MediaService {
  private static instance: MediaService | undefined;
  private context: common.UIAbilityContext | undefined = undefined;
  private playMode: MusicPlayMode = MusicPlayMode.ORDER;
  private musicIndex: number = 0;
  private songList: SongItem[] = [];
  private songChangedBack?: (data: SongChangedData) => void;
  private songItemBuilder?: SongItemBuilder;
  private timeUpdateCallBack?: (progress: number, updateTimeStr: string) => void;
  private changedData: SongChangedData = new SongChangedData();
  private mLrcEntryList: LrcEntry[] = [];
  private isInitSuccess: boolean = false;
  private isFirstLoadAsset: boolean = true;
  private playerService = AVPlayerService.getInstance();
  private initPromise?: Promise<void>;

  public static getInstance(): MediaService {
    if (!MediaService.instance) {
      MediaService.instance = new MediaService();
    }
    return MediaService.instance;
  }

  public setOnPlayStateCall(callBak: (data: SongChangedData) => void): void {
    this.songChangedBack = callBak;
  }

  public setTimeUpdateCall(callBak: (progress: number, updateTimeStr: string) => void): void {
    this.timeUpdateCallBack = callBak;
  }

  private setCallBackData(isPlay: boolean): void {
    if (this.songChangedBack && this.context) {
      let playerService = AVPlayerService.getInstance();
      this.changedData.songItem = this.songList[this.musicIndex];
      this.changedData.isPlay = isPlay;
      this.changedData.selectIndex = this.musicIndex;
      this.changedData.totalTime = MediaTools.msToCountdownTime(playerService.getDuration());
      this.changedData.progressMax = playerService.getDuration();
      this.songChangedBack(this.changedData);
    }
  }

  /**
   * @throws initPromise error
   * @param context
   * @returns
   */
  async initialize(context: Context): Promise<void> {
    if (this.initPromise) {
      Logger.info(TAG, 'initialize already in progress, await same promise');
      return this.initPromise;
    }
    this.initPromise = this.doInitialize(context);
    try {
      await this.initPromise;
    } catch (e) {
      this.initPromise = undefined;
      Logger.error(TAG, `initialize failed, clear initPromise for retry: ${e.code}, ${e.message}`);
      throw new Error(String(e));
    }
  }

  private async doInitialize(context: Context): Promise<void> {
    Logger.info(TAG, 'initialize');
    this.context = context as common.UIAbilityContext;
    this.songItemBuilder = new SongItemBuilder(this.context);
    let songRdbHelper = SongRdbHelper.getInstance(context);
    let initSongs = getSongListData();
    songRdbHelper.insertSongs(initSongs);
    AppStorage.setOrCreate(Constants.KEY_SONG_LIST, initSongs);

    let currentSong = MusicFileStore.readCurrentSong(context);
    if (!currentSong) {
      currentSong = initSongs[0];
      MusicFileStore.writeCurrentSong(context, currentSong);
    }
    AppStorage.setOrCreate(Constants.KEY_CURRENT_SONG, currentSong);

    this.songList = initSongs;
    const songId = Number.parseInt(currentSong.id);
    if (currentSong && currentSong.id !== '' && !Number.isNaN(songId)) {
      this.musicIndex = songId - 1;
    }
    let playerService = AVPlayerService.getInstance();
    playerService.setContext(this.context);

    let sessionService = AVSessionService.getInstance();
    sessionService.setContext(this.context);

    sessionService.setOnPlayCallback(() => {
      this.play();
    });

    sessionService.setOnPauseCallback(() => {
      this.pause();
    });

    sessionService.setOnPlayNextCallback(() => {
      this.playNext();
    });

    sessionService.setOnPlayPreviousCallback(() => {
      this.playPrevious();
    });

    playerService.setStateChangeCallback((data: PlayerStateData) => {
      this.handlePlayerStateChange(data);
    });

    playerService.setTimeUpdateCallback((currentTime: number, duration: number) => {
      this.handleTimeUpdate(currentTime, duration);
    });

    playerService.setSeekDoneCallback((seekTime: number) => {
      AVSessionService.getInstance().updatePosition(seekTime);
    });

    await sessionService.initialize();

    await this.songItemBuilder.build(currentSong);
    let url = this.songItemBuilder.getRealUrl();
    await playerService.initialize(url);

    let collectedSongList = await songRdbHelper.queryCollectedSongs();
    AppStorage.setOrCreate(Constants.KEY_COLLECTED_SONG_LIST, collectedSongList);

    this.setupCallbacks();
    this.isInitSuccess = true;
    Logger.info(TAG, 'initialize success');
  }

  private handlePlayerStateChange(data: PlayerStateData): void {
    Logger.info(TAG, `handlePlayerStateChange state: ${data.state}, isPrepared: ${data.isPrepared}`);

    switch (data.state) {
      case AudioPlayerState.IDLE:
        if (this.songItemBuilder) {
          this.songItemBuilder.build(this.songList[this.musicIndex]).then(() => {
            if (this.songItemBuilder) {
              let url = this.songItemBuilder.getRealUrl();
              this.playerService.loadAssetByFd(url);
            }
          }).catch((e: BusinessError) => {
            Logger.error(TAG,
              `handlePlayerStateChange songItemBuilder build error, code: ${e.code}, messahe: ${e.message}`)
          });
        }
        break;
      case AudioPlayerState.PLAY:
        this.setCallBackData(true);
        AVSessionService.getInstance().updatePlayState(true, data.currentTime);
        if (!this.isFirstLoadAsset) {
          AVSessionService.getInstance().setMetadata(this.songList[this.musicIndex], data.duration);
        }
        break;
      case AudioPlayerState.PAUSE:
        this.setCallBackData(false);
        AVSessionService.getInstance().updatePlayState(false, data.currentTime);
        break;
      case AudioPlayerState.COMPLETED:
        this.playCompleteAuto();
        break;
      case AudioPlayerState.PREPARED:
        if (!this.isFirstLoadAsset) {
          AVPlayerService.getInstance().play();
          AVSessionService.getInstance().setMetadata(this.songList[this.musicIndex], data.duration);
        }
        break;
      case AudioPlayerState.RELEASED:
        FormUtils.updateCardPlayStatusCached(false);
        Logger.info(TAG, 'handlePlayerStateChange: player released');
        break;
    }
  }

  private handleTimeUpdate(currentTime: number, duration: number): void {
    Logger.info(TAG, `handleTimeUpdate currentTime: ${currentTime} duration: ${duration}}`);
    if (this.timeUpdateCallBack) {
      let updateTimeStr = MediaTools.msToCountdownTime(currentTime);
      this.timeUpdateCallBack(currentTime, updateTimeStr);
    }
  }

  private setupCallbacks(): void {
    this.setOnPlayStateCall(async (data: SongChangedData) => {
      Logger.info(TAG, `SongChangedData index: ${data.selectIndex}`);
      if (!this.context) {
        return;
      }

      AppStorage.setOrCreate(Constants.KEY_TOTAL_TIME, data.totalTime);
      AppStorage.setOrCreate(Constants.KEY_PROGRESS_MAX, data.progressMax);
      AppStorage.setOrCreate(Constants.KEY_IS_PLAY, data.isPlay);
      AppStorage.setOrCreate(Constants.KEY_SELECT_INDEX, data.selectIndex);
      AppStorage.setOrCreate(Constants.KEY_CURRENT_SONG, data.songItem);
      MusicFileStore.writeCurrentSong(this.context, data.songItem);
      FormUtils.updateMusicControlCards(this.context, data.songItem, data.isPlay);

      await this.loadLyric(data.songItem, this.context);

      if (data.isPlay) {
        BackgroundUtil.startContinuousTask(this.context);
      } else {
        BackgroundUtil.stopContinuousTask(this.context);
      }
    });

    this.setTimeUpdateCall((progress: number, updateTimeStr: string) => {
      if (!this.context) {
        return;
      }

      AppStorage.setOrCreate(Constants.KEY_CURRENT_TIME, updateTimeStr);
      AppStorage.setOrCreate(Constants.KEY_PROGRESS, progress);
      Logger.info(TAG, `time update:${updateTimeStr},${progress}`);
    });
  }

  getInitSuccess(): boolean {
    return this.isInitSuccess;
  }

  async initAndPlayByAction(playActionType: PlayActionType): Promise<void> {
    if (!this.isInitSuccess && this.context) {
      try {
        await this.initialize(this.context);
      } catch (e) {
        Logger.error(TAG, `MediaService initialize error, code is ${e.code}, message is ${e.message}`);
        return;
      }
    }
    this.playByAction(playActionType);
  }

  private async loadLyric(currentSong: SongItem, context: Context): Promise<void> {
    if (currentSong.lyric === '') {
      return;
    }
    this.mLrcEntryList = [];
    try {
      let value: Uint8Array | undefined = await context.resourceManager.getRawFileContent(currentSong.lyric);
      const textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
      const stringData = textDecoder.decodeToString(value, { stream: false });
      this.mLrcEntryList = parseLrcLyric(stringData);
      value = undefined;
      Logger.info(TAG, `loadLyric success, length: ${this.mLrcEntryList.length}`);
    } catch (error) {
      Logger.error(TAG, `loadLyric error: ${error.code}, message is ${error.message}`);
    }
  }

  public controlPlay(musicIndex: number): void {
    this.isFirstLoadAsset = false;
    this.playByIndex(musicIndex);
  }

  public setPlayModel(playMode: MusicPlayMode): void {
    this.playMode = playMode;
    Logger.info(TAG, 'setPlayModel mode: ' + this.playMode);
  }

  public seek(ms: number): void {
    AVPlayerService.getInstance().seek(ms);
  }

  public play(): void {
    AVPlayerService.getInstance().play();
  }

  public pause(): void {
    AVPlayerService.getInstance().pause();
  }

  public playNext(): void {
    this.isFirstLoadAsset = false;
    Logger.info(TAG, `playNext Index: ${this.musicIndex}, songList length: ${this.songList.length}`);
    switch (this.playMode) {
      case MusicPlayMode.RANDOM:
        this.playRandom();
        break;
      case MusicPlayMode.ORDER:
      case MusicPlayMode.SINGLE_CYCLE:
        if (this.musicIndex === this.songList.length - 1) {
          this.playByIndex(0);
        } else {
          this.playByIndex(this.musicIndex + 1);
        }
        break;
      default:
        break;
    }
  }

  public playPrevious(): void {
    this.isFirstLoadAsset = false;
    Logger.info(TAG, `playPrevious Index: ${this.musicIndex}, songList length: ${this.songList.length}`);
    switch (this.playMode) {
      case MusicPlayMode.RANDOM:
        this.playRandom();
        break;
      case MusicPlayMode.ORDER:
      case MusicPlayMode.SINGLE_CYCLE:
        if (this.musicIndex === 0) {
          this.playByIndex(this.songList.length - 1);
        } else {
          this.playByIndex(this.musicIndex - 1);
        }
        break;
      default:
        break;
    }
  }

  public playByAction(action: PlayActionType): void {
    switch (action) {
      case PlayActionType.PAUSE:
        this.pause();
        break;
      case PlayActionType.PLAY:
        this.isFirstLoadAsset = false;
        this.play();
        break;
      case PlayActionType.PREVIOUS:
        this.playPrevious();
        break;
      case PlayActionType.NEXT:
        this.playNext();
        break;
      default:
        break;
    }
  }

  public async playByIndex(musicIndex: number): Promise<void> {
    if (musicIndex >= this.songList.length) {
      Logger.error(TAG, `playByIndex error, index is ${musicIndex} out of songList length ${this.songList.length}`);
      return;
    }

    this.updateMusicIndex(musicIndex);
    let playerService = AVPlayerService.getInstance();

    await playerService.stop();
  }

  private playCompleteAuto(): void {
    switch (this.playMode) {
      case MusicPlayMode.SINGLE_CYCLE:
        this.play();
        break;
      case MusicPlayMode.ORDER:
        this.playNext();
        break;
      case MusicPlayMode.RANDOM:
        this.playRandom();
        break;
      default:
        break;
    }
  }

  private playRandom(): void {
    let num = Math.round(Math.random() * (this.songList.length - 1));
    if (this.musicIndex === num && this.songList.length !== 1) {
      this.playRandom();
    } else {
      this.playByIndex(num);
    }
  }

  private updateMusicIndex(musicIndex: number): void {
    Logger.info(TAG, `updateMusicIndex: ${musicIndex}`);
    if (this.musicIndex !== musicIndex) {
      this.musicIndex = musicIndex;
    }
  }

  async destroy(): Promise<void> {
    if (MediaService.instance === undefined) {
      return;
    }
    MediaService.instance = undefined;

    if (this.songItemBuilder) {
      this.songItemBuilder.release();
      this.songItemBuilder = undefined;
    }

    if (this.context) {
      BackgroundUtil.stopContinuousTask(this.context);
    }

    let playerInstance = AVPlayerService.getInstance();
    AVPlayerService.resetInstance();
    await playerInstance.release();

    let sessionInstance = AVSessionService.getInstance();
    AVSessionService.resetInstance();
    await sessionInstance.destroy();

    AppStorage.delete(Constants.KEY_IS_PLAY);
    AppStorage.delete(Constants.KEY_CURRENT_SONG);
    AppStorage.delete(Constants.KEY_SELECT_INDEX);
    AppStorage.delete(Constants.KEY_PROGRESS_MAX);
    AppStorage.delete(Constants.KEY_TOTAL_TIME);
    AppStorage.delete(Constants.KEY_PROGRESS);
    AppStorage.delete(Constants.KEY_CURRENT_TIME);
    AppStorage.delete(Constants.KEY_SONG_LIST);
    AppStorage.delete(Constants.KEY_COLLECTED_SONG_LIST);

    Logger.info(TAG, 'destroy success');
  }

  public getAvPlayer(): media.AVPlayer | undefined {
    return AVPlayerService.getInstance().getAvPlayer();
  }
}