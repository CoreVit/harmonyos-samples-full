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

@Entry
@Component
struct SliderVerificationCode {
  @State tipText: string = '';
  @State inSetValueOne: number = 0;
  @State opacityNumber: number = 0;
  @Consume(Constants.KEY_PATH_STACK) pathInfos: NavPathStack;
  @StorageProp(Constants.KEY_BREAKPOINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(Constants.KEY_NAV_INDICATOR_HEIGHT) navIndicatorHeight: number = 0;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;

  getTargetTranslateX() {
    return this.inSetValueOne * Constants.COEFFICIENT;
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

        Text($r('app.string.slider_verification_code'))
          .margin({ left: $r('sys.float.padding_level4') })
          .font({ size: $r('app.float.bar_font_size'), weight: Constants.FONT_WEIGHT_700 })
          .fontColor($r('sys.color.font_primary'))
      }
      .width(Constants.FULL_WIDTH)
      .height($r('app.float.bar_height'))
      .zIndex(2)
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
      })

      Stack() {
        Image($r('app.media.sliderBackground'))
          .width(this.curBp === 'sm' ? $r('app.float.image_width') : $r('app.float.image_width'))
          .height($r('app.float.image_height'))

        Image($r('app.media.slider'))
          .width($r('app.float.image_width_m'))
          .height($r('app.float.image_height_m'))
          .translate({
            x: this.getTargetTranslateX(),
            y: Constants.NEGATIVE_TWO
          })
      }
      .margin({ top: $r('sys.float.padding_level8') })
      .alignContent(Alignment.Start)

      Stack() {
        Text($r('app.string.slide'))
          .fontColor($r('sys.color.mask_tertiary'))

        Slider({
          value: this.inSetValueOne,
          min: Constants.ZERO,
          max: Constants.ONE_HUNDRED,
          style: SliderStyle.InSet
        })
          .blockSize({ width: $r('app.float.button_width'), height: $r('app.float.button_width') })
          .blockStyle({ type: SliderBlockType.IMAGE, image: $r('app.media.button') })
          .width(this.curBp === 'sm' ? $r('app.float.image_width') : $r('app.float.image_width'))
          .trackColor($r('sys.color.ohos_id_color_hover'))
          .selectedColor($r('app.color.select_color'))
          .showTips(false)
          .trackThickness(Constants.ANGLE)
          .sliderInteractionMode(SliderInteraction.SLIDE_ONLY)
          .onChange((value: number, mode: SliderChangeMode) => {
            this.inSetValueOne = value;
            if (value === Constants.CHANGE_VALUE && mode.valueOf() === Constants.TWO) {
              this.inSetValueOne = Constants.CHANGE_VALUE;
              this.opacityNumber = Constants.LINE_HEIGHT;
              setTimeout(() => {
                this.opacityNumber = Constants.ZERO;
                if (this.inSetValueOne === Constants.CHANGE_VALUE) {
                  this.inSetValueOne = Constants.ZERO;
                }
              }, Constants.THREE_THOUSAND);
            }
            if (value !== Constants.CHANGE_VALUE && mode.valueOf() === Constants.TWO) {
              this.inSetValueOne = Constants.ZERO;
            }
          })
      }
      .margin({ top: $r('app.float.padding') })

      Row() {
        Text($r('app.string.change'))
          .fontSize($r('app.float.font_size_m'))
          .fontColor($r('sys.color.brand'))
          .textAlign(TextAlign.Center)
          .margin({ top: $r('app.float.row_margin') })
          .lineHeight($r('app.float.change'))
        SymbolGlyph($r('sys.symbol.arrow_clockwise'))
          .fontSize($r('app.float.change'))
          .fontColor([$r('sys.color.brand')])
          .translate({
            y: Constants.TEN,
            x: Constants.ITEM_DIVIDER
          })
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)

      Text($r('app.string.verification_passed'))
        .opacity(this.opacityNumber)
        .fontSize($r('app.float.font_size'))
        .fontColor(Color.Black)
        .height($r('app.float.toast_height'))
        .backgroundColor(Color.White)
        .padding({
          left: $r('app.float.change'),
          right: $r('app.float.change')
        })
        .margin({ top: $r('app.float.toast_margin') })
        .borderRadius($r('app.float.toast_border_radius'))
        .shadow({
          radius: $r('app.float.shadow'),
          type: ShadowType.COLOR,
          color: $r('app.color.shadow')
        })
    }
    .padding({
      top: this.statusBarHeight
    })
    .width(Constants.ONE_HUNDRED_PERCENT)
    .height(Constants.ONE_HUNDRED_PERCENT)
  }
}

@Builder
export function getSliderVerification(name: string): void {
  if (name === 'SliderVerification') {
    NavDestination() {
      SliderVerificationCode()
    }
    .hideTitleBar(true)
  }
}

export const wrappedBuilderSliderVerification: WrappedBuilder<[string, number]> = wrapBuilder(getSliderVerification);