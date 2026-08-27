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

import { image } from '@kit.ImageKit';
import { generateBarcode, scanCore } from '@kit.ScanKit';
import { CommonConstants } from 'multimobilepaymentbase';

/**
 * ViewModel for generating barcode/QR code images
 * Uses ScanKit to create barcode images with configurable options
 */
@ObservedV2
export class GenerateBarcodeViewModel {
  /**
   * Generate a QR code barcode image
   * @returns Promise containing the generated PixelMap image
   * @throws Error if barcode generation fails
   */
  public getGenerateBarCode(): Promise<image.PixelMap> {
    let content = CommonConstants.NAME;
    if (canIUse('SystemCapability.Multimedia.Scan.Core') &&
      canIUse('SystemCapability.Multimedia.Scan.GenerateBarcode')) {
      let options: generateBarcode.CreateOptions = {
        scanType: scanCore.ScanType.QR_CODE,
        height: CommonConstants.BAR_CODE_SIZE,
        width: CommonConstants.BAR_CODE_SIZE,
        level: generateBarcode.ErrorCorrectionLevel.LEVEL_H,
        backgroundColor: 0xffffff,
        pixelMapColor: 0x000000
      };
      return generateBarcode.createBarcode(content, options);
    }
    return Promise.reject(new Error('Barcode generation is not supported on this device'));
  }
}