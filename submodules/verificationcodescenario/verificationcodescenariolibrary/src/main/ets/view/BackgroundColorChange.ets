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

import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { inputMethod } from '@kit.IMEKit';
import Constants from '../common/Constants';
import { BreakpointType, BreakpointTypeEnum } from '../common/utils/BreakpointSystem';
import Logger from '../common/utils/Logger';

@Extend(Text)
function verifyCodeUnitStyle() {
  .fontSize($r('app.float.font_size'))
  .fontWeight(FontWeight.Bold)
  .textAlign(TextAlign.Center)
  .width($r('app.float.text_height'))
  .aspectRatio(Constants.LINE_HEIGHT)
  .margin({
    left: $r('app.float.text_margin'),
    right: $r('app.float.text_margin')
  })
  .borderRadius($r('app.float.row_width'))
}

const TAG = 'BackgroundColorChange';

@Entry
@Component
struct BackgroundColorChange {
  @State codeText: string = '';
  @Consume(Constants.KEY_PATH_STACK) pathInfos: NavPathStack;
  @StorageProp(Constants.KEY_BREAKPOINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  private inputController: inputMethod.InputMethodController = inputMethod.getController();
  private arrArea: number[] = [0.0, 1, 0];
  private verifyCodeLength: number = 6;
  private codeIndexArray: Array<number> = Array.from([0, 1, 2, 3, 4, 5]);
  private textConfig: inputMethod.TextConfig = {
    inputAttribute: {
      textInputType: inputMethod.TextInputType.NUMBER,
      enterKeyType: inputMethod.EnterKeyType.GO
    }
  };
  private windowClass?: window.Window = AppStorage.get(Constants.KEY_WINDOWS) as window.Window;
  private isFirstOpenPage: boolean = true;
  private registerCount: number = 1;
  private windowEventCallBack: (windowState: window.WindowEventType) => void = async (windowState) => {
    if (windowState === window.WindowEventType.WINDOW_ACTIVE && this.registerCount === 1) {
      try {
        await this.inputController.attach(true, this.textConfig);
        this.listen();
        this.registerCount++;
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        Logger.error(TAG, `Attach catch error, Cause: the code is ${err.code}, the message is ${err.message}`);
      }
    }
  };
  private insertTextCallBack: (text: string) => void = (text) => {
    if (this.codeText.length >= this.verifyCodeLength || isNaN(Number(text)) || text === ' ') {
      return;
    }
    this.codeText += text;
  };
  private deleteLeftCallBack: () => void = () => {
    this.codeText = this.codeText.substring(0, this.codeText.length - 1);
  };

  aboutToDisappear(): void {
    this.detach();
  }

  async attach() {
    try {
      if (this.isFirstOpenPage) {
        await this.inputController.attach(true, this.textConfig);
        this.listen();
        return;
      }
      if (this.windowClass) {
        this.windowClass?.on('windowEvent', this.windowEventCallBack);
      } else {
        Logger.error(TAG, `Attach failed. windowClass is undefined`);
      }
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Attach catch error, Cause: the code is ${err.code}, the message is ${err.message}`);
    }
  }

  listen() {
    try {
      this.inputController.on('insertText', this.insertTextCallBack);
      this.inputController.on('deleteLeft', this.deleteLeftCallBack);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Register callback failed: ${err.code}, ${err.message}`);
    }
  }

  detach(): void {
    try {
      this.isFirstOpenPage = false;
      this.registerCount = 1;
      this.windowClass?.off('windowEvent', this.windowEventCallBack);
      this.inputController.off('insertText', this.insertTextCallBack);
      this.inputController.off('deleteLeft', this.deleteLeftCallBack);
      this.inputController.detach((err: BusinessError) => {
        if (err) {
          Logger.error(TAG, `Detach catch error, Cause: the code is ${err.code}, the message is ${err.message}.`);
        }
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Detach or off catch error, Cause: the code is ${err.code}, the message is ${err.message}.`);
    }
  }

  private unicodeToDigit(unicodeValue: number): number {
    // Check for half-width digits('0'to'9')
    if (unicodeValue >= 48 && unicodeValue <= 57) {
      return unicodeValue - 48;
    }
    return 0;
  }

  @Builder
  buildVerifyCodeComponent() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
      ForEach(this.codeIndexArray, (item: number) => {
        Text(this.codeText[item])
          .verifyCodeUnitStyle()
          .backgroundColor(this.codeText[item] === undefined ? $r('sys.color.comp_background_secondary') :
            $r('app.color.theme_color_m'))
      }, (item: number) => JSON.stringify(item))
    }
    .onVisibleAreaChange(this.arrArea, async (isVisible: boolean, currentRatio: number) => {
      if (isVisible && currentRatio >= 1.0) {
        this.attach();
      }
      if (!isVisible && currentRatio <= 0.0) {
        this.detach();
      }
    })
    .width($r('app.float.input_width'))
    .backgroundColor(Color.Transparent)
    .height($r('app.float.text_height'))
    .defaultFocus(true)
    .onClick(() => {
      this.inputController.attach(true, this.textConfig).catch((err: BusinessError) => {
        if (err) {
          Logger.error(TAG, `Detach catch error, Cause: the code is ${err.code}, the message is ${err.message}.`);
        }
      });
    })
    .onKeyPreIme((key: KeyEvent) => {
      if (key.type === KeyType.Up && key.unicode && (key.unicode >= 48 && key.unicode <= 57)) {
        if (this.codeText.length >= this.verifyCodeLength) {
          return;
        }
        this.codeText += this.unicodeToDigit(key.unicode);
        return true;
      }
      return false;
    })
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

        Text($r('app.string.background'))
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
      .height($r('app.float.list_padding_top'))
      .margin({ top: $r('sys.float.padding_level8') })
      .alignSelf(ItemAlign.Center)

      Row() {
        Text($r('app.string.Verification_code_sent_to'))
          .fontSize($r('app.float.font_size_m'))
          .fontColor($r('sys.color.font_tertiary'))
          .fontWeight(FontWeight.Regular)
        Text($r('app.string.phone_number1'))
          .fontSize($r('app.float.font_size_m'))
          .fontColor($r('sys.color.brand'))
          .fontWeight(FontWeight.Regular)
      }
      .margin({ bottom: $r('sys.float.padding_level6') })
      .alignSelf(ItemAlign.Center)

      this.buildVerifyCodeComponent()

      Row() {
        Text($r('app.string.reacquire'))
          .fontSize($r('app.float.font_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.brand'))
      }
      .margin({ top: $r('sys.float.padding_level6') })
      .padding({
        right: new BreakpointType({
          sm: $r('sys.float.padding_level0'),
          md: $r('sys.float.padding_level3'),
          lg: $r('sys.float.padding_level3')
        }).getValue(this.curBp)
      })
      .alignSelf(ItemAlign.Center)
      .justifyContent(FlexAlign.End)
      .width(this.curBp === 'sm' ? '100%' : $r('app.float.input_width'))
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
      }).getValue(this.curBp),
      top: this.statusBarHeight
    })
    .height(Constants.ONE_HUNDRED_PERCENT)
    .width(Constants.ONE_HUNDRED_PERCENT)
  }
}

@Builder
export function getColorChange(name: string): void {
  if (name === 'BackgroundColorChange') {
    NavDestination() {
      BackgroundColorChange()
    }
    .hideTitleBar(true)
  }
}

export const wrappedBuilderColorChange: WrappedBuilder<[string, number]> = wrapBuilder(getColorChange);