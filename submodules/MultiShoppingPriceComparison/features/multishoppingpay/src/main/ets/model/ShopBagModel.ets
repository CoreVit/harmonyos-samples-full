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

export interface ShopBagHeaderIconConfig {
  icon: Resource;
  name: string;
}

export interface ShopBagProductConfig {
  image: Resource;
  name: string;
  remark: string;
  discounts: string[];
  price: number;
}

export class ShopBagModel {
  private static getString(context: Context, res: Resource): string {
    try {
      return context.resourceManager.getStringSync(res.id);
    } catch {
      return '';
    }
  }

  static getTabNames(context: Context): string[] {
    return [
      ShopBagModel.getString(context, $r('app.string.SHOP_BAG_TAB_ALL')),
      ShopBagModel.getString(context, $r('app.string.SHOP_BAG_TAB_PHONE')),
      ShopBagModel.getString(context, $r('app.string.SHOP_BAG_TAB_TABLET')),
      ShopBagModel.getString(context, $r('app.string.SHOP_BAG_TAB_LAPTOP')),
      ShopBagModel.getString(context, $r('app.string.SHOP_BAG_TAB_WATCH')),
      ShopBagModel.getString(context, $r('app.string.SHOP_BAG_TAB_EARPHONE'))
    ];
  }

  static getHeaderTitle(context: Context): string {
    return ShopBagModel.getString(context, $r('app.string.SHOP_BAG_HEADER_TITLE'));
  }

  static getHeaderIcons(context: Context): ShopBagHeaderIconConfig[] {
    return [
      {
        icon: $r('app.media.icon_bag'),
        name: ShopBagModel.getString(context, $r('app.string.SHOP_BAG_ICON_BAG'))
      },
      {
        icon: $r('app.media.icon_search'),
        name: ShopBagModel.getString(context, $r('app.string.SHOP_BAG_ICON_SEARCH'))
      },
      {
        icon: $r('app.media.icon_order'),
        name: ShopBagModel.getString(context, $r('app.string.SHOP_BAG_ICON_ORDER'))
      }
    ];
  }

  static getPreferentialTitle(context: Context): string {
    return ShopBagModel.getString(context, $r('app.string.SHOP_BAG_COUPON_TITLE'));
  }

  static getProducts(context: Context): ShopBagProductConfig[] {
    const g = (res: Resource) => ShopBagModel.getString(context, res);
    return [
      {
        image: $r('app.media.live_bag_product_1'),
        name: 'HUAWEI Mate 60 Pro',
        remark: g($r('app.string.SHOP_BAG_P1_REMARK')),
        discounts: [g($r('app.string.SHOP_BAG_DISCOUNT_POINTS')), g($r('app.string.SHOP_BAG_DISCOUNT_FLAGSHIP'))],
        price: 6999
      },
      {
        image: $r('app.media.live_bag_product_2'),
        name: 'Mate Xs 2',
        remark: g($r('app.string.SHOP_BAG_P2_REMARK')),
        discounts: [g($r('app.string.SHOP_BAG_DISCOUNT_FLAGSHIP'))],
        price: 9999
      },
      {
        image: $r('app.media.live_bag_product_3'),
        name: 'MateBook E Go',
        remark: g($r('app.string.SHOP_BAG_P3_REMARK')),
        discounts: [g($r('app.string.SHOP_BAG_DISCOUNT_P3'))],
        price: 4899
      },
      {
        image: $r('app.media.live_bag_product_4'),
        name: 'HUAWEI Mate 50',
        remark: g($r('app.string.SHOP_BAG_P4_REMARK')),
        discounts: [g($r('app.string.SHOP_BAG_DISCOUNT_POINTS')), g($r('app.string.SHOP_BAG_DISCOUNT_FLAGSHIP'))],
        price: 4999
      }
    ];
  }
}
