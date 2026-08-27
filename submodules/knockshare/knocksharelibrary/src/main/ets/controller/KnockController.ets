/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { harmonyShare, systemShare } from '@kit.ShareKit';
import { fileUri } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { uniformTypeDescriptor } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { VIDEO_SOURCES, VideoData, VIDEO_NAME } from '../model/VideoData';
import { ConfigMapKey, ResourceUtil } from '../utils/ResourceUtil';
import Logger from '../utils/Logger';

const TAG = '[KnockShareSample]';

export class KnockController {
  private static controller: KnockController;
  private context: common.UIAbilityContext | undefined = undefined;
  private isKnockListening: boolean = false;

  public static getInstance(context: common.UIAbilityContext): KnockController {
    if (!KnockController.controller) {
      KnockController.controller = new KnockController(context);
    }
    return KnockController.controller;
  }

  constructor(context: common.UIAbilityContext) {
    this.context = context;
  }

  /**
   * knock listening callback
   * @param target After the Huawei Share event is triggered,
   * you can call back the parameters and share them across devices.
   */
  public immersiveCallback(target: harmonyShare.SharableTarget, videoIndex: number, context: common.UIAbilityContext) {
    if (videoIndex < 0 || videoIndex >= VIDEO_SOURCES.length || videoIndex >= VIDEO_NAME.length) {
      return;
    }
    // share app linking
    try {
      let videoData: VideoData = VIDEO_SOURCES[videoIndex];
      // Video thumbnail image sandbox path
      let filePath: string = context?.filesDir + `/${videoData.head}`;
      // Get video thumbnail URI path
      let coverUri: string = fileUri.getUriFromPath(filePath);
      let videoUrl: string =
        ResourceUtil.getRawFileStringByKey(context, VIDEO_NAME[videoIndex] as ConfigMapKey);
      let shareData: systemShare.SharedData = new systemShare.SharedData({
        // Set the shared data type to Link
        utd: uniformTypeDescriptor.UniformDataType.HYPERLINK,
        // The shared App Linking link is replaced with the real address here
        content: videoUrl,
        thumbnailUri: coverUri,
        title: videoData.name,
        description: videoData.description
      });
      // Initiate a share
      target.share(shareData).then(() => {
        Logger.info(TAG, 'Share link success');
      }).catch((error: BusinessError) => {
        Logger.error(TAG, `Share link  error. code: ${error.code}, message: ${error.message}`);
      });
    } catch (err) {
      Logger.error(TAG, `Share link exception. code: ${err.code}, message: ${err.message}`);
    }
  }

  /**
   *  Add knock listening
   */
  public immersiveListening(videoIndex: number, context: common.UIAbilityContext) {
    try {
      if (canIUse('SystemCapability.Collaboration.HarmonyShare')) {
        harmonyShare.on('knockShare', (target: harmonyShare.SharableTarget) => {
          this.immersiveCallback(target, videoIndex, context);
        });
        this.isKnockListening = true;
      }
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `KnockController immersiveListening error, code: ${err.code}, message: ${err.message}`);
    }
  }

  /**
   *  remove knock listening
   */
  public immersiveDisableListening() {
    try {
      if (canIUse('SystemCapability.Collaboration.HarmonyShare') && this.isKnockListening) {
        harmonyShare.off('knockShare');
        this.isKnockListening = false;
      }
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `KnockController immersiveDisableListening error, code: ${err.code}, message: ${err.message}`);
    }
  }
}