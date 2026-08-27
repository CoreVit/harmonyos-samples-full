/*
* Copyright (C) 2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

export default class Constants {
  /*
   * Full percent.
   */
  public static readonly FULL_PERCENT: string = '100%';
  /*
   * Text scroll duration.
   */
  public static readonly TEXT_SCROLL_DURATION: number = 5000;
  /*
   * Angle degree.
   */
  public static readonly ANGLE_DEGREE: number = 180;
  /*
   * Fifty percent.
   */
  public static readonly FIFTY_PERCENT: string = '50%';
  /*
   * Angle degree horizontal.
   */
  public static readonly ANGLE_DEGREE_HORIZONTAL: number = 90;
  /*
   * Font weight 500.
   */
  public static readonly FONT_WEIGHT_500: number = 500;
  /*
   * Font weight 700.
   */
  public static readonly FONT_WEIGHT_700: number = 700;
  /*
   * WaterFlow columnsGap.
   */
  public static readonly COLUMN_GAP: number = 12;
  /*
   * TextMarqueeView column height.
   */
  public static readonly COLUMN_HEIGHT: number = 74;
  /*
   * AppStorage key
   */
  public static readonly KEY_PREFIX_TEXT_EFFECTS: string = 'textEffects';
  public static readonly KEY_BREAKPOINT: string = Constants.KEY_PREFIX_TEXT_EFFECTS + 'Breakpoint';
  public static readonly KEY_STATUS_BAR_HEIGHT: string = Constants.KEY_PREFIX_TEXT_EFFECTS + 'StatusBarHeight';
  public static readonly KEY_NAV_INDICATOR_HEIGHT: string = Constants.KEY_PREFIX_TEXT_EFFECTS + 'NavIndicatorHeight';
  public static readonly KEY_UI_CONTEXT: string = Constants.KEY_PREFIX_TEXT_EFFECTS + 'UIContext';
}