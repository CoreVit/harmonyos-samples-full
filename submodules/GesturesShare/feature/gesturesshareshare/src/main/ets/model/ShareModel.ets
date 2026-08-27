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

import { uniformTypeDescriptor } from '@kit.ArkData';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileUri } from '@kit.CoreFileKit';
// [Start importShare]
import { harmonyShare, systemShare } from '@kit.ShareKit';
import { ConfigMapKey, Constants, Logger, ResourceUtil } from 'gesturessharecommon';
import { FileData, ShareType, VIDEO_SOURCES } from './FileData';

// [Start importShare]
export class ShareModel {
  private static controller: ShareModel;
  // The index of shared files.
  private fileShare: number[] = [];
  // All file data.
  private videoDataList: FileData[] = [];
  // Video playback index.
  private videoIndex: number = 0;

  /**
   * Initialize a shareModel instance.
   *
   * @param context common.UIAbilityContext.
   * @returns ShareModel.
   */
  public static getInstance(): ShareModel {
    if (!ShareModel.controller) {
      ShareModel.controller = new ShareModel();
    }
    return ShareModel.controller;
  }

  constructor() {
  }

  // [Start ShareListening]
  /**
   *  Add gesturesShare listening.
   */
  public immersiveListening(shareType: ShareType) {
    if (canIUse('SystemCapability.Collaboration.HarmonyShare')) {
      const context: UIContext | undefined = AppStorage.get<UIContext>(Constants.KEY_UI_CONTEXT);
      if (context) {
        window.getLastWindow(context.getHostContext()).then((data) => {
          try {
            let mainWindowID: number = data.getWindowProperties().id;
            harmonyShare.on('gesturesShare', { windowId: mainWindowID }, (target: harmonyShare.SharableTarget) => {
              this.immersiveCallback(target, shareType);
            });
          } catch (err) {
            let error = err as BusinessError;
            Logger.error(Constants.LOG_TAG, `getWindowProperties error ${error.code} ${error.message}`);
          }
        }).catch((error: BusinessError) => {
          Logger.error(Constants.LOG_TAG, `immersiveListening error ${error.code} ${error.message}`);
        })
      }
    }
  }

  /**
   *  Remove gesturesShare listening.
   */
  public immersiveDisableListening() {
    if (canIUse('SystemCapability.Collaboration.HarmonyShare')) {
      const context: UIContext | undefined = AppStorage.get<UIContext>(Constants.KEY_UI_CONTEXT);
      if (context) {
        window.getLastWindow(context.getHostContext()).then((data) => {
          try {
            let mainWindowID: number = data.getWindowProperties().id;
            harmonyShare.off('gesturesShare', { windowId: mainWindowID });
          } catch (error) {
            let err = error as BusinessError;
            Logger.error(Constants.LOG_TAG, `getWindowProperties error ${err.code} ${err.message}`);
          }
        }).catch((error: BusinessError) => {
          Logger.error(Constants.LOG_TAG, `immersiveDisableListening error ${error.code} ${error.message}`);
        })
      }
    }
  }
  // [End ShareListening]

  /**
   * GesturesShare listening callback.
   *
   * @param target After the Huawei Share event is triggered,
   * you can call back the parameters and share them across devices.
   */
  // [Start ShareCallback]
  public immersiveCallback(target: harmonyShare.SharableTarget, shareType: ShareType) {
    if (shareType === ShareType.FILE_SHARE) {
      if (!this.fileShare || this.fileShare.length === 0) {
        return;
      }
      let shareData: systemShare.SharedData = this.getFileShareData();
      target.share(shareData);
    } else {
      let shareData: systemShare.SharedData = this.getLinkShareData();
      target.share(shareData);
    }
  }
  // [End ShareCallback]

  // [Start FileShareData]
  /**
   * Get file Share data.
   * @returns systemShare.SharedData.
   */
  private getFileShareData(): systemShare.SharedData {
    let firstData: FileData | undefined = this.videoDataList[this.fileShare[0]];
    if (!firstData) {
      return new systemShare.SharedData({ utd: uniformTypeDescriptor.UniformDataType.TEXT, content: '' });
    }
    let shareData: systemShare.SharedData = new systemShare.SharedData(this.getShareRecord(firstData));
    try {
      for (let i = 1; i < this.fileShare.length; i++) {
        let data: FileData | undefined = this.videoDataList[this.fileShare[i]];
        if (data) {
          shareData.addRecord(this.getShareRecord(data));
        }
      }
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(Constants.LOG_TAG, `shareData.addRecord error ${error.code} ${error.message}`);
    }
    return shareData;
  }

  /**
   * Get shared data.
   *
   * @param data File data to be shared.
   * @returns systemShare.SharedRecord.
   */
  private getShareRecord(data: FileData): systemShare.SharedRecord {
    let suffix = '.' + data.url.split('.').pop();
    // Obtain the UTD through the file extension.
    let utd = uniformTypeDescriptor.getUniformDataTypeByFilenameExtension(suffix);
    Logger.info(Constants.LOG_TAG, `getShareRecord utd ${utd}`);
    return {
      utd: utd,
      uri: data.url,
      thumbnailUri: data.thumbnail,
      title: data.name,
      description: data.description
    };
  }
  // [End FileShareData]

  /**
   * Get link share data.
   * @returns systemShare.SharedData.
   */
  // [Start LinkShareData]
  getLinkShareData(): systemShare.SharedData {
    const shareUrl: string = ResourceUtil.getRawFileStringByKey(ConfigMapKey.SHARE_URL) as string;
    if (this.videoIndex < 0 || this.videoIndex >= VIDEO_SOURCES.length) {
      return new systemShare.SharedData({
        utd: uniformTypeDescriptor.UniformDataType.HYPERLINK,
        content: ''
      });
    }
    const videoData: FileData = VIDEO_SOURCES[this.videoIndex];
    const context: UIContext | undefined = AppStorage.get<UIContext>(Constants.KEY_UI_CONTEXT);
    const hostContext: Context | undefined = context?.getHostContext();
    const filePath: string = hostContext ? hostContext.filesDir + `/${videoData.thumbnail}` : '';
    let coverUri: string = '';
    try {
      coverUri = fileUri.getUriFromPath(filePath);
    } catch (err) {
      coverUri = '';
      let error = err as BusinessError;
      Logger.error(Constants.LOG_TAG,
        `Failed to get the uri from the path of file in app sandbox, error ${error.code} ${error.message}`);
    }
    let shareData: systemShare.SharedData = new systemShare.SharedData({
      utd: uniformTypeDescriptor.UniformDataType.HYPERLINK,
      content: `${shareUrl}?videoIndex=${this.videoIndex}`,
      thumbnailUri: coverUri,
      title: videoData.name,
      description: videoData.description
    });
    return shareData;
  }
  // [End LinkShareData]

  public getFileShare(): number[] {
    return this.fileShare;
  }

  public setFileShare(value: number[]) {
    this.fileShare = value;
  }

  public getVideoDataList(): FileData[] {
    return this.videoDataList;
  }

  public setVideoDataList(value: FileData[]) {
    this.videoDataList = value;
  }

  public getVideoIndex(): number {
    return this.videoIndex;
  }

  public setVideoIndex(value: number) {
    this.videoIndex = value;
  }
}