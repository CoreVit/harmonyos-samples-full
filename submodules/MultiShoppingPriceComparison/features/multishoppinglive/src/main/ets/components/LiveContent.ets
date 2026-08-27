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
import { AvPlayerUtil, PipWindowUtil } from 'multishoppingbase';
import { WidthBreakpointType } from 'multishoppingbase';

/**
 * Video area migrated from detail/Live.ets (AvPlayer/PiP not fully wired; placeholder view with tap handling).
 */
@ComponentV2
export struct LiveContent {
  private static readonly VIDEO_ASPECT_RATIO: number = 16 / 9;
  @Param public widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @Local private surfaceId: string = '';
  private pipWindowUtil: PipWindowUtil | undefined = PipWindowUtil.getPipWindowUtil(this.getUIContext());
  private avPlayerUtil: AvPlayerUtil | undefined = AvPlayerUtil.getAvPlayerUtil(this.getUIContext());

  aboutToDisappear(): void {
    if (this.avPlayerUtil === undefined) {
      return;
    }
    this.avPlayerUtil.release();
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        Column() {
          XComponent({
            type: XComponentType.SURFACE,
            controller: this.pipWindowUtil?.getXComponentController()
          })
            .onLoad(() => {
              if (this.pipWindowUtil === undefined) {
                return;
              }
              this.surfaceId = this.pipWindowUtil.getXComponentController().getXComponentSurfaceId();
              if (this.avPlayerUtil === undefined) {
                return;
              }
              this.avPlayerUtil.createAvPlayer(this.surfaceId);
            })
            .width(new WidthBreakpointType('100%', '100%', 'auto', 'auto').getValue(this.widthBp))
            .height(new WidthBreakpointType('auto', 'auto', '100%', '100%').getValue(this.widthBp))
            .aspectRatio(LiveContent.VIDEO_ASPECT_RATIO)
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .layoutWeight(1)
      .onClick(() => {
        if (this.avPlayerUtil === undefined) {
          return;
        }
        this.avPlayerUtil.playerStateControl();
      })
    }
    .backgroundColor($r('app.color.live_stage_background'))
    .width('100%')
    .height('100%')
  }
}
