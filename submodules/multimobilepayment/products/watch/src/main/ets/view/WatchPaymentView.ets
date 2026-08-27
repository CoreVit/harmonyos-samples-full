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

import { CommonConstants, Logger, WindowUtil } from 'multimobilepaymentbase';
import { image } from '@kit.ImageKit';
import { GenerateBarcodeViewModel } from 'multimobilepaymentpay';
import { AppStorageV2 } from '@kit.ArkUI';

const TAG = 'WatchPaymentView';

/**
 * Watch payment view component
 * Optimized payment receipt view for wearable devices
 * Displays QR code for payment on watch screens
 */
@ComponentV2
export struct WatchPaymentView {
  @Event onClose: () => void = () => {
  };
  @Local windowUtil: WindowUtil = AppStorageV2.connect(WindowUtil, CommonConstants.KEY_WINDOWUTIL)!;
  private context: UIContext = this.windowUtil.getUIContext() as UIContext;
  @Local pixelMap: image.PixelMap | undefined = undefined;
  private generateBarcodeViewModel: GenerateBarcodeViewModel = new GenerateBarcodeViewModel();

  aboutToAppear(): void {
    this.generateBarcodeViewModel.getGenerateBarCode()
      .then((result: image.PixelMap) => {
        this.pixelMap = result;
      })
      .catch((error: Error) => {
        Logger.error(TAG, 'Failed to generate barcode: %{public}s', error.message);
      });
  }

  build() {
    NavDestination() {
      Column({ space: $r('app.float.watch_payment_card_padding') }) {
        Text($r('app.string.payment_receipt_title'))
          .fontSize($r('app.float.watch_card_font_size'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.watch_text_primary'))
          .textAlign(TextAlign.Center)

        // QR code display area
        Column({ space: $r('app.float.wealth_section_space') }) {
          if (this.pixelMap) {
            Column() {
              Image(this.pixelMap)
                .width(this.context.px2vp(CommonConstants.WATCH_PIXEL_SIZE))
                .height(this.context.px2vp(CommonConstants.WATCH_PIXEL_SIZE))
                .objectFit(ImageFit.Contain)
            }
            .width(this.context.px2vp(CommonConstants.WATCH_PIXEL_BACKGROUND))
            .height(this.context.px2vp(CommonConstants.WATCH_PIXEL_BACKGROUND))
            .backgroundColor($r('app.color.card_background'))
            .borderRadius($r('app.float.watch_payment_card_radius'))
            .justifyContent(FlexAlign.Center)
            .shadow({
              radius: $r('app.float.function_item_radius'),
              color: $r('app.color.shadow_light'),
              offsetX: $r('app.float.watch_payment_shadow_offset_x'),
              offsetY: $r('app.float.watch_payment_shadow_offset_y')
            })
          } else {
            Column({ space: $r('app.float.bottom_function_space') }) {
              SymbolGlyph($r('sys.symbol.exclamationmark_circle'))
                .fontSize($r('app.float.watch_icon_bg_size'))
                .fontColor([$r('app.color.watch_text_secondary')])
              Text($r('app.string.reminder'))
                .fontSize($r('app.float.watch_location_icon_size'))
                .fontColor($r('app.color.watch_text_secondary'))
            }
          }

          Text(CommonConstants.NAME)
            .fontSize($r('app.float.watch_payment_username_font_size'))
            .fontColor($r('app.color.watch_text_primary'))
            .fontWeight(FontWeight.Medium)
        }
        .width(CommonConstants.FULL_WIDTH)
        .justifyContent(FlexAlign.Center)
      }
      .width(CommonConstants.FULL_WIDTH)
      .height(CommonConstants.FULL_HEIGHT)
      .padding({
        top: $r('app.float.watch_payment_container_padding_top')
      })
    }
    .hideTitleBar(true)
  }
}