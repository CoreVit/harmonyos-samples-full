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

import CommonConstants from '../../common/CommonConstants';
import Logger from '../../utils/Logger'

@Component
export struct CaptchaLogin {
  // Controlling the Presentation of Half-Modalities
  @Link isPresent: boolean;
  // Controlling Full-Modal Presentation
  @Link isPresentInLoginView: boolean;
  // Controlling the Display of the Verification Code for Login
  @State isDefaultLogin: boolean = true;
  // Transparency of the login button
  @State op: number = CommonConstants.HALF_OPACITY;
  // Determine whether to agree with the agreement
  isConfirmed: boolean = false;
  @Link isShowTransition: boolean;
  private effect1: TransitionEffect =
    TransitionEffect.asymmetric(
      TransitionEffect.IDENTITY,
      TransitionEffect.move(TransitionEdge.START)
        .animation({ duration: CommonConstants.EFFECT_DURATION, curve: Curve.Linear }));
  private effect3: TransitionEffect =
    TransitionEffect
      .move(TransitionEdge.START).animation({ duration: CommonConstants.EFFECT_DURATION, curve: Curve.Linear });
  @Consume(CommonConstants.KEY_PREFIX_TRANSITIONS_NAV_PATH_STACK) pageInfos: NavPathStack;
  private uiContext: UIContext = this.getUIContext();
  @State phone: string = '';
  @State isPhoneValid: boolean = false;

  aboutToAppear(): void {
    this.isPresent = false;
  }

  aboutToDisappear(): void {
    this.pageInfos.pop();
  }

  validatePhone(phone: string): boolean {
    const PHONE_REGEX = /^1(?:3\d|4[014-9]|5[0-35-9]|6[2567]|7[0-8]|8\d|9[0-35-9])\d{8}$/;
    return PHONE_REGEX.test(phone.trim());
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      if (this.isDefaultLogin) {
        Column({ space: CommonConstants.SPACE_FIFTEEN }) {
          Row({ space: CommonConstants.SPACE_FIFTEEN }) {
            Column({ space: CommonConstants.SPACE_FIFTEEN }) {
              Text($r('app.string.multimodaltransion_phone_back'))
                .fontSize($r('app.integer.multimodaltransion_font_size_middle'))
                .fontWeight(CommonConstants.FONT_WEIGHT_SEVENTY)
                .fontColor($r('sys.color.ohos_id_color_primary'))
              Text($r('app.string.multimodaltransion_auto_after_login'))
                .fontColor($r('app.color.multimodaltransion_grey_3'))
                .fontWeight(CommonConstants.FONT_WEIGHT_NORMAL)
                .opacity(CommonConstants.HALF_OPACITY)
            }
            .alignItems(HorizontalAlign.Start)
          }
          .alignItems(VerticalAlign.Top)
          .width($r('app.string.multimodaltransion_size_eighty_percent'))
          .padding({ bottom: $r('app.integer.multimodaltransion_check_box_size') })

          Row() {
            Text($r('app.string.multimodaltransion_86'))
            SymbolGlyph($r('sys.symbol.chevron_right'))
              .fontColor([$r('sys.color.font_primary')])
              .fontSize(26)
              .margin({
                left: $r('app.integer.multimodaltransion_margin_default'),
              })
              .onClick(() => {
                try {
                  this.uiContext.getPromptAction()
                    .showToast({ message: $r('app.string.multimodaltransion_only_show_ui') });
                } catch (error) {
                  const err: BusinessError = error as BusinessError;
                  Logger.error('IconView1', `showToast failed, ErrorCode: ${err.code}, Message: ${err.message}`)
                }
              })
            TextInput({ placeholder: $r('app.string.multimodaltransion_input_phone_number') })
              .type(InputType.PhoneNumber)
              .backgroundColor(Color.Transparent)
              .caretColor(Color.Grey)
              .width($r('app.string.multimodaltransion_size_full'))
              .maxLength(CommonConstants.PHONE_NUMBER_LENGTH)

              .onChange((value: string) => {
                this.phone = value;
                if (this.phone.length >= 11) {
                  this.phone = this.phone.substring(0, 11);
                  this.isPhoneValid = this.validatePhone(this.phone);
                } else {
                  this.isPhoneValid = false;
                }
                if (this.isPhoneValid) {
                  this.op = CommonConstants.DEFAULT_ONE;
                } else {
                  this.op = CommonConstants.HALF_OPACITY;
                }

              })
          }
          .height($r('app.integer.multimodaltransion_user_image_height'))
          .width($r('app.string.multimodaltransion_size_eighty_percent'))

          Text($r('app.string.multimodaltransion_captcha_change_title_text'))
            .fontColor($r('app.color.multimodaltransion_note_color'))
            .fontSize($r('app.integer.multimodaltransion_height_fifty_five'))
            .backgroundColor($r('app.color.multimodaltransion_transparent_7'))
            .width($r('app.string.multimodaltransion_size_eighty_percent'))
            .padding({ bottom: $r('app.integer.multimodaltransion_margin_default') })

          Button($r('app.string.multimodaltransion_captcha_get'))
            .fontColor(Color.White)
            .fontWeight(FontWeight.Normal)
            .borderRadius($r('app.integer.multimodaltransion_border_radius'))
            .type(ButtonType.Normal)
            .backgroundColor($r('app.color.multimodaltransion_red'))
            .opacity(this.op)
            .onClick(() => {
              if (!this.isConfirmed) {
                try {
                  this.uiContext.getPromptAction()
                    .showToast({ message: $r('app.string.multimodaltransion_please_read_and_agree') });
                } catch (error) {
                  const err: BusinessError = error as BusinessError;
                  Logger.error('IconView1', `showToast failed, ErrorCode: ${err.code}, Message: ${err.message}`)
                }
                return;
              }

              if (this.isPhoneValid) {
                try {
                  this.uiContext.getPromptAction()
                    .showToast({ message: $r('app.string.multimodaltransion_captcha_sent') });
                } catch (error) {
                  const err: BusinessError = error as BusinessError;
                  Logger.error('IconView1', `showToast failed, ErrorCode: ${err.code}, Message: ${err.message}`)
                }
              } else {
                try {
                  this.uiContext.getPromptAction()
                    .showToast({ message: $r('app.string.login_mobile_error') });
                } catch (error) {
                  const err: BusinessError = error as BusinessError;
                  Logger.error('IconView1', `showToast failed, ErrorCode: ${err.code}, Message: ${err.message}`)
                }
              }
            })
            .width($r('app.string.multimodaltransion_size_eighty_percent'))
          Row() {
            Checkbox({ name: CommonConstants.CHECK_BOX_NAME1 })
              .select(this.isConfirmed)
              .size({
                width: $r('app.integer.multimodaltransion_check_box_size'),
                height: $r('app.integer.multimodaltransion_check_box_size')
              })
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
            }
            .fontSize($r('app.integer.font_size_xm'))
            .flexShrink(CommonConstants.DEFAULT_ONE)
          }
          .alignItems(VerticalAlign.Center)
          .padding({ bottom: $r('app.integer.multimodaltransion_margin_default') })
          .width($r('app.string.multimodaltransion_size_eighty_two_percent'))

          Blank()
        }
        .transition(this.isShowTransition ? this.effect3 : this.effect1)
        .width($r('app.string.multimodaltransion_size_full'))
        .height($r('app.string.multimodaltransion_size_full'))
        .backgroundColor($r('sys.color.ohos_id_color_background'))
        .padding({
          bottom: $r('app.integer.multimodaltransion_padding_mid'),
          top: $r('app.integer.multimodaltransion_padding_top')
        })
        .justifyContent(FlexAlign.Center)
      }
      Button({ type: ButtonType.Circle }) {
        SymbolGlyph($r('sys.symbol.xmark'))
          .fontColor([$r('sys.color.icon_secondary')])
          .fontSize(18)
      }
      .height(40)
      .aspectRatio(1)
      .backgroundColor($r('sys.color.comp_background_secondary'))
      .margin({ top: CommonConstants.MARGIN_LEFT, left: $r('sys.float.padding_level8') })
      .onClick(() => {
        this.isPresentInLoginView = false;
      })
    }
    .size({
      width: $r('app.string.multimodaltransion_size_full'),
      height: $r('app.string.multimodaltransion_size_full')
    })
  }
}