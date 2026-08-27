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
   * Paused state of avPlayer.
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
   * Undefined avPlayer.
   */
  UNDEFINED = 'undefined'
}

export enum VideoDataType {
  RAW_FILE = 1,
  RAW_M3U8FILE = 2,
  URL = 3,
  RAW_MP4FILE = 4
}

export class CommonConstants {
  public static readonly PLAY_PREVIOUS_EVENT_ID = 'playPreviousEvent';
  public static readonly PLAY_NEXT_EVENT_ID = 'playNextEvent';

  /**
   * Animate Duration.
   */
  public static readonly ANIMATE_DURATION: number = 200;
  /**
   * Track Thickness borderRadius.
   */
  public static readonly TRACK_BORDER_RADIUS: number = 2;
  /**
   * The surface width.
   */
  public static readonly SURFACE_WIDTH: number = 1920;
  /**
   * The surface height.
   */
  public static readonly SURFACE_HEIGHT: number = 1080;
  /**
   * Slider step.
   */
  public static readonly SLIDER_STEP: number = 0.1;
  /**
   * Slider min.
   */
  public static readonly SLIDER_MIN: number = 0;
  /**
   * Slider index.
   */
  public static readonly SLIDER_INDEX: number = 3;
  /**
   * Video Play button index.
   */
  public static readonly Z_INDEX_VIDEO_PLAY: number = 2;
  /**
   * Video base index.
   */
  public static readonly Z_INDEX_BASE: number = 1;
  /**
   * Width percent full.
   */
  public static readonly WIDTH_FULL_PERCENT: string = '100%';
  /**
   * Height percent full.
   */
  public static readonly HEIGHT_FULL_PERCENT: string = '100%';
  /**
   * Seek hour unit.
   */
  public static readonly HOUR_UNIT: number = 60;
  /**
   * Second to Millisecond.
   */
  public static readonly SECOND_TO_MS: number = 1000;
  /**
   * Time const number.
   */
  public static readonly TIME_CONST_TEN: number = 10;
  /**
   * CurIndex default number.
   */
  public static readonly CURINDEX_DEFAULT_NUM: number = -1;
  /**
   *  Detail video list space.
   */
  public static readonly LIST_SPACE: string = '12vp';
  /**
   *  Detail video list space 16vp.
   */
  public static readonly SPACE_16: number = 16;
  /**
   *  Video aspect.
   */
  public static readonly ASPECT: number = 16 / 9;
}

export class CaptionFontConstants {
  public static readonly CAPTION_FONT_FAMILY: ResourceStr[] = ['Sans', 'Condensed'];
  public static readonly CAPTION_FONT_COLOR: ResourceColor[] = [Color.White, Color.Black, Color.Red];
  public static readonly CAPTION_FONT_SIZE: ResourceStr[] = ['14', '16', '18'];
}

export class ScreenShotConstants {
  public static readonly FRAME_RATE: number = 25;
}