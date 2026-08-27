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

import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from './Logger';

const TAG: string = '[SmartPhotoPickerUtils]';

export class SmartPhotoPickerUtils {
  photoPicker() {
    let option: photoAccessHelper.PhotoSelectOptions = {
      isPhotoTakingSupported: true,
      maxSelectNumber: 1,
      MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE
    };
    const photoPicker = new photoAccessHelper.PhotoViewPicker();
    try {
      photoPicker.select(option).then(() => {
        Logger.info(TAG, 'Create photoPicker success');
      }).catch((error: BusinessError) => {
        Logger.error(TAG, 'Create photoPicker failed, error.code = ' + error.code);
      });
    } catch (err) {
      Logger.error(TAG, 'Create photoPicker failed, err.code = ' + err.code);
    }
  }

  smartPhotoPickerByRecommendType(recommendType: number) {
    const photoPicker = new photoAccessHelper.PhotoViewPicker();
    let recommendationOptions: photoAccessHelper.RecommendationOptions = {
      recommendationType: recommendType
    };
    let option: photoAccessHelper.PhotoSelectOptions = {
      recommendationOptions: recommendationOptions,
      isPhotoTakingSupported: true,
      maxSelectNumber: 1,
      MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE
    };
    try {
      photoPicker.select(option).then(() => {
        Logger.info(TAG, 'Create photoPicker success');
      }).catch((error: BusinessError) => {
        Logger.error(TAG, 'Create photoPicker failed, error.code = ' + error.code);
      });
    } catch (err) {
      Logger.error(TAG, 'Create photoPicker failed, err.code = ' + err.code);
    }
  }

  smartPhotoPickerByTextInfo(content: string) {
    let photoPicker = new photoAccessHelper.PhotoViewPicker();
    let textInfo: photoAccessHelper.TextContextInfo = {
      text: content
    };
    let recommendationOptions: photoAccessHelper.RecommendationOptions = {
      textContextInfo: textInfo
    };
    let option: photoAccessHelper.PhotoSelectOptions = {
      recommendationOptions: recommendationOptions,
      isPhotoTakingSupported: true,
      maxSelectNumber: 1,
      MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE
    };
    try {
      photoPicker.select(option).then(() => {
        Logger.info(TAG, 'Create photoPicker success');
      }).catch((error: BusinessError) => {
        Logger.error(TAG, 'Create photoPicker failed, error.code = ' + error.code);
      });
    } catch (err) {
      Logger.error(TAG, 'Create photoPicker failed, err.code = ' + err.code);
    }
  }
}

export default new SmartPhotoPickerUtils();