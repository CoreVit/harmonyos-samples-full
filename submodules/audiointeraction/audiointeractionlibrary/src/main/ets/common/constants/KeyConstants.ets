/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

/**
 * Constants for AppStorage key.
 */
export class KeyConstants {
  /**
   * AppStorage key
   */
  public static readonly KEY_PREFIX: string = 'audioInter';
  public static readonly KEY_BREAKPOINT: string = KeyConstants.KEY_PREFIX + 'BreakPoint';
  public static readonly KEY_STATUS_BAR_HEIGHT: string = KeyConstants.KEY_PREFIX + 'StatusBarHeight';
  public static readonly KEY_NAV_INDICATOR_HEIGHT: string = KeyConstants.KEY_PREFIX + 'NavIndicatorHeight';
  public static readonly KEY_PATH_STACK: string = KeyConstants.KEY_PREFIX + 'PathStack';
  public static readonly KEY_UI_CONTEXT: string = KeyConstants.KEY_PREFIX + 'UIContext';
  public static readonly KEY_ABILITY_CONTEXT: string = KeyConstants.KEY_PREFIX + 'AbilityContext';
  public static readonly KEY_WINDOW: string = KeyConstants.KEY_PREFIX + 'Window';
  public static readonly KEY_IS_PLAY: string = KeyConstants.KEY_PREFIX + 'IsPlay';
  public static readonly KEY_CURRENT_TIME: string = KeyConstants.KEY_PREFIX + 'CurrentTime';
  public static readonly KEY_TOTAL_TIME: string = KeyConstants.KEY_PREFIX + 'TotalTime';
  public static readonly KEY_PROGRESS: string = KeyConstants.KEY_PREFIX + 'Progress';
  public static readonly KEY_PROGRESS_MAX: string = KeyConstants.KEY_PREFIX + 'ProgressMax';
  public static readonly KEY_PAGE_SHOW_TIME: string = KeyConstants.KEY_PREFIX + 'PageShowTime';
  public static readonly KEY_SONG_LIST: string = KeyConstants.KEY_PREFIX + 'SongList';
  public static readonly KEY_PLAY_MODE: string = KeyConstants.KEY_PREFIX + 'PlayMode';
  public static readonly KEY_SELECT_INDEX: string = KeyConstants.KEY_PREFIX + 'SelectIndex';
  public static readonly KEY_IS_FAVORITE: string = KeyConstants.KEY_PREFIX + 'IsFavorite';
  public static readonly KEY_IS_SILENT_MODE: string = KeyConstants.KEY_PREFIX + 'IsSilentMode';
  public static readonly KEY_IMAGE_COLOR: string = KeyConstants.KEY_PREFIX + 'ImageColor';
  public static readonly KEY_IS_FOLD_FULL: string = KeyConstants.KEY_PREFIX + 'IsFoldFull';
  public static readonly KEY_SYS_LANGUAGE: string = KeyConstants.KEY_PREFIX + 'SystemLanguage';
  public static readonly KEY_AUDIO_RENDER_CONTROLLER: string = KeyConstants.KEY_PREFIX + 'AudioRendererController';
  public static readonly KEY_TOTAL_MS_TIME: string = KeyConstants.KEY_PREFIX + 'TotalMsTime';
  public static readonly KEY_TOTAL_BYTE_LEN: string = KeyConstants.KEY_PREFIX + 'TotalByteLength';
  public static readonly KEY_AV_SESSION_CONTROLLER: string = KeyConstants.KEY_PREFIX + 'AVSessionController';
}