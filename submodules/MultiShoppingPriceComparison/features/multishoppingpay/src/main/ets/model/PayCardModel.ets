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

export class PayCardModel {
  public static readonly CAPACITY_SELECT_NAME_LIST: string[] = ['12GB+512GB', '12GB+1T'];

  private static getStringSafe(context: Context, res: Resource): string {
    try {
      return context.resourceManager.getStringSync(res.id);
    } catch (error) {
      return '';
    }
  }

  static getColorSelectImages(): Resource[] {
    return [
      $r('app.media.pay_product_1'),
      $r('app.media.pay_product_2'),
      $r('app.media.pay_product_3'),
      $r('app.media.pay_product_4')
    ];
  }

  static getColorSelectNameList(context: Context): string[] {
    return [
      PayCardModel.getStringSafe(context, $r('app.string.PAY_COLOR_NAME_1')),
      PayCardModel.getStringSafe(context, $r('app.string.PAY_COLOR_NAME_2')),
      PayCardModel.getStringSafe(context, $r('app.string.PAY_COLOR_NAME_3')),
      PayCardModel.getStringSafe(context, $r('app.string.PAY_COLOR_NAME_4'))
    ];
  }

  static getTypeSelectNameList(context: Context): string[] {
    return [PayCardModel.getStringSafe(context, $r('app.string.PAY_OFFICIAL_STANDARD'))];
  }

  static getSelectSectionTitles(context: Context): string[] {
    return [
      PayCardModel.getStringSafe(context, $r('app.string.PAY_SELECT_SECTION_1')),
      PayCardModel.getStringSafe(context, $r('app.string.PAY_SELECT_SECTION_2')),
      PayCardModel.getStringSafe(context, $r('app.string.PAY_SELECT_SECTION_3'))
    ];
  }

  /** Matches the original DetailConstants.CUSTOMER_SERVICE_CONTENTS (two price items are fixed display values). */
  static getCustomerServiceContents(context: Context): string[] {
    return [
      PayCardModel.getStringSafe(context, $r('app.string.PAY_STORE')),
      '￥12999',
      '￥13999',
      PayCardModel.getStringSafe(context, $r('app.string.PAY_BUY')),
      PayCardModel.getStringSafe(context, $r('app.string.PAY_CS_CONTENT_1')),
      PayCardModel.getStringSafe(context, $r('app.string.PAY_CS_CONTENT_2')),
      PayCardModel.getStringSafe(context, $r('app.string.PAY_CS_CONTENT_3')),
      PayCardModel.getStringSafe(context, $r('app.string.PAY_CS_CONTENT_4'))
    ];
  }

  static getPayInfo(context: Context): string[] {
    return [
      PayCardModel.getStringSafe(context, $r('app.string.PAY_INFO_1')),
      PayCardModel.getStringSafe(context, $r('app.string.PAY_INFO_2')),
      PayCardModel.getStringSafe(context, $r('app.string.PAY_INFO_3')),
      PayCardModel.getStringSafe(context, $r('app.string.PAY_INFO_4'))
    ];
  }
}
