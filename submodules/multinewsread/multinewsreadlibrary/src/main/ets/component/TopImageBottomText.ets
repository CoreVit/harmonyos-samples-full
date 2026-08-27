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

import Constants from '../common/Constants';
import { News } from '../viewmodel/ImageAndTextViewModel';

@Component
export default struct TopImageBottomText {
  @Prop news: News;

  build() {
    Column() {
      Image(this.news.getFirstImage())
        .height($r('app.float.image_height'))
        .width(Constants.FULL_WIDTH)
        .borderRadius({
          topLeft: $r('sys.float.corner_radius_level5'),
          topRight: $r('sys.float.corner_radius_level5')
        })
      Text()
        .backgroundColor($r('sys.color.comp_background_secondary'))
        .height($r('app.float.font_pic_height'))
        .width('80%')
        .borderRadius($r('app.float.font_radius'))
        .margin({
          bottom: $r('sys.float.padding_level2'),
          top: $r('sys.float.padding_level6'),
          left: $r('sys.float.padding_level4')
        })
        .alignSelf(ItemAlign.Start)
      Text()
        .backgroundColor($r('sys.color.comp_background_secondary'))
        .height($r('app.float.font_pic_height'))
        .width('35%')
        .borderRadius($r('app.float.font_radius'))
        .margin({ bottom: $r('sys.float.padding_level7'), left: $r('sys.float.padding_level4') })
        .alignSelf(ItemAlign.Start)
      Row() {
        Row() {
          Text()
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .height($r('app.float.small_font_size'))
            .borderRadius($r('app.float.small_font_radius'))
            .width($r('app.float.font_width5'))
          Text(' ')
          Text(this.news.getTimeToNow())
            .opacity(Constants.OPACITY[0])
            .fontFamily($r('app.string.font_family'))
            .fontSize($r('sys.float.Body_S'))
            .fontColor($r('sys.color.font_primary'))
            .fontWeight(Constants.FONT_WEIGHT[0])
        }

        SymbolGlyph($r('sys.symbol.dot_grid_1x2'))
          .fontColor([$r('sys.color.icon_primary')])
          .fontSize($r('app.float.small_more_icon_size'))
      }
      .borderRadius($r('sys.float.corner_radius_level5'))
      .backgroundColor($r('sys.color.background_secondary'))
      .padding({ right: $r('sys.float.padding_level4'), left: $r('sys.float.padding_level4') })
      .width(Constants.FULL_WIDTH)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width(Constants.FULL_WIDTH)
    .height($r('app.float.cards_height'))
    .borderRadius($r('sys.float.corner_radius_level5'))
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}