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

import CommonConstants from '../../../common/CommonConstants';
import { PageWaterConstants } from '../common/PageWaterConstants';

@Component
export struct WaterRipples {
  @State isListening: boolean = false;
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) currentBreakpoint: string = '';
  private pageInfos: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Row() {
        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.chevron_backward'))
            .fontColor([$r('sys.color.icon_primary')])
            .fontSize($r('sys.float.Title_M'))
        }
        .height(40)
        .aspectRatio(1)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .onClick(() => this.pageInfos.pop())

        Text('')
          .margin({ left: $r('sys.float.padding_level4') })
          .font({ size: 20, weight: 700 })
          .fontColor($r('sys.color.font_primary'))
      }
      .padding({
        top: 40,
        left: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                 $r('sys.float.padding_level12') :
                                                                                 $r('sys.float.padding_level16'),
        right: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                  $r('sys.float.padding_level12') :
                                                                                  $r('sys.float.padding_level16')
      })
      .width('100%')
      .height(96)
      .zIndex(2)

      Column() {
        ButtonWithWaterRipples({ isListening: this.isListening }).offset({ x: 0, y: -96 })
      }
      .justifyContent(FlexAlign.Center)
      .backgroundColor($r('sys.color.background_primary'))
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;
    })
    .backgroundColor($r('sys.color.background_primary'))

  }
}

interface Scale {
  x: number;
  y: number;
}

// [Start construct_component]
@Component
struct ButtonWithWaterRipples {
  @Link public isListening: boolean;
  @State public immediatelyOpacity: number = 0.5;
  @State public immediatelyScale: Scale = { x: 1, y: 1 };
  @State public delayOpacity: number = 0.5;
  @State public delayScale: Scale = { x: 1, y: 1 };
  private readonly BUTTON_SIZE: number = 120;
  private readonly BUTTON_CLICK_SCALE: number = 0.8;
  private readonly ANIMATION_DURATION: number = 1300;

  @Styles
  ripplesStyle() {
    .width(this.BUTTON_SIZE * this.BUTTON_CLICK_SCALE)
    .height(this.BUTTON_SIZE * this.BUTTON_CLICK_SCALE)
    .borderRadius(this.BUTTON_SIZE * this.BUTTON_CLICK_SCALE / 2)
    .backgroundColor(Color.Red)
  }

  build() {
    Stack() {
      Stack()
        .ripplesStyle()// eslint-disable-next-line @performance/hp-arkui-use-transition-to-replace-animateto
        .opacity(this.immediatelyOpacity)
        .scale(this.immediatelyScale)
      Stack()
        .ripplesStyle()// eslint-disable-next-line @performance/hp-arkui-use-transition-to-replace-animateto
        .opacity(this.delayOpacity)
        .scale(this.delayScale)
      // [Start set_animation_and_delay]
      Button() {
        Image($r('app.media.ic_public_music_filled'))
          .width($r('app.float.water_ripples_width'))
          .fillColor(Color.White)
      }
      .clickEffect({ level: ClickEffectLevel.HEAVY, scale: this.BUTTON_CLICK_SCALE })
      .backgroundColor($r('app.color.music_icon'))
      .type(ButtonType.Circle)
      .width(this.BUTTON_SIZE)
      .height(this.BUTTON_SIZE)
      .zIndex(1)
      // [StartExclude construct_component]
      .onClick(() => {
        this.isListening = !this.isListening;
        if (this.isListening) {
          this.getUIContext().animateTo({
            duration: this.ANIMATION_DURATION,
            iterations: PageWaterConstants.ITERATIONS,
            curve: Curve.EaseInOut
          }, () => {
            this.immediatelyOpacity = PageWaterConstants.COMMON_NUMBER_0;
            this.immediatelyScale = {
              x: PageWaterConstants.COMMON_NUMBER_6,
              y: PageWaterConstants.COMMON_NUMBER_6
            };
          })
          this.getUIContext().animateTo({
            duration: this.ANIMATION_DURATION,
            iterations: PageWaterConstants.ITERATIONS,
            curve: Curve.EaseInOut,
            delay: PageWaterConstants.DELAY_200
          }, () => {
            this.delayOpacity = PageWaterConstants.COMMON_NUMBER_0;
            this.delayScale = {
              x: PageWaterConstants.COMMON_NUMBER_6,
              y: PageWaterConstants.COMMON_NUMBER_6
            };
          })
        } else {
          // Break the animation by modifying the variable with a closure of duration 0.
          this.getUIContext().animateTo({ duration: PageWaterConstants.COMMON_NUMBER_0 }, () => {
            this.immediatelyOpacity = PageWaterConstants.COMMON_NUMBER;
            this.delayOpacity = PageWaterConstants.COMMON_NUMBER;
            this.immediatelyScale = {
              x: PageWaterConstants.COMMON_NUMBER_1,
              y: PageWaterConstants.COMMON_NUMBER_1
            };
            this.delayScale = {
              x: PageWaterConstants.COMMON_NUMBER_1,
              y: PageWaterConstants.COMMON_NUMBER_1
            };
          })
        }
      })

      // [StartExclude construct_component]
      // [End set_animation_and_delay]
    }
  }
}

// [End construct_component]

@Builder
export function getPageWaterRipples(name: string): void {
  if (name === 'PageWaterRipples') {
    WaterRipples()

  }
}

export const wrappedBuilderWaterRipples: WrappedBuilder<[string, number]> = wrapBuilder(getPageWaterRipples);