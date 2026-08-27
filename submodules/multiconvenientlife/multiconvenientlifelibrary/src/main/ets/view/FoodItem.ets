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

import { CommonConstants } from '../constants/CommonConstants';
import { FoodData } from '../viewmodel/FoodListViewModel';

@Component
export struct FoodItem {
  @Consume(CommonConstants.LIFE_PREFIX + 'ifShowSides') ifShowSides: boolean;
  @Prop foodData: FoodData;
  @Prop chooseIndex: number;
  listIndex: number = 0;

  @Styles
  orangeText() {
    .backgroundColor($r('app.color.orange_background'))
    .padding($r('app.float.orange_padding'))
    .borderRadius($r('app.float.orange_border'))
  }

  build() {
    Row() {
      Image(this.foodData.getImage())
        .width($r('app.float.food_data_image'))
        .aspectRatio(1)
      Column() {
        Row() {
          Button()
            .backgroundColor($r('sys.color.comp_divider'))
            .height(18)
            .width(120)
        }
        .width(CommonConstants.FULL_PERCENT)
        .margin({
          bottom: $r('app.float.food_data_bottom')
        })

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Rating({ rating: this.foodData.getRating(), indicator: true })
            .height(16)
            .margin({
              right: $r('sys.float.padding_level4')
            })
          Text(this.foodData.getRating().toFixed(1))
            .fontWeight(CommonConstants.FONT_WEIGHT_700)
            .fontColor($r('sys.color.ohos_id_color_alert'))
            .maxFontSize(14)
            .minFontSize(12)
            .maxLines(1)
            .margin({
              right: $r('app.float.filtering_margin_right')
            })
          Text(CommonConstants.CURRENCY_SYMBOL + 'XX')
            .fontWeight(CommonConstants.FONT_WEIGHT_400)
            .maxFontSize(12)
            .minFontSize(10)
            .maxLines(1)
            .textAlign(TextAlign.Center)
        }
        .width(CommonConstants.FULL_PERCENT)
        .margin({
          bottom: $r('app.float.food_margin_bottom')
        })

        Row() {
          Button()
            .height(12)
            .width(40)
            .backgroundColor($r('sys.color.comp_background_secondary'))
          Blank()
          Button()
            .height(12)
            .width(40)
            .backgroundColor($r('sys.color.comp_background_secondary'))
        }
        .width(CommonConstants.FULL_PERCENT)
        .margin({
          bottom: $r('app.float.text_margin_bottom')
        })

        Row() {
          Button()
            .height(14)
            .constraintSize({
              minWidth: 65,
              maxWidth: 80
            })
            .backgroundColor($r('sys.color.ohos_id_color_alert'))
            .margin({ right: 4 })
            .opacity(0.15)
          Blank()
          Button()
            .height(14)
            .constraintSize({
              minWidth: 65,
              maxWidth: 80
            })
            .backgroundColor($r('sys.color.ohos_id_color_alert'))
            .opacity(0.15)
        }
        .width(CommonConstants.FULL_PERCENT)
        .margin({
          bottom: $r('app.float.text_margin_bottom')
        })

        Row() {
          Button()
            .type(ButtonType.Circle)
            .size({ width: 14, height: 14 })
            .backgroundColor($r('sys.color.ohos_id_color_alert'))
            .opacity(0.15)
            .margin({ right: 4 })
          Button()
            .type(ButtonType.Capsule)
            .size({ width: 21, height: 16 })
            .backgroundColor($r('sys.color.ohos_id_color_alert'))
            .opacity(0.15)
            .margin({ right: 4 })
          Button()
            .type(ButtonType.Capsule)
            .size({ width: 29, height: 16 })
            .backgroundColor($r('sys.color.comp_background_secondary'))
            .margin({ right: 8 })
          Button()
            .type(ButtonType.Capsule)
            .size({ height: 16 })
            .layoutWeight(1)
            .backgroundColor($r('sys.color.comp_background_secondary'))
        }
        .width(CommonConstants.FULL_PERCENT)
      }
      .padding({
        left: $r('app.float.twelves_padding')
      })
      .layoutWeight(1)
    }
    .alignItems(VerticalAlign.Top)
    .width(CommonConstants.FULL_PERCENT)
    .padding($r('app.float.twelves_padding'))
    .borderRadius($r('app.float.dish_border'))
    .backgroundColor(this.listIndex === this.chooseIndex && this.ifShowSides ?
      $r('app.color.food_background') : $r('sys.color.comp_background_gray'))
  }
}