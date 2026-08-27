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
import { deviceInfo } from '@kit.BasicServicesKit';
import { ColorHsv, ColorRgb, ColorUtils } from '../utils/ColorUtils';
import { findMaxPixelValue, image2PixelMap, modifySVValue, traverseAllPixelValue } from '../utils/ImageUtils';
import { AppInfo } from '../viewmodel/AppInfoModel';
import CommonConstants from '../constants/CommonContants';
import MockDataModel from '../viewmodel/MockDataModel';
import { IconItem } from './IconItem';
import Logger from '../utils/Logger';
import { ImmersiveType, WindowUtil } from '../utils/WindowUtil';

const TAG: string = '[Index]';

@Entry
@Component
struct Index {
  private mockData = new MockDataModel();
  private arrayAppInfo: Array<AppInfo> = this.mockData.getArrayAppInfo();
  @StorageLink(CommonConstants.KEY_PREFIX + 'windowUtil') windowUtil: WindowUtil | undefined = undefined;
  @State is2in1Device: boolean = false;

  async aboutToAppear() {
    this.windowUtil?.setImmersiveType(ImmersiveType.IMMERSIVE);
    this.windowUtil?.startWindowStatusListener();
    this.is2in1Device = deviceInfo.deviceType === '2in1';
    for (const item of this.arrayAppInfo) {
      try {
        const pixelMap: image.PixelMap = await image2PixelMap(item.icon);
        const allPixelsValue: number[] = await traverseAllPixelValue(pixelMap);
        const maxPixel: number = findMaxPixelValue(allPixelsValue);
        let rgb: ColorRgb = ColorUtils.numberToRgb(maxPixel);
        const hsv: ColorHsv = ColorUtils.rgb2hsv(rgb);
        if (maxPixel !== -1) {
          modifySVValue(hsv);
        }
        rgb = ColorUtils.hsv2rgb(hsv);
        item.backgroundColor = ColorUtils.rgbToNumber(rgb);
        pixelMap.release();
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `Failed to get main window. code = ${err.code}, message = ${err.message}`);
      }
    }
  }

  aboutToDisappear() {
    this.windowUtil?.setImmersiveType(ImmersiveType.NORMAL);
    this.windowUtil?.release();
    AppStorage.delete(CommonConstants.KEY_PREFIX + 'windowUtil');
    AppStorage.delete(CommonConstants.KEY_PREFIX + 'UIContext');
  }

  build() {
    List({ space: CommonConstants.LIST_SPACE }) {
      ForEach(this.arrayAppInfo, (item: AppInfo) => {
        ListItem() {
          IconItem({ item: item })
            .margin({ left: $r('app.integer.list_item_margin'), right: $r('app.integer.list_item_margin') })
        }
      }, (item: AppInfo) => JSON.stringify(item))
    }
    .width($r('app.string.percent_100'))
    .height($r('app.string.percent_100'))
    .padding({ top: this.is2in1Device ? $r('app.integer.list_padding_big_top') : $r('app.integer.list_padding_top') })
  }
}