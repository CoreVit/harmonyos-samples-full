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

import { CommonConstants, getWindowInfoState, WindowInfo } from 'multimobilepaymentbase';
import { BusinessView, WealthSectionView, RecommendationView } from 'multimobilepaymentrecommend';

@ComponentV2
export struct HomeContentView {
  @Event onPaymentClick: () => void = () => {};
  @Event onScanClick: () => void = () => {};
  @Local windowInfo: WindowInfo = getWindowInfoState();

  build() {
    Scroll() {
      Stack({ alignContent: Alignment.TopStart }) {
        Image($r('app.media.header_background'))
          .width(CommonConstants.FULL_WIDTH)
          .height(CommonConstants.BACKGROUND_IMAGE_HEIGHT + this.windowInfo.statusBarTopVp)
          .objectFit(ImageFit.Fill)

        Column() {
          RecommendationView({
            onPaymentClick: this.onPaymentClick,
            onScanClick: this.onScanClick
          })

          BusinessView()

          WealthSectionView()
        }
        .width(CommonConstants.FULL_WIDTH)
      }
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
    .scrollBar(BarState.Off)
    .background(this.windowInfo.widthBp <= WidthBreakpoint.WIDTH_MD ? $r('app.color.on_primary') : $r('app.color.gray_01'))
  }
}
