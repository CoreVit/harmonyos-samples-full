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

import Constants from '../constants/Constants';
import { BreakpointTypeEnum } from '../constants/utils/BreakpointSystem';

@Component
export default struct TextMarqueeView {
  @State message: ResourceStr = '';
  @StorageLink(Constants.KEY_BREAKPOINT) curBp: string = BreakpointTypeEnum.SM;

  build() {
    Row() {
      Column() {
        Text(this.message)
          .width($r('app.string.ninety_percent'))
          .fontColor($r('sys.color.font_primary'))
          .fontSize($r('sys.float.Title_L'))
          .fontWeight(FontWeight.Bold)
          .textOverflow({ overflow: TextOverflow.MARQUEE })
      }
      .justifyContent(FlexAlign.Center)
      .height(this.curBp === BreakpointTypeEnum.SM ? '' : Constants.COLUMN_HEIGHT)
      .blendMode(BlendMode.SRC_IN, BlendApplyType.OFFSCREEN)
      .backgroundColor(Color.Transparent)
      .width(Constants.FULL_PERCENT)
    }
    .width(Constants.FULL_PERCENT)
    .linearGradient({
      angle: Constants.ANGLE_DEGREE_HORIZONTAL,
      colors: [[Color.Transparent, 0], [$r('sys.color.font_primary'), 0.2],
        [$r('sys.color.font_primary'), 0.8], [Color.Transparent, 1]]
    })
    .blendMode(BlendMode.SRC_OVER, BlendApplyType.OFFSCREEN)
  }
}