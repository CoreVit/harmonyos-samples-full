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

import { BusinessError } from '@kit.BasicServicesKit';
import { camera, cameraPicker } from '@kit.CameraKit';
import { common } from '@kit.AbilityKit';
import Logger from './Logger';

const TAG: string = '[cameraCapture]';

export async function cameraCapture(context: common.UIAbilityContext): Promise<string> {
  try {
    const cameraPosition: camera.CameraPosition[] =
      [camera.CameraPosition.CAMERA_POSITION_UNSPECIFIED, camera.CameraPosition.CAMERA_POSITION_BACK,
        camera.CameraPosition.CAMERA_POSITION_FRONT];
    const pickerProfile: cameraPicker.PickerProfile = { cameraPosition: cameraPosition[1] };
    const mediaType: cameraPicker.PickerMediaType[] =
      [cameraPicker.PickerMediaType.PHOTO, cameraPicker.PickerMediaType.VIDEO];
    const pickerResult: cameraPicker.PickerResult =
      await cameraPicker.pick(context, [mediaType[0]], pickerProfile);
    let resourceUri: string = pickerResult.resultUri;
    Logger.info(TAG, 'Succeeded in cameraCapture');
    if (resourceUri !== undefined && resourceUri !== '') {
      return resourceUri;
    } else {
      return '';
    }
  } catch (error) {
    let err = error as BusinessError;
    Logger.error(TAG, `the pick call failed. error code: ${err.code}`);
    return '';
  }
}