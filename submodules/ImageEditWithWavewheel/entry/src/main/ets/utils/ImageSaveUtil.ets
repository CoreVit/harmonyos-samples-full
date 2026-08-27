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
import { fileIo } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import Logger from './Logger';

const TAG = 'ImageSaveUtil';

export async function saveImageToGallery(
  previewPixelMap: image.PixelMap | undefined,
  context: common.UIAbilityContext,
  uiContext: UIContext
): Promise<void> {
  let tempFileUri: string = '';

  try {
    if (!previewPixelMap) {
      return;
    }

    let packer: image.ImagePacker = image.createImagePacker();
    let arrayBuffer: ArrayBuffer;
    try {
      let packOpts: image.PackingOption = {
        format: 'image/jpeg',
        quality: 95
      };
      arrayBuffer = await packer.packToData(previewPixelMap, packOpts);
    } finally {
      packer.release();
    }

    tempFileUri = context.filesDir + `/temp_edit_${Date.now()}.jpg`;
    let tempFile: fileIo.File = await fileIo.open(tempFileUri, fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY);
    try {
      await fileIo.write(tempFile.fd, arrayBuffer);
    } finally {
      fileIo.closeSync(tempFile);
    }

    let phAccessHelper: photoAccessHelper.PhotoAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
    let srcFileUris: string[] = [tempFileUri];
    let photoCreationConfigs: photoAccessHelper.PhotoCreationConfig[] = [
      {
        title: 'edited_image',
        fileNameExtension: 'jpg',
        photoType: photoAccessHelper.PhotoType.IMAGE,
        subtype: photoAccessHelper.PhotoSubtype.DEFAULT,
      }
    ];

    let desFileUris: string[] = await phAccessHelper.showAssetsCreationDialog(srcFileUris, photoCreationConfigs);

    if (!desFileUris || desFileUris.length === 0) {
      throw new Error(`Save was cancel by user.`);
    }

    let desFile: fileIo.File = await fileIo.open(desFileUris[0], fileIo.OpenMode.WRITE_ONLY);
    try {
      let srcFile: fileIo.File = await fileIo.open(tempFileUri, fileIo.OpenMode.READ_ONLY);
      try {
        await fileIo.copyFile(srcFile.fd, desFile.fd);
      } finally {
        fileIo.closeSync(srcFile);
      }
    } finally {
      fileIo.closeSync(desFile);
    }

    uiContext.getPromptAction().showToast({ message: $r('app.string.save_success'), duration: 2000 });
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    Logger.error(TAG, `save image failed, error ${err.code}: ${err.message}`);
    try {
      const saveFailedMsg = context.resourceManager.getStringByNameSync('save_failed') + (err as BusinessError).code;
      uiContext.getPromptAction().showToast({ message: saveFailedMsg, duration: 3000 });
    } catch (errorInner) {
      const errInner: BusinessError = errorInner as BusinessError;
      Logger.error(TAG, `failed to showToast, error ${errInner.code}: ${errInner.message}`);
    }
  } finally {
    if (tempFileUri) {
      try {
        fileIo.unlinkSync(tempFileUri);
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        Logger.error(TAG, `cleanup temp file failed, error ${err.code}: ${err.message}`);
      }
    }
  }
}
