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

import { CommonConstants } from '../common/constants/CommonConstants';
import { GridComponent } from './GridComponent';
import { GoodsTabComponent } from './GoodsTabComponent';
import SearchComponent from './SearchComponent';
import SwiperComponent from './SwiperComponent';

const SCROLL_OFFSET_FULL: number = 60;

@Component
export struct GoodsNavComponent {
  @State isRefreshing: boolean = false;
  @State bgOpacity: number = CommonConstants.FULL_OPACITY;
  private scroller: Scroller = new Scroller();
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Refresh({ refreshing: $$this.isRefreshing }) {
        Scroll(this.scroller) {
          Column() {
            SwiperComponent()
            GridComponent()
            GoodsTabComponent()
          }
        }
        .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
        .width(CommonConstants.FULL_WIDTH)
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Vertical)
        .onWillScroll(() => {
          let opacity = (SCROLL_OFFSET_FULL - (this.scroller.currentOffset()?.yOffset ?? 0)) * 1.0 / SCROLL_OFFSET_FULL;
          if (opacity <= 0) {
            this.bgOpacity = 0;
          } else {
            this.bgOpacity = opacity;
          }
        })
      }
      .onRefreshing(() => {
        setTimeout(() => {
          this.isRefreshing = false;
        }, CommonConstants.TIME_OUT_TWO_THOUSANDS)
      })
      .padding({
        top: this.statusBarHeight + CommonConstants.GOOD_NAV_TITLE_HEIGHT
      })

      SearchComponent()
    }
    .height(CommonConstants.FULL_HEIGHT)
    .backgroundColor($r('sys.color.gray_01'))
  }
}