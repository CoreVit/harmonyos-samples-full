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

import { DocType, DocumentScanner, DocumentScannerConfig, FilterId, SaveOption, ShootingMode } from '@kit.VisionKit';
import Constants from '../constants/Constants';
import { FileUtil } from '../constants/utils/FileUtil';
import Logger from '../constants/utils/Logger';

const TAG: string = 'DocDemoPage';

@Builder
export function DocScanBuilder() {
  DocScanComponent()
}

@Component
export struct DocScanComponent {
  @StorageProp(Constants.KEY_BREAKPOINT) docScanBreakpoint: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(Constants.KEY_NAV_INDICATOR_HEIGHT) navIndicatorHeight: number = 0;
  @State saveDocType: SaveOption = SaveOption.JPG;
  @State docUris: string[] = [];
  @State filePath: string = '';
  @State fileSize: number = 0;
  @State isScanFinished: boolean = false;
  private context: Context = this.getUIContext().getHostContext() as Context;
  private pathStack: NavPathStack = new NavPathStack();
  private docScanConfig = new DocumentScannerConfig();

  aboutToAppear() {
    if (canIUse('SystemCapability.AI.Component.DocScan')) {
      this.docScanConfig.supportType = [DocType.DOC];
      this.docScanConfig.saveOptions = [SaveOption.JPG, SaveOption.PDF];
      this.docScanConfig.isGallerySupported = true;
      this.docScanConfig.editTabs = [];
      this.docScanConfig.maxShotCount = 1;
      this.docScanConfig.defaultFilterId = FilterId.ORIGINAL;
      this.docScanConfig.defaultShootingMode = ShootingMode.MANUAL;
      this.docScanConfig.isShareable = true;
      this.docScanConfig.originalUris = [];
    }
  }

  build() {
    NavDestination() {
      Stack() {
        DocumentScanner({
          scannerConfig: this.docScanConfig,
          onResult: (code: number, saveType: SaveOption, uris: string[]) => {
            Logger.info(TAG, `Result code: ${code}, save: ${saveType}`);
            this.isScanFinished = true;
            if (code === 200) {
              if (uris.length > 0) {
                let res = FileUtil.accessFileSync(uris[0]);
                if (!res) {
                  this.filePath = FileUtil.getFilePath(this.context, uris[0]);
                  Logger.info(TAG, `Source file path: ${uris[0]}, target file path: ${this.filePath}`);
                  FileUtil.readWriteFile(uris[0], this.filePath);
                  this.saveDocType = saveType;
                  this.docUris = uris;
                }
              }
            } else {
              this.pathStack.pop();
            }
          }
        })
          .visibility(this.isScanFinished ? Visibility.None : Visibility.Visible)
          .size({ width: '100%', height: '100%' })
        Column() {
          Row() {
            Button({ type: ButtonType.Circle }) {
              SymbolGlyph($r('sys.symbol.chevron_backward'))
                .fontColor([$r('sys.color.icon_primary')])
                .fontSize($r('sys.float.Title_M'))
            }
            .height($r('sys.float.ohos_id_button_height'))
            .aspectRatio(1)
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .onClick(() => {
              this.pathStack.pop();
            })

            Text($r('app.string.scan_result'))
              .margin({ left: $r('sys.float.padding_level4') })
              .fontSize($r('sys.float.Title_S'))
              .fontColor($r('sys.color.font_primary'))
              .fontWeight(FontWeight.Bold)
          }
          .width('100%')
          .height($r('sys.float.ohos_id_navigation_bar_height'))
          .margin({ bottom: $r('sys.float.padding_level8') })
          .alignItems(VerticalAlign.Center)

          if (this.docUris.length > 0 && this.saveDocType === SaveOption.JPG) {
            Row() {
              Image($r('app.media.ic_grid_image'))
                .aspectRatio(1)
                .width($r('sys.float.ohos_id_radio_size'))
                .margin({ right: $r('sys.float.padding_level8') })
              Column() {
                Text(FileUtil.getFileName(this.filePath))
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.MARQUEE })
                  .fontSize($r('sys.float.Body_L'))
                  .fontColor($r('sys.color.font_primary'))
                  .fontWeight(FontWeight.Bold)
                  .margin({ bottom: $r('sys.float.padding_level3') })

                Text(`${FileUtil.getFileSize(this.filePath)}M`)
                  .fontSize($r('sys.float.Subtitle_S'))
                  .fontColor($r('sys.color.font_secondary'))
                  .fontWeight(FontWeight.Medium)
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.Center)
              .width('100%')
              .height('100%')
            }
            .padding($r('sys.float.padding_level6'))
            .backgroundColor($r('sys.color.background_primary'))
            .border({ radius: $r('sys.float.corner_radius_level8') })
            .width('100%')
            .height($r('app.float.result_item_height'))
            .onClick(() => {
              this.pathStack.pushPathByName('imageViewer', this.docUris[0]);
            })
          } else if (this.docUris.length > 0 && this.saveDocType === SaveOption.PDF) {
            Row() {
              Image($r('app.media.ic_grid_documents'))
                .aspectRatio(1)
                .width($r('sys.float.ohos_id_radio_size'))
                .margin({ right: $r('sys.float.padding_level8') })

              Column() {
                Text(FileUtil.getFileName(this.filePath))
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.MARQUEE })
                  .fontSize($r('sys.float.Body_L'))
                  .fontColor($r('sys.color.font_primary'))
                  .fontWeight(FontWeight.Bold)
                  .margin({ bottom: $r('sys.float.padding_level3') })
                Text(`${FileUtil.getFileSize(this.filePath)}M`)
                  .fontSize($r('sys.float.Subtitle_S'))
                  .fontColor($r('sys.color.font_secondary'))
                  .fontWeight(FontWeight.Medium)
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.Center)
              .width('100%')
              .height('100%')
            }
            .padding($r('sys.float.padding_level6'))
            .backgroundColor($r('sys.color.background_primary'))
            .border({ radius: $r('sys.float.corner_radius_level8') })
            .width('100%')
            .height($r('app.float.result_item_height'))
            .onClick(() => {
              this.pathStack.pushPathByName('pdfViewer', this.filePath);
            })
          }
          Blank()
          Button($r('app.string.button_home'))
            .type(ButtonType.Capsule)
            .buttonStyle(ButtonStyleMode.NORMAL)
            .width(this.docScanBreakpoint === WidthBreakpoint.WIDTH_SM ? '100%' : $r('app.float.button_width'))
            .height($r('sys.float.ohos_id_button_height'))
            .margin({
              top: $r('sys.float.corner_radius_level6'),
              bottom: $r('sys.float.corner_radius_level8')
            })
            .onClick(() => {
              this.pathStack.pop();
            })
        }
        .padding({
          left: $r('sys.float.padding_level8'),
          right: $r('sys.float.padding_level8')
        })
        .justifyContent(FlexAlign.Start)
        .visibility(this.docUris.length > 0 ? Visibility.Visible : Visibility.None)
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .height('100%')
    }
    .padding({
      top: this.statusBarHeight
    })
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx.pathStack;
    })
    .backgroundColor($r('sys.color.background_secondary'))
    .hideTitleBar(true)
  }
}
