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
import { ProductCategoryItem } from '../model/ProductCategoryModel';
import { ProductClassificationState } from '../viewmodel/ProductClassificationState';

@ComponentV2
export struct ProductClassification {
  private context: Context = this.getUIContext().getHostContext()!;
  @Env(SystemProperties.BREAK_POINT) private breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Local private state: ProductClassificationState = new ProductClassificationState(this.context);

  build() {
    Column() {
      List({
        space: new WidthBreakpointType(0, 36, 72, 72).getValue(this.breakpoint.widthBreakpoint)
      }) {
        ForEach(this.state.categories, (item:ProductCategoryItem, index: number) => {
          ListItem() {
            Row() {
              Column() {
                Image(item.icon)
                  .height(new WidthBreakpointType(40, 64, 68, 68).getValue(this.breakpoint.widthBreakpoint))
                Text(item.title)
                  .fontSize(12)
                  .fontWeight(FontWeight.Normal)
                  .lineHeight(17)
              }
            }
            .width('100%')
            .height('100%')
            .justifyContent((this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
              this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? FlexAlign.Center : FlexAlign.Start)
          }
          .width(new WidthBreakpointType('20%', '64vp', '68vp', '68vp').getValue(this.breakpoint.widthBreakpoint))
          .height(new WidthBreakpointType(57, 81, 85, 85).getValue(this.breakpoint.widthBreakpoint))
        }, (index: number) => `category-${index}`)
      }
      .lanes((this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
        this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? 2 : 1, 12)
      .listDirection(Axis.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')
      .height(new WidthBreakpointType(126, 81, 85, 85).getValue(this.breakpoint.widthBreakpoint))
      .onScrollIndex((start: number, end: number) => {
        this.state.onScrollIndex(start, end);
      })

      if (this.breakpoint.widthBreakpoint !== WidthBreakpoint.WIDTH_XS &&
        this.breakpoint.widthBreakpoint !== WidthBreakpoint.WIDTH_SM) {
        Row() {
          Divider()
            .color(this.state.isNextCategory ? $r('app.color.living_badge_border') : '#D0092D')
            .width(24)
            .strokeWidth(4)
            .lineCap(LineCapStyle.Round)
          Divider()
            .color(this.state.isNextCategory ? '#D0092D' : $r('app.color.living_badge_border'))
            .width(24)
            .strokeWidth(4)
            .lineCap(LineCapStyle.Round)
        }
        .width('100%')
        .height(32)
        .justifyContent(FlexAlign.Center)
      }
    }
    .height(new WidthBreakpointType(126, 113, 117, 117).getValue(this.breakpoint.widthBreakpoint))
    .width('100%')
    .margin({
      top: (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
        this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? 0 : 12,
      right: new WidthBreakpointType(16, 0, 0, 0).getValue(this.breakpoint.widthBreakpoint)
    })
  }
}