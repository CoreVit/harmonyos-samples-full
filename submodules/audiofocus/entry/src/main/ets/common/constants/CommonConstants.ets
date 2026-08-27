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

import { emitter } from '@kit.BasicServicesKit';

export enum AVPlayerState {
  /**
   * Idle state of avPlayer.
   */
  IDLE = 'idle',

  /**
   * Initialized state of avPlayer.
   */
  INITIALIZED = 'initialized',

  /**
   * Prepared state of avPlayer.
   */
  PREPARED = 'prepared',

  /**
   * Playing state of avPlayer.
   */
  PLAYING = 'playing',

  /**
   * Pause state of avPlayer.
   */
  PAUSED = 'paused',

  /**
   * Completed state of avPlayer.
   */
  COMPLETED = 'completed',

  /**
   * Stopped state of avPlayer.
   */
  STOPPED = 'stopped',

  /**
   * Release state of avPlayer.
   */
  RELEASED = 'released',

  /**
   * Error state of avPlayer.
   */
  ERROR = 'error',

  /**
   * Undefined state of avPlayer.
   */
  UNDEFINED = 'undefined'
}

export enum VideoDataType {
  RAW_FILE = 1,
  RAW_M3U8_FILE = 2,
  URL = 3,
  RAW_MP4_FILE = 4,
}

enum EventId {
  IMMEDIATE_ID = 4,
  HIGH_ID = 3,
}

export class CommonConstants {
  public static readonly  SUBTITLE_UPDATE: emitter.InnerEvent = {
    eventId: EventId.IMMEDIATE_ID,
    priority: emitter.EventPriority.IMMEDIATE
  };
  public static readonly AVPLAYER_PREPARED: emitter.InnerEvent = {
    eventId: EventId.HIGH_ID,
    priority: emitter.EventPriority.HIGH
  };
  public static readonly SLIDER_PROGRESS_MIN: number = 0;
  public static readonly SLIDER_PROGRESS_STEP: number = 0.1;
  public static readonly ROW_CONTROLLER_Z_INDEX: number = 3;
  /**
   * Seek hour unit
   */
  public static readonly HOUR_UNIT: number = 60;
  /**
   * Second to Millisecond
   */
  public static readonly SECOND_TO_MS: number = 1000;
  /**
   * Time const number
   */
  public static readonly TIME_CONST_TEN: number = 10;
  /**
   * Width percent full
   */
  public static readonly WIDTH_FULL_PERCENT: string = '100%';
  /**
   * Height percent full
   */
  public static readonly HEIGHT_FULL_PERCENT: string = '100%';
  /**
   * Hilog Domain.
   */
  public static readonly LOG_DOMAIN = 0x0000;

  public static readonly AUDIO_TYPE = '.pcm';

  /**
   * TAG.
   * */
  public static readonly KEY_PREFIX: string = 'audiofocussample';
  /**
   * currentBreakpoint.
   * */
  public static readonly KEY_CURRENT_BREAK_POINT: string = CommonConstants.KEY_PREFIX + 'currentBreakpoint';
  /**
   * StartRender.
   * */
  public static readonly KEY_START_RENDER: string = CommonConstants.KEY_PREFIX + 'StartRender';
  /**
   * isW.
   * */
  public static readonly KEY_IS_W: string = CommonConstants.KEY_PREFIX + 'isW';
  /**
   * isL.
   * */
  public static readonly KEY_IS_L: string = CommonConstants.KEY_PREFIX + 'isL';
  /**
   * context.
   * */
  public static readonly KEY_CONTEXT: string = CommonConstants.KEY_PREFIX + 'context';
  /**
   * audioIsPlaying.
   * */
  public static readonly KEY_AUDIO_IS_PLAYING: string = CommonConstants.KEY_PREFIX + 'audioIsPlaying';
  /**
   * windowStage.
   * */
  public static readonly KEY_WINDOW_STAGE: string = CommonConstants.KEY_PREFIX + 'windowStage';
  /**
   * hideSplit.
   * */
  public static readonly KEY_HIDE_SPLIT: string = CommonConstants.KEY_PREFIX + 'hideSplit';
  /**
   * windowClass.
   * */
  public static readonly KEY_WINDOW_CLASS: string = CommonConstants.KEY_PREFIX + 'windowClass';
  /**
   * DurationTime.
   * */
  public static readonly KEY_DURATION_TIME: string = CommonConstants.KEY_PREFIX + 'DurationTime';
  /**
   * CurrentTime.
   * */
  public static readonly KEY_CURRENT_TIME: string = CommonConstants.KEY_PREFIX + 'CurrentTime';
  /**
   * isPlaying.
   * */
  public static readonly KEY_IS_PLAYING: string = CommonConstants.KEY_PREFIX + 'isPlaying';
  /**
   * deviceWidth.
   * */
  public static readonly KEY_DEVICE_WIDTH: string = CommonConstants.KEY_PREFIX + 'deviceWidth';
  /**
   * deviceHeight.
   * */
  public static readonly KEY_DEVICE_HEIGHT: string = CommonConstants.KEY_PREFIX + 'deviceHeight';
  /**
   * statusBarHeight.
   * */
  public static readonly KEY_STATUS_BAR_HEIGHT: string = CommonConstants.KEY_PREFIX + 'statusBarHeight';
  /**
   * navBarHeight.
   * */
  public static readonly KEY_NAV_BAR_HEIGHT: string = CommonConstants.KEY_PREFIX + 'navBarHeight';
  /**
   * audioConcurrencyMode.
   * */
  public static readonly KEY_AUDIO_CONCURRENCY_MODE: string = CommonConstants.KEY_PREFIX + 'audioConcurrencyMode';
  /**
   * VoIPCallAbilityContext.
   * */
  public static readonly KEY_VOIP_CALL_ABILITY_CONTEXT: string = CommonConstants.KEY_PREFIX + 'VoIPCallAbilityContext';
  /**
   * navigationAiBarHeight.
   * */
  public static readonly KEY_NAVIGATION_AI_BAR_HEIGHT: string = CommonConstants.KEY_PREFIX + 'navigationAiBarHeight';

  /**
   * Paf.TopHeight.
   * */
  public static readonly KEY_PAF_TOP_HEIGHT: string = CommonConstants.KEY_PREFIX + 'Paf.TopHeight';
  /**
   * windowWidth.
   * */
  public static readonly KEY_WINDOW_WIDTH: string = CommonConstants.KEY_PREFIX + 'windowWidth';

  /**
   * windowHeight.
   * */
  public static readonly KEY_WINDOW_HEIGHT: string = CommonConstants.KEY_PREFIX + 'windowHeight';

  /**
   * NavigationBarHeight.
   * */
  public static readonly KEY_NAVIGATION_BAR_HEIGHT: string = CommonConstants.KEY_PREFIX + 'NavigationBarHeight';

  /**
   * NavigationBarHeight.
   * */
  public static readonly KEY_GRID_TAB_PRO_ENABLE_AVOID_AREA_LISTENER: string = CommonConstants.KEY_PREFIX +
    'Grid.tabPro.enableAvoidAreaListener';
  /**
   * BackParam.
   * */
  public static readonly KEY_BACK_PARAM: string = CommonConstants.KEY_PREFIX + 'BackParam';
  /**
   * image.
   * */
  public static readonly KEY_IMG: string = CommonConstants.KEY_PREFIX + 'img';
  /**
   * currentLanguageType.
   * */
  public static readonly KEY_CURRENT_LANGUAGE_TYPE: string = CommonConstants.KEY_PREFIX + 'currentLanguageType';
  /**
   * videoScaleType.
   * */
  public static readonly KEY_VIDEO_SCALE_TYPE: string = CommonConstants.KEY_PREFIX + 'videoScaleType';
  /**
   * speedName.
   * */
  public static readonly KEY_SPEED_NAME: string = CommonConstants.KEY_PREFIX + 'speedName';
  /**
   * speedIndex.
   * */
  public static readonly KEY_SPEED_INDEX: string = CommonConstants.KEY_PREFIX + 'speedIndex';
  /**
   * isFullLandscapeScreen.
   * */
  public static readonly KEY_IS_FULL_LAND_SCAPE_SCREEN: string = CommonConstants.KEY_PREFIX + 'isFullLandscapeScreen';
  /**
   * isVoIPFullScreen.
   * */
  public static readonly KEY_IS_VOIP_FULL_SCREEN: string = CommonConstants.KEY_PREFIX + 'isVoIPFullScreen';
  /**
   * isScrolling.
   * */
  public static readonly KEY_IS_SCROLLING: string = CommonConstants.KEY_PREFIX + 'isScrolling';
  /**
   * isMuted.
   * */
  public static readonly KEY_IS_MUTED: string = CommonConstants.KEY_PREFIX + 'isMuted';
  /**
   * voipCallState.
   * */
  public static readonly KEY_VOIP_CALL_STATE: string = CommonConstants.KEY_PREFIX + 'voipCallState';
  /**
   * voipCallId.
   * */
  public static readonly KEY_VOIP_CALL_ID: string = CommonConstants.KEY_PREFIX + 'voipCallId';
  /**
   * uiContext.
   * */
  public static readonly KEY_UI_CONTEXT: string = CommonConstants.KEY_PREFIX + 'uiContext';
  /**
   * isPIPShow.
   * */
  public static readonly KEY_IS_PIP_SHOW: string = CommonConstants.KEY_PREFIX + 'isPIPShow';
  /**
   * voipCallMuteState.
   * */
  public static readonly KEY_VOIP_CALL_MUTE_STATE: string = CommonConstants.KEY_PREFIX + 'voipCallMuteState';
  /**
   * isPIPShow.
   * */
  public static readonly KEY_IS_CHANGE_HEIGHT: string = CommonConstants.KEY_PREFIX + 'isChangeHeight';
  /**
   * voipCallMuteState.
   * */
  public static readonly KEY_IS_CHANGE_PADDING: string = CommonConstants.KEY_PREFIX + 'isChangePadding';
  /**
   * currentColorMode.
   * */
  public static readonly KEY_CURRENT_COLOR_MODE: string = CommonConstants.KEY_PREFIX + 'currentColorMode';
  /**
   * Frame rate.
   * */
  public static readonly FRAME_RATE: number = 25;
}

export class Constants {
  public static DELAY_MS = 600;
  public static WH_RADIO = 16 / 9;
  public static LIST_CACHE_COUNT = 8;
  public static LIST_FRICTION = 2.0;
  public static LIST_ITEM_TOP_PADDING = 16;
  public static TITLE_HEIGHT = 40;
  public static LIST_ITEM_LEFT_PADDING = 16;
  public static LIST_ITEM_RIGHT_PADDING = 16;
  public static LIST_DIVIDER_WIDTH = 8;
  public static SLIDER_PADDING = 5;
  public static INFO_AREA_HEIGHT = 96;
  public static FOOTER_HEIGHT = 64;
  public static DOMAIN = 0x0000;
  public static UI_CONTEXT = 'uiContext';
  public static SURFACE_ID_KEY = 'surfaceID';
  public static DETAIL_PAGE_NAME = 'DetailPage';
  public static readonly PROGRESS_REFRESH_INTERVAL: number = 100;
  public static readonly PROGRESS_SHOWN_DURATION: number = 5000;
}

export class CaptionFontConstants {
  public static readonly CAPTION_FONT_FAMILY: ResourceStr[] = ['Sans', 'Condensed'];
  public static readonly CAPTION_FONT_COLOR: ResourceColor[] = [Color.White, Color.Black, Color.Red];
  public static readonly CAPTION_FONT_SIZE: ResourceStr[] = ['14', '16', '18'];
  public static readonly SECOND_TIME = 3600;
  public static readonly MINUTE_TIME = 60;
}

export enum AudioNameTag {
  FIRST_SONG_NAME = 'boisterous',
  SECOND_SONG_NAME = 'power',
  THIRD_SONG_NAME = 'world'
}
