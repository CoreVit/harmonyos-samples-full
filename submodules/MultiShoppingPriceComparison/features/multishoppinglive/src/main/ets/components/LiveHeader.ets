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

import { uiObserver } from '@kit.ArkUI';
import { WidthBreakpointType } from 'multishoppingbase';
import { LiveHeaderState } from '../viewmodel/LiveHeaderState';

/**
 * Migrated from detail/LiverHeader.
 * If PiP (PipWindowUtil) dependencies are not moved into base, non-phone close actions use
 * the {@link onNonPhoneClose} callback, which defaults to a no-op.
 */
@ComponentV2
export struct LiveHeader {
  @Env(SystemProperties.BREAK_POINT) private breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Param public widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @Local private headerState: LiveHeaderState = new LiveHeaderState(this.getUIContext().getHostContext()!);
  @Event public onClose: () => void = () => {
  };

  build() {
    Row() {
      Row() {
        Image($r('app.media.live_vmall'))
          .width(36)
          .aspectRatio(1)
          .margin({ right: 4 })
        Column() {
          Text(this.headerState.storeName)
            .fontSize(12)
            .fontColor($r('sys.color.font_on_primary'))
          Text(this.headerState.viewersText)
            .fontSize(10)
            .fontColor($r('sys.color.font_on_primary'))
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ right: 16 })
      }
      .height(36)
      .backgroundColor($r('app.color.live_header_scrim'))
      .border({ radius: 18 })

      Image($r('app.media.icon_close_3'))
        .width(24)
        .height(24)
        .onClick(() => {
          this.onClose();
        })
    }
    .width('100%')
    .height(36)
    .padding({
      left: new WidthBreakpointType(16, 24, 32, 32).getValue(this.widthBp),
      right: new WidthBreakpointType(16, 24, 32, 32).getValue(this.widthBp)
    })
    .justifyContent(FlexAlign.SpaceBetween)
    .background($r('app.color.live_stage_background'))
  }
}
