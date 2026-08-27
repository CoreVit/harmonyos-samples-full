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

import { CommonConstants, getWindowInfoState, WidthBreakpointType, WindowInfo } from 'multimobilepaymentbase';
import { QuickActionsView } from './QuickActionsView';

/**
 * Recommendation view component
 * Main header view containing location, search, and quick actions
 */
@ComponentV2
export struct RecommendationView {
  @Event onPaymentClick: () => void = () => {
  };
  @Event onScanClick: () => void = () => {
  };
  @Local windowInfo: WindowInfo = getWindowInfoState();

  build() {
    Column() {
      Row({ space: $r('app.float.recommendation_search_space') }) {
        Row({ space: $r('app.float.recommendation_location_space') }) {
          SymbolGlyph($r('sys.symbol.local_fill'))
            .fontSize($r('app.float.recommendation_location_icon_size'))
            .fontColor([$r('app.color.on_primary')])
          Text($r('app.string.city'))
            .fontSize($r('app.float.recommendation_location_text_size'))
            .fontColor($r('app.color.on_primary'))
        }

        if (!(this.windowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
          this.windowInfo.heightBp <= HeightBreakpoint.HEIGHT_MD)) {
          Blank()
        }

        Search({ placeholder: $r('app.string.search_placeholder') })
          .width(new WidthBreakpointType($r('app.float.search_width_sm'), $r('app.float.search_width_md'),
            $r('app.float.search_width_lg'), $r('app.float.search_width_xl')).getValue(this.windowInfo.widthBp))
          .searchIcon({ color: $r('app.color.on_primary60') })
          .placeholderColor($r('app.color.on_primary60'))

        Image($r('app.media.ic_public_more'))
          .width($r('app.float.recommendation_more_icon_size'))
          .height($r('app.float.recommendation_more_icon_size'))
          .fillColor($r('app.color.on_primary'))
      }
      .width(CommonConstants.FULL_WIDTH)
      .padding({
        top: this.windowInfo.statusBarTopVp,
        right: this.windowInfo.isImmersive ? this.windowInfo.titleButtonRect?.width : 0
      })

      QuickActionsView({
        onPaymentClick: this.onPaymentClick,
        onScanClick: this.onScanClick
      })
    }
    .width(CommonConstants.FULL_WIDTH)
    .padding({
      left: new WidthBreakpointType($r('app.float.recommendation_padding_sm'),
        $r('app.float.recommendation_padding_md'), $r('app.float.recommendation_padding_lg'),
        $r('app.float.recommendation_padding_sm')).getValue(this.windowInfo.widthBp),
      right: new WidthBreakpointType($r('app.float.recommendation_padding_sm'),
        $r('app.float.recommendation_padding_md'), $r('app.float.recommendation_padding_lg'),
        $r('app.float.recommendation_padding_sm')).getValue(this.windowInfo.widthBp)
    })
  }
}
