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

export class MobilePhoneItem {
  public name: string;
  public image: Resource;

  constructor(name: string, image: Resource) {
    this.name = name;
    this.image = image;
  }
}

export class MobilePhoneSection {
  public name: string;
  public items: MobilePhoneItem[];

  constructor(name: string, items: MobilePhoneItem[]) {
    this.name = name;
    this.items = items;
  }
}

export class MobilePhoneListModel {
  private static getStringSafe(context: Context, res: Resource): string {
    try {
      return context.resourceManager.getStringSync(res.id);
    } catch (error) {
      return '';
    }
  }

  static getSections(context: Context): MobilePhoneSection[] {
    const sectionNames: string[] = [
      MobilePhoneListModel.getStringSafe(context, $r('app.string.SHOP_TITLE_LIST1')),
      MobilePhoneListModel.getStringSafe(context, $r('app.string.SHOP_TITLE_LIST2')),
      MobilePhoneListModel.getStringSafe(context, $r('app.string.SHOP_TITLE_LIST3'))
    ];
    const nameMatrix: string[][] = [
      ['Mate 60 Pro+', 'Mate 60', 'Mate 60 Pro', 'Mate X5'],
      ['Mate 60 Pro+', 'Mate 60', 'Mate 60 Pro', 'Mate X5', 'Mate X3', 'Mate 50', 'Mate 50 Pro', 'Mate Xs 2',
        'Mate 50E', 'Mate 50 RS'],
      ['P60', 'P60 Pro', 'P60 Art', 'P50 Pro', 'P50E', 'P50 Pocket']
    ];
    const imageMatrix: Resource[][] = [
      [$r('app.media.classify_product_1'), $r('app.media.classify_product_2'), $r('app.media.classify_product_3'),
        $r('app.media.classify_product_4')],
      [$r('app.media.classify_product_1'), $r('app.media.classify_product_2'), $r('app.media.classify_product_3'),
        $r('app.media.classify_product_4'), $r('app.media.classify_product_5'), $r('app.media.classify_product_6'),
        $r('app.media.classify_product_7'), $r('app.media.classify_product_8'), $r('app.media.classify_product_9'),
        $r('app.media.classify_product_10')],
      [$r('app.media.classify_product_11'), $r('app.media.classify_product_12'), $r('app.media.classify_product_13'),
        $r('app.media.classify_product_14'), $r('app.media.classify_product_15'), $r('app.media.classify_product_16')]
    ];

    return sectionNames.map((name: string, sectionIndex: number) => {
      const items: MobilePhoneItem[] = nameMatrix[sectionIndex].map((itemName: string, itemIndex: number) =>
        new MobilePhoneItem(itemName, imageMatrix[sectionIndex][itemIndex]));
      return new MobilePhoneSection(name, items);
    });
  }
}
