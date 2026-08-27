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

import { image } from '@kit.ImageKit';
import { textRecognition } from '@kit.CoreVisionKit';
import { fileIo } from '@kit.CoreFileKit';
import { CommonConstants } from '../constants/CommonConstants';
import Logger from '../utils/Logger';

@Component
export struct TextRecognitionComponent {
  @State cardDataSource: Record<string, string>[] = [];
  @Consume(CommonConstants.KEY_PREFIX_SYSTEM_PATHSTACK) pathStack: NavPathStack;
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) currentBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @State isPresent: boolean = false;
  @State sdkApiVersion: number = 0;
  private imageSource: image.ImageSource | undefined = undefined;
  @State chooseImage: PixelMap | undefined = undefined;
  @State dataValues: string = '';
  private pageParam: string = '';

  async aboutToAppear(): Promise<void> {
    const initResult = await textRecognition.init();
    Logger.info('OCRDemo', `OCR service initialization result:${this.currentBp}`);
    this.loadImage(this.pageParam);
  }

  aboutToDisappear(): void {
    if (this.chooseImage && this.imageSource) {
      this.chooseImage.release();
      this.imageSource.release();
    }
  }

  @Builder
  msgDialogBuilder() {
    Column() {
      Text(this.dataValues)
        .width((CommonConstants.FULL_PERCENT))
        .fontSize(CommonConstants.CARD_FONT_SIZE)
    }
    .margin({
      left: $r('sys.float.padding_level16'),
      right: $r('sys.float.padding_level16'),
    })
  }

  private loadImage(name: string) {
    setTimeout(async () => {
      let fileSource = await fileIo.open(name, fileIo.OpenMode.READ_ONLY);
      this.imageSource = image.createImageSource(fileSource.fd);
      this.chooseImage = await this.imageSource.createPixelMap();
    }, CommonConstants.DURATION)
  }

  private async textRecognitionTest() {
    if (!this.chooseImage) {
      return;
    }

    if (this.dataValues.length > 0) {
      this.isPresent = !this.isPresent;
      return;
    }

    let visionInfo: textRecognition.VisionInfo = {
      pixelMap: this.chooseImage
    };
    let textConfiguration: textRecognition.TextRecognitionConfiguration = {
      isDirectionDetectionSupported: false
    };
    // Call the OCR API.
    let recognitionResult = await textRecognition.recognizeText(visionInfo, textConfiguration);
    let recognitionString = recognitionResult.value;
    this.dataValues = recognitionString;
    this.isPresent = !this.isPresent;
    Logger.info('OCRDemo', `Succeeded in recognizing text：${recognitionString}`);
  }

  build() {
    NavDestination() {
      Column() {
        Stack() {
          if (this.chooseImage) {
            Image(this.chooseImage)
              .objectFit(ImageFit.Contain)
              .width(CommonConstants.FULL_PERCENT)
              .height(CommonConstants.FULL_PERCENT)
          }
        }
        .layoutWeight(1)
        .width(CommonConstants.FULL_PERCENT)
        .backgroundColor($r('sys.color.comp_background_tertiary'))

        Stack() {
          Button($r('app.string.btn_recognize_result'), { stateEffect: true, type: ButtonType.Capsule })
            .width(this.currentBp == WidthBreakpoint.WIDTH_SM ? CommonConstants.FULL_PERCENT :
                   CommonConstants.BTN_MAX_WIDTH)
            .height(CommonConstants.BTN_HEIGHT)
            .onClick(() => {
              this.textRecognitionTest();
            })
        }
        .height(CommonConstants.BOTTOM_BTN_BG)
        .backgroundColor($r('sys.color.ohos_id_color_background'))
        .padding({
          top: 16,
          right: this.currentBp === WidthBreakpoint.WIDTH_SM ? $r('sys.float.padding_level8') :
                 $r('sys.float.padding_level0'),
          left: this.currentBp === WidthBreakpoint.WIDTH_SM ? $r('sys.float.padding_level8') :
                $r('sys.float.padding_level0'),
          bottom: CommonConstants.BOTTOM_MARGIN
        })
      }
      .bindSheet($$this.isPresent, this.msgDialogBuilder(), {
        height: SheetSize.MEDIUM,
        preferType: SheetType.CENTER,
        title: { title: $r('app.string.btn_result_title') },
        onWillDisappear: () => {
        }
      })
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .justifyContent(FlexAlign.End)
    }
    .backgroundColor($r('sys.color.ohos_id_color_background'))
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .hideTitleBar(false)
    .onReady((context: NavDestinationContext) => {
      this.pageParam = context.pathInfo.param as string;
    })
  }
}