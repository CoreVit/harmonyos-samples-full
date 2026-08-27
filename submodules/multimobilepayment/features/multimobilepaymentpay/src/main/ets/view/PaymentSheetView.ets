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

import { CommonConstants, getWindowInfoState, Logger, WindowInfo } from 'multimobilepaymentbase';
import { image } from '@kit.ImageKit';
import { GenerateBarcodeViewModel } from '../viewmodel/GenerateBarcodeViewModel';

const TAG = 'PaymentSheetView';

/**
 * Payment sheet view component
 * Displays payment receipt with QR code and action buttons
 * Supports responsive layout for different device sizes
 */
@ComponentV2
export struct PaymentSheetView {
  @Param isCenterMode: boolean = false;
  @Event onClose: () => void = () => {
  };
  @Local windowInfo: WindowInfo = getWindowInfoState();
  @Local pixelMap: image.PixelMap | undefined = undefined;
  private generateBarcodeViewModel: GenerateBarcodeViewModel = new GenerateBarcodeViewModel();

  aboutToAppear(): void {
    this.generateBarcodeViewModel.getGenerateBarCode().catch(() => {
      Logger.error(TAG, 'Failed to get generateBarCode');
    }).then((result: image.PixelMap | void) => {
      if (result) {
        this.pixelMap = result;
      }
    })
  }

  @Builder
  receiptCard() {
    Column({ space: $r('app.float.receiptCard_column_space') }) {
      Row({ space: $r('app.float.receiptCard_row_space') }) {
        Row() {
          Text('¥')
            .fontSize($r('app.float.currency_symbol_size'))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.on_primary'))
        }
        .width($r('app.float.currency_icon_size'))
        .height($r('app.float.currency_icon_size'))
        .backgroundColor($r('app.color.accent_orange'))
        .borderRadius($r('app.float.currency_icon_radius'))
        .justifyContent(FlexAlign.Center)
        .visibility(this.windowInfo.widthBp <= WidthBreakpoint.WIDTH_SM ? Visibility.Visible : Visibility.None)

        Text($r('app.string.payment_receipt_subtitle'))
          .fontSize($r('app.float.subtitle_font_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
      }
      .width(CommonConstants.FULL_WIDTH)
      .justifyContent(FlexAlign.Start)
      .padding({
        top: $r('app.float.receipt_card_padding_top'),
        left: this.windowInfo.widthBp <= WidthBreakpoint.WIDTH_SM ? $r('app.float.receipt_card_padding_horizontal_sm') :
          $r('app.float.receipt_card_padding_horizontal_lg'),
        right: this.windowInfo.widthBp <= WidthBreakpoint.WIDTH_SM ?
          $r('app.float.receipt_card_padding_horizontal_sm') : $r('app.float.receipt_card_padding_horizontal_lg')
      })
      .visibility(this.windowInfo.heightBp === HeightBreakpoint.HEIGHT_MD &&
        this.windowInfo.widthBp === WidthBreakpoint.WIDTH_SM ? Visibility.None : Visibility.Visible)

      Text($r('app.string.payment_name'))
        .fontSize($r('app.float.username_font_size'))
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: $r('app.float.username_margin_top') })

      if (this.pixelMap) {
        Image(this.pixelMap)
          .width($r('app.float.pixel_size'))
          .height($r('app.float.pixel_size'))
          .objectFit(ImageFit.Contain)
      }

      Row() {
        Button($r('app.string.payment_set_amount'))
          .fontSize($r('app.float.button_text_size'))
          .fontColor($r('app.color.primary60'))
          .backgroundColor(Color.Transparent)

        Divider()
          .vertical(true)
          .height($r('app.float.divider_height'))
          .color($r('app.color.primary20'))

        Button($r('app.string.payment_save_image'))
          .fontSize($r('app.float.button_text_size'))
          .fontColor($r('app.color.primary60'))
          .backgroundColor(Color.Transparent)
      }
      .width(CommonConstants.FULL_WIDTH)
      .height($r('app.float.action_bar_height'))
      .justifyContent(FlexAlign.SpaceEvenly)

      Blank()
        .visibility(this.windowInfo.widthBp <= WidthBreakpoint.WIDTH_SM ? Visibility.None : Visibility.Visible)

      this.functionItem(
        $r('sys.symbol.doc_text'),
        $r('app.string.payment_record')
      )

      if (this.windowInfo.widthBp > WidthBreakpoint.WIDTH_SM) {
        this.functionList()
      }
    }
    .width(CommonConstants.FULL_WIDTH)
    .backgroundColor($r('app.color.on_primary'))
    .borderRadius($r('app.float.receipt_card_radius'))
  }

  @Builder
  functionItem(icon: Resource, title: Resource) {
    Row({ space: $r('app.float.function_item_space') }) {
      SymbolGlyph(icon)
        .fontSize($r('app.float.function_item_icon_size'))
        .fontColor([$r('app.color.text_primary')])
      Text(title)
        .fontSize($r('app.float.function_item_text_size'))
        .fontColor($r('app.color.text_primary'))
      Blank()
      SymbolGlyph($r('sys.symbol.chevron_right'))
        .fontSize($r('app.float.function_item_icon_size'))
        .fontColor([$r('app.color.text_secondary')])
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(this.windowInfo.widthBp <= WidthBreakpoint.WIDTH_SM ? $r('app.float.function_item_height_sm') :
      $r('app.float.function_item_height_lg'))
    .padding({
      left: $r('app.float.function_item_padding_horizontal'),
      right: $r('app.float.function_item_padding_horizontal')
    })
    .backgroundColor($r('app.color.card_background'))
    .borderRadius($r('app.float.function_item_radius'))
  }

  @Builder
  functionList() {
    Column({ space: $r('app.float.function_list_space') }) {
      this.functionItem(
        $r('sys.symbol.briefcase'),
        $r('app.string.merchant_service')
      )

      this.functionItem(
        $r('sys.symbol.speaker_wave_2'),
        $r('app.string.voice_reminder')
      )
    }
    .width(CommonConstants.FULL_WIDTH)
  }

  @Builder
  backgroundSet() {
    Column()
      .width(CommonConstants.FULL_WIDTH)
      .height(CommonConstants.FULL_HEIGHT)
      .linearGradient({
        colors: [
          [$r('app.color.gradient_blue_start'), 0.0],
          [$r('app.color.gradient_blue_mid1'), 0.9],
          [$r('app.color.gradient_blue_mid2'), 1.0]
        ]
      })
  }

  build() {
    Scroll() {
      Column() {
        Row() {
          Button() {
            SymbolGlyph($r('sys.symbol.chevron_left'))
              .fontColor([$r('app.color.on_primary')])
              .fontSize($r('app.float.header_icon_size'))
          }
          .type(ButtonType.Circle)
          .width($r('app.float.header_button_size'))
          .height($r('app.float.header_button_size'))
          .backgroundColor($r('app.color.button_background_transparent'))
          .margin({ right: $r('app.float.header_button_margin') })
          .labelStyle({
            textAlign: TextAlign.Center
          })
          .onClick(() => {
            this.onClose();
          })
          .visibility(this.windowInfo.widthBp <= WidthBreakpoint.WIDTH_SM ? Visibility.Visible :
            Visibility.None)

          Text($r('app.string.payment_receipt_title'))
            .fontSize($r('app.float.header_title_font_size'))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.on_primary'))

          Blank()

          Button() {
            SymbolGlyph($r('sys.symbol.share'))
              .fontColor([$r('app.color.on_primary')])
              .fontSize($r('app.float.header_icon_size'))
          }
          .type(ButtonType.Circle)
          .width($r('app.float.header_button_size'))
          .height($r('app.float.header_button_size'))
          .backgroundColor($r('app.color.button_background_transparent'))
          .margin({ right: $r('app.float.header_button_margin') })
          .labelStyle({
            textAlign: TextAlign.Center
          })
          .visibility(this.windowInfo.widthBp <= WidthBreakpoint.WIDTH_SM ? Visibility.Visible :
            Visibility.None)
        }
        .width(CommonConstants.FULL_WIDTH)
        .height($r('app.float.header_height'))
        .visibility(this.windowInfo.widthBp <= WidthBreakpoint.WIDTH_SM ? Visibility.Visible : Visibility.None)
        .padding({
          left: $r('app.float.header_padding_horizontal'),
          right: $r('app.float.header_padding_horizontal')
        })

        Column() {
          Column({ space: $r('app.float.content_space') }) {
            this.receiptCard()
            if (this.windowInfo.widthBp <= WidthBreakpoint.WIDTH_SM) {
              this.functionList()
            }
          }
          .width(CommonConstants.FULL_WIDTH)
          .padding({
            left: $r('app.float.content_padding_horizontal'),
            right: $r('app.float.content_padding_horizontal'),
            bottom: $r('app.float.content_padding_bottom')
          })
        }
        .width(CommonConstants.FULL_WIDTH)
      }
      .width(CommonConstants.FULL_WIDTH)
    }
    .align(Alignment.TopStart)
    .height(CommonConstants.FULL_HEIGHT)
    .scrollBar(BarState.Off)
    .background(this.isCenterMode ? $r('app.color.card_background') : this.backgroundSet(),
      { ignoresLayoutSafeAreaEdges: [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM] })
  }
}