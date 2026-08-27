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
export default struct NewsWithImages {
  @Prop news: News;

  build() {
    Column() {
      Text()
        .backgroundColor($r('sys.color.comp_background_secondary'))
        .height($r('app.float.font_pic_height'))
        .width('100%')
        .borderRadius($r('app.float.font_radius'))
        .margin({ bottom: $r('sys.float.padding_level2') })

      Text()
        .backgroundColor($r('sys.color.comp_background_secondary'))
        .height($r('app.float.font_pic_height'))
        .width('35%')
        .borderRadius($r('app.float.font_radius'))
        .margin({ bottom: $r('sys.float.padding_level4') })

      Row() {
        ForEach(this.news.getImages(), (item: Resource) => {
          Image(item)
            .width(Constants.ONE_THIRD_WIDTH)
            .objectFit(ImageFit.Cover)
        }, (item: Resource) => JSON.stringify(item))
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .width(Constants.FULL_WIDTH)

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
      .width(Constants.FULL_WIDTH)
      .height($r('app.float.bigger_line_height'))
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .alignItems(HorizontalAlign.Start)
    .width(Constants.FULL_WIDTH)
  }
}