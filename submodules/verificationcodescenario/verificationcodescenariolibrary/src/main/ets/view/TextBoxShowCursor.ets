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

import { display, window } from '@kit.ArkUI';
import { BusinessError, deviceInfo } from '@kit.BasicServicesKit';
import { inputMethod } from '@kit.IMEKit';
import Constants from '../common/Constants';
import { BreakpointType, BreakpointTypeEnum } from '../common/utils/BreakpointSystem';
import Logger from '../common/utils/Logger';

@Extend(Text)
function verifyCodeUnitStyle() {
  .fontSize($r('app.float.font_size'))
  .fontWeight(FontWeight.Bold)
  .fontColor($r('app.color.theme_color'))
  .textAlign(TextAlign.Center)
  .width($r('app.float.text_height'))
  .height(Constants.ONE_HUNDRED_PERCENT)
  .margin({
    left: $r('app.float.text_margin'),
    right: $r('app.float.text_margin')
  })
}

const TAG = 'TextBoxShowCursor';

@Entry
@Component
struct TextBoxShowCursor {
  @Consume(Constants.KEY_PATH_STACK) pathInfos: NavPathStack;
  @StorageProp(Constants.KEY_BREAKPOINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @State codeText: string = '';
  @State opacityColumn: number = 0;
  @State flag: boolean = true;
  private arrArea: number[] = [0.0, 1, 0];
  private inputController: inputMethod.InputMethodController = inputMethod.getController();
  private verifyCodeLength: number = 6;
  private codeIndexArray: Array<number> = Array.from([0, 1, 2, 3, 4, 5]);
  private textConfig: inputMethod.TextConfig = {
    inputAttribute: {
      textInputType: inputMethod.TextInputType.NUMBER,
      enterKeyType: inputMethod.EnterKeyType.GO
    }
  };
  private windowClass: window.Window = AppStorage.get(Constants.KEY_WINDOWS) as window.Window;
  private isFirstOpenPage: boolean = true;
  private registerCount: number = 1;

  aboutToDisappear(): void {
    this.detach();
  }

  /**
   * Binding an Input Method and Subscribing to Input Method-related Events.
   */
  async attach() {
    try {
      if (this.isFirstOpenPage) {
        await this.inputController.attach(true, this.textConfig);
        this.listen();
        return;
      }
      this.windowClass.on('windowEvent', async (windowState) => {
        if (windowState === window.WindowEventType.WINDOW_ACTIVE && this.registerCount === 1) {
          this.registerCount++;
          try {
            await this.inputController.attach(true, this.textConfig);
            this.listen();
          } catch (error) {
            const err: BusinessError = error as BusinessError;
            Logger.error(TAG, `Attach catch error, Cause: the code is ${err.code}, the message is ${err.message}.`);
          }
        }
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Attach catch error, Cause: the code is ${err.code}, the message is ${err.message}.`);
    }
  }

  /**
   * Subscribe to the events of inserting and deleting leftward in the input method to obtain the input content of
   * the keyboard.
   */
  listen() {
    try {
      this.inputController.on('insertText', (text: string) => {
        if (this.codeText.length >= this.verifyCodeLength || isNaN(Number(text)) || text === ' ') {
          return;
        }
        this.codeText += text;
        if (this.codeText.length === this.verifyCodeLength) {
          this.flag = false;
        }
      })
      this.inputController.on('deleteLeft', () => {
        this.codeText = this.codeText.substring(0, this.codeText.length - 1);
        if (this.codeText.length !== this.verifyCodeLength) {
          this.flag = true;
        }
      })
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG,
        `Input controller on listen catch error, Cause: the code is ${err.code}, the message is ${err.message}.`);
    }
  }

  /**
   * Unbinding.
   */
  detach() {
    try {
      this.isFirstOpenPage = false;
      this.registerCount = 1;
      this.windowClass.off('windowEvent');
      this.inputController.off('insertText');
      this.inputController.off('deleteLeft');
      this.inputController.detach((_err: BusinessError) => {
      })
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Detach catch failed, Cause: the code is ${err.code}, the message is ${err.message}.`);
    }
  }

  getCursorTranslateX(): number {
    if (canIUse('SystemCapability.Window.SessionManager')) {
      let foldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
      try {
        foldStatus = display.getFoldStatus();
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        Logger.error(TAG, `Get foldStatus failed: ${err.code}, ${err.message}.`);
      }
      if (deviceInfo.productSeries === 'VDE' && foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED) {
        return Constants.ITEM_CODE_START + this.codeText.length * Constants.ITEM_CODE_WIDTH;
      }
      if (foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED) {
        return Constants.ITEM_DIVIDER + this.codeText.length * Constants.ITEM_FOLD_CODE_WIDTH;
      }
    }
    return (this.codeText.length === Constants.ZERO ? Constants.ITEM_DIVIDER : this.codeText.length *
      (this.codeText.length > Constants.TWO ?
        (this.codeText.length === Constants.ITEM_DIVIDER ? Constants.FIFTY_EIGHT_POINT_FIVE :
          Constants.FIFTY_NINE) : Constants.SIXTY))
  }

  private unicodeToDigit(unicodeValue: number): number {
    // Check for half-width digits('0'to'9')
    if (unicodeValue >= 48 && unicodeValue <= 57) {
      return unicodeValue - 48;
    }
    return 0;
  }

  /**
   * In some verification code scenarios, the functions of selecting and copying entered verification codes must be
   * disabled.
   * Therefore, the Text component can be used.
   */
  @Builder
  buildVerifyCodeComponent() {
    Stack() {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        ForEach(this.codeIndexArray, (item: number) => {
          Text(this.codeText[item])
            .verifyCodeUnitStyle()
            .border({
              width: { bottom: $r('app.float.row_height_one') },
              color: {
                bottom: this.codeText[item] === undefined ? $r('sys.color.comp_divider') : $r('sys.color.brand')
              },
              style: { bottom: BorderStyle.Solid }
            })
        }, (item: number) => item.toString())
      }
      // When the visible area changes, binding registration and unbinding are performed.
      .onVisibleAreaChange(this.arrArea, async (isVisible: boolean, currentRatio: number) => {
        if (isVisible && currentRatio >= 1) {
          this.opacityColumn = 1;
          this.attach();
        }
        if (!isVisible && currentRatio <= 0) {
          this.detach();
        }
      })
      .backgroundColor(Color.Transparent)
      .height($r('app.float.text_height'))
      .defaultFocus(true)
      .onClick(() => {
        // When you click this component, the input method is displayed. Because the Text component is used here,
        // you need to re-attach it instead of directly using showSoftKeyboard.
        try {
          this.inputController.attach(true, this.textConfig);
        } catch (error) {
          const err: BusinessError = error as BusinessError;
          Logger.error(TAG, `Attach catch error, Cause: the code is ${err.code}, the message is ${err.message}.`);
        }
      })
      .width(this.curBp === 'sm' ? Constants.FULL_WIDTH : $r('app.float.context_area'))
      .onKeyPreIme((key: KeyEvent) => {
        if (key.type === KeyType.Up && key.unicode && (key.unicode >= 48 && key.unicode <= 57)) {
          if (this.codeText.length >= this.verifyCodeLength) {
            return;
          }
          this.codeText += this.unicodeToDigit(key.unicode);
          if (this.codeText.length === this.verifyCodeLength) {
            this.flag = false;
          }
          return true;
        }
        return false;
      })

      Row() {
        Column() {
          Text()
            .opacity(this.opacityColumn)
            .width(Constants.TWO)
            .height($r('app.float.cursor_height'))
            .backgroundColor($r('sys.color.font_primary'))
            .borderRadius($r('app.float.row_height_one'))
            .animation({
              duration: Constants.EIGHT_HUNDRED,
              curve: Curve.Rhythm,
              iterations: Constants.ITERATION,
              playMode: PlayMode.Alternate,
              expectedFrameRateRange: {
                min: Constants.TWENTY,
                max: Constants.ONE_HUNDRED_AND_TWENTY,
                expected: Constants.NINETY
              }
            })
        }
        .visibility(this.flag ? Visibility.Visible : Visibility.Hidden)
        .translate({ x: this.getCursorTranslateX() })
        .hitTestBehavior(HitTestMode.Transparent)
        .onClick(() => {
          try {
            this.inputController.attach(true, this.textConfig);
          } catch (error) {
            const err: BusinessError = error as BusinessError;
            Logger.error(TAG, `Attach catch error, Cause: the code is ${err.code}, the message is ${err.message}.`);
          }
        })
        .justifyContent(FlexAlign.Center)
        .height(Constants.ONE_HUNDRED_PERCENT)
      }
      .hitTestBehavior(HitTestMode.Transparent)
      .height($r('app.float.text_height'))
      .width(this.curBp === 'sm' ? Constants.FULL_WIDTH : $r('app.float.context_area'))
    }
  }

  build() {
    Column() {
      Row() {
        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.chevron_backward'))
            .fontColor([$r('sys.color.icon_primary')])
            .fontSize($r('sys.float.Title_M'))
        }
        .height($r('app.float.back_button_height'))
        .aspectRatio(1)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .onClick(() => this.pathInfos.pop())

        Text($r('app.string.word'))
          .margin({ left: $r('sys.float.padding_level4') })
          .font({ size: $r('app.float.bar_font_size'), weight: Constants.FONT_WEIGHT_700 })
          .fontColor($r('sys.color.font_primary'))
      }
      .width(Constants.FULL_WIDTH)
      .height($r('app.float.bar_height'))
      .zIndex(2)

      Row() {
        Text($r('app.string.enter_the_verification_code'))
          .fontSize($r('app.float.font_size_l'))
          .fontWeight(FontWeight.Medium)
      }
      .margin({ top: $r('sys.float.padding_level8') })
      .height($r('app.float.list_padding_top'))
      .alignSelf(ItemAlign.Center)

      Row() {
        Text($r('app.string.Verification_code_sent_to'))
          .fontSize($r('app.float.font_size_m'))
          .fontColor($r('sys.color.font_tertiary'))
          .fontWeight(FontWeight.Regular)
        Text($r('app.string.phone_number'))
          .fontSize($r('app.float.font_size_m'))
          .fontColor($r('sys.color.brand'))
          .fontWeight(FontWeight.Regular)
      }
      .margin({ bottom: $r('app.float.margin_bottom') })
      .alignSelf(ItemAlign.Center)

      this.buildVerifyCodeComponent()

      Row() {
        Text($r('app.string.reacquire'))
          .fontSize($r('app.float.font_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.brand'))
      }
      .margin({ top: $r('sys.float.padding_level6') })
      .alignSelf(ItemAlign.Center)
      .justifyContent(FlexAlign.End)
      .width(this.curBp === 'sm' ? '100%' : $r('app.float.input_width'))
    }
    .backgroundColor($r('sys.color.background_secondary'))
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
      }).getValue(this.curBp),
      top: this.statusBarHeight
    })
    .height(Constants.ONE_HUNDRED_PERCENT)
    .width(Constants.ONE_HUNDRED_PERCENT)
  }
}

@Builder
export function getShowCursor(name: string): void {
  if (name === 'TextBoxShowCursor') {
    NavDestination() {
      TextBoxShowCursor()
    }
    .hideTitleBar(true)
  }
}

export const wrappedBuilderShowCursor: WrappedBuilder<[string, number]> = wrapBuilder(getShowCursor);