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
import { ListItemProp } from '../viewmodel/ListItemProp';

export default class CommonConstants {
  /**
   * FontWeight.borderRadius.
   */
  public static readonly FONT_WEIGHT: number = 500;
  public static readonly FONT_WEIGHT_SM: number = 50;
  public static readonly FONT_TEXT: number = 14;
  public static readonly ITEM_TEXT_HEIGHT: number = 58;
  public static readonly SMALL_SCREEN_IMAGE_SIZE: number = 1000;
  public static readonly OTHER_SCREEN_IMAGE_SIZE: number = 1260;
  /**
   * Top navigation height.
   */
  public static readonly NAV_TOP_HEIGHT: number = 56;
  public static readonly MARGIN_LEFT: number = 40;
  public static readonly MARGIN_TOP: number = 40;
  /**
   * Device size.
   */
  public static readonly DEFAULT_DEVICE_SIZE: number = 840;
  /**
   * Half opacity.
   */
  public static readonly HALF_OPACITY: number = 0.5;
  /**
   * Maximum number of input characters.
   */
  public static readonly PHONE_NUMBER_LENGTH = 11;
  /**
   * The animation duration is 300 ms.
   */
  public static readonly EFFECT_DURATION = 300;
  /**
   * Spacing of child elements const.
   */
  public static readonly SPACE_FIFTEEN = 15;
  /**
   * FontWeight.seventy.
   */
  public static readonly FONT_WEIGHT_SEVENTY = 70;
  /**
   * FontWeight.twenty.
   */
  public static readonly FONT_WEIGHT_NORMAL = 20;
  /**
   * Default row spacing of waterfall flow.
   */
  public static readonly DEFAULT_ONE: number = 1;
  /**
   * Check box name.
   */
  public static readonly CHECK_BOX_NAME1 = 'checkbox';
  public static EMPTY_OBJECT_EXCEPTION = new Error('object is empty');
  /**
   * Default color.
   */
  public static readonly DEFAULT_BG_COLOR: ResourceColor = $r('sys.color.gray_01');
  public static readonly INIT_OVERLAY_COLOR = $r('sys.color.black');
  public static readonly FINAL_OVERLAY_COLOR = $r('sys.color.font_fourth');
  /**
   * AppStorage key prefix.
   */
  public static readonly KEY_PREFIX: string = 'Transitionscollection';
  public static readonly KEY_PREFIX_BREAKPOINT: string = CommonConstants.KEY_PREFIX + 'CurrentBreakpoint';
  public static readonly KEY_PREFIX_NAVIGATOR_BAR_HEIGHT: string = CommonConstants.KEY_PREFIX + 'NavigatorBarHeight';
  public static readonly KEY_PREFIX_STATUS_BAR_HEIGHT: string = CommonConstants.KEY_PREFIX + 'StatusBarHeight';
  public static readonly KEY_PREFIX_SYSTEM_UICONTEXT: string = CommonConstants.KEY_PREFIX + 'UIContext';
  public static readonly KEY_PREFIX_WINDOW_SIZE_CHANGE: string = CommonConstants.KEY_PREFIX + 'windowSizeChanged';
  public static readonly KEY_PREFIX_TRANSITIONS_NAV_PATH_STACK: string =
    CommonConstants.KEY_PREFIX + 'transitionsNavPathStack';
  public static readonly KEY_PREFIX_COLLAPSE: string = CommonConstants.KEY_PREFIX + 'collapse';
  public static readonly KEY_PREFIX_EXPAND: string = CommonConstants.KEY_PREFIX + 'expand';
  public static readonly KEY_PREFIX_NAVIGATOR_SCREEN_HEIGHT: string = CommonConstants.KEY_PREFIX + 'ScreenHeight';
  public static readonly KEY_PREFIX_NAVIGATOR_SCREEN_WIDTH: string = CommonConstants.KEY_PREFIX + 'ScreenWidth';
  /**
   * NavDestinationItem.
   */
  public static readonly navList: ListItemProp[] = [
    {
      title: $r('app.string.model_title'),
      onLine: true,
      children: [
        {
          title: $r('app.string.model_transition'), name: 'MultiModalPage', hasUnderLine: false
        }
      ]
    },
    {
      title: $r('app.string.long_take_title'),
      onLine: false,
      children: [
        {
          title: $r('app.string.search_title'),
          name: 'SearchLongTakeTransitionPageOne',
          hasUnderLine: true
        },
        {
          title: $r('app.string.card_title'),
          name: 'CardLongTakeTransitionPageOne',
          hasUnderLine: true
        },
        {
          title: $r('app.string.semiView_larger_image_modal'),
          name: 'ShowLargeImageWithGesturePageOne',
          hasUnderLine: true
        },
        {
          title: $r('app.string.list_title'),
          name: 'ListLongTakeTransitionPageOne',
          hasUnderLine: true
        },
        {
          title: $r('app.string.book_title'),
          name: 'BookFlipLongTakeTransitionPageOne',
          hasUnderLine: false
        }]
    }
  ]
}