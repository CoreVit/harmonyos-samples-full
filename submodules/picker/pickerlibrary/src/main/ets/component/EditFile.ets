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
import { fileIo, picker } from '@kit.CoreFileKit';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/CommonConstants';
import { FileParam } from './PickerComponent';
import MediaFileUri from '../media/MediaFileUri';
import Logger from '../utils/Logger';

const TAG = 'EditFile: ';
const OPACITY_VALUE = 0.6;

@Builder
export function EditFileBuilder() {
  EditFile();
}

@Component
struct EditFile {
  @LocalStorageLink('loadFlag') loadFlag: Boolean = false;
  @LocalStorageLink('loadFileSize') loadFileSize: number = 0;
  @LocalStorageLink('loadFileName') loadFileName: string = '';
  @LocalStorageLink('loadFileContent') loadFileContent: string = '';
  @LocalStorageLink('loadUri') loadUri: string = '';
  @State editable: Boolean = false;
  @State myFileSize: number = 0;
  @State myFileContent: string = '';
  @State myUri: string = '';
  @State myFileName: string = '';
  @State opacityValue: number = OPACITY_VALUE;
  @StorageProp(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  public isFileContentUpdated: boolean = false;
  isCreateFile: boolean = false;
  scroller: Scroller = new Scroller();
  controller: TextAreaController = new TextAreaController();
  mediaFileUri: MediaFileUri = new MediaFileUri();
  @Consume(CommonConstants.AS_KEY_PATH_STACK) pageStack: NavPathStack;

  getFileInfo(): void {
    if (this.loadFlag) {
      this.myUri = this.loadUri;
      this.myFileName = this.loadFileName;
      this.myFileContent = this.loadFileContent;
      this.myFileSize = this.loadFileSize;
      Logger.info(TAG, 'Successfully obtained the name, content and size of the load file.');
    } else {
      if (this.pageStack.getParamByName('EditFile').length === 0) {
        return;
      }
      let fileParam = this.pageStack.getParamByName('EditFile')[0] as FileParam;
      this.myUri = fileParam.myUri;
      this.myFileName = fileParam.fileName;
      this.isCreateFile = fileParam.isCreate;
      this.myFileContent = this.mediaFileUri.readFileContent(this.myUri);
      this.myFileSize = this.mediaFileUri.myGetFileSize(this.myUri, fileIo.OpenMode.READ_ONLY);
      Logger.info(TAG, 'Successfully obtained the name, content and size of the file.');
      if (this.isCreateFile) {
        this.myFileContent = '';
        this.myFileSize = 0;
      }
    }
  }

  // Pull up the picker to save the file.
  async writeFileContent2NewFile(): Promise<void> {
    try {
      let documentSaveOptions = new picker.DocumentSaveOptions();
      documentSaveOptions.newFileNames = ['MyDocument_01.txt'];
      let documentPicker = new picker.DocumentViewPicker();
      documentPicker.save(documentSaveOptions).then((documentSaveResult) => {
        if (!documentSaveResult) {
          Logger.info(TAG, 'DocumentViewPicker.save failed.');
          return;
        }
        let saveAsUri = documentSaveResult[0];
        this.mediaFileUri.writeFileContent(saveAsUri, this.myFileContent);
        this.myFileName = decodeURI((saveAsUri.split('/').pop()) as string);

        this.myFileSize = this.mediaFileUri.myGetFileSize(saveAsUri, fileIo.OpenMode.READ_ONLY);
        this.myUri = saveAsUri;
        Logger.info(TAG, `save callFilePickerSaveFile file succeed.`);
      }).catch((err: BusinessError) => {
        Logger.error(TAG,
          `DocumentViewPicker.save failed with err, ErrorCode: ${err.code},  Message: ${err.message}`);
      });
    } catch (err) {
      Logger.error(TAG,
        `DocumentViewPicker failed with err, ErrorCode: ${(err as BusinessError).code},  Message: ${(err as BusinessError).message}`);
    }
  }

  writeFileContent2CurrentFile(): void {
    let isWriteSuccess: boolean = true;
    try {
      if (this.loadFlag) {
        let file = fileIo.openSync(this.loadUri,
          fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.TRUNC);
        Logger.info(TAG, 'save onClick file.fd succeed. ');
        fileIo.write(file.fd, this.myFileContent).then(() => {
          Logger.info(TAG, 'write data to file succeed.');
          this.myFileSize = fileIo.statSync(file.fd).size;
          Logger.info(TAG, 'save onClick fileSize succeed.');
        }).catch((err: BusinessError) => {
          Logger.error(TAG, `write data to file failed, ErrorCode: ${err.code},  Message: ${err.message}`);
        }).finally(() => {
          file && fileIo.closeSync(file);
        })
      } else {
        let file = fileIo.openSync(this.myUri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.TRUNC);
        fileIo.write(file.fd, this.myFileContent).then(() => {
          this.myFileSize = fileIo.statSync(file.fd).size;
          Logger.info(TAG, 'write data to file succeed.');
        }).catch((err: BusinessError) => {
          isWriteSuccess = false;
          Logger.error(TAG, `save data to file failed ErrorCode: ${err.code},  Message: ${err.message}`);
          this.getUIContext().getPromptAction().showToast({
            message: $r('app.string.show_toast_message'),
            duration: CommonConstants.WRITE_SUCCESS_DURATION
          })
        }).finally(() => {
          file && fileIo.closeSync(file);
        })
      }
    } catch (err) {
      Logger.error(TAG, `openSync failed, ErrorCode: ${err.code},  Message: ${err.message}`);
    }
    if (isWriteSuccess) {
      this.editable = false;
      try {
        this.getUIContext().getPromptAction().showToast({ message: $r('app.string.saved') });
      } catch (err) {
        Logger.error(TAG, `showToast failed, ErrorCode: ${err.code},  Message: ${err.message}`);
      }
    }
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.chevron_backward'))
              .fontSize($r('sys.float.Title_M'))
              .fontColor([$r('sys.color.font_primary')])
          }
          .focusable(true)
          .focusOnTouch(true)
          .id('backIndex')
          .height(40)
          .aspectRatio(1)
          .margin({ right: $r('sys.float.padding_level4') })
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .onClick(() => {
            this.pageStack.pop();
          })

          // File name and information.
          Column() {
            Row() {
              Text(this.myFileName)
                .focusable(true)
                .focusOnTouch(true)
                .fontSize($r('app.float.text_font_size'))
                .fontFamily('HarmonyHeiTi-Bold')
                .fontColor($r('sys.color.font_primary'))
                .textAlign(TextAlign.Start)
                .fontWeight(CommonConstants.TEXT_FONT_WEIGHT)
                .lineHeight(CommonConstants.TEXT_LINE_HEIGHT)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .width(CommonConstants.FULL_PERCENT)
            .align(Alignment.Start)
            .margin({
              top: CommonConstants.MARGIN_TOP,
              bottom: CommonConstants.MARGIN_ZERO_POINT_THREE_PERCENT
            })

            Row() {
              Text(`size: ${this.myFileSize}B`)
                .focusable(true)
                .focusOnTouch(true)
                .opacity(CommonConstants.TEXT_OPACITY)
                .fontFamily('HarmonyHeiTi')
                .fontSize($r('app.float.text_font_size_14'))
                .fontColor($r('sys.color.font_primary'))
                .textAlign(TextAlign.Start)
                .lineHeight(CommonConstants.TEXT_LINE_HEIGHT_19)
                .fontWeight(CommonConstants.TEXT_FONT_WEIGHT_400)
            }
            .width(CommonConstants.FULL_PERCENT)
            .margin({
              top: CommonConstants.MARGIN_ZERO_POINT_THREE_PERCENT,
              bottom: CommonConstants.MARGIN_ZERO_POINT_FIVE_PERCENT
            })
            .align(Alignment.Start)
          }
          .layoutWeight(1)

          // Three icons on the right.
          Row() {
            Button({ type: ButtonType.Circle }) {
              SymbolGlyph($r('sys.symbol.plus_square_on_square'))
                .fontSize($r('sys.float.Title_M'))
                .fontColor([$r('sys.color.font_primary')])
            }
            .focusable(true)
            .focusOnTouch(true)
            .id('saveAs')
            .margin({
              right: new BreakpointType({
                sm: $r('sys.float.padding_level4'),
                md: $r('sys.float.padding_level6'),
                lg: $r('sys.float.padding_level8')
              }).getValue(this.curBp)
            })
            .height(40)
            .aspectRatio(1)
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .onClick(() => {
              this.writeFileContent2NewFile();
            })
            .visibility(this.loadFlag ? Visibility.Hidden : Visibility.Visible)

            Button({ type: ButtonType.Circle }) {
              SymbolGlyph($r('sys.symbol.square_and_pencil'))
                .fontSize($r('sys.float.Title_M'))
                .fontColor([$r('sys.color.font_primary')])
            }
            .focusable(true)
            .focusOnTouch(true)
            .id('editable')
            .margin({
              right: new BreakpointType({
                sm: $r('sys.float.padding_level4'),
                md: $r('sys.float.padding_level6'),
                lg: $r('sys.float.padding_level8')
              }).getValue(this.curBp)
            })
            .height(40)
            .aspectRatio(1)
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .onClick(() => {
              try {
                this.editable = true;
                this.controller.caretPosition(this.myFileContent.length);
                this.getUIContext().getPromptAction().showToast({ message: $r('app.string.editable') });
              } catch (error) {
                const err: BusinessError = error as BusinessError;
                Logger.error(TAG, `showToast failed, ErrorCode: ${err.code},  Message: ${err.message}`);
              }
            })

            Button({ type: ButtonType.Circle }) {
              SymbolGlyph($r('sys.symbol.save'))
                .fontSize($r('sys.float.Title_M'))
                .fontColor([$r('sys.color.font_primary')])
            }
            .focusable(true)
            .focusOnTouch(true)
            .id('save')
            .height(40)
            .aspectRatio(1)
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .onClick(() => {
              if (!this.isFileContentUpdated) {
                Logger.info(TAG, 'content is never changed.')
                return;
              }
              this.writeFileContent2CurrentFile();
            })
          }
          .margin({ left: $r('sys.float.padding_level8') })
          .justifyContent(FlexAlign.End)
        }
        .padding({
          left: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.curBp),
          right: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.curBp)
        })
        .width(CommonConstants.FULL_PERCENT)
        .height(56)
        .zIndex(2)

        Column() {
          Scroll(this.scroller) {
            Row() {
              TextArea({
                text: this.myFileContent,
                placeholder: CommonConstants.TEXT_AREA_PLACEHOLDER,
                controller: this.controller
              })
                .id('textArea')
                .fontSize($r('app.float.text_area_font_size'))
                .fontColor($r('sys.color.font_primary'))
                .opacity(this.opacityValue)
                .fontWeight(CommonConstants.TEXT_FONT_WEIGHT_400)
                .align(Alignment.TopStart)
                .textAlign(TextAlign.Start)
                .backgroundColor($r('sys.color.gray_01'))
                .fontFamily('HarmonyHeiTi')
                .padding({
                  top: $r('app.float.padding_top_bottom'),
                  right: $r('app.float.padding_left_right'),
                  left: $r('app.float.padding_left_right'),
                  bottom: $r('app.float.padding_top_bottom')
                })
                .focusable(this.editable ? true : false)
                .focusOnTouch(true)
                .defaultFocus(false)
                .onFocus(() => {
                  this.opacityValue = 1;
                })
                .onBlur(() => {
                  this.opacityValue = OPACITY_VALUE;
                })
                .onChange((value: string) => {
                  this.myFileContent = value;
                  this.isFileContentUpdated = true;
                })
            }
            .padding({
              top: CommonConstants.PADDING_TOP,
              left: 16,
              right: 16
            })
          }
          .padding({ bottom: this.navigatorBarHeight })
        }
        .align(Alignment.Start)
        .layoutWeight(1)
      }
      .backgroundColor($r('sys.color.gray_01'))
      .height(CommonConstants.FULL_PERCENT)
      .padding({ top: this.statusBarHeight })
    }
    .hideTitleBar(true)
    .onAppear(() => {
      this.getFileInfo();
    })
  }
}