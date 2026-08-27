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

import Constants from '../common/Constants';
import { BreakpointType, BreakpointTypeEnum } from '../common/utils/BreakpointSystem';

@Extend(Text)
function word() {
  .fontSize($r('app.float.font_size_max'))
  .fontColor($r('app.color.word_color'))
  .fontWeight(FontWeight.Bold)
}

@Extend(Text)
function number() {
  .fontSize($r('app.float.font_size'))
  .fontColor(Color.White)
  .fontWeight(FontWeight.Bold)
  .backgroundColor($r('app.color.theme_color'))
  .width($r('app.float.margin_bottom'))
  .height($r('app.float.margin_bottom'))
  .borderRadius($r('app.float.padding'))
  .textAlign(TextAlign.Center)
}

@Extend(Text)
function toast() {
  .fontSize($r('app.float.font_size'))
  .fontColor(Color.Black)
  .height($r('app.float.toast_height'))
  .backgroundColor(Color.White)
  .padding({
    left: $r('app.float.change'),
    right: $r('app.float.change')
  })
  .margin({ top: $r('app.float.toast_margin_m') })
  .borderRadius($r('app.float.toast_border_radius'))
  .shadow({
    radius: $r('app.float.shadow'),
    type: ShadowType.COLOR,
    color: $r('app.color.shadow')
  })
  .animation({
    duration: Constants.TWO_THOUSAND,
    curve: Curve.Ease
  })
}

@Entry
@Component
struct SelectVerificationCode {
  @Consume(Constants.KEY_PATH_STACK) pathInfos: NavPathStack;
  @StorageProp(Constants.KEY_BREAKPOINT) @Watch('deviceTypeChange') curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(Constants.KEY_NAV_INDICATOR_HEIGHT) navIndicatorHeight: number = 0;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @State showNumberIcon: Visibility[] = [Visibility.Hidden, Visibility.Hidden, Visibility.Hidden, Visibility.Hidden];
  @State textPaddingSize: number = Constants.PADDING_SM;
  @State text: string = '';
  @State wordNumber: number = 1;
  @State wordArr: string[] = [];
  @State flag: boolean = true;
  @State opacitySuccess: number = 0;
  @State opacityFail: number = 0;
  @State oneX: number = 0;
  @State oneY: number = 0;
  @State twoX: number = 0;
  @State twoY: number = 0;
  @State threeX: number = 0;
  @State threeY: number = 0;
  @State fourX: number = 0;
  @State fourY: number = 0;
  private timer: number = 0;
  private flagWordOne: boolean = true;
  private flagWordTwo: boolean = true;
  private flagWordThree: boolean = true;
  private flagWordFour: boolean = true;
  private flagWordFive: boolean = true;
  private flagWordSix: boolean = true;
  private flagWordSeven: boolean = true;

  clickContent(flag: boolean, word: string, e: ClickEvent): boolean {
    if (flag && this.wordArr.length < 4) {
      this.wordArr.push(word);
      if (this.wordNumber === 1) {
        this.oneX = e.windowX - 18;
        this.oneY = e.windowY - 18;
        this.wordNumber++;
        this.showNumberIcon[0] = Visibility.Visible;
      } else if (this.wordNumber === 2) {
        this.twoX = e.windowX - 18;
        this.twoY = e.windowY - 18;
        this.wordNumber++;
        this.showNumberIcon[1] = Visibility.Visible;
      } else if (this.wordNumber === 3) {
        this.threeX = e.windowX - 18;
        this.threeY = e.windowY - 18;
        this.wordNumber++;
        this.showNumberIcon[2] = Visibility.Visible;
      } else if (this.wordNumber === 4) {
        this.fourX = e.windowX - 18;
        this.fourY = e.windowY - 18;
        this.wordNumber++;
        this.showNumberIcon[3] = Visibility.Visible;
      }
    }
    return false;
  }

  initWord(): void {
    this.wordArr = [];
    this.wordNumber = Constants.LINE_HEIGHT;
    this.oneX = Constants.ZERO;
    this.oneY = Constants.ZERO;
    this.twoX = Constants.ZERO;
    this.twoY = Constants.ZERO;
    this.threeX = Constants.ZERO;
    this.threeY = Constants.ZERO;
    this.fourX = Constants.ZERO;
    this.fourY = Constants.ZERO;
    this.flagWordOne = true;
    this.flagWordTwo = true;
    this.flagWordThree = true;
    this.flagWordFour = true;
    this.flagWordFive = true;
    this.flagWordSix = true;
    this.flagWordSeven = true;
  }

  deviceTypeChange() {
    this.showNumberIcon = [Visibility.Hidden, Visibility.Hidden, Visibility.Hidden, Visibility.Hidden];
    this.textPaddingSize = this.getPadding(this.curBp);
    this.initWord();
  }

  aboutToDisappear(): void {
    clearTimeout(this.timer);
  }

  private getPadding(curBp: string): number {
    switch (curBp) {
      case BreakpointTypeEnum.SM:
        return Constants.PADDING_SM;
      case BreakpointTypeEnum.MD:
        return Constants.PADDING_MD;
      case BreakpointTypeEnum.LG:
      case BreakpointTypeEnum.XL:
        return Constants.PADDING_LG;
      default:
        return Constants.PADDING_SM;
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

        Text($r('app.string.select_verification_code'))
          .margin({ left: $r('sys.float.padding_level4') })
          .font({ size: $r('app.float.bar_font_size'), weight: Constants.FONT_WEIGHT_700 })
          .fontColor($r('sys.color.font_primary'))
      }
      .width(Constants.FULL_WIDTH)
      .height($r('app.float.bar_height'))
      .zIndex(2)

      Stack() {
        Text(Constants.LINE_HEIGHT.toString())
          .number()
          .translate({
            x: this.oneX - this.textPaddingSize,
            y: this.oneY - this.statusBarHeight - Constants.BAR_HEIGHT
          })
          .visibility(this.showNumberIcon[0])
        Text(Constants.TWO.toString())
          .number()
          .translate({
            x: this.twoX - this.textPaddingSize,
            y: this.twoY - this.statusBarHeight - Constants.BAR_HEIGHT
          })
          .visibility(this.showNumberIcon[1])
        Text(Constants.THREE.toString())
          .number()
          .translate({
            x: this.threeX - this.textPaddingSize,
            y: this.threeY - this.statusBarHeight - Constants.BAR_HEIGHT
          })
          .visibility(this.showNumberIcon[2])

        Text(Constants.FOUR.toString())
          .number()
          .translate({
            x: this.fourX - this.textPaddingSize,
            y: this.fourY - this.statusBarHeight - Constants.BAR_HEIGHT
          })
          .visibility(this.showNumberIcon[3])

      }
      .alignSelf(ItemAlign.Start)
      .zIndex(Constants.ONE_HUNDRED)

      Stack() {
        Image($r('app.media.img_1'))
          .width(this.curBp === 'sm' ? '100%' : $r('app.float.image_width'))
          .height($r('app.float.image_height'))
        Column() {
          Text($r('app.string.hua'))
            .word()
            .translate({
              x: Constants.NEGATIVE_ONE_HUNDRED_TWENTY,
              y: Constants.THIRTY
            })
            .rotate({ angle: Constants.NEGATIVE_TWENTY })
            .onClick((e) => {
              this.flagWordOne = this.clickContent(this.flagWordOne, Constants.DRAW, e);
            })
          Text($r('app.string.cause'))
            .word()
            .translate({ x: Constants.MINUS_THIRTY })
            .rotate({ angle: Constants.TWENTY })
            .onClick((e) => {
              this.flagWordTwo = this.clickContent(this.flagWordTwo, Constants.THEREFORE, e);
            })
          Text($r('app.string.yan'))
            .word()
            .translate({
              x: Constants.FORTY,
              y: Constants.NEGATIVE_TWENTY_FIVE
            })
            .rotate({ angle: Constants.NEGATIVE_TWENTY })
            .onClick((e) => {
              this.flagWordThree = this.clickContent(this.flagWordThree, Constants.WEIR, e);
            })
          Text($r('app.string.xiang'))
            .word()
            .translate({
              x: Constants.ONE_HUNDRED_FORTY,
              y: Constants.NEGATIVE_ONE_HUNDRED
            })
            .onClick((e) => {
              this.flagWordFour = this.clickContent(this.flagWordFour, Constants.COMMUNES, e);
            })
          Text($r('app.string.china'))
            .word()
            .translate({
              x: Constants.NEGATIVE_ONE_HUNDRED,
              y: Constants.NEGATIVE_THIRTY_FIVE
            })
            .rotate({ angle: Constants.TEN })
            .onClick((e) => {
              this.flagWordFive = this.clickContent(this.flagWordFive, Constants.HUA, e);
            })
          Text($r('app.string.gu'))
            .word()
            .translate({
              x: Constants.NEGATIVE_FIVE,
              y: Constants.NEGATIVE_SEVENTY_FIVE
            })
            .rotate({ angle: Constants.NEGATIVE_SIXTY })
            .onClick((e) => {
              this.flagWordSix = this.clickContent(this.flagWordSix, Constants.ANCIENTS, e);
            })
          Text($r('app.string.hunan'))
            .word()
            .translate({
              x: Constants.NINETY_FIVE,
              y: Constants.NEGATIVE_ONE_HUNDRED_TEN
            })
            .rotate({ angle: Constants.TEN })
            .onClick((e) => {
              this.flagWordSeven = this.clickContent(this.flagWordSeven, Constants.HUNAN, e);
            })
        }
        .width(Constants.FULL_WIDTH)
        .height($r('app.float.image_height'))
      }

      Row() {
        Text($r('app.string.sentence'))
          .fontColor($r('sys.color.font_primary'))
          .fontSize($r('app.float.font_size'))
          .fontWeight(FontWeight.Medium)
        Row() {
          Text($r('app.string.change_another'))
            .fontSize($r('app.float.font_size'))
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.brand'))
            .textAlign(TextAlign.Center)
            .margin({ right: $r('app.float.change_margin') })
          SymbolGlyph($r('sys.symbol.arrow_clockwise'))
            .fontSize($r('app.float.change'))
            .fontColor([$r('sys.color.brand')])
        }
      }
      .margin({
        top: $r('app.float.word_margin_top'),
        bottom: $r('app.float.word_margin_bottom')
      })
      .width(this.curBp === 'sm' ? '100%' : $r('app.float.image_width'))
      .justifyContent(FlexAlign.SpaceBetween)

      Button($r('app.string.commit'))
        .backgroundColor($r('sys.color.brand'))
        .fontColor($r('sys.color.font_on_primary'))
        .width(this.curBp === 'sm' ? '100%' : 448)
        .height($r('app.float.bottom_height'))
        .onClick(() => {
          this.showNumberIcon = [Visibility.Hidden, Visibility.Hidden, Visibility.Hidden, Visibility.Hidden];
          clearTimeout(this.timer);
          if (this.wordArr.join('') === Constants.WORD) {
            this.opacitySuccess = Constants.LINE_HEIGHT;
            this.flag = true;
            this.initWord();
            this.timer = setTimeout(() => {
              this.opacitySuccess = Constants.ZERO;
            }, Constants.THREE_THOUSAND);
          } else {
            this.opacityFail = Constants.LINE_HEIGHT;
            this.flag = false;
            this.initWord();
            this.timer = setTimeout(() => {
              this.opacityFail = Constants.ZERO;
            }, Constants.THREE_THOUSAND);
          }
        })

      if (this.flag) {
        Text($r('app.string.verification_passed'))
          .opacity(this.opacitySuccess)
          .toast()
      } else {
        Text($r('app.string.verification_fail'))
          .opacity(this.opacityFail)
          .toast()
      }
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
    .width(Constants.ONE_HUNDRED_PERCENT)
    .height(Constants.ONE_HUNDRED_PERCENT)
  }
}

@Builder
export function getVerificationCode(name: string): void {
  if (name === 'VerificationCode') {
    NavDestination() {
      SelectVerificationCode()
    }
    .hideTitleBar(true)
  }
}

export const wrappedBuilderVerificationCode: WrappedBuilder<[string, number]> = wrapBuilder(getVerificationCode);