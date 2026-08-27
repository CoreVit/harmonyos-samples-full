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
import { DialogConfig, DialogPosition } from 'hadss_dialog';

export default class CommonConstant {
  public static readonly FULL_LENGTH = '100%';
  public static readonly HALF_FULL_LENGTH = '50%';
  public static readonly SHEET_MIDDLE: number = 276;
  public static readonly SHEET_LARGE: number = 514;
  public static readonly DURATION_1000: number = 1000;
  public static readonly DURATION_2000: number = 2000;
  public static readonly DURATION_3000: number = 3000;
  public static readonly Interval_20: number = 20;
  public static readonly MODEL_DIALOG: string = '模态弹窗';
  public static readonly NON_MODEL_DIALOG: string = '非模态弹窗';
  public static readonly INPUT_DEFAULT_VALUE: string = '空';
  public static readonly TIMED_DIALOG_DURATION: number = 6;
  public static readonly OPEN: string = '打开';
  public static readonly DIALOG_STATE_OPEN: string = '当前弹窗状态：打开';
  public static readonly DIALOG_STATE_CLOSE: string = '当前弹窗状态：关闭'
  public static readonly CUSTOM_TEMPLATE_SIMPLE: string = 'SimpleCustom';
  public static readonly TOAST_TITLE: string = 'Toast';
  public static readonly SKIP_ACTION_PATH: string = 'SkipAction';
  public static readonly SKIP_ACTION_TITLE: string = 'SkipAction';
  public static readonly SKIP_ACTION_PARAM: string = 'SkipAction Success!';
  public static readonly ROUTER_PATH: string = 'pages/others/RouterSkip';
  public static readonly COMMON_ACTION_PATH: string = 'CommonExamples';
  public static readonly OPERABLE_ACTION_PATH: string = 'OperableExample';
  public static readonly REUSE_ACTION_PATH: string = 'ReuseExample';
  public static readonly MULTI_ACTION_PATH: string = 'MultiDialogExample';
  public static readonly DIALOG_HUB_EXAMPLES = 'DialogHub弹窗示例';
  public static readonly COMMON_DIALOG_EXAMPLES = '常见弹窗示例';
  public static readonly OPERABLE_DIALOG_EXAMPLES = '弹窗与页面/用户交互示例';
  public static readonly REUSE_DIALOG_EXAMPLES = '弹窗复用示例';
  public static readonly MULTI_DIALOG_EXAMPLES = '多个弹窗处理示例';
  public static readonly ADJUST_SHEET_DIALOG_ID = 'adjustSheetDialog';
  public static readonly DIALOG_A = '我是弹窗A';
  public static readonly DIALOG_B = '我是弹窗B';
  public static readonly DIALOG_C = '我是弹窗C';
  public static readonly DIALOG_D = '我是弹窗D';
  public static readonly DIALOG_E = '我是弹窗E';
  public static readonly DIALOG_F = '我是弹窗F';
  public static readonly DIALOG_G = '我是弹窗G';
  public static readonly DIALOG_H = '我是弹窗H';
  public static readonly DIALOG_A_CONTENT = 'AAAAAAAAAAAAAAAAAAAAAA';
  public static readonly DIALOG_B_CONTENT = 'BBBBBBBBBBBBBBBBBBBBBB';
  public static readonly DIALOG_C_CONTENT = 'CCCCCCCCCCCCCCCCCCCCCC';
  public static readonly DIALOG_D_CONTENT = 'DDDDDDDDDD';
  public static readonly DIALOG_E_CONTENT = 'EEEEEEEEEE';
  public static readonly DIALOG_F_CONTENT = 'FFFFFFFFFF';
  public static readonly DIALOG_G_CONTENT = 'GGGGGGGGGG';
  public static readonly DIALOG_H_CONTENT = 'HHHHHHHHHH';
  public static readonly DIALOG_B_SUPPRESSION = '弹窗B弹出失败';
  public static readonly DIALOG_C_SUPPRESSION = '弹窗C弹出失败';
  public static readonly DIALOG_A_BINDING_BUTTON = 'dialogAButton';
  public static readonly DIALOG_B_BINDING_BUTTON = 'dialogBButton';
  public static readonly DIALOG_C_BINDING_BUTTON = 'dialogCButton';
  public static readonly DIALOG_D_BINDING_BUTTON = 'dialogDButton';
  public static readonly DIALOG_E_BINDING_BUTTON = 'dialogEButton';
  public static readonly DIALOG_F_BINDING_BUTTON = 'dialogFButton';
  public static readonly DIALOG_G_BINDING_BUTTON = 'dialogGButton';
  public static readonly DIALOG_H_BINDING_BUTTON = 'dialogHButton';
  public static readonly DIALOG_MULTI_BINDING_BUTTON = 'multiDialogExampleCloseButton';
  public static readonly DIALOG_F_LAYER_INDEX = 10;
  public static readonly SHUT_DOW_ALL_DIALOG = '关闭当前页面所有弹窗';
  public static readonly CURRENT_BREAK_POINT = 'currentBreakpoint';
  public static readonly CURRENT_BREAK_POINT_XS = 'xs';
  public static readonly CURRENT_BREAK_POINT_SM = 'sm';
  public static readonly CURRENT_BREAK_POINT_MD = 'md';
  public static readonly CURRENT_BREAK_POINT_LG = 'lg';
  public static readonly CURRENT_BREAK_POINT_XL = 'xl';
  public static readonly CURRENT_BREAK_POINT_XS_SIZE = 320;
  public static readonly CURRENT_BREAK_POINT_SM_SIZE = 600;
  public static readonly CURRENT_BREAK_POINT_MD_SIZE = 840;
  public static readonly CURRENT_BREAK_POINT_LG_SIZE = 1440;
  public static readonly TAG_NAME = 'DialogHub';
  public static readonly UPDATE_TAG = '修改标签';
  public static readonly TAG_NAME_TEXT = '标签名: ';
  public static readonly NOW_DIALOGS = '当前页面弹窗数: ';
  public static readonly DIALOG_1 = '弹窗1';
  public static readonly DIALOG_2 = '弹窗2';
  public static readonly DIALOG_3 = '弹窗3';
  public static readonly DIALOG_NOW_STATE = '当前状态：';
  public static readonly BREAK_ON_DIALOG = '当前配置: 返回手势作用于弹窗';
  public static readonly BREAK_ON_PAGE = '当前配置: 返回手势作用于页面';
  public static readonly progressNameStart = 0;
  public static readonly progressNameTotal = 100;
  public static readonly SkipBuilderSpan_2 = '关于XX业务与隐私的声明';
  public static readonly REUSE_SIMPLE_DIALOG = 'This is a Toast message';
  public static readonly MY_TEMPLATE_NAME = 'SimpleToast';
  public static readonly CUSTOM_SAMPLE_STYLE_SHADOW: ShadowOptions = {
    radius: $r('app.float.custom_sample_shadow_radius'),
    color: $r('app.color.custom_sample_shadow_color'),
    offsetY: $r('app.float.custom_sample_shadow_offset')
  };
  public static readonly CUSTOM_SAMPLE_POSITION: DialogPosition = {
    alignment: DialogAlignment.Bottom,
    offset: {
      dx: 0, dy: $r('app.float.custom_sample_offset')
    }
  };
  public static readonly CUSTOM_SAMPLE_CONFIG: DialogConfig = {
    dialogPosition: CommonConstant.CUSTOM_SAMPLE_POSITION
  };
  public static readonly TOP_BOTTOM_MARGIN: Margin = {
    top: 10, bottom: 10
  };
  public static readonly CENTER_DIALOG_OFFSET: Offset = {
    dx: '50%', dy: 0
  };
  public static readonly LEFT_DIALOG_OFFSET: Offset = {
    dx: '-25%', dy: 0
  };
  public static readonly RIGHT_DIALOG_OFFSET: Offset = {
    dx: '25%', dy: 0
  };
  public static readonly REUSE_EXAMPLE_TITLE = '弹窗复用示例';
  public static readonly POPUP_DIRECTLY_BUTTON_ID = 'popupDirectlyButton';
  public static readonly POPUP_WITH_ANIMATION_BUTTON_ID = 'popupWithAnimationButton';
  public static readonly POPUP_WITH_CUSTOM_POSITION_BUTTON_ID = 'popupWithCustomPositionButton';
  public static readonly TOAST_DISPLAYED_CONTENT = 'This is a Toast message';
  public static readonly TOAST_DISPLAY_DURATION: number = 1500;
  public static readonly CLICK_TO_CREATE = '点击创建';
  public static readonly CLICK_TO_DELETE = '点击删除';
  public static readonly CLICK_TO_MODIFY = '点击修改';
  public static readonly CLICK_TO_DEMONSTRATE = '点击演示';
  public static readonly DIALOG_TEXT = '弹窗';
  public static readonly SINGLETON_DIALOG_ID = 'singletonPopup';
  public static readonly REUSEEXAMPLE_ITEMHEAD = '通过自定义弹窗模板进行弹窗';
  public static readonly TOAST_DEFAULT_BACKGROUNDCOLOR = '#88000000';
  public static readonly Y_OFFSET: number = 80;
}