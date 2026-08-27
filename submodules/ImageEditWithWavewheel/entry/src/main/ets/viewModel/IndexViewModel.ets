/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { BusinessError, deviceInfo } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import { fileIo } from '@kit.CoreFileKit';
import {
  hdsMaterial, ScrollEffectType, TitleBarStyleOptions
} from '@kit.UIDesignKit';
import Logger from '../utils/Logger';
import { getResourceFd } from '../utils/DecodeUtil';
import { CommonConstants } from '../common/constant/CommonConstants';
import type { ImageInfoItem } from '../types/CommonTypes';

export interface InitDataResult {
  imageFile: fileIo.File | undefined;
  imageSource: image.ImageSource | undefined;
  imageInfoArr: ImageInfoItem[];
}

export class IndexViewModel {
  static initTitleBarStyle(): TitleBarStyleOptions {
    const titleBarStyle: TitleBarStyleOptions = {
      scrollEffectOpts: {
        enableScrollEffect: false,
        scrollEffectType: ScrollEffectType.COMMON_BLUR,
      },
      originalStyle: {
        contentStyle: {
          titleStyle: {
            mainTitleColor: Color.White,
          },
          menuStyle: {
            iconColor: Color.White,
          },
          backIconStyle: {
            iconColor: Color.White,
          }
        }
      }
    };
    try {
      let customMaterialLevel = hdsMaterial.MaterialLevel.ADAPTIVE;
      let materialTypes: hdsMaterial.MaterialType[] = hdsMaterial.getSystemMaterialTypes();
      if (materialTypes.indexOf(hdsMaterial.MaterialType.IMMERSIVE) >= 0) {
        customMaterialLevel = hdsMaterial.MaterialLevel.EXQUISITE;
      }

      const deviceTypeInfo: string = deviceInfo.deviceType;
      const isEnableMaterial: boolean =
        deviceTypeInfo === deviceInfo.DeviceTypes.TYPE_PHONE || deviceTypeInfo === deviceInfo.DeviceTypes.TYPE_TABLET;
      if (deviceInfo.sdkApiVersion >= 23 && isEnableMaterial) {
        titleBarStyle.systemMaterialEffect = {
          materialType: hdsMaterial.MaterialType.ADAPTIVE,
          materialLevel: customMaterialLevel,
        };
      }
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(`initTitleBarStyle failed, error ${err.code}: ${err.message}`);
    }
    return titleBarStyle;
  }

  static async initData(uiContext: UIContext): Promise<InitDataResult> {
    const imageInfoArr: ImageInfoItem[] = [];
    const file = await getResourceFd(uiContext);
    if (!file) {
      Logger.error('initData', 'Failed to get resource file');
      return { imageFile: undefined, imageSource: undefined, imageInfoArr: [] } as InitDataResult;
    }
    const imageSource = image.createImageSource(file.fd);

    try {
      await new Promise<void>((resolve, reject) => {
        imageSource.getImageInfo((err, info) => {
          if (err) {
            const bErr: BusinessError = err as BusinessError;
            Logger.error(`Failed to get image info, error ${err.code}: ${err.message}`);
            reject(err);
            return;
          }
          Object.keys(info).forEach((key) => {
            if (key === 'size') {
              Object.keys(info[key]).forEach((chlKey) => {
                imageInfoArr.push({
                  label: chlKey,
                  value: info[key][chlKey]
                });
              });
            } else {
              imageInfoArr.push({
                label: key,
                value: info[key]
              });
            }
          });
          resolve();
        });
      });
    } catch (error) {
      const bizError = error as BusinessError;
      Logger.error(`Failed to get image info, error ${bizError.code}: ${bizError.message}`);
      try {
        imageSource.release();
      } catch (releaseErr) {
        Logger.error(`Failed to release imageSource: ${(releaseErr as BusinessError).message}`);
      }
      try {
        fileIo.closeSync(file);
      } catch (closeErr) {
        Logger.error(`Failed to close file: ${(closeErr as BusinessError).message}`);
      }
      return { imageFile: undefined, imageSource: undefined, imageInfoArr: [] } as InitDataResult;
    }

    try {
      const result = await imageSource.getImageProperties(CommonConstants.IMG_PROPERTIES_KEYS);
      Object.keys(result).forEach((key) => {
        imageInfoArr.push({
          label: key,
          value: result[key]
        });
      });
    } catch (error) {
      const bizError = error as BusinessError;
      Logger.error(
        `code is ${bizError.code}, Failed to get the value of the specified attribute key of the image. ${bizError}`);
    }

    return { imageFile: file, imageSource, imageInfoArr } as InitDataResult;
  }
}
