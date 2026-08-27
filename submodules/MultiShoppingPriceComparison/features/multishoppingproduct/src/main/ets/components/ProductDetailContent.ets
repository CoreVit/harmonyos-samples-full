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
import { uiObserver } from '@kit.ArkUI';
import { WidthBreakpointType } from 'multishoppingbase';
import { ProductInfo } from './ProductInfo';
import { ProductSwiper } from './ProductSwiper';
import { ProductUtil } from './ProductUtil';

@ComponentV2
export struct ProductDetailContent {
  @Env(SystemProperties.BREAK_POINT) public breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Param public mainPageMap: NavPathStack = new NavPathStack();
  @Event public onBuyClick: () => void = () => {
  };

  private isWidthLg(): boolean {
    return this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_LG ||
      this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XL;
  }

  build() {
    RelativeContainer() {
      Scroll() {
        Flex({
          direction: new WidthBreakpointType(FlexDirection.Column, FlexDirection.Column, FlexDirection.Row,
            FlexDirection.Row)
            .getValue(this.breakpoint.widthBreakpoint)
        }) {
          ProductSwiper({ mainPageMap: this.mainPageMap })
            .height(new WidthBreakpointType('auto', 'auto', '100%', '100%').getValue(this.breakpoint.widthBreakpoint))
            .width(new WidthBreakpointType('100%', '100%', '50%', '50%').getValue(this.breakpoint.widthBreakpoint))

          Scroll() {
            ProductInfo()
              .width('100%')
          }
          .background($r('app.color.page_section_background'))
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
          .height(new WidthBreakpointType('auto', 'auto', '100%', '100%').getValue(this.breakpoint.widthBreakpoint))
          .width(new WidthBreakpointType('100%', '100%', '50%', '50%').getValue(this.breakpoint.widthBreakpoint))
          .nestedScroll(this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM || WidthBreakpoint.WIDTH_MD ?
            { scrollForward: NestedScrollMode.PARENT_FIRST, scrollBackward: NestedScrollMode.PARENT_FIRST } :
            { scrollForward: NestedScrollMode.SELF_ONLY, scrollBackward: NestedScrollMode.SELF_ONLY })
          .padding({
            bottom: 70
          })
        }
        .height(new WidthBreakpointType('auto', 'auto', '100%', '100%').getValue(this.breakpoint.widthBreakpoint))
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .height('100%')

      ProductUtil({
        widthBp: this.breakpoint.widthBreakpoint,
        onBuyClick: this.onBuyClick
      })
        .alignRules(this.isWidthLg() ? {
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          right: { anchor: '__container__', align: HorizontalAlign.End }
        } : {
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          right: { anchor: '__container__', align: HorizontalAlign.End }
        })
        .margin(this.isWidthLg() ? { right: 32 } : { bottom: 0 })
        .width(
          new WidthBreakpointType('calc(100% - 32vp)', 'calc(100% - 48vp)', 'calc(50% - 64vp)', 'calc(50% - 64vp)')
            .getValue(this.breakpoint.widthBreakpoint)
        )
    }
    .width('100%')
  }
}
