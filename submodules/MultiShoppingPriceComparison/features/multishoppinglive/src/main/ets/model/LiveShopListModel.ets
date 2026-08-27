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

import { LiveProduct } from './LiveProduct';

/** Matches CommonConstants.BIND_SHEET_PAGE_TYPES[2] in the original implementation (product detail half-sheet). */
export class LiveShopListModel {
  public static readonly SHEET_PRODUCT_DETAIL: string = 'ProductDetail';

  private static getStringSafe(context: Context, res: Resource): string {
    try {
      return context.resourceManager.getStringSync(res.id);
    } catch (error) {
      return '';
    }
  }

  static getProductResources(): Resource[] {
    return [
      $r('app.media.live_product_1'),
      $r('app.media.live_product_2'),
      $r('app.media.live_product_3'),
      $r('app.media.live_product_4'),
      $r('app.media.live_product_5'),
      $r('app.media.live_product_6'),
      $r('app.media.live_product_7'),
      $r('app.media.live_product_8')
    ];
  }

  static getProductNames(context: Context): string[] {
    return [
      LiveShopListModel.getStringSafe(context, $r('app.string.LIVE_SHOP_NAME_1')),
      LiveShopListModel.getStringSafe(context, $r('app.string.LIVE_SHOP_NAME_2')),
      LiveShopListModel.getStringSafe(context, $r('app.string.LIVE_SHOP_NAME_3')),
      LiveShopListModel.getStringSafe(context, $r('app.string.LIVE_SHOP_NAME_4')),
      LiveShopListModel.getStringSafe(context, $r('app.string.LIVE_SHOP_NAME_5')),
      LiveShopListModel.getStringSafe(context, $r('app.string.LIVE_SHOP_NAME_6')),
      LiveShopListModel.getStringSafe(context, $r('app.string.LIVE_SHOP_NAME_7')),
      LiveShopListModel.getStringSafe(context, $r('app.string.LIVE_SHOP_NAME_8'))
    ];
  }

  static getProductPrices(context: Context): string[] {
    return [
      LiveShopListModel.getStringSafe(context, $r('app.string.LIVE_SHOP_PRICE_1')),
      LiveShopListModel.getStringSafe(context, $r('app.string.LIVE_SHOP_PRICE_2')),
      LiveShopListModel.getStringSafe(context, $r('app.string.LIVE_SHOP_PRICE_3')),
      LiveShopListModel.getStringSafe(context, $r('app.string.LIVE_SHOP_PRICE_4')),
      LiveShopListModel.getStringSafe(context, $r('app.string.LIVE_SHOP_PRICE_5')),
      LiveShopListModel.getStringSafe(context, $r('app.string.LIVE_SHOP_PRICE_6')),
      LiveShopListModel.getStringSafe(context, $r('app.string.LIVE_SHOP_PRICE_7')),
      LiveShopListModel.getStringSafe(context, $r('app.string.LIVE_SHOP_PRICE_8'))
    ];
  }

  static buildProductList(context: Context): LiveProduct[] {
    const names = LiveShopListModel.getProductNames(context);
    const imgs = LiveShopListModel.getProductResources();
    const prices = LiveShopListModel.getProductPrices(context);
    const list: LiveProduct[] = [];
    for (let i = 0; i < names.length; i++) {
      list.push(new LiveProduct(names[i], imgs[i], prices[i]));
    }
    return list;
  }
}
