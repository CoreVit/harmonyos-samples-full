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

export class ProductCategoryNavModel {
  private static getStringSafe(context: Context, res: Resource): string {
    try {
      return context.resourceManager.getStringSync(res.id);
    } catch (error) {
      return '';
    }
  }

  static getNavList(context: Context): string[] {
    return [
      ProductCategoryNavModel.getStringSafe(context, $r('app.string.NAV_ROUTER_LIST1')),
      ProductCategoryNavModel.getStringSafe(context, $r('app.string.NAV_ROUTER_LIST2')),
      ProductCategoryNavModel.getStringSafe(context, $r('app.string.NAV_ROUTER_LIST3')),
      ProductCategoryNavModel.getStringSafe(context, $r('app.string.NAV_ROUTER_LIST4')),
      ProductCategoryNavModel.getStringSafe(context, $r('app.string.NAV_ROUTER_LIST5')),
      ProductCategoryNavModel.getStringSafe(context, $r('app.string.NAV_ROUTER_LIST6')),
      ProductCategoryNavModel.getStringSafe(context, $r('app.string.NAV_ROUTER_LIST7')),
      ProductCategoryNavModel.getStringSafe(context, $r('app.string.NAV_ROUTER_LIST8')),
      ProductCategoryNavModel.getStringSafe(context, $r('app.string.NAV_ROUTER_LIST9')),
      ProductCategoryNavModel.getStringSafe(context, $r('app.string.NAV_ROUTER_LIST10')),
      ProductCategoryNavModel.getStringSafe(context, $r('app.string.NAV_ROUTER_LIST11')),
      ProductCategoryNavModel.getStringSafe(context, $r('app.string.NAV_ROUTER_LIST12')),
      ProductCategoryNavModel.getStringSafe(context, $r('app.string.NAV_ROUTER_LIST13')),
      ProductCategoryNavModel.getStringSafe(context, $r('app.string.NAV_ROUTER_LIST14')),
      ProductCategoryNavModel.getStringSafe(context, $r('app.string.NAV_ROUTER_LIST15'))
    ];
  }
}
