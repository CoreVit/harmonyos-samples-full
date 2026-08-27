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

export class ProductInfoModel {
  public static readonly GRADIENT_COLORS: string[] = ['#FF6354', '#CF0A2C', '#FAE8E0', '#FFC9C9'];
  public static readonly PRODUCT_CONFIG_LIST_SPACE: number = 12;

  private static getStringSafe(context: Context, res: Resource): string {
    try {
      return context.resourceManager.getStringSync(res.id);
    } catch (error) {
      return '';
    }
  }

  static isLargeWidth(widthBp: WidthBreakpoint): boolean {
    return widthBp === WidthBreakpoint.WIDTH_LG || widthBp === WidthBreakpoint.WIDTH_XL;
  }

  static horizontalPaddingVp(widthBp: WidthBreakpoint): number {
    if (widthBp === WidthBreakpoint.WIDTH_XS || widthBp === WidthBreakpoint.WIDTH_SM) {
      return 16;
    }
    if (widthBp === WidthBreakpoint.WIDTH_MD) {
      return 24;
    }
    return 32;
  }

  static marginSmMdLg(widthBp: WidthBreakpoint, sm: number, md: number, lg: number): number {
    if (widthBp === WidthBreakpoint.WIDTH_XS || widthBp === WidthBreakpoint.WIDTH_SM) {
      return sm;
    }
    if (widthBp === WidthBreakpoint.WIDTH_MD) {
      return md;
    }
    return lg;
  }

  static getColorSelectionImages(): Resource[] {
    return [
      $r('app.media.product_small_1'),
      $r('app.media.product_small_2'),
      $r('app.media.product_small_3')
    ];
  }

  static getRecommendedConfigImages(): Resource[] {
    return [
      $r('app.media.recommended_config_1'),
      $r('app.media.recommended_config_2'),
      $r('app.media.recommended_config_3'),
      $r('app.media.recommended_config_4')
    ];
  }

  static getProductPriceNames(context: Context): string[] {
    return [
      '￥',
      '12999',
      '￥13999',
      ProductInfoModel.getStringSafe(context, $r('app.string.PRODUCT_PRICE_NAMES1')),
      '07',
      ':',
      '14',
      ':',
      '50',
      ProductInfoModel.getStringSafe(context, $r('app.string.PRODUCT_PRICE_NAMES2')),
      ProductInfoModel.getStringSafe(context, $r('app.string.PRODUCT_PRICE_NAMES3')),
      ProductInfoModel.getStringSafe(context, $r('app.string.PRODUCT_PRICE_NAMES4')),
      ProductInfoModel.getStringSafe(context, $r('app.string.PRODUCT_PRICE_NAMES5')),
      ProductInfoModel.getStringSafe(context, $r('app.string.PRODUCT_PRICE_NAMES6')),
      ProductInfoModel.getStringSafe(context, $r('app.string.PRODUCT_PRICE_NAMES7')),
      ProductInfoModel.getStringSafe(context, $r('app.string.PRODUCT_PRICE_NAMES8'))
    ];
  }

  static getProductDiscountNames(context: Context): string[] {
    return [
      ProductInfoModel.getStringSafe(context, $r('app.string.PRODUCT_DISCOUNT_NAMES1')),
      ProductInfoModel.getStringSafe(context, $r('app.string.PRODUCT_DISCOUNT_NAMES2')),
      ProductInfoModel.getStringSafe(context, $r('app.string.PRODUCT_DISCOUNT_MATE')),
      ProductInfoModel.getStringSafe(context, $r('app.string.PRODUCT_DISCOUNT_NAMES3'))
    ];
  }

  static getProductConfigNames(context: Context): string[] {
    return [
      ProductInfoModel.getStringSafe(context, $r('app.string.PRODUCT_CONFIG_NAMES1')),
      ProductInfoModel.getStringSafe(context, $r('app.string.PRODUCT_CONFIG_NAMES2')),
      ProductInfoModel.getStringSafe(context, $r('app.string.PRODUCT_CONFIG_NAMES3')),
      ProductInfoModel.getStringSafe(context, $r('app.string.PRODUCT_CONFIG_NAMES4')),
      ProductInfoModel.getStringSafe(context, $r('app.string.PRODUCT_CONFIG_NAMES5')),
      ProductInfoModel.getStringSafe(context, $r('app.string.PRODUCT_CONFIG_NAMES6')),
      ProductInfoModel.getStringSafe(context, $r('app.string.PRODUCT_CONFIG_NAMES7')),
      ProductInfoModel.getStringSafe(context, $r('app.string.PRODUCT_CONFIG_NAMES8'))
    ];
  }

  static getUserCommentNames(context: Context): string[] {
    return [
      ProductInfoModel.getStringSafe(context, $r('app.string.USER_COMMENT_NAMES1')),
      ProductInfoModel.getStringSafe(context, $r('app.string.USER_COMMENT_NAMES2')),
      ProductInfoModel.getStringSafe(context, $r('app.string.USER_COMMENT_NAMES3')),
      ProductInfoModel.getStringSafe(context, $r('app.string.USER_COMMENT_NAMES4')),
      ProductInfoModel.getStringSafe(context, $r('app.string.USER_COMMENT_NAMES5')),
      ProductInfoModel.getStringSafe(context, $r('app.string.USER_COMMENT_NAMES6')),
      ProductInfoModel.getStringSafe(context, $r('app.string.USER_COMMENT_NAMES7')),
      ProductInfoModel.getStringSafe(context, $r('app.string.USER_COMMENT_NAMES8'))
    ];
  }
}
