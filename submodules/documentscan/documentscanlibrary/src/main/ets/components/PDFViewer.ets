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
import { pdfService, PdfView, pdfViewManager } from '@kit.PDFKit';
import Constants from '../constants/Constants';
import Logger from '../constants/utils/Logger';

const TAG = 'PDFViewer';

@Builder
export function PdfViewerBuilder(name: string, param: string) {
  PDFViewer({ pageParam: param })
}

@Component
export struct PDFViewer {
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(Constants.KEY_NAV_INDICATOR_HEIGHT) navIndicatorHeight: number = 0;
  @Prop pageParam: string;
  private pathStack: NavPathStack = new NavPathStack();
  private controller: pdfViewManager.PdfController = new pdfViewManager.PdfController();

  aboutToAppear(): void {
    (async () => {
      this.controller.registerPageCountChangedListener((pageCount: number) => {
        Logger.info(TAG, pageCount.toString());
      });
      const loadResult: pdfService.ParseResult = await this.controller.loadDocument(this.pageParam);
      if (pdfService.ParseResult.PARSE_SUCCESS === loadResult) {
        Logger.info(TAG, 'PdfView Component has been successfully loaded!');
      }
    })()
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.TopStart }) {
        PdfView({
          controller: this.controller,
          pageLayout: pdfService.PageLayout.LAYOUT_SINGLE,
          pageFit: pdfService.PageFit.FIT_WIDTH,
          showScroll: true
        })
          .id('pdfview_app_view')
          .layoutWeight(1)
        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.chevron_backward'))
            .fontColor([$r('sys.color.icon_primary')])
            .fontSize($r('sys.float.Title_M'))
        }
        .margin({
          top: this.statusBarHeight,
          left: $r('sys.float.padding_level8')
        })
        .height($r('sys.float.ohos_id_button_height'))
        .aspectRatio(1)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .onClick(() => {
          this.pathStack.pop();
        })
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx.pathStack;
    })
  }
}