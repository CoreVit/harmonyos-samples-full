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
import { RecommendedProductItem } from '../model/RecommendedProductModel';
import { HomeRecommendCardState } from '../viewmodel/HomeRecommendCardState';

@ComponentV2
export struct HomeRecommendCard {
  @Env(SystemProperties.BREAK_POINT) private breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Local private state: HomeRecommendCardState = new HomeRecommendCardState();

  private getRecommendedProducts(): RecommendedProductItem[] {
    if (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
      this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) {
      return this.state.products.slice(0, 2);
    }
    if (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_MD) {
      return this.state.products.slice(0, 3);
    }
    return this.state.products;
  }

  private getSwiperSize(): number {
    return new WidthBreakpointType(160, 188, 224, 224).getValue(this.breakpoint.widthBreakpoint);
  }

  build() {
    Swiper() {
      ForEach(this.getRecommendedProducts(), (item: RecommendedProductItem, index: number) => {
        Stack() {
          Image(item.image)
            .width('100%')
            .height('100%')
            .borderRadius(16)

          if (item.isLive) {
            Image($r('app.media.icon_is_living'))
              .width(24)
              .height(24)
              .margin({ top: 8, right: 8 })
          }
        }
        .alignContent(Alignment.TopEnd)
        .aspectRatio(1)
        .width(this.getSwiperSize())
        .height(this.getSwiperSize())
      }, (index: number) => `recommend-${index}`)
    }
    .displayCount((this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
      this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? 2 :
      new WidthBreakpointType(2, 3, 4, 4).getValue(this.breakpoint.widthBreakpoint))
    .itemSpace(new WidthBreakpointType(16, 12, 16, 16).getValue(this.breakpoint.widthBreakpoint))
    .margin({
      top: (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
        this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? 24 : 0,
      bottom: new WidthBreakpointType(16, 12, 16, 16).getValue(this.breakpoint.widthBreakpoint)
    })
    .indicator(false)
  }
}
