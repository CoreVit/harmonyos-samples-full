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

export class ProductSwiperModel {
  private static getStringSafe(context: Context, res: Resource): string {
    try {
      return context.resourceManager.getStringSync(res.id);
    } catch (error) {
      return '';
    }
  }

  static getDetailResources(): Resource[] {
    return [
      $r('app.media.product_detail_1'),
      $r('app.media.product_detail_2'),
      $r('app.media.product_detail_2'),
      $r('app.media.product_detail_2'),
      $r('app.media.product_detail_3')
    ];
  }

  static getSmallResources(): Resource[] {
    return [
      $r('app.media.product_small_1'),
      $r('app.media.product_small_2'),
      $r('app.media.product_small_2'),
      $r('app.media.product_small_2'),
      $r('app.media.product_small_3')
    ];
  }

  static getIndicatorTexts(context: Context): string[] {
    return [
      ProductSwiperModel.getStringSafe(context, $r('app.string.PRODUCT_SWIPER_3D')),
      ProductSwiperModel.getStringSafe(context, $r('app.string.PRODUCT_SWIPER_COMPARE'))
    ];
  }

  static getLivingText(context: Context): string {
    return ProductSwiperModel.getStringSafe(context, $r('app.string.PRODUCT_SWIPER_LIVING'));
  }
}
