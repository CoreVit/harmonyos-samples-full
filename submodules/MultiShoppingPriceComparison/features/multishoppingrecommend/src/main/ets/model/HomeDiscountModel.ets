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

export class HomeDiscountItem {
  public info: string;
  public image: Resource;

  constructor(info: string, image: Resource) {
    this.info = info;
    this.image = image;
  }
}

export class HomeDiscountModel {
  private static getStringSafe(context: Context, res: Resource): string {
    try {
      return context.resourceManager.getStringSync(res.id);
    } catch (error) {
      return '';
    }
  }

  static getPriceUnit(context: Context): string {
    return HomeDiscountModel.getStringSafe(context, $r('app.string.PRICE_UNIT'));
  }

  static getItems(context: Context): HomeDiscountItem[] {
    const priceUnit: string = HomeDiscountModel.getPriceUnit(context);
    return [
      new HomeDiscountItem(`￥1299${priceUnit}`, $r('app.media.welfare_product_1')),
      new HomeDiscountItem(`￥899${priceUnit}`, $r('app.media.welfare_product_2')),
      new HomeDiscountItem(`￥599${priceUnit}`, $r('app.media.welfare_product_3')),
      new HomeDiscountItem(`￥2499${priceUnit}`, $r('app.media.welfare_product_4')),
      new HomeDiscountItem(`￥6988${priceUnit}`, $r('app.media.welfare_product_5')),
      new HomeDiscountItem(`￥1799${priceUnit}`, $r('app.media.welfare_product_6')),
      new HomeDiscountItem(`￥988${priceUnit}`, $r('app.media.welfare_product_7')),
      new HomeDiscountItem(`￥6999${priceUnit}`, $r('app.media.welfare_product_8'))
    ];
  }
}
