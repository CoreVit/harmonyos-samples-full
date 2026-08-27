/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

import { DocType, DocumentScanner, SaveOption } from '@kit.VisionKit';
import { fileIo as fs, picker } from '@kit.CoreFileKit';
import { FileUtil } from '../utils/FileUtil';
import { CommonConstants } from '../constants/CommonConstants';
import Logger from '../utils/Logger';

const TAG: string = 'SheetExtractionPage';

@Component
export struct SheetExtractionComponent {
  @Consume('pathStack') pathStack: NavPathStack;
  @State filePath: string = '';

  build() {
    Stack({ alignContent: Alignment.Top }) {
      // The document scanning control is embedded in the blank page.
      // The control provides the table extraction capability.
      DocumentScanner({
        scannerConfig: {
          // The DocType.SHEET attribute needs to be configured to support table extraction.
          supportType: [DocType.SHEET],
          isGallerySupported: true,
          saveOptions: [SaveOption.JPG, SaveOption.EXCEL]
        },
        onResult: (code: number, saveType: SaveOption, uris: string[]) => {
          // 200 indicates success, SaveOption.EXCEL indicates that the Excel file is returned.
          // and uris indicates the file path.
          if (code === 200) {
            if (uris.length > 0) {
              if (saveType == SaveOption.EXCEL) {
                let res = FileUtil.accessFileSync(uris[0]);
                if (!res) {
                  this.saveToExcel(uris[0], saveType).catch((error: string) => {
                    Logger.error(TAG, `SaveToExcel error message: ${error}`);
                  });
                }
              }
              if (saveType == SaveOption.JPG) {
                let res = FileUtil.accessFileSync(uris[0]);
                if (!res) {
                  this.saveToExcel(uris[0], saveType).catch((error: string) => {
                    Logger.error(TAG, `SaveToExcel error message: ${error}`);
                  });
                }
              }
            }
          }
          this.pathStack.pop();
        }
      })
        .size({ width: CommonConstants.FULL_PERCENT, height: CommonConstants.FULL_PERCENT })
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
  }

  /**
   * Save File to the Files
   * @param uri
   * @returns
   */
  async saveToExcel(uri: string, type: SaveOption): Promise<string> {
    let originFile: fs.File | undefined = undefined;
    let targetFile: fs.File | undefined = undefined;
    let documentSaveOptions = new picker.DocumentSaveOptions;
    documentSaveOptions.newFileNames = [`DocumentScanner_${new Date().getTime()}`];
    if (type === SaveOption.JPG) {
      documentSaveOptions.fileSuffixChoices = ['.JPG'];
    }
    if (type === SaveOption.EXCEL) {
      documentSaveOptions.fileSuffixChoices = ['.xlsx'];
    }
    if (!this.getUIContext().getHostContext()) {
      return '';
    }
    let documentViewPicker = new picker.DocumentViewPicker(this.getUIContext().getHostContext()!);
    let saveUri = new Promise<string>(async (resolve, reject) => {
      documentViewPicker.save(documentSaveOptions).then((saveResult: Array<string>) => {
        let fileUri = saveResult[0];
        try {
          originFile = fs.openSync(uri, fs.OpenMode.READ_ONLY);
          targetFile = fs.openSync(fileUri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
          fs.copyFileSync(originFile.fd, targetFile.fd);
          this.getUIContext().getPromptAction().showToast({
            message: $r('app.string.save_success'),
            alignment: Alignment.Center
          });
          resolve(fileUri);
        } catch (error) {
          const err: BusinessError = error as BusinessError;
          this.getUIContext().getPromptAction().showToast({
            message: $r('app.string.save_error'),
            alignment: Alignment.Center
          });
          reject(err.message);
        } finally {
          try {
            originFile && fs.closeSync(originFile);
            targetFile && fs.closeSync(targetFile);
          } catch (error) {
            const err = error as BusinessError;
            Logger.error(TAG, `Close file failed. Cause code: ${err.code}, message: ${err.message}`);
          }
        }
      })
    })
    return saveUri;
  }
}

