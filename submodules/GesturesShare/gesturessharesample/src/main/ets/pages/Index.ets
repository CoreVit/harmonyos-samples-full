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

import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo, fileUri } from '@kit.CoreFileKit';
import { HdsNavigation } from '@kit.UIDesignKit';
import { BreakpointType, Constants, Logger } from 'gesturessharecommon';
import { FILE_SOURCES, FileData, IMAGE_DATA } from 'gesturesshareshare';

@Entry
@Component
struct Index {
  @StorageLink(Constants.KEY_BREAKPOINT) currentBreakpoint: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @StorageLink(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(Constants.KEY_NAV_INDICATOR_HEIGHT) navIndicatorHeight: number = 0;
  @StorageLink(Constants.KEY_IS_LINK) isShareLink: boolean = false;
  private pageInfos: NavPathStack = new NavPathStack();
  private context: common.UIAbilityContext | undefined =
    this.getUIContext().getHostContext() as common.UIAbilityContext | undefined;
  private dataList: FileData[] = FILE_SOURCES;

  aboutToAppear(): void {
    this.handleFileInit();
  }

  // [Start jumpLinkSharePage]
  onPageShow(): void {
    if (this.isShareLink) {
      this.pageInfos.pushPathByName('LinkSharePage', null, true);
    }
  }

  // [Start jumpLinkSharePage]
  build() {
    HdsNavigation(this.pageInfos) {
      Column({ space: Constants.PADDING_12 }) {
        Button($r('app.string.gestures_share_file'))
          .buttonStyle(ButtonStyleMode.NORMAL)
          .width('100%')
          .constraintSize({
            maxWidth: 448
          })
          .onClick(() => {
            this.pageInfos.pushPathByName('FileSharePage', null, true);
          })

        Button($r('app.string.gestures_share_link'))
          .buttonStyle(ButtonStyleMode.NORMAL)
          .width('100%')
          .constraintSize({
            maxWidth: 448
          })
          .onClick(() => {
            this.pageInfos.pushPathByName('LinkSharePage', null, true);
          })
      }
      .justifyContent(FlexAlign.End)
      .width('100%')
      .height('100%')
      .padding({
        left: new BreakpointType({
          sm: $r('sys.float.padding_level8'),
          md: $r('sys.float.padding_level12'),
          lg: $r('sys.float.padding_level16')
        }).getValue(this.currentBreakpoint),
        right: new BreakpointType({
          sm: $r('sys.float.padding_level8'),
          md: $r('sys.float.padding_level12'),
          lg: $r('sys.float.padding_level16')
        }).getValue(this.currentBreakpoint),
        top: this.statusBarHeight,
        bottom: this.navIndicatorHeight === 0 ? Constants.PADDING_32 : this.navIndicatorHeight + Constants.PADDING_16
      })
    }
    .titleBar({
      content: {
        title: {
          mainTitle: $r('app.string.index_title')
        }
      }
    })
    .transition(TransitionEffect.OPACITY)
    .hideToolBar(true)
    .mode(NavigationMode.Stack)
    .backgroundColor($r('sys.color.container_modal_unfocus_background'))
  }

  /**
   * Initialize operations to process files.
   */
  handleFileInit() {
    if (!this.context) {
      return;
    }
    let filesDir = this.context.filesDir;
    for (const item of this.dataList) {
      let file: fileIo.File | undefined = undefined;
      try {
        let url = filesDir + '/' + item.url;
        file = fileIo.openSync(url, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
        let writeLen =
          fileIo.writeSync(file.fd,
            (this.context.resourceManager.getRawFileContentSync(item.url) as Uint8Array).buffer);
        Logger.info(Constants.LOG_TAG, `write data to file succeed and size is : ${writeLen}`);
        item.url = fileUri.getUriFromPath(url);
      } catch (err) {
        let error = err as BusinessError;
        Logger.error(Constants.LOG_TAG, `Failed to save file. ${error.code} ${error.message}`);
      } finally {
        if (file) {
          fileIo.close(file).catch((error: BusinessError) => {
            Logger.error(Constants.LOG_TAG, `Failed to close file. ${error.code} ${error.message}`);
          });
        }
      }
      try {
        let imageData: Resource | undefined = IMAGE_DATA[item.index];
        if (!imageData) {
          continue;
        }
        let url = filesDir + '/' + item.thumbnail;
        file = fileIo.openSync(url, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
        let writeLen = fileIo.writeSync(file.fd,
          (this.context.resourceManager.getMediaContentSync(imageData.id) as Uint8Array).buffer);
        Logger.info(Constants.LOG_TAG, `write data to file success and size is : ${writeLen}`);
        item.thumbnail = fileUri.getUriFromPath(url);
      } catch (err) {
        let error = err as BusinessError;
        Logger.error(Constants.LOG_TAG, `Failed to save image. ${error.code} ${error.message}`);
      } finally {
        if (file) {
          fileIo.close(file).catch((error: BusinessError) => {
            Logger.error(Constants.LOG_TAG, `Failed to close file. ${error.code} ${error.message}`);
          });
        }
      }
    }
  }
}