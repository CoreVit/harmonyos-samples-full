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

import { ShopBagHeaderIconConfig, ShopBagModel, ShopBagProductConfig } from '../model/ShopBagModel';

export class ShopBagViewModel {
  getTabNames(context: Context): string[] {
    return ShopBagModel.getTabNames(context);
  }

  getHeaderTitle(context: Context): string {
    return ShopBagModel.getHeaderTitle(context);
  }

  getHeaderIcons(context: Context): ShopBagHeaderIcon[] {
    return ShopBagModel.getHeaderIcons(context).map((item: ShopBagHeaderIconConfig) => {
      return new ShopBagHeaderIcon(item.icon, item.name);
    });
  }

  getPreferentialTitle(context: Context): string {
    return ShopBagModel.getPreferentialTitle(context);
  }

  getProducts(context: Context): ShopBagProduct[] {
    return ShopBagModel.getProducts(context).map((item: ShopBagProductConfig) => {
      return new ShopBagProduct(item.image, item.name, item.remark, item.discounts, item.price);
    });
  }

  getCurrencyPrefix(context: Context): string {
    try {
      return context.resourceManager.getStringSync($r('app.string.SHOP_BAG_CURRENCY').id);
    } catch {
      return '';
    }
  }
}

export class ShopBagHeaderIcon {
  private icon: Resource;
  private name: string;

  constructor(icon: Resource, name: string) {
    this.icon = icon;
    this.name = name;
  }

  getIcon(): Resource {
    return this.icon;
  }

  getName(): string {
    return this.name;
  }
}

export class ShopBagProduct {
  private image: Resource;
  private name: string;
  private remark: string;
  private discounts: string[];
  private price: number;

  constructor(image: Resource, name: string, remark: string, discounts: string[], price: number) {
    this.image = image;
    this.name = name;
    this.remark = remark;
    this.discounts = discounts;
    this.price = price;
  }

  getImage(): Resource {
    return this.image;
  }

  getName(): string {
    return this.name;
  }

  getRemark(): string {
    return this.remark;
  }

  getDiscounts(): string[] {
    return this.discounts;
  }

  getPrice(): number {
    return this.price;
  }
}
