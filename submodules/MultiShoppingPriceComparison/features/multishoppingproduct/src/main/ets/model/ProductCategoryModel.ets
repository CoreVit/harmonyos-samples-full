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

export interface ProductCategoryItem {
  title: string;
  icon: Resource;
}

export class ProductCategoryItemModel implements ProductCategoryItem {
  public title: string;
  public icon: Resource;

  constructor(title: string, icon: Resource) {
    this.title = title;
    this.icon = icon;
  }
}

export class ProductCategoryModel {
  private static getStringSafe(context: Context, res: Resource): string {
    try {
      return context.resourceManager.getStringSync(res.id);
    } catch (error) {
      return '';
    }
  }

  static getItems(context: Context): ProductCategoryItem[] {
    const names: string[] = [
      ProductCategoryModel.getStringSafe(context, $r('app.string.GOOD_CATEGORIES1')),
      ProductCategoryModel.getStringSafe(context, $r('app.string.GOOD_CATEGORIES2')),
      ProductCategoryModel.getStringSafe(context, $r('app.string.GOOD_CATEGORIES3')),
      ProductCategoryModel.getStringSafe(context, $r('app.string.GOOD_CATEGORIES4')),
      ProductCategoryModel.getStringSafe(context, $r('app.string.GOOD_CATEGORIES5')),
      ProductCategoryModel.getStringSafe(context, $r('app.string.GOOD_CATEGORIES6')),
      ProductCategoryModel.getStringSafe(context, $r('app.string.GOOD_CATEGORIES7')),
      ProductCategoryModel.getStringSafe(context, $r('app.string.GOOD_CATEGORIES8')),
      ProductCategoryModel.getStringSafe(context, $r('app.string.GOOD_CATEGORIES9')),
      ProductCategoryModel.getStringSafe(context, $r('app.string.GOOD_CATEGORIES10'))
    ];
    const icons: Resource[] = [
      $r('app.media.categories_1'),
      $r('app.media.categories_2'),
      $r('app.media.categories_3'),
      $r('app.media.categories_4'),
      $r('app.media.categories_5'),
      $r('app.media.categories_6'),
      $r('app.media.categories_7'),
      $r('app.media.categories_8'),
      $r('app.media.categories_9'),
      $r('app.media.categories_10')
    ];
    return names.map((title: string, index: number) => {
      return new ProductCategoryItemModel(title, icons[index]);
    });
  }
}
