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

export class Constants {
  public static readonly KEY_PREFIX: string = 'livecard';

  public static readonly KEY_CONTEXT: string = Constants.KEY_PREFIX + 'context';
  public static readonly KEY_DYNAMIC_LYRICS_SONG_ID: string = Constants.KEY_PREFIX + 'dynamicLyricsSongID';
  public static readonly KEY_WIDTH_BP: string = Constants.KEY_PREFIX + 'widthBp';
  public static readonly KEY_HEIGHT_BP: string = Constants.KEY_PREFIX + 'heightBp';
  public static readonly KEY_WINDOW_INFO: string = Constants.KEY_PREFIX + 'windowInfo';
  public static readonly KEY_IS_PLAY: string = Constants.KEY_PREFIX + 'isPlay';
  public static readonly KEY_SONG_LIST: string = Constants.KEY_PREFIX + 'songList';
  public static readonly KEY_CURRENT_SONG: string = Constants.KEY_PREFIX + 'currentSong';
  public static readonly KEY_COLLECTED_SONG_LIST: string = Constants.KEY_PREFIX + 'collectedSongList';
  public static readonly KEY_WINDOW_UTIL: string = Constants.KEY_PREFIX + 'windowUtil';
  public static readonly KEY_CURRENT_LYRIC_INDEX: string = Constants.KEY_PREFIX + 'currentLyricIndex';
  public static readonly KEY_SELECT_INDEX: string = Constants.KEY_PREFIX + 'selectIndex';
  public static readonly KEY_PROGRESS_MAX: string = Constants.KEY_PREFIX + 'progressMax';
  public static readonly KEY_TOTAL_TIME: string = Constants.KEY_PREFIX + 'totalTime';
  public static readonly KEY_PROGRESS: string = Constants.KEY_PREFIX + 'progress';
  public static readonly KEY_CURRENT_TIME: string = Constants.KEY_PREFIX + 'currentTime';
}

export interface CommonDimensions {
  borderRadius: number;
  padding: number;
  dividerWidth: number;
  dividerHeight: number;
}

export interface FontStyleItem {
  fontSize: number;
  lineHeight: number;
}

export interface FontStyles {
  titleLarge: FontStyleItem;
  titleMedium: FontStyleItem;
  bodyXLarge: FontStyleItem;
  bodyLarge: FontStyleItem;
  bodyMedium: FontStyleItem;
  bodySmall: FontStyleItem;
  valueLarge: FontStyleItem;
  valueMedium: FontStyleItem;
}

export interface Spacing {
  small: number;
  medium: number;
  large: number;
  iconPadding: number;
  buttonPadding: number;
}

export const LIVE_CARD_RATIO: number = 1.5;
export const ANIMATE_COMPONENT_BOTTOM: number = 41;
export const ANIMATE_COMPONENT_LEFT: number = 51;

export const COMMON_DIMENSIONS: CommonDimensions = {
  borderRadius: 20,
  padding: 12,
  dividerWidth: 0.5,
  dividerHeight: 32
};

export const FONT_STYLES: FontStyles = {
  titleLarge: { fontSize: 18, lineHeight: 24 },
  titleMedium: { fontSize: 14, lineHeight: 19 },
  bodyXLarge: { fontSize: 20, lineHeight: 27 },
  bodyLarge: {fontSize: 16, lineHeight: 21 },
  bodyMedium: { fontSize: 14, lineHeight: 19 },
  bodySmall: { fontSize: 12, lineHeight: 16 },
  valueLarge: { fontSize: 24, lineHeight: 32 },
  valueMedium: { fontSize: 14, lineHeight: 19 }
};

export const SPACING: Spacing = {
  small: 4,
  medium: 12,
  large: 16,
  iconPadding: 8,
  buttonPadding: 10
};

export class BorderRadius {
  public static readonly SMALL: number = 4;
  public static readonly MEDIUM: number = 8;
  public static readonly CARD: number = 16;
  public static readonly BUTTON: number = 20;
  public static readonly CONTAINER: number = 24;
  public static readonly PILL: number = 29;
}

export class IconSize {
  public static readonly SMALL: number = 10;
  public static readonly MEDIUM: number = 18;
  public static readonly STANDARD: number = 24;
  public static readonly LARGE: number = 32;
}

export class CardPadding {
  public static readonly STANDARD: number = 12;
  public static readonly CARD: number = 20;
  public static readonly SECTION: number = 16;
}

export class AnimationDuration {
  public static readonly SHORT: number = 400;
  public static readonly STANDARD: number = 1000;
  public static readonly FRAME_INTERVAL: number = 16;
}

export class CommonPadding {
  public static readonly SMALL: number = 16;
  public static readonly MEDIUM: number = 24;
  public static readonly LARGE: number = 32;
}

export class DataView {
  public static readonly DATA_PANEL_SIZE: number = 72;
  public static readonly DATA_PANEL_STROKE: number = 12;
  public static readonly DIVIDER_HEIGHT: number = 40;
  public static readonly STATS_LEFT_MARGIN: number = 48;
}
