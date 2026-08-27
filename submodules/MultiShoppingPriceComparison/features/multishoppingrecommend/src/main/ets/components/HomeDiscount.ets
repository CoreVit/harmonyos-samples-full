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
import { uiObserver } from '@kit.ArkUI';
import { WidthBreakpointType } from 'multishoppingbase';
import { HomeDiscountItem } from '../model/HomeDiscountModel';
import { HomeDiscountState } from '../viewmodel/HomeDiscountState';

@ComponentV2
export struct HomeDiscount {
  private context: Context = this.getUIContext().getHostContext()!;
  @Env(SystemProperties.BREAK_POINT) private breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Local private state: HomeDiscountState = new HomeDiscountState(this.context);

  build() {
    Column() {
      Row() {
        Text($r('app.string.HOME_TITLES1'))
          .fontSize(16)
          .lineHeight(22)
          .fontWeight(FontWeight.Medium)

        Blank()

        Text($r('app.string.BUTTON_TEXTS1'))
          .fontSize(12)
          .fontColor($r('sys.color.font_on_primary'))
          .height(28)
          .padding({ left: 12, right: 12 })
          .borderRadius(14)
          .backgroundColor('#CF0A2C')
          .textAlign(TextAlign.Center)
      }
      .justifyContent(FlexAlign.Start)
      .height(48)
      .width('100%')

      Row() {
        ForEach(
          this.state.getCurrentWelfareList(this.breakpoint.widthBreakpoint),
          (item: HomeDiscountItem, index: number) => {
          Column() {
            Image(item.image)
              .width(new WidthBreakpointType(60, 72, 72, 72).getValue(this.breakpoint.widthBreakpoint))
              .height(new WidthBreakpointType(60, 72, 72, 72).getValue(this.breakpoint.widthBreakpoint))
            Text($r('app.string.TIP_TEXTS1'))
              .fontSize(10)
              .fontWeight(FontWeight.Normal)
              .lineHeight(16)
              .width(40)
              .borderRadius(10)
              .backgroundColor($r('app.color.overlay_low'))
              .textAlign(TextAlign.Center)
            Text(item.info)
              .fontSize(12)
              .lineHeight(16)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 4 })
          }
          .height('100%')
          .justifyContent(FlexAlign.Start)
          .backgroundColor($r('app.color.surface_primary'))
          },
          (_item: HomeDiscountItem, index: number) => `welfare-${index}`
        )
      }
      .height((this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
        this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? 102 :
        new WidthBreakpointType(102, 114, 118, 118).getValue(this.breakpoint.widthBreakpoint))
      .width('100%')
      .borderRadius(12)
      .backgroundColor($r('app.color.surface_primary'))
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
          this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? 16 :
          new WidthBreakpointType(16, 12, 20, 20).getValue(this.breakpoint.widthBreakpoint),
        right: (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
          this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? 16 :
          new WidthBreakpointType(16, 12, 20, 20).getValue(this.breakpoint.widthBreakpoint)
      })
    }
    .height((this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
      this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? 162 :
      new WidthBreakpointType(162, 174, 178, 178).getValue(this.breakpoint.widthBreakpoint))
    .width('100%')
    .padding({ left: 12, right: 12 })
    .borderRadius(12)
    .linearGradient({
      direction: GradientDirection.Right,
      repeating: false,
      colors: [[$r('app.color.discount_gradient_start'), 0.0], [$r('app.color.discount_gradient_end'), 1.0]]
    })
  }
}