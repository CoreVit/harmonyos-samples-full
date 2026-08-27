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
export default struct TopTextBottomVideo {
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

      RelativeContainer() {
        Image(this.news.getFirstImage())
          .width(Constants.FULL_WIDTH)
          .borderRadius($r('sys.float.corner_radius_level5'))
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            left: { anchor: '__container__', align: HorizontalAlign.Start }
          })
          .id('previewImg')
        Row() {
          Image($r('app.media.ic_pause'))
            .width($r('app.float.play_icon_width'))
            .height($r('app.float.play_icon_height'))
        }
        .alignRules({
          middle: { anchor: 'previewImg', align: HorizontalAlign.Center },
          center: { anchor: 'previewImg', align: VerticalAlign.Center }
        })
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .backgroundColor(Color.Black)
        .opacity(Constants.OPACITY[0])
        .borderRadius($r('sys.float.corner_radius_level10'))
        .width($r('app.float.play_icon_size'))
        .height($r('app.float.play_icon_size'))
        .id('sample_multi_news_read_id_2_playBtn')

        Row() {
          Text(this.news.getDuration())
            .fontFamily($r('app.string.font_family_normal'))
            .fontSize($r('app.float.smallest_font_size'))
            .fontColor(Color.White)
            .opacity(Constants.OPACITY[2])
            .lineHeight($r('app.float.duration_height'))
            .fontWeight(Constants.FONT_WEIGHT[0])
            .width($r('app.float.duration_width'))
            .height($r('app.float.duration_height'))
            .backgroundColor(Color.Black)
            .borderRadius($r('sys.float.corner_radius_level2'))
        }
        .borderRadius($r('sys.float.corner_radius_level2'))
        .width($r('app.float.duration_container_width'))
        .height($r('app.float.duration_container_height'))
        .padding($r('sys.float.padding_level2'))
        .opacity(Constants.OPACITY[1])
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Top)
        .alignRules({
          bottom: { anchor: 'previewImg', align: VerticalAlign.Bottom },
          right: { anchor: 'previewImg', align: HorizontalAlign.End }
        })
        .id('sample_multi_news_read_id_2_duration')
      }
      .width(Constants.FULL_WIDTH)
      .height($r('app.float.relative_container_height'))

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