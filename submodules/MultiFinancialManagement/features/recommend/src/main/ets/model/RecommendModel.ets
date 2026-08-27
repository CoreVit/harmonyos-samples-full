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

export class RecommendModel {
  private wealthProductList: WealthProductInfo[];

  constructor() {
    this.wealthProductList = [
      { name: $r('app.string.wealth_product_1'), rate: '3.89%', duration: $r('app.string.duration_3_months') },
      { name: $r('app.string.wealth_product_2'), rate: '3.76%', duration: $r('app.string.duration_6_months') },
      { name: $r('app.string.wealth_product_3'), rate: '3.83%', duration: $r('app.string.duration_9_months') },
      { name: $r('app.string.wealth_product_4'), rate: '3.89%', duration: $r('app.string.duration_3_months') },
      { name: $r('app.string.wealth_product_5'), rate: '3.76%', duration: $r('app.string.duration_4_months') },
      { name: $r('app.string.wealth_product_6'), rate: '3.83%', duration: $r('app.string.duration_9_months') }
    ]
  }

  getWealthProductList(): WealthProductInfo[] {
    return this.wealthProductList;
  }
}

export interface WealthProductInfo {
  name: ResourceStr;
  rate: string;
  duration: ResourceStr;
}
