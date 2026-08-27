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

import { NavDestinationItem } from '../viewmodel/NavDestinationItem';

export default class Constants {
  /**
   * One hundred percent.
   */
  public static readonly ONE_HUNDRED_PERCENT: string = '100%';
  /**
   * Rotate angle.
   */
  public static readonly ANGLE: number = 45;
  /**
   * Change value.
   */
  public static readonly CHANGE_VALUE: number = 77;
  /**
   * Zero.
   */
  public static readonly ZERO: number = 0;
  /**
   * Eight hundred.
   */
  public static readonly EIGHT_HUNDRED: number = 800;
  /**
   * Two thousand.
   */
  public static readonly TWO_THOUSAND: number = 2000;
  /**
   * Three thousand.
   */
  public static readonly THREE_THOUSAND: number = 3000;
  /**
   * One hundred.
   */
  public static readonly ONE_HUNDRED: number = 100;
  /**
   * Iteration.
   */
  public static readonly ITERATION: number = -1;
  /**
   * Negative two.
   */
  public static readonly NEGATIVE_TWO: number = -2;
  /**
   * Font weight 700.
   */
  public static readonly FONT_WEIGHT_700: number = 700;
  /**
   * Bar height.
   */
  public static readonly BAR_HEIGHT: number = 60;
  /**
   * Negative one hundred twenty.
   */
  public static readonly NEGATIVE_ONE_HUNDRED_TWENTY: number = -120;
  /**
   * Coefficient of movement.
   */
  public static readonly COEFFICIENT: number = 2.83;
  /**
   * Twenty.
   */
  public static readonly TWENTY: number = 20;
  /**
   * Negative twenty.
   */
  public static readonly NEGATIVE_TWENTY: number = -20;
  /**
   * Thirty.
   */
  public static readonly THIRTY: number = 30;
  /**
   * One hundred and twenty.
   */
  public static readonly ONE_HUNDRED_AND_TWENTY: number = 120;
  /**
   * Ninety.
   */
  public static readonly NINETY: number = 90;
  /**
   * Ninety five.
   */
  public static readonly NINETY_FIVE: number = 95;
  /**
   * Two.
   */
  public static readonly TWO: number = 2;
  /**
   * Three.
   */
  public static readonly THREE: number = 3;
  /**
   * Four.
   */
  public static readonly FOUR: number = 4;
  /**
   * Line height.
   */
  public static readonly LINE_HEIGHT: number = 1;
  /**
   * Item code start.
   */
  public static readonly ITEM_CODE_START: number = 30;
  /**
   * Item divider.
   */
  public static readonly ITEM_CODE_WIDTH: number = 60;
  /**
   * Item divider.
   */
  public static readonly ITEM_FOLD_CODE_WIDTH: number = 51;
  /**
   * Item divider.
   */
  public static readonly ITEM_DIVIDER: number = 5;
  /**
   * Fifty-eight point five.
   */
  public static readonly FIFTY_EIGHT_POINT_FIVE: number = 58.5;
  /**
   * Fifty-nine.
   */
  public static readonly FIFTY_NINE: number = 59;
  /**
   * Sixty.
   */
  public static readonly SIXTY: number = 60;
  /**
   * Negative sixty.
   */
  public static readonly NEGATIVE_SIXTY: number = -60;
  /**
   * Forty.
   */
  public static readonly FORTY: number = 40;
  /**
   * One hundred forty.
   */
  public static readonly ONE_HUNDRED_FORTY: number = 120;
  /**
   * Negative one hundred.
   */
  public static readonly NEGATIVE_ONE_HUNDRED: number = -100;
  /**
   * Negative one hundred ten.
   */
  public static readonly NEGATIVE_ONE_HUNDRED_TEN: number = -110;
  /**
   * Negative thirty-five.
   */
  public static readonly NEGATIVE_THIRTY_FIVE: number = -35;
  /**
   * Negative seventy-five.
   */
  public static readonly NEGATIVE_SEVENTY_FIVE: number = -75;
  /**
   * Ten.
   */
  public static readonly TEN: number = 10;
  /**
   * Negative twelve.
   */
  public static readonly NEGATIVE_TWELVE: number = -12;
  /**
   * Negative twenty-five.
   */
  public static readonly NEGATIVE_TWENTY_FIVE: number = -25;
  /**
   * Negative five.
   */
  public static readonly NEGATIVE_FIVE: number = -5;
  /**
   * Minus thirty.
   */
  public static readonly MINUS_THIRTY: number = -30;
  /**
   * Draw.
   */
  public static readonly DRAW: string = '画';
  /**
   * Therefore.
   */
  public static readonly THEREFORE: string = '故';
  /**
   * Weir.
   */
  public static readonly WEIR: string = '堰';
  /**
   * Communes.
   */
  public static readonly COMMUNES: string = '乡';
  /**
   * Hua.
   */
  public static readonly HUA: string = '华';
  /**
   * Ancients.
   */
  public static readonly ANCIENTS: string = '古';
  /**
   * Hunan.
   */
  public static readonly HUNAN: string = '湘';
  /**
   * Word.
   */
  public static readonly WORD: string = '古堰画乡';
  /**
   * All breakpoints
   */
  public static readonly BREAKPOINTS: string[] = ['sm', 'md', 'lg'];
  /**
   * Full Screen width
   */
  public static readonly FULL_WIDTH: string = '100%';
  /**
   * Full Screen height
   */
  public static readonly FULL_HEIGHT: string = '100%';
  /**
   * Index page padding top size.
   */
  public static readonly PADDING_TOP_INDEX: number = 56;
  /**
   * Index page padding bottom size.
   */
  public static readonly PADDING_BOTTOM_INDEX: number = 16;
  /**
   * Icon padding sm.
   */
  public static readonly PADDING_SM: number = 16;
  /**
   * Icon padding md.
   */
  public static readonly PADDING_MD: number = 24;
  /**
   * Icon padding lg.
   */
  public static readonly PADDING_LG: number = 32;
  /**
   * Destination.
   */
  public static readonly NAV_DESTINATION_DATA: NavDestinationItem[] = [
    {
      name: 'TextBoxShowCursor', detail: $r('app.string.word')
    },
    {
      name: 'BottomWithBar', detail: $r('app.string.bottom')
    },
    {
      name: 'BackgroundColorChange', detail: $r('app.string.background')
    },
    {
      name: 'VerificationCode', detail: $r('app.string.select_verification_code')
    },
    {
      name: 'SliderVerification', detail: $r('app.string.slider_verification_code')
    }
  ];
  /**
   * AppStorage key
   */
  public static readonly KEY_PREFIX: string = 'verificationCode';
  public static readonly KEY_BREAKPOINT: string = Constants.KEY_PREFIX + 'BreakPoint';
  public static readonly KEY_STATUS_BAR_HEIGHT: string = Constants.KEY_PREFIX + 'StatusBarHeight';
  public static readonly KEY_NAV_INDICATOR_HEIGHT: string = Constants.KEY_PREFIX + 'NavIndicatorHeight';
  public static readonly KEY_PATH_STACK: string = Constants.KEY_PREFIX + 'PathStack';
  public static readonly KEY_UI_CONTEXT: string = Constants.KEY_PREFIX + 'UIContext';
  public static readonly KEY_WINDOWS: string = Constants.KEY_PREFIX + 'WindowClass';
}