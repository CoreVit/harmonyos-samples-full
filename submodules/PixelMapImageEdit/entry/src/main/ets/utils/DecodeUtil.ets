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

import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';
import { fileIo } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from './Logger';
import { CommonConstants } from '../common/constant/CommonConstants';


const TAG: string = 'imageEdit_Decode';

/**
 * Async get resource file.
 *
 * @return file object containing fd, caller is responsible for closing.
 */
export async function getResourceFd(uiContext: UIContext, uri: string = ''): Promise<fileIo.File | undefined> {
  const context = uiContext.getHostContext() as common.UIAbilityContext;
  const resourceMgr = context.resourceManager;

  let filePath: string;
  let file: fileIo.File;

  try {
    if (uri === '') {
      let imageBuffer = await resourceMgr.getMediaContent($r('app.media.ic_low').id);

      filePath = context.cacheDir + '/' + CommonConstants.RAW_FILE_NAME;
      file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
      fileIo.writeSync(file.fd, imageBuffer.buffer);
    } else {
      file = fileIo.openSync(uri, fileIo.OpenMode.READ_ONLY);
    }
    return file;
  } catch (err) {
    let error = err as BusinessError;
    Logger.error(TAG, `${error.code}, ${error.message}`);
    return;
  }
}

/**
 * Async create pixel map.
 *
 * @return pixelMa.
 */
export async function decodePixelMapFromImageSource(imageSource: image.ImageSource) {
  if (!imageSource) {
    Logger.error(TAG, 'imageSourceAPI created failed!');
    return;
  }
  let decodingOptions: image.DecodingOptions = {
    editable: true,
    desiredPixelFormat: 3,
    /**
     * Setting to AUTO will decode based on the image resource format.
     * If the image resource is an HDR resource, it will be decoded as an HDR pixel map
     */
    desiredDynamicRange: image.DecodingDynamicRange.AUTO
  };
  const pixelMap = await imageSource.createPixelMap(decodingOptions);

  return pixelMap;
}