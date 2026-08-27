/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { BusinessError } from '@kit.BasicServicesKit';
import { CommonConstants, InputSecurityUtil, Logger, WindowInfo, WindowUtil } from 'multivideobase';
import { SearchConstants } from '../constants/SearchConstants';

const TAG = '[SearchHeader]';

@Component
export struct SearchHeader {
  @Link searchInput: string;
  @Consume('currentTopIndex') currentTopIndex: number = 0;
  @Consume('inOnPc') isOnPc: boolean;
  @StorageLink(CommonConstants.WINDOW_UTIL) windowUtil: WindowUtil | undefined = undefined;
  @ObjectLink @Watch('mainWindowInfoChange') mainWindowInfo: WindowInfo;
  @Consume('pageInfo') pageInfo: NavPathStack;
  @State topAvoidHeight: number = 0;
  @State decorWidth: number = 0;
  @State decorHeight: number = 0;

  /**
   * Updates layout when window info changes.
   */
  mainWindowInfoChange() {
    this.topAvoidHeight = this.getUIContext().px2vp(this.mainWindowInfo.avoidSystem?.topRect.height);
    this.topAvoidHeight = Math.max(this.topAvoidHeight, 8);
    if (this.windowUtil !== undefined) {
      try {
        this.decorWidth = this.windowUtil.mainWindow.getTitleButtonRect().width;
        this.decorHeight = this.windowUtil.mainWindow.getTitleButtonRect().height;
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `getTitleButtonRect failed, errCode = ${err.code}, errMessage = ${err.message}.`);
      }
    }
  }

  aboutToAppear(): void {
    this.mainWindowInfoChange();
  }

  build() {
    Row() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize('24fp')
          .fontColor([$r('app.color.srh_header_icon')])
      }
      .justifyContent(this.isOnPc ? FlexAlign.Start : FlexAlign.Center)
      .height('40vp')
      .width('40vp')
      .margin({ right: this.isOnPc ? '0vp' : '8vp' })
      .onClick(() => {
        this.pageInfo.pop();
        this.searchInput = '';
      })
      .backgroundColor(this.isOnPc ? $r('app.color.srh_transparent') : $r('app.color.srh_header_icon_background'))
      .borderRadius('50%')

      Stack({ alignContent: Alignment.Start }) {
        // Search box.
        TextInput({ placeholder: SearchConstants.SEARCH_PLACEHOLDER, text: this.searchInput })
          .placeholderFont({
            size: '16fp',
            weight: FontWeight.Normal
          })
          .placeholderColor($r('app.color.srh_input_placeholder'))
          .height('40vp')
          .fontSize('16fp')
          .padding({
            left: '36vp',
            right: '12vp'
          })
          .width('100%')
          .enableKeyboardOnFocus(false)
          .onChange((value: string) => {
            this.searchInput = InputSecurityUtil.sanitizeSearchInput(value);
          })
          .cancelButton({
            style: CancelButtonStyle.INPUT,
            icon: {
              src: $r('app.media.xmark'),
              size: 16,
              color: $r('app.color.srh_header_icon')
            }
          })
          .backgroundColor($r('app.color.srh_input_background'))

        // Search image.
        SymbolGlyph($r('sys.symbol.magnifyingglass'))
          .fontSize('16fp')
          .margin({ left: '12vp' })
          .fontColor([$r('app.color.srh_input_placeholder')])
      }
      .alignSelf(ItemAlign.Center)
      .layoutWeight(1)
    }
    .padding({
      top: this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG && this.isOnPc ? '0vp' : `${this.topAvoidHeight}vp`,
      right: this.isOnPc ? `${this.decorWidth}vp` : '0vp',
      bottom: this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG && this.isOnPc  ? '0vp' : '8vp'
    })
    .height(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG && this.isOnPc ? this.decorHeight : 'auto')
    .width('100%')
  }
}