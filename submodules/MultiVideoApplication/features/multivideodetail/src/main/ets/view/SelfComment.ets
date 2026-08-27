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

import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { InputSecurityUtil, Logger, WindowInfo } from 'multivideobase';
import { DetailConstants } from '../constants/DetailConstants';
import UserSelfItemViewModel from '../viewmodel/UserSelfItemViewModel';

const TAG = '[SelfComment]';

@Component
export struct SelfComment {
  @ObjectLink mainWindowInfo: WindowInfo;
  @Link @Watch('setSelfCommentHeight') currentYOffset: number;
  @State selfCommentHeight: number = DetailConstants.SELF_COMMENT_MAX_HEIGHT;
  @State isShowingKeyboard: boolean = false;
  @ObjectLink userSelfItemViewModel: UserSelfItemViewModel;
  @Link commentInput: string;
  /**
   * Updates the self comment bar height based on current scroll offset.
   */
  setSelfCommentHeight() {
    if (this.currentYOffset === 0) {
      this.selfCommentHeight = DetailConstants.SELF_COMMENT_MAX_HEIGHT;
    } else if (this.currentYOffset > 0 &&
      this.currentYOffset <= DetailConstants.SELF_COMMENT_SCROLL_HIDE_THRESHOLD) {
      this.selfCommentHeight = DetailConstants.SELF_COMMENT_MAX_HEIGHT *
        (1 - this.currentYOffset / DetailConstants.SELF_COMMENT_SCROLL_HIDE_THRESHOLD);
    } else if (this.currentYOffset > DetailConstants.SELF_COMMENT_SCROLL_HIDE_THRESHOLD) {
      this.selfCommentHeight = 0;
    } else {
      this.selfCommentHeight = DetailConstants.SELF_COMMENT_MAX_HEIGHT;
    }
  }

  aboutToAppear(): void {
    this.userSelfItemViewModel.loadUserSelfInfoData();
    window.getLastWindow(this.getUIContext().getHostContext()).then((currentWindow) => {
      currentWindow.on('keyboardHeightChange', () => {
        this.currentYOffset = 0;
      });
    }).catch((error: BusinessError) => {
      Logger.error(TAG, `getLastWindow failed, errCode = ${error.code}, errMessage = ${error.message}.`);
    })
  }

  aboutToDisappear(): void {
    this.userSelfItemViewModel.clearUserSelfInfoData();
    window.getLastWindow(this.getUIContext().getHostContext()).then((currentWindow) => {
      currentWindow.off('keyboardHeightChange');
    }).catch((error: BusinessError) => {
      Logger.error(TAG, `getLastWindow failed, errCode = ${error.code}, errMessage = ${error.message}.`);
    })
  }

  build() {
    Row() {
      Image(this.userSelfItemViewModel.getImageSrc())
        .height('36vp')
        .width('36vp')
        .borderRadius(18)
        .margin({
          left: '24vp',
          right: '12vp'
        })

      Stack({ alignContent: Alignment.Start }) {
        Row() {
          Image($r('app.media.ic_public_emoji'))
            .height('24vp')
            .width('24vp')
            .margin({ right: '16vp' })
            .fillColor($r('app.color.vd_placeholder'))
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.End)
        .alignItems(VerticalAlign.Center)

        SymbolGlyph($r('sys.symbol.pencil_waveform_fill'))
          .fontSize('16fp')
          .margin({
            top: '12vp',
            bottom: '12vp',
            left: '12vp',
            right: '8vp'
          })
          .fontColor([$r('app.color.vd_placeholder')])

        TextInput({ placeholder: DetailConstants.COMMENT_PLACEHOLDER, text: this.commentInput })
          .placeholderFont({
            size: '16fp',
            weight: FontWeight.Normal
          })
          .placeholderColor($r('app.color.vd_placeholder'))
          .height('40vp')
          .fontSize('16fp')
          .padding({
            left: '36vp',
            right: '48vp'
          })
          .width('100%')
          .backgroundColor($r('app.color.vd_input_background'))
          .onChange((value: string) => {
            this.commentInput = InputSecurityUtil.sanitizeSearchInput(value);
          })
      }
      .alignSelf(ItemAlign.Center)
      .layoutWeight(1)
      .borderRadius(20)
      .height('40vp')
    }
    .shadow({
      radius: DetailConstants.SHADOW_RADIUS,
      color: $r('app.color.vd_input_shadow'),
      offsetY: DetailConstants.SHADOW_OFFSET_Y
    })
    .height(this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
      this.mainWindowInfo.heightBp <= HeightBreakpoint.HEIGHT_MD ? this.selfCommentHeight : '80vp')
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .backgroundColor($r('app.color.vd_page_background'))
    .padding({
      right: '24vp'
    })
    .clip(true)
  }
}