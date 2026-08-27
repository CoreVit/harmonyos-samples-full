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

import { WindowInfo, BreakpointType, Logger, CommonConstants, DeviceApiVersionUtil, AvPlayerUtil } from 'multivideobase';
import { MainPageConstants } from '../constants/MainPageConstants';

const TAG = '[VideoDialog]';

@Builder
function menuItemFunction(img: Resource, text: ResourceStr) {
  Row() {
    SymbolGlyph(img)
      .fontSize('16fp')
      .margin({ right: '8vp' })
      .fontColor([$r('app.color.mp_text_primary')])
    Text(text)
      .layoutWeight(1)
      .fontSize('16fp')
      .fontWeight(FontWeight.Normal)
  }
  .height('48vp')
}

@Builder
export function RightClickMenu(currentWidthBreakpoint: number) {
  Column() {
    menuItemFunction($r('sys.symbol.list_square'), MainPageConstants.VIDEO_DIALOG_OPTIONS[0])
    menuItemFunction($r('sys.symbol.star'), MainPageConstants.VIDEO_DIALOG_OPTIONS[1])
    menuItemFunction($r('sys.symbol.heart'), MainPageConstants.VIDEO_DIALOG_OPTIONS[2])
  }
  .borderRadius(16)
  .backgroundColor($r('app.color.mp_menu_popup_background'))
  .width(currentWidthBreakpoint >= WidthBreakpoint.WIDTH_LG ? '186vp' : '156vp')
  .padding({
    left: '16vp',
    right: '16vp'
  })
}

/**
 * Video preview dialog with AVPlayer for playing video previews.
 */
@CustomDialog
export struct VideoDialog {
  @ObjectLink mainWindowInfo: WindowInfo;
  private xComponentController: XComponentController = new XComponentController();
  private surfaceId: string = '';
  private controller?: CustomDialogController;
  private avPlayerUtil?: AvPlayerUtil = AvPlayerUtil.getInstance(this.getUIContext());
  private videoHeight: number = 0;

  private updateVideoHeight(): void {
    this.videoHeight = Number(new BreakpointType(161, 161, 268,
      DeviceApiVersionUtil.isApiVersionAfter23() ? 268 : 347, 347).getValue(this.mainWindowInfo.widthBp));
  }

  private getVideoHeight(): string {
    return `${this.videoHeight}${MainPageConstants.VP_UNIT}`;
  }

  private getVideoDialogWidth(): string {
    return `${this.videoHeight * MainPageConstants.VIDEO_DIALOG_ASPECT_RATIO}${MainPageConstants.VP_UNIT}`;
  }

  aboutToAppear() {
    this.surfaceId = '';
    this.avPlayerUtil = AvPlayerUtil.getInstance(this.getUIContext());
    this.updateVideoHeight();
  }

  aboutToDisappear() {
    this.surfaceId = '';
    this.avPlayerUtil?.release();
  }

  build() {
    Column() {
      Column() {
        XComponent({
          type: XComponentType.SURFACE,
          controller: this.xComponentController
        })
          .borderRadius(24)
          .onLoad(() => {
            this.surfaceId = this.xComponentController.getXComponentSurfaceId();
            if (!this.surfaceId) {
              Logger.error(TAG, `XComponent surface is invalid.`);
              this.controller?.close();
              return;
            }
            this.avPlayerUtil?.createAvPlayer(this.surfaceId, CommonConstants.PRODUCT_VIDEO_NAME);
          })
          .width('100%')
          .height('100%')
      }
      .margin({ bottom: '12vp' })
      .height(this.getVideoHeight())
      .aspectRatio(MainPageConstants.VIDEO_DIALOG_ASPECT_RATIO)
      .onClick(() => {
        this.avPlayerUtil?.playerStateControl();
      })

      Row() {
        RightClickMenu(this.mainWindowInfo.widthBp)

        Blank()
          .layoutWeight(1)
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            this.controller?.close();
          })
      }
      .width('100%')
    }
    .width(this.getVideoDialogWidth())
    .alignItems(HorizontalAlign.Start)
  }
}