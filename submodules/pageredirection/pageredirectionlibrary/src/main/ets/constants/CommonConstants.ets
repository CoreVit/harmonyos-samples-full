/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
 * Common constants for common component.
 */
export class CommonConstants {
  // 100 percent.
  public static readonly FULL_PERCENT: string = '100%';
  // Duration.
  public static readonly TOAST_DURATION: number = 2000;
  /**
   * AppStorage key prefix.
   */
  public static readonly KEY_PREFIX: string = 'PageRedirection';
  public static readonly KEY_PREFIX_BREAKPOINT: string = CommonConstants.KEY_PREFIX + 'CurrentBreakpoint';
  public static readonly KEY_PREFIX_NAVIGATOR_BAR_HEIGHT: string = CommonConstants.KEY_PREFIX + 'NavigatorBarHeight';
  public static readonly KEY_PREFIX_STATUS_BAR_HEIGHT: string = CommonConstants.KEY_PREFIX + 'StatusBarHeight';
  public static readonly KEY_PREFIX_SYSTEM_COLOR_MODE: string = CommonConstants.KEY_PREFIX + 'SystemColorMode';
  public static readonly KEY_PREFIX_SYSTEM_UICONTEXT: string = CommonConstants.KEY_PREFIX + 'UIContext';
  public static readonly KEY_PREFIX_SYSTEM_SYSTEMLANGUAGE: string = CommonConstants.KEY_PREFIX + 'SystemLanguage';
  public static readonly KEY_PREFIX_SYSTEM_PATHSTACK: string = CommonConstants.KEY_PREFIX + 'PathStack';
}