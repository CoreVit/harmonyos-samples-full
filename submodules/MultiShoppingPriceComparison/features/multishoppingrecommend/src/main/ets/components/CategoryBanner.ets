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
import { CategoryBannerState } from '../viewmodel/CategoryBannerState';

@ComponentV2
export struct CategoryBanner {
  private swiperController: SwiperController = new SwiperController();
  @Env(SystemProperties.BREAK_POINT) private breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Local private state: CategoryBannerState = new CategoryBannerState();

  build() {
    Swiper(this.swiperController) {
      ForEach(this.state.bannerList, (item: Resource) => {
        Image(item)
          .width('100%')
          .height(107)
          .aspectRatio(2.32)
      }, (_item: Resource, index: number) => `banner-${index}`)
    }
    .loop(true)
    .indicator((this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
      this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? Indicator.dot()
      .itemWidth(6)
      .itemHeight(6)
      .selectedItemWidth(12)
      .selectedItemHeight(6)
      .color($r('app.color.banner_indicator'))
      .selectedColor('#CF0A2C') : false)
    .displayCount((this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
      this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? 1 :
      (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_MD ? 2 : 3))
    .nextMargin(this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_MD ? 13 : 0)
    .itemSpace((this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
      this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? 0 :
      (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_MD ? 12 : 16))
  }
}