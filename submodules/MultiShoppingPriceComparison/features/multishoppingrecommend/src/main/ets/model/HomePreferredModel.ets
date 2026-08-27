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

export class HomePreferredItem {
  public image: Resource;
  public title: string;
  public info: string;
  public feature: string;
  public price: string;
  public comments: string;
  public isLive: boolean;

  constructor(
    image: Resource,
    title: string,
    info: string,
    feature: string,
    price: string,
    comments: string,
    isLive: boolean
  ) {
    this.image = image;
    this.title = title;
    this.info = info;
    this.feature = feature;
    this.price = price;
    this.comments = comments;
    this.isLive = isLive;
  }
}

export class HomePreferredModel {
  private static getStringSafe(context: Context, res: Resource): string {
    try {
      return context.resourceManager.getStringSync(res.id);
    } catch (error) {
      return '';
    }
  }

  static getTitle(context: Context): string {
    return HomePreferredModel.getStringSafe(context, $r('app.string.HOME_TITLES2'));
  }

  static getItems(context: Context): HomePreferredItem[] {
    const comments: string = HomePreferredModel.getStringSafe(context, $r('app.string.HOME_REVIEW'));
    return [
      new HomePreferredItem($r('app.media.section_product_1'),
        HomePreferredModel.getStringSafe(context, $r('app.string.HOME_PREFERRED_MATEBOOK_TITLE')),
        '',
        HomePreferredModel.getStringSafe(context, $r('app.string.HOME_PREFERRED_MATEBOOK_FEATURE')),
        '￥10999', comments, false),
      new HomePreferredItem(
        $r('app.media.section_product_2'),
        HomePreferredModel.getStringSafe(context, $r('app.string.HOME_PREFERRED_MATE50_NEW_TITLE')),
        HomePreferredModel.getStringSafe(context, $r('app.string.SECTION_PRODUCTS_INFO1')),
        HomePreferredModel.getStringSafe(context, $r('app.string.SECTION_PRODUCTS_FEATURES2')),
        '￥4999',
        comments,
        true
      ),
      new HomePreferredItem(
        $r('app.media.section_product_3'),
        'Sound X NEW',
        '',
        HomePreferredModel.getStringSafe(context, $r('app.string.SECTION_PRODUCTS_FEATURES3')),
        '￥2499',
        comments,
        false
      ),
      new HomePreferredItem(
        $r('app.media.section_product_4'),
        'HUAWEI MatePad Air',
        HomePreferredModel.getStringSafe(context, $r('app.string.SECTION_PRODUCTS_INFO2')),
        HomePreferredModel.getStringSafe(context, $r('app.string.SECTION_PRODUCTS_FEATURES4')),
        '￥2599',
        comments,
        false
      ),
      new HomePreferredItem(
        $r('app.media.section_product_5'),
        'HUAWEI MateBook 14s',
        HomePreferredModel.getStringSafe(context, $r('app.string.SECTION_PRODUCTS_INFO3')),
        HomePreferredModel.getStringSafe(context, $r('app.string.SECTION_PRODUCTS_FEATURES5')),
        '￥8399',
        comments,
        false
      )
    ];
  }
}
