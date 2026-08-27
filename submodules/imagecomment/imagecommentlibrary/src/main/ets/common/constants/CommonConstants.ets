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
 * Common constants for all features.
 */
export class CommonConstants {
  /**
   * The prefix of app store key.
   */
  public static readonly PREFIX: string = 'image_comment_';
  /**
   * The key of break point.
   */
  public static readonly AS_KEY_BREAK_POINT: string = `${CommonConstants.PREFIX}currentBreakpoint`;
  /**
   * The key of status bar height.
   */
  public static readonly AS_KEY_STATUS_BAR_HEIGHT: string = `${CommonConstants.PREFIX}statusBarHeight`;
  /**
   * The key of navigator bar height.
   */
  public static readonly AS_KEY_NAVIGATOR_BAR_HEIGHT: string = `${CommonConstants.PREFIX}navigatorBarHeight`;
  /**
   * The key of toast bottom margin.
   */
  public static readonly TOAST_BOTTOM_MARGIN: number = 80;
  /**
   * The key of toast duration.
   */
  public static readonly TOAST_DURATION: number = 2000;
}