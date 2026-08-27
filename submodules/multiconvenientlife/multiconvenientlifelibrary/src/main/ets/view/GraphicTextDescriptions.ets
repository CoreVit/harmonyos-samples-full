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

import { BreakpointConstants } from '../constants/BreakpointConstants';
import { CommonConstants } from '../constants/CommonConstants';
import { BreakpointType } from '../utils/BreakpointSystem';

@Component
export struct GraphicTextDescriptions {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @Consume(CommonConstants.LIFE_PREFIX + 'showSideBar') showSideBar: boolean;

  build() {
    Column() {
      Button()
        .size({ width: 160, height: 24 })
        .backgroundColor($r('sys.color.comp_divider'))
        .margin({
          bottom: $r('app.float.twelves_padding')
        })
      Button()
        .size({ width: '100%', height: 16 })
        .backgroundColor($r('sys.color.comp_background_secondary'))
        .margin({
          bottom: $r('app.float.twelves_padding')
        })
      Button()
        .size({ width: '100%', height: 16 })
        .backgroundColor($r('sys.color.comp_background_secondary'))
        .margin({
          bottom: $r('app.float.twelves_padding')
        })
      Button()
        .size({ width: 145, height: 16 })
        .backgroundColor($r('sys.color.comp_background_secondary'))
        .margin({
          bottom: 24
        })
      Button()
        .size({ width: '100%', height: 16 })
        .backgroundColor($r('sys.color.comp_background_secondary'))
        .margin({
          bottom: 8
        })
      Button()
        .size({ width: '100%', height: 16 })
        .backgroundColor($r('sys.color.comp_background_secondary'))
        .margin({
          bottom: 8
        })
      Button()
        .size({ width: '100%', height: 16 })
        .backgroundColor($r('sys.color.comp_background_secondary'))
        .margin({
          bottom: 24
        })
      Button()
        .size({ width: '100%', height: 16 })
        .backgroundColor($r('sys.color.comp_background_secondary'))
        .margin({
          bottom: 8
        })
      Button()
        .size({ width: '100%', height: 16 })
        .backgroundColor($r('sys.color.comp_background_secondary'))
        .margin({
          bottom: 24
        })
      Button()
        .size({ width: 72, height: 12 })
        .backgroundColor($r('sys.color.comp_background_secondary'))
        .margin({
          bottom: 24
        })

      Row() {
        Image($r('app.media.slt_img'))
          .width($r('app.float.graphic_slt_width'))
          .aspectRatio(1)
          .borderRadius($r('app.float.add_cart_border'))
          .margin({
            right: $r('app.float.tabs_margin_right')
          })
        Row() {
          Column() {
            Button()
              .size({ width: '50%', height: 12 })
              .backgroundColor($r('sys.color.comp_background_secondary'))
              .margin({ bottom: 4 })
            Button()
              .size({ width: 48, height: 12 })
              .backgroundColor($r('sys.color.comp_background_secondary'))
              .margin({ bottom: 4 })
            Button()
              .size({ width: 72, height: 12 })
              .backgroundColor($r('sys.color.ohos_id_color_alert'))
              .opacity(0.15)
          }
          .height($r('app.float.graphic_slt_width'))
          .layoutWeight(1)
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(HorizontalAlign.Start)

          Button({ type: ButtonType.Circle })
            .buttonStyle(ButtonStyleMode.NORMAL)
            .height(40)
            .aspectRatio(1)
        }
        .layoutWeight(1)
        .onClick(() => {
          this.showSideBar = true;
        })
      }
      .transition(TransitionEffect.OPACITY.animation({ duration: 300 }))
      .width(CommonConstants.FULL_PERCENT)
      .borderRadius($r('app.float.five_radius'))
      .backgroundColor($r('sys.color.comp_background_primary'))
      .padding({
        top: $r('app.float.seven_padding'),
        left: $r('app.float.eight_padding'),
        right: $r('app.float.twelves_padding'),
        bottom: $r('app.float.eight_padding')
      })
      .margin({
        top: $r('app.float.price_margin_right'),
        bottom: $r('app.float.margin_twelves')
      })

      Column() {
        Divider()
          .vertical(false)
          .width(CommonConstants.FULL_PERCENT)
          .margin({
            bottom: $r('app.float.margin_small')
          })
        Text($r('app.string.total_reviews'))
          .fontSize($r('app.float.tabs_font'))
          .fontColor($r('sys.color.font_secondary'))
          .width(CommonConstants.FULL_PERCENT)
          .textAlign(TextAlign.Start)
          .margin({
            bottom: $r('app.float.margin_small')
          })
        Row() {
          Image($r('app.media.tx2_img'))
            .width($r('app.float.tx2_width'))
            .aspectRatio(1)
            .margin({
              right: $r('app.float.back_image_right')
            })
          Column() {
            Button()
              .size({ width: 38, height: 16 })
              .backgroundColor($r('sys.color.comp_background_tertiary'))
              .margin({ bottom: $r('sys.float.padding_level4') })
            Button()
              .size({ width: '90%', height: 16 })
              .backgroundColor($r('sys.color.comp_background_secondary'))
              .margin({ bottom: $r('sys.float.padding_level4') })
            Button()
              .size({ width: 124, height: 16 })
              .backgroundColor($r('sys.color.comp_background_secondary'))
          }
          .alignItems(HorizontalAlign.Start)
          .padding({
            top: $r('app.float.text_margin_bottom')
          })
          .layoutWeight(1)

          Column() {
            Image($r('app.media.v2_ic_public_favor'))
              .width($r('app.float.more_width'))
              .aspectRatio(1)
              .margin({
                bottom: $r('app.float.flag_margin_right')
              })
            Text($r('app.string.two_number'))
              .fontColor($r('app.color.forty_black'))
              .fontSize($r('app.float.filtering_font'))
          }
        }
        .width(CommonConstants.FULL_PERCENT)
        .margin({
          bottom: $r('app.float.margin_small')
        })

        Divider()
          .vertical(false)
          .color($r('app.color.five_white'))
          .width(CommonConstants.FULL_PERCENT)
          .margin({
            bottom: $r('app.float.margin_small')
          })
      }
      .padding({
        top: $r('app.float.margin_small')
      })
    }
    .alignItems(HorizontalAlign.Start)
    .padding({
      right: new BreakpointType({
        sm: $r('app.float.padding_small'), md: $r('app.float.common_padding'),
        lg: $r('app.float.padding_large')
      }).getValue(this.currentBreakpoint),
      left: new BreakpointType({
        sm: $r('app.float.padding_small'), md: $r('app.float.common_padding'),
        lg: $r('app.float.zero')
      }).getValue(this.currentBreakpoint)
    })
    .width(CommonConstants.FULL_PERCENT)
  }
}