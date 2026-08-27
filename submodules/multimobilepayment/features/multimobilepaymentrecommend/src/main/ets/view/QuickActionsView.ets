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

import { AppStorageV2 } from '@kit.ArkUI';
import {
  CommonConstants,
  getWindowInfoState,
  WidthBreakpointType,
  WindowInfo,
  WindowUtil
} from 'multimobilepaymentbase';
import { QuickActionModel } from '../model/QuickActionModel';
import { QuickActionViewModel } from '../viewmodel/QuickActionViewModel';

/**
 * Quick actions view component
 * Displays quick action buttons (scan, payment, travel, card bag)
 * Handles device capability checks before triggering actions
 */
@ComponentV2
export struct QuickActionsView {
  @Event onPaymentClick: () => void = () => {
  };
  @Event onScanClick: () => void = () => {
  };
  @Local windowInfo: WindowInfo = getWindowInfoState();
  @Local windowUtil: WindowUtil | undefined = AppStorageV2.connect(WindowUtil, CommonConstants.KEY_WINDOWUTIL);
  private quickActions: QuickActionModel[] = new QuickActionViewModel().getQuickActionList();

  /**
   * Handle scan button click
   * Checks device capability before triggering scan action
   */
  private handleScanClick(): void {
    if (canIUse('SystemCapability.Multimedia.Scan.ScanBarcode') && canIUse('SystemCapability.Multimedia.Camera.Core')) {
      this.onScanClick();
    } else {
      if (this.windowUtil) {
        this.windowUtil.getUIContext()?.showAlertDialog({
          message: $r('app.string.device_not_support')
        });
      }
    }
  }

  build() {
    Row() {
      ForEach(this.quickActions, (item: QuickActionModel, index: number) => {
        Column({ space: $r('app.float.quick_action_space') }) {
          Row({ space: $r('app.float.quick_action_space') }) {
            SymbolGlyph(item.getIcon())
              .fontSize($r('app.float.quick_action_icon_size'))
              .fontColor([$r('app.color.on_primary')])

            Text(item.getText())
              .fontSize($r('app.float.quick_action_text_size'))
              .fontColor($r('app.color.on_primary'))
              .visibility(this.windowInfo.widthBp > WidthBreakpoint.WIDTH_SM ? Visibility.Visible : Visibility.None)
          }
          .width(this.windowInfo.widthBp <= WidthBreakpoint.WIDTH_SM ? $r('app.float.quick_action_button_size_sm') :
            CommonConstants.QUICK_ACTION_WIDTH)
          .height(new WidthBreakpointType($r('app.float.quick_action_button_height_sm'),
            $r('app.float.quick_action_button_height_md'), $r('app.float.quick_action_button_height_lg'),
            $r('app.float.quick_action_button_height_xl')).getValue(this.windowInfo.widthBp))
          .borderRadius(this.windowInfo.widthBp <= WidthBreakpoint.WIDTH_SM ?
            $r('app.float.quick_action_button_radius_sm') : $r('app.float.quick_action_button_radius_lg'))
          .backgroundColor($r('app.color.button_background_overlay'))
          .justifyContent(FlexAlign.Center)

          Text(item.getText())
            .fontSize($r('app.float.quick_action_text_size'))
            .fontColor($r('app.color.on_primary'))
            .visibility(this.windowInfo.widthBp <= WidthBreakpoint.WIDTH_SM ? Visibility.Visible : Visibility.None)
        }
        .onClick(() => {
          if (index === 0) {
            this.handleScanClick();
          } else if (index === 1) {
            this.onPaymentClick();
          }
        })
      }, (_item: QuickActionModel, index: number) => index.toString())
    }
    .width(CommonConstants.FULL_WIDTH)
    .padding({
      top: $r('app.float.quick_action_padding_top'),
      bottom: $r('app.float.quick_action_padding_bottom')
    })
    .justifyContent(FlexAlign.SpaceAround)
  }
}
