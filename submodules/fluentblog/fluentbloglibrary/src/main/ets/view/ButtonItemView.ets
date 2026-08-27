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
import ButtonUnitItem from '../viewmodel/ButtonUnitItem';

// Row height
const ROW_HEIGHT = 40;
// Static margin
const STATIC_MARGIN = 10;

@Component
export default struct ButtonItemView {
  @Prop unit: ButtonUnitItem;

  build() {
    Row() {
      SymbolGlyph(this.unit.buttonLikesImg)
        .fontColor([$r('sys.color.comp_foreground_primary')])
        .fontSize($r('sys.float.Title_M'))
      SymbolGlyph(this.unit.buttonCommentImg)
        .fontColor([$r('sys.color.comp_foreground_primary')])
        .fontSize($r('sys.float.Title_M'))
      SymbolGlyph(this.unit.buttonCollectImg)
        .fontColor([$r('sys.color.comp_foreground_primary')])
        .fontSize($r('sys.float.Title_M'))
      SymbolGlyph(this.unit.buttonShareImg)
        .fontColor([$r('sys.color.comp_foreground_primary')])
        .fontSize($r('sys.float.Title_M'))
    }
    .height(ROW_HEIGHT)
    .width(Constants.FULL_SIZE)
    .justifyContent(FlexAlign.SpaceAround)
    .margin({ left: STATIC_MARGIN, right: STATIC_MARGIN })
  }
}