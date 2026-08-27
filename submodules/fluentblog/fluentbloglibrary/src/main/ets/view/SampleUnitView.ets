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

import ButtonUnitItem from '../viewmodel/ButtonUnitItem';
import ButtonItemView from './ButtonItemView';
import SampleUnitPicView from './SampleUnitPicView';
import SampleUnitVideoView from './SampleUnitVideoView';
import TitleAreaItemView from './TitleAreaItemView';

// Font family
const FONT_FAMILY = 'HarmonyHeiTi';
// Margin about
const STATIC_MARGIN = 8;
// All types
const TYPE_ENUM = ['video', 'pic'];
// Font weight.
const FONT_WEIGHT = 400;
// Border radius
const BORDER_RADIUS = 5;

@Component
export default struct SampleUnitView {
  @Prop buttonUnit: ButtonUnitItem;
  @Prop type: string;
  @Prop imageArray: Resource[];

  build() {
    Flex({ direction: FlexDirection.Column }) {
      TitleAreaItemView()
      Text($r('app.string.show_text'))
        .fontSize(14)
        .fontWeight(FONT_WEIGHT)
        .textAlign(TextAlign.JUSTIFY)
        .fontFamily(FONT_FAMILY)
        .margin({ bottom: STATIC_MARGIN })
      if (this.type === TYPE_ENUM[0]) {
        SampleUnitVideoView();
      } else if (this.type === TYPE_ENUM[1]) {
        SampleUnitPicView({ imageArray: this.imageArray });
      }
      Column() {
        ButtonItemView({ unit: this.buttonUnit })
      }
      .margin({ bottom: STATIC_MARGIN, top: STATIC_MARGIN })
    }
    .borderRadius(BORDER_RADIUS)
  }
}