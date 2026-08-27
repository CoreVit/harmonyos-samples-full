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

import { CommonConstants, CommonConstants as Const } from '../common/constants/CommonConstants';
import { IProductItem, FlowItemCardType } from '../model/ProductItem';
import { waterFlowData } from '../model/HomeViewModel';

/**
 * Flow item component.
 * Usage: This component is used in FlowItem.
 */
@Component
export default struct FlowItemComponent {
  item: IProductItem = waterFlowData[0];

  build() {
    if (this.item?.showType === FlowItemCardType.SWIPER) {
      this.SwiperCardBuilder(this.item)
    } else {
      Stack() {
        Column() {
          Image(this.item?.imageUrl)
            .aspectRatio(this.item?.imgRatio)
            .width(CommonConstants.FULL_WIDTH)
            .objectFit(ImageFit.Contain)
            .backgroundColor($r('app.color.flow_image_bg_color'))
            .borderRadius({
              topLeft: $r('app.float.product_layout_radius'),
              topRight: $r('app.float.product_layout_radius')
            })
          Text(this.item?.name)
            .fontSize($r('app.float.small_font_size'))
            .fontWeight(FontWeight.Normal)
            .maxLines(2)
            .alignSelf(ItemAlign.Start)
            .margin({
              top: $r('app.float.product_name_margin_top'),
              left: $r('app.float.product_layout_margin_left'),
              right: $r('app.float.product_layout_margin_right')
            })
          Text(this.item?.discount)
            .fontSize($r('app.float.smaller_font_size'))
            .fontWeight(FontWeight.Normal)
            .opacity(Const.SIXTY_OPACITY)
            .alignSelf(ItemAlign.Start)
            .margin({
              left: $r('app.float.product_layout_margin_left'),
              right: $r('app.float.product_layout_margin_right')
            })
          Text(this.item?.price)
            .fontSize($r('app.float.middle_font_size'))
            .fontColor($r('app.color.focus_color'))
            .fontWeight(FontWeight.Normal)
            .alignSelf(ItemAlign.Start)
            .lineHeight($r('app.float.piece_line_height'))
            .margin({
              top: $r('app.float.product_price_margin_top'),
              left: $r('app.float.product_layout_margin_left'),
              right: $r('app.float.product_layout_margin_right')
            })
          Row() {
            Stack() {
              if (this.item?.promotion) {
                Text(this.item?.promotion)
                  .height($r('app.float.promotion_text_height'))
                  .fontSize($r('app.float.promotion_font_size'))
                  .fontColor(Color.White)
                  .fontWeight(CommonConstants.FONT_WEIGHT_FIVE)
                  .borderRadius($r('app.float.promotion_radius'))
                  .backgroundColor($r('app.color.focus_color'))
                  .padding({
                    left: $r('app.float.promotion_padding_left'),
                    right: $r('app.float.promotion_padding_right')
                  })
                  .margin({
                    top: $r('app.float.product_promotion_margin_top'),
                    left: $r('app.float.product_layout_margin_left')
                  })
              }
            }

            Stack() {
              if (this.item?.bonusPoints) {
                Text(this.item?.bonusPoints)
                  .height($r('app.float.promotion_text_height'))
                  .fontSize($r('app.float.promotion_font_size'))
                  .fontColor($r('app.color.focus_color'))
                  .fontWeight(CommonConstants.FONT_WEIGHT_FIVE)
                  .borderRadius($r('app.float.promotion_radius'))
                  .borderWidth($r('app.float.bonus_points_radius_width'))
                  .borderColor($r('app.color.focus_color'))
                  .padding({
                    left: $r('app.float.bonus_points_padding_left'),
                    right: $r('app.float.bonus_points_padding_right')
                  })
                  .margin({
                    top: $r('app.float.product_bonus_margin_top'),
                    left: $r('app.float.product_bonus_margin_left'),
                    right: $r('app.float.product_layout_margin_right')
                  })
              }
            }
          }
          .width(Const.FULL_WIDTH)
          .justifyContent(FlexAlign.Start)
        }
        .borderRadius($r('app.float.product_layout_radius'))
        .backgroundColor($r('sys.color.ohos_id_color_dialog_bg'))
        .padding({
          bottom: $r('app.float.product_layout_margin_bottom')
        })
      }
    }
  }

  @Builder
  SwiperCardBuilder(item: IProductItem) {
    Swiper() {
      ForEach(item?.swiperUrls, (item: Resource) => {
        Image(item)
          .width(Const.FULL_WIDTH)
          .aspectRatio(this.item?.imgRatio)
          .borderRadius($r('app.float.product_layout_radius'))
          .backgroundColor($r('app.color.flow_image_bg_color'))
      }, (item: Resource) => JSON.stringify(item))
    }
    .indicator(
      new DotIndicator()
        .selectedColor($r('app.color.indicator_select'))
    )
    .autoPlay(true)
    .itemSpace(0)
    .width(Const.FULL_WIDTH)
    .displayCount(1)
  }
}