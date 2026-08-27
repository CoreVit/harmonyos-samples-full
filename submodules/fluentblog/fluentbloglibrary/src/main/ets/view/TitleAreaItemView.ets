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

import { Constants } from '../common/Constants';

// Font family
const FONT_FAMILY = 'HarmonyHeiTi-Medium';
// Margin
const STATIC_MARGIN = 8;
// Static space
const STATIC_SPACE = 5;
// Static height
const STATIC_HEIGHT = 50;

@Component
export default struct TitleAreaItemView {
  build() {
    Row() {
      Row({ space: STATIC_SPACE }) {
        Image($r('app.media.avatar'))
          .height(Constants.BIG_ICON_SIZE)
          .width(Constants.BIG_ICON_SIZE)
          .objectFit(ImageFit.Contain)
        Column() {
          Text($r('app.string.show_netname'))
            .height('50%')
            .fontWeight(FontWeight.Medium)
            .fontFamily(FONT_FAMILY)
            .fontSize(14)
          Row({ space: STATIC_SPACE }) {
            Text($r('app.string.show_time'))
              .fontSize(12)
              .fontColor(Color.Gray)
          }
        }
        .width(Constants.FULL_SIZE)
        .alignItems(HorizontalAlign.Start)
        .margin({ left: STATIC_MARGIN })
      }
      .height(Constants.FULL_SIZE)
      .width('80%')
    }
    .width(Constants.FULL_SIZE)
    .height(STATIC_HEIGHT)
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ top: STATIC_MARGIN, bottom: STATIC_MARGIN })
  }
}