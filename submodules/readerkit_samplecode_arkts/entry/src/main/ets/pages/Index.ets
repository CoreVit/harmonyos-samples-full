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

import { picker } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { display } from '@kit.ArkUI';
import { readerCore } from '@kit.ReaderKit';
import { WindowAbility } from '../entryability/WindowAbility';
import { LocalBookImporter } from '../common/LocalBookImporter';
import { BookUtils } from '../utils/BookUtils';
import Logger from '../utils/Logger';
import CommonConstants from '../constants/CommonConstants';

const TAG: string = 'IndexPage';

@Entry
@Component
struct Index {
  private filePath: string = '';
  @State bookName: string = '';
  private curBp: string | undefined = '';
  @State isWide: boolean = false;
  @State isHalfFolded: boolean = false;
  @State oldFoldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
  /**
   * Page data information, used here to get the reading progress of the book
   */
  @StorageLink(CommonConstants.KEY_CURRENT_DATA) currentData: readerCore.PageDataInfo | null = null;
  /**
   * System font scaled density is changed? If it has changed, the reader needs to be restarted.
   */
  @StorageLink(CommonConstants.KEY_IS_DENSITY_CHANGE) isDensityChange: boolean = false;
  onFoldStatusChange: (foldStatus: display.FoldStatus) => void = (foldStatus: display.FoldStatus) => {
    Logger.info(TAG, 'aboutToAppear1-' + foldStatus);
    if (foldStatus === display.FoldStatus.FOLD_STATUS_HALF_FOLDED && this.curBp === 'sm') {
      this.isHalfFolded = true;
    } else if (foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED) {
      this.isHalfFolded = false;
    }
    this.oldFoldStatus = foldStatus;
  }

  async aboutToAppear() {
    WindowAbility.getInstance().toggleWindowSystemBar(['status', 'navigation'], this.getUIContext().getHostContext());
    this.curBp = AppStorage.get(CommonConstants.KEY_PREFIX + 'currentBreakpoint');
    if (this.curBp === 'lg' || this.curBp === 'xl' || this.curBp === 'xxl') {
      this.isWide = true;
    }
    try {
      display.on('foldStatusChange', this.onFoldStatusChange);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error('MultiDeviceCamera',
        `Failed to obtain fold status. Code: ${err.code}, message: ${err.message}`);
    }
  }

  onPageShow(): void {
    WindowAbility.getInstance().toggleWindowSystemBar(['status', 'navigation'], this.getUIContext().getHostContext());
    if (this.isDensityChange) {
      // Restart the reader page.
      this.jumper();
      AppStorage.setOrCreate(CommonConstants.KEY_IS_DENSITY_CHANGE, false);
    }
  }

  private async loadBook() {
    try {
      // Initialize the file selector.
      let documentSelectOptions = new picker.DocumentSelectOptions();
      // Set file type selection.
      documentSelectOptions.fileSuffixFilters = ['.epub', '.txt', '.mobi', '.azw', '.azw3'];
      let documentPicker = new picker.DocumentViewPicker();
      let documentSelectResult = await documentPicker.select(documentSelectOptions);
      if (!documentSelectResult || documentSelectResult.length <= 0) {
        Logger.error(TAG, 'loadBook failed');
        return;
      }
      // Obtain the book file path.
      let srcFile: string = decodeURI(documentSelectResult[0]);
      Logger.info(TAG, 'loadBook decodeURI succeeded. ' + srcFile);
      let importer = new LocalBookImporter();
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      let bookParserInfo = await importer.importLocalBookToCache(srcFile,
        BookUtils.getBookFileLocalBookPath(context.filesDir));
      this.filePath = bookParserInfo.getFilePath();
      this.bookName = bookParserInfo.getBookName();
      Logger.info(TAG, 'loadBook bookParserInfo parse succeeded,dest path is: ' + this.filePath);
      this.getUIContext()
        .getPromptAction()
        .showToast({ message: $r('app.string.import_successful_tips'), duration: 2000 });
      this.currentData = null;
    } catch (error) {
      Logger.error(TAG, `loadBook failed , Code: ${error.code}, message: ${error.message}`);
    }
  }

  build() {
    RelativeContainer() {
      Column() {
        Text($r('app.string.EntryAbility_label'))
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .margin({ top: this.isHalfFolded ? 36 : 100 })
          .height(56)
          .alignSelf(ItemAlign.Start)

        Text($r('app.string.book_name'))
          .fontSize(14)
          .fontColor($r('app.color.black_60_opacity'))
          .alignSelf(ItemAlign.Start)
          .margin({ top: 28, left: 16 })
          .visibility(this.bookName ? Visibility.Visible : Visibility.Hidden)

        Text(this.bookName)
          .fontSize(16)
          .fontColor($r('app.color.black_90_opacity'))
          .backgroundColor(Color.White)
          .borderRadius(16)
          .width('100%')
          .height(56)
          .margin({ top: 8 })
          .padding({ left: 16 })
          .visibility(this.bookName ? Visibility.Visible : Visibility.Hidden)
      }
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        start: { anchor: '__container__', align: HorizontalAlign.Start }
      })

      Column() {
        GridRow({
          columns: {
            xs: 1,
            sm: 1,
            md: 1,
            lg: 2,
            xl: 2,
            xxl: 2
          },
          breakpoints: {
            value: ['320vp', '600vp', '840vp', '1440vp', '1600vp'],
            reference: BreakpointsReference.WindowSize
          }
        }) {
          GridCol({ span: 1 }) {
            Row() {
              Button($r('app.string.import_book'))
                .width(this.isHalfFolded ? 294 : 328)
                .height(40)
                .backgroundColor($r('app.color.blue'))
                .onClick(async () => {
                  this.loadBook();
                })
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
          }

          GridCol({ span: 1 }) {
            Row() {
              Button(this.currentData ? $r('app.string.continue_reading') : $r('app.string.go_to_reader'))
                .width(this.isHalfFolded ? 294 : 328)
                .height(40)
                .fontColor(this.currentData ? Color.White : $r('app.color.blue'))
                .backgroundColor(this.currentData ? $r('app.color.blue') : $r('app.color.black_5_opacity'))
                .onClick(async () => {
                  if (!this.filePath) {
                    await this.loadBook();
                  }
                  this.jumper();
                })
            }
            .width('100%')
            .margin({ top: this.isWide ? 0 : 12 })
            .justifyContent(FlexAlign.Center)
          }
        }
        .margin({
          top: 12,
          bottom: this.isHalfFolded ? 16 : 44
        })
        .width(680)
        .onBreakpointChange((breakPoint) => {
          this.curBp = breakPoint;
          if (this.curBp === 'lg' || this.curBp === 'xl' || this.curBp === 'xxl') {
            this.isWide = true;
          } else {
            this.isWide = false;
          }
        })
      }
      .width('100%')
      .alignRules({
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
        start: { anchor: '__container__', align: HorizontalAlign.Start }
      })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.page_background'))
    .padding({ left: 16, right: 16 })
  }

  private jumper() {
    if (!this.filePath) {
      return;
    }
    AppStorage.setOrCreate(CommonConstants.KEY_FILE_PATH, this.filePath);
    this.getUIContext().getRouter().pushUrl({
      url: 'pages/Reader', params: {
        filePath: this.filePath,
        resourceIndex: this.currentData?.resourceIndex,
        domPos: this.currentData?.startDomPos || ''
      }
    }).catch(() => {
      Logger.error(TAG, 'pushUrl failed');
    })
  }

  /**
   * Remove the page transition animation to speed up the page access speed of the reader
   */
  pageTransition() {
    PageTransitionEnter({ duration: 0, curve: Curve.Sharp });
    PageTransitionExit({ duration: 0, curve: Curve.Sharp });
  }
}
