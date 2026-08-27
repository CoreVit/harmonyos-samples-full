/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

/**
 * Card show type in WaterFlow
 */
export enum FlowItemCardType {
  IMAGE, SWIPER
}

export interface IProductItem {
  /**
   * Product image url.
   */
  imageUrl: Resource | string;

  /**
   * Product name.
   */
  name: string | Resource;

  /**
   * Product discount.
   */
  discount: string;

  /**
   * Product price.
   */
  price: string;

  /**
   * Product promotion.
   */
  promotion: string | Resource;

  /**
   * Product bonus points.
   */
  bonusPoints: string | Resource;

  /**
   * Image width/height ratio
   */
  imgRatio: number;

  /**
   * ID
   */
  id: number;

  /**
   * Show type
   */
  showType: FlowItemCardType;

  /**
   * urls for swiper card
   */
  swiperUrls: Resource[] | string[];

  /**
   * type ID
   */
  typeId: number;
}
