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

import { HomeDiscountItem, HomeDiscountModel } from '../model/HomeDiscountModel';

@ObservedV2
export class HomeDiscountState {
  public items: HomeDiscountItem[];

  constructor(context: Context) {
    this.items = HomeDiscountModel.getItems(context);
  }

  public getCurrentWelfareList(widthBp: WidthBreakpoint): HomeDiscountItem[] {
    if (widthBp === WidthBreakpoint.WIDTH_XS || widthBp === WidthBreakpoint.WIDTH_SM) {
      return this.items.slice(0, 3);
    }
    if (widthBp === WidthBreakpoint.WIDTH_MD) {
      return this.items.slice(0, 6);
    }
    return this.items;
  }
}
