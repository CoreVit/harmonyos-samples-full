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

// [Start FileSharePage]
import { filePreview } from '@kit.PreviewKit';
import { HdsNavDestination } from '@kit.UIDesignKit';
import { BreakpointType, Constants, FileUtil, Logger } from 'gesturessharecommon';
import { FILE_SOURCES, FileData, ShareType } from '../model/FileData';
import { ShareModel } from '../model/ShareModel';

@Component
export struct FileSharePageComponent {
  // [StartExclude FileSharePage]
  @StorageLink(Constants.KEY_BREAKPOINT) currentBreakpoint: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @StorageLink(Constants.KEY_IS_LINK) isShareLink: boolean = false;
  @StorageLink(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(Constants.KEY_NAV_INDICATOR_HEIGHT) navIndicatorHeight: number = 0;
  private shareModel: ShareModel | undefined = undefined;
  private pageInfos?: NavPathStack;
  // [EndExclude FileSharePage]
  // Pending shared data index.
  @State fileShare: number[] = [];
  // All file data collection.
  @State dataList: FileData[] = FILE_SOURCES;

  aboutToDisappear(): void {
    this.fileShare = [];
    this.shareModel?.setFileShare(this.fileShare);
  }

  build() {
    HdsNavDestination() {
      List({ space: Constants.PADDING_16 }) {
        ForEach(this.dataList, (item: FileData, index: number) => {
          ListItem() {
            Stack() {
              // [StartExclude FileSharePage]
              Column() {
                Image(item.thumbnail)
                  .width('100%')
                  .aspectRatio(1)
                  .borderRadius($r('sys.float.corner_radius_level5'))
                  .onClick(() => {
                    if (!canIUse('SystemCapability.FileManagement.FilePreview.Core')) {
                      return;
                    }
                    let uiContext = this.getUIContext().getHostContext();
                    if (!uiContext) {
                      return;
                    }
                    let displayInfo: filePreview.DisplayInfo = {
                      x: 100,
                      y: 100,
                      width: 800,
                      height: 800
                    };
                    let fileInfo: filePreview.PreviewInfo = {
                      title: item.name,
                      uri: item.url,
                      mimeType: FileUtil.getMimeTypeFromPath((item.url))
                    };
                    filePreview.openPreview(uiContext, fileInfo, displayInfo, (err) => {
                      if (err && err.code) {
                        Logger.error(Constants.LOG_TAG, `Failed to open preview. Cause: ${err.code}, ${err.message}`);
                        return;
                      }
                      Logger.info(Constants.LOG_TAG, 'Success in opening preview');
                    });
                  })
              }

              // [EndExclude FileSharePage]
              Column() {
                Checkbox({ name: index.toString(), group: 'checkboxGroup' })
                // [StartExclude FileSharePage]
                  .select(false)
                  .selectedColor('#0A59F7')
                  .unselectedColor(Color.White)
                  .shape(CheckBoxShape.CIRCLE)
                  .margin({
                    right: $r('sys.float.padding_level5')
                  })
                  // [EndExclude FileSharePage]
                  .onChange((value: boolean) => {
                    if (value) {
                      this.fileShare.push(index);
                    } else {
                      this.fileShare.splice(this.fileShare.indexOf(index), 1);
                    }
                    this.shareModel = ShareModel.getInstance();
                    this.shareModel.setFileShare(this.fileShare);
                    this.shareModel.setVideoDataList(this.dataList);
                  })
                // [StartExclude FileSharePage]
              }
              .layoutWeight(1)
            }
            .alignContent(Alignment.BottomEnd)
          }
        }, (item: FileData, index: number) => index + JSON.stringify(item))
      }
      .width('100%')
      .height('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .lanes(new BreakpointType({
        sm: Constants.LANES_2,
        md: Constants.LANES_4,
        lg: Constants.LANES_6
      }).getValue(this.currentBreakpoint), $r('sys.float.padding_level4'))
      .margin({
        top: Constants.WINDOW_NAV_HEIGHT
      })
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
        }).getValue(this.currentBreakpoint)
      })
      // [EndExclude FileSharePage]
    }
    // [StartExclude FileSharePage]
    .titleBar({
      content: {
        title: {
          mainTitle: $r('app.string.gestures_share_file')
        }
      }
    })
    .backgroundColor($r('sys.color.container_modal_unfocus_background'))
    .padding({
      top: this.statusBarHeight,
      bottom: this.navIndicatorHeight === 0 ? Constants.PADDING_16 : this.navIndicatorHeight
    })
    .onReady((ctx: NavDestinationContext) => {
      this.pageInfos = ctx.pathStack;
    })
    .onBackPressed(() => {
      this.fileShare = [];
      this.shareModel = ShareModel.getInstance();
      this.shareModel.setFileShare(this.fileShare);
      this.shareModel.setVideoDataList(this.dataList);
      return false;
    })
    // [EndExclude FileSharePage]
    .onShown(() => {
      // [StartExclude FileSharePage]
      if (this.isShareLink) {
        this.pageInfos?.pushPathByName('LinkSharePage', null, true);
        return;
      }
      if (!canIUse('SystemCapability.Collaboration.SystemShare')) {
        return;
      }
      // [EndExclude FileSharePage]
      this.shareModel = ShareModel.getInstance();
      this.shareModel.immersiveListening(ShareType.FILE_SHARE);
    })
    .onHidden(() => {
      this.shareModel = ShareModel.getInstance();
      this.shareModel.immersiveDisableListening();
    })
  }
}
// [End FileSharePage]

@Builder
export function FileSharePageComponentBuilder() {
  FileSharePageComponent()
}