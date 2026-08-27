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

import { ProductSwiperModel } from '../model/ProductSwiperModel';

@ObservedV2
export class ProductSwiperState {
  public detailResources: Resource[] = ProductSwiperModel.getDetailResources();
  public smallResources: Resource[] = ProductSwiperModel.getSmallResources();
  public indicatorTexts: string[];
  public livingText: string;
  @Trace public currentSwiperIndex: number = 0;

  constructor(context: Context) {
    this.indicatorTexts = ProductSwiperModel.getIndicatorTexts(context);
    this.livingText = ProductSwiperModel.getLivingText(context);
  }
}
