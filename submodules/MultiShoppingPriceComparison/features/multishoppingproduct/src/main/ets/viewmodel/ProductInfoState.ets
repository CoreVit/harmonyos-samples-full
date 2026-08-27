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

import { ProductInfoModel } from '../model/ProductInfoModel';

@ObservedV2
export class ProductInfoState {
  public priceNames: string[] = [];
  public discountNames: string[] = [];
  public configNames: string[] = [];
  public userCommentNames: string[] = [];
  public colorImages: Resource[] = ProductInfoModel.getColorSelectionImages();
  public recommendImages: Resource[] = ProductInfoModel.getRecommendedConfigImages();

  constructor(context: Context) {
    this.priceNames = ProductInfoModel.getProductPriceNames(context);
    this.discountNames = ProductInfoModel.getProductDiscountNames(context);
    this.configNames = ProductInfoModel.getProductConfigNames(context);
    this.userCommentNames = ProductInfoModel.getUserCommentNames(context);
  }
}
