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

@ObservedV2
export class ProductUtilState {
  public addCartLabel: string = '';
  public buyLabel: string = '';

  constructor(context: Context) {
    const rm = context.resourceManager;
    const labels = [
      rm.getStringSync($r('app.string.PRODUCT_DETAIL_BUTTON1').id),
      rm.getStringSync($r('app.string.PRODUCT_DETAIL_BUTTON2').id)
    ];
    this.addCartLabel = labels[0];
    this.buyLabel = labels[1];
  }
}
