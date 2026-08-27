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

import { display } from '@kit.ArkUI';
import { CaptchaLogin } from './CaptchaLogin';
import CommonConstants from '../../common/CommonConstants';
import Logger from '../../utils/Logger';

@Builder
export function MultiModalPageBuilder() {
  HalfModalWindow();
}

@Component
export struct HalfModalWindow {
  @Consume(CommonConstants.KEY_PREFIX_TRANSITIONS_NAV_PATH_STACK) pageInfos: NavPathStack;
  // Whether to display the half-screen modal page.
  @State isPresent: boolean = false;
  // half-mode height
  @State sheetHeight: number = CommonConstants.FONT_WEIGHT;
  // Whether to display the control bar
  @State showDragBar: boolean = true;
  // Determine whether to agree with the agreement
  @State isConfirmed: boolean = false;
  // Controlling Full-Modal Presentation
  @State isPresentInLoginView: boolean = false;
  // Transparency of the button for sending a verification code
  @State isShowTransition: boolean = false;
  @State isCenter: boolean = true;
  @State screenW: number = 0;
  @StorageProp(CommonConstants.KEY_PREFIX_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageProp(CommonConstants.KEY_PREFIX_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) currentBreakpoint: string = '';
  private uiContext: UIContext = this.getUIContext();

  aboutToAppear(): void {
    try {
      this.screenW = (display.getDefaultDisplaySync().width);
      if (canIUse('SystemCapability.Window.SessionManager')) {
        this.isPresent = true;
        // When isPresent is set to true, the semi-modal page is displayed. Otherwise, the semi-modal page is
        // not displayed
      }
    } catch (err) {
      const error: BusinessError = err as BusinessError;
      Logger.error('HalfModalWindow',
        `An unexpected error occurred. Code: ${error.code}, message: ${error.message}`);
    }
  }

  // [Start full_modal]
  @Builder
  defaultLogin() {
    Column() {
      // CheckBox to control, semi-modal, full-modal, and semi-modal confirmations in the login page
      CaptchaLogin({
        isPresent: $isPresent,
        isPresentInLoginView: $isPresentInLoginView,
        isShowTransition: $isShowTransition
      })
    }
  }

  // [Start full_modal]

  // [Start half_modal]
  @Builder
  halfModalLogin() {
    // semi-modal window page
    Column() {
      Text($r('app.string.multimodaltransion_after_login_more_service'))
        .fontColor($r('sys.color.font_primary'))
        .fontSize($r('app.integer.font_size_normal'))
        .padding({ top: $r('app.integer.padding_top_large') })

      Text($r('app.string.multimodaltransion_user_phone_number'))
        .fontColor($r('sys.color.font_primary'))
        .fontSize($r('app.integer.font_size_large'))
        .fontWeight(CommonConstants.FONT_WEIGHT_SM)
        .padding({
          top: $r('app.integer.font_size_large'),
          bottom: $r('app.integer.multimodaltransion_margin_default')
        })

      Text($r('app.string.multimodaltransion_get_service'))
        .fontColor($r('sys.color.font_tertiary'))
        .fontSize($r('app.integer.multimodaltransion_row_text_font_size'))
        .padding({ bottom: $r('app.integer.multimodaltransion_height_fifty') })

      Button($r('app.string.multimodaltransion_phone_start_login'))
        .fontColor($r('sys.color.white'))
        .type(ButtonType.Normal)
        .backgroundColor($r('sys.color.brand'))
        .type(ButtonType.Capsule)
        .onClick(() => {
          if (this.isConfirmed) {
            try {
              this.uiContext.getPromptAction()
                .showToast({ message: $r('app.string.multimodaltransion_login_success') });
            } catch (error) {
              const err: BusinessError = error as BusinessError;
              Logger.error('IconView1', `showToast failed, ErrorCode: ${err.code}, Message: ${err.message}`)
            }
            this.pageInfos.pop();
          } else {
            try {
              this.uiContext.getPromptAction()
                .showToast({ message: $r('app.string.multimodaltransion_please_read_and_agree') });
            } catch (error) {
              const err: BusinessError = error as BusinessError;
              Logger.error('IconView1', `showToast failed, ErrorCode: ${err.code}, Message: ${err.message}`)
            }
          }
        })
        .width($r('app.string.multimodaltransion_size_ninety_percent'))
        .height($r('app.integer.multimodaltransion_height_fifty'))
        .margin({
          left: $r('app.integer.main_page_padding2'),
          right: $r('app.integer.main_page_padding2'),
          bottom: $r('app.integer.multimodaltransion_row_padding_bottom')
        })

      Button($r('app.string.multimodaltransion_captcha_login_text'))
        .fontColor($r('sys.color.white'))
        .borderRadius($r('app.integer.multimodaltransion_border_radius'))
        .type(ButtonType.Normal)
        .backgroundColor($r('sys.color.brand'))
        .type(ButtonType.Capsule)
        .border({
          color: $r('app.color.multimodaltransion_half_modal_btn_bgc')
        })
        .onClick(() => {
          if (this.isConfirmed) {
            this.isPresentInLoginView = true;
            this.isConfirmed = false;
            this.isShowTransition = false;
          } else {
            try {
              this.uiContext.getPromptAction()
                .showToast({ message: $r('app.string.multimodaltransion_please_read_and_agree') });
            } catch (error) {
              const err: BusinessError = error as BusinessError;
              Logger.error('IconView1', `showToast failed, ErrorCode: ${err.code}, Message: ${err.message}`)
            }
          }
        })
        .width($r('app.string.multimodaltransion_size_ninety_percent'))
        .height($r('app.integer.multimodaltransion_height_fifty'))
        .margin({ bottom: $r('app.integer.font_size_large') })
      Blank()

      Row() {
        Checkbox({ name: CommonConstants.CHECK_BOX_NAME1 })
          .select(this.isConfirmed)
          .width($r('app.integer.font_size_sm'))
          .onChange((value: boolean) => {
            this.isConfirmed = value;
          })
        Text() {
          Span($r('app.string.multimodaltransion_read_and_agree'))
            .fontColor($r('app.color.multimodaltransion_grey_9'))
          Span($r('app.string.multimodaltransion_server_proxy_rule_detail'))
            .fontColor($r('app.color.multimodaltransion_note_color'))
            .onClick(() => {
              try {
                this.uiContext.getPromptAction()
                  .showToast({ message: $r('app.string.multimodaltransion_only_show_ui') });
              } catch (error) {
                const err: BusinessError = error as BusinessError;
                Logger.error('IconView1', `showToast failed, ErrorCode: ${err.code}, Message: ${err.message}`)
              }
            })
        }.fontSize($r('app.integer.font_size_sm'))
      }
      .margin({ left: $r('app.integer.multimodaltransion_other_ways_icon_height') })
      .width($r('app.string.multimodaltransion_size_full'))
    }
  }

  build() {
    NavDestination() {
      Column() {
        //The Text component is bound for semi-modal display
        Text()
          .bindSheet($$this.isPresent, this.halfModalLogin(), {
            height: this.sheetHeight,
            dragBar: this.showDragBar,
            preferType: this.currentBreakpoint === 'sm' ? SheetType.POPUP : SheetType.CENTER,
            backgroundColor: $r('sys.color.comp_background_primary'),
            showClose: true,
            shouldDismiss: ((sheetDismiss: SheetDismiss) => {
              sheetDismiss.dismiss();
              this.pageInfos.pop();
            })
          })
        Text()
          .bindContentCover($$this.isPresentInLoginView, this.defaultLogin())
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .justifyContent(FlexAlign.Center)
      .size({
        width: $r('app.string.multimodaltransion_size_full'),
        height: $r('app.string.multimodaltransion_size_full')
      })
      .padding($r('app.integer.multimodaltransion_padding_default'))
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({ top: this.statusBarHeight, bottom: this.navigatorBarHeight })

  }

  // [End half_modal]
}