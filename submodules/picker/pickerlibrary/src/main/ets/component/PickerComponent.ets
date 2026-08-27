/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { BusinessError } from '@kit.BasicServicesKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { picker } from '@kit.CoreFileKit';
import { CommonConstants } from '../common/CommonConstants';
import MediaFileUri from '../media/MediaFileUri';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import Logger from '../utils/Logger';
import { WindowUtil } from '../utils/WindowUtil';

const MAX_SELECT_NUM = 4; // Select the maximum number of media files.
const TAG = 'pickerIndex';

export interface UrisParam {
  uris: string[];
}

export interface FileParam {
  fileName: string;
  myUri: string;
  isCreate: boolean
}

@Component
export struct PickerComponent {
  @State uri: string = '';
  @State filename: string = '';
  @StorageProp(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageLink(CommonConstants.AS_KEY_FILE_NAME_LIST) fileNameList: Array<string> = [];
  @StorageLink(CommonConstants.AS_KEY_FILE_SIZE_LIST) fileSizeList: Array<number> = [];
  @StorageLink(CommonConstants.AS_KEY_FILE_URI_LIST) fileUriList: Array<string> = [];
  @Provide(CommonConstants.AS_KEY_PATH_STACK) pathStack: NavPathStack = new NavPathStack();
  mediaFileUri: MediaFileUri = new MediaFileUri();
  scroller: Scroller = new Scroller();

  // Pull up the picker to select files.
  async viewDocumentFile(): Promise<void> {
    try {
      let documentSelectOptions = new picker.DocumentSelectOptions();
      documentSelectOptions.maxSelectNumber = 1;
      let documentPicker = new picker.DocumentViewPicker();
      documentPicker.select(documentSelectOptions).then((documentSelectResult) => {
        if (!documentSelectResult) {
          Logger.error(TAG, 'DocumentViewPicker.select failed');
          return;
        }
        Logger.info(TAG, 'DocumentViewPicker.select successfully');
        this.uri = documentSelectResult[0];
        this.getFilenameByUri(this.uri, false);
      }).catch((err: BusinessError) => {
        Logger.error(TAG,
          `DocumentViewPicker.select failed with err, ErrorCode: ${err.code},  Message: ${err.message}`);
      });
    } catch (err) {
      Logger.error(TAG, 'DocumentViewPicker failed.');
    }
  }

  // Pull up the picker to save the file.
  async createDocumentFile(): Promise<void> {
    try {
      let documentSaveOptions = new picker.DocumentSaveOptions();
      documentSaveOptions.newFileNames = ['MyDocument_01.txt'];
      let documentPicker = new picker.DocumentViewPicker();
      documentPicker.save(documentSaveOptions).then((documentSaveResult) => {
        if (!documentSaveResult) {
          Logger.error(TAG, 'DocumentViewPicker.save failed.');
          return;
        }
        Logger.info(TAG, 'DocumentViewPicker.save successfully.');
        this.uri = documentSaveResult[0];
        this.getFilenameByUri(this.uri, true);
      }).catch((err: BusinessError) => {
        Logger.error(TAG, `DocumentViewPicker.save failed, ErrorCode: ${err.code}, Message: ${err.message}`);
      });
    } catch (err) {
      Logger.error(TAG, 'DocumentViewPicker failed.');
    }
  }

  async getFilenameByUriForMedia(myUris: string[]) {
    const params: UrisParam = {
      uris: myUris
    }
    this.pathStack.pushPathByName('ViewMedia', params)
  }

  async getFilenameByUri(myUri: string, created: boolean): Promise<void> {
    this.filename = decodeURI((myUri.split('/').pop()) as string);
    const params: FileParam = {
      fileName: this.filename,
      myUri: myUri,
      isCreate: created
    }
    this.pathStack.pushPathByName('EditFile', params)
  }

  // Pull up the picker to select images/videos.
  async callFilePickerSelectImage(): Promise<void> {
    let array: string[];
    try {
      let photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
      photoSelectOptions.maxSelectNumber = MAX_SELECT_NUM;
      let mediaFlag = false;
      // Create a PhotoViewPicker object.
      let photoPicker = new photoAccessHelper.PhotoViewPicker();
      photoPicker.select(photoSelectOptions).then((photoSelectResult) => {
        Logger.info(TAG,
          'PhotoViewPicker.select successfully.');
        if (photoSelectResult !== null && photoSelectResult !== undefined) {
          // Declare variable array, whose value is the array in PhotoSelectResult.
          array = photoSelectResult.photoUris;
          array.forEach((value) => {
            this.uri = value;
            mediaFlag = true;
            Logger.info(TAG, `select image/video succeed.`);
          })
        }
        if (mediaFlag) {
          this.getFilenameByUriForMedia(array);
        }
      }).catch((err: BusinessError) => {
        Logger.error(TAG, `PhotoViewPicker.select failed, ErrorCode: ${err.code}, Message: ${err.message}`);
      });
    } catch (err) {
      Logger.error(TAG, 'PhotoViewPicker failed.');
    }
  }

  aboutToDisappear(): void {
    this.fileNameList = [];
    this.fileSizeList = [];
    this.fileUriList = [];
    WindowUtil.unRegisterBreakPoint();
  }

  onPageShow(): void {
    this.mediaFileUri.getAllFiles();
  }

  build() {
    Scroll(this.scroller) {
      Row() {
        Navigation(this.pathStack) {
          Column() {
            Button($r('app.string.new_file'))
              .id('newFile')
              .fontSize(16)
              .width(this.curBp === 'sm' ? '100%' : 448)
              .height(40)
              .margin({ bottom: $r('sys.float.padding_level6') })
              .backgroundColor($r('sys.color.brand'))
              .onClick(() => {
                this.createDocumentFile();
              })

            Button($r('app.string.picture'))
              .id('picture')
              .fontSize(16)
              .width(this.curBp === 'sm' ? '100%' : 448)
              .height(40)
              .margin({ bottom: $r('sys.float.padding_level6') })
              .backgroundColor($r('sys.color.brand'))
              .onClick(() => {
                this.callFilePickerSelectImage();
              })

            Button($r('app.string.edit_file'))
              .id('folder')
              .fontSize(16)
              .width(this.curBp === 'sm' ? '100%' : 448)
              .height(40)
              .margin({ bottom: $r('sys.float.padding_level6') })
              .backgroundColor($r('sys.color.brand'))
              .onClick(() => {
                this.viewDocumentFile();
              })
          }
          .height(CommonConstants.FULL_PERCENT)
          .width(CommonConstants.FULL_PERCENT)
          .justifyContent(FlexAlign.End)
          .padding({
            top: this.statusBarHeight,
            bottom: this.navigatorBarHeight,
            right: new BreakpointType({
              sm: $r('sys.float.padding_level8'),
              md: $r('sys.float.padding_level0'),
              lg: $r('sys.float.padding_level0')
            }).getValue(this.curBp),
            left: new BreakpointType({
              sm: $r('sys.float.padding_level8'),
              md: $r('sys.float.padding_level0'),
              lg: $r('sys.float.padding_level0')
            }).getValue(this.curBp)
          })
        }
        .titleMode(NavigationTitleMode.Full)
        .mode(NavigationMode.Stack)
        .title(this.getTitle())
      }
      .padding({
        right: new BreakpointType({
          sm: $r('sys.float.padding_level0'),
          md: $r('sys.float.padding_level4'),
          lg: $r('sys.float.padding_level8')
        }).getValue(this.curBp),
        left: new BreakpointType({
          sm: $r('sys.float.padding_level0'),
          md: $r('sys.float.padding_level4'),
          lg: $r('sys.float.padding_level8')
        }).getValue(this.curBp)
      })
      .height(CommonConstants.FULL_PERCENT)
      .width(CommonConstants.FULL_PERCENT)
      .backgroundColor($r('sys.color.background_secondary'))
    }
  }

  getTitle(): string | undefined {
    try {
      return this.getUIContext().getHostContext()?.resourceManager.getStringSync($r('app.string.last_open').id);
    } catch (err) {
      Logger.error(TAG, `getStringSync failed, ErrorCode: ${err.code},  Message: ${err.message}`);
    }
    return '';
  }
}