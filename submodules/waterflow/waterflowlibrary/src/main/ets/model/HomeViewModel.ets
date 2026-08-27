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

import { FlowItemCardType, IProductItem } from './ProductItem';

/**
 * Home page swiper image data.
 */
const swiperImage: Resource[] = [
  $r('app.media.ic_home_appliances_special'),
  $r('app.media.ic_coupons'),
  $r('app.media.ic_internal_purchase_price')
];

/**
 * Home page water flow item init data.
 */
const waterFlowData: IProductItem[] = [
  {
    id: 1,
    typeId: 0,
    imageUrl: $r('app.media.ic_holder_mate50'),
    imgRatio: 0.75,
    name: 'XXXMate 50 8GB+256GB',
    discount: '',
    price: '5499',
    promotion: '',
    bonusPoints: $r('app.string.str_bonus_points_data_demo'),
    showType: FlowItemCardType.SWIPER,
    swiperUrls: [
      $r('app.media.ic_holder_mate50'),
      $r('app.media.ic_holder_50e'),
      $r('app.media.ic_holder_mouse')
    ]
  },
  {
    id: 2,
    typeId: 0,
    imageUrl: $r('app.media.ic_phone_gif'),
    imgRatio: 1,
    name: 'XXXPad Pro',
    discount: '',
    price: '3499',
    promotion: '',
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: $r('app.string.str_bonus_points_data_demo')
  },
  {
    id: 3,
    typeId: 2,
    imageUrl: $r('app.media.ic_holder_computer'),
    imgRatio: 0.75,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '10099',
    promotion: '',
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: $r('app.string.str_bonus_points_data_demo')
  },
  {
    id: 4,
    typeId: 3,
    imageUrl: $r('app.media.ic_holder_mouse'),
    imgRatio: 1.33,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '199',
    promotion: '',
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: ''
  },
  {
    id: 5,
    typeId: 4,
    imageUrl: $r('app.media.ic_holder_xs2'),
    imgRatio: 1,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '9999',
    promotion: $r('app.string.str_promotion_data_demo'),
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: $r('app.string.str_bonus_points_data_demo')
  },
  {
    id: 6,
    typeId: 1,
    imageUrl: $r('app.media.ic_holder_50e'),
    imgRatio: 1.33,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '4088',
    promotion: '',
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: ''
  },
  {
    id: 7,
    typeId: 1,
    imageUrl: $r('app.media.ic_holder_60pro'),
    imgRatio: 0.75,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '1299',
    promotion: $r('app.string.str_promotion_data_demo'),
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: ''
  },
  {
    id: 8,
    typeId: 0,
    imageUrl: $r('app.media.ic_holder_50e'),
    imgRatio: 1.33,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '4088',
    promotion: '',
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: $r('app.string.str_bonus_points_data_demo')
  },
  {
    id: 9,
    typeId: 4,
    imageUrl: $r('app.media.ic_holder_xs2'),
    imgRatio: 1,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '9999',
    promotion: $r('app.string.str_promotion_data_demo'),
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: $r('app.string.str_bonus_points_data_demo')
  },
  {
    id: 10,
    typeId: 2,
    imageUrl: $r('app.media.ic_holder_computer'),
    imgRatio: 1,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '10099',
    promotion: $r('app.string.str_promotion_data_demo'),
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: ''
  },
  {
    id: 11,
    typeId: 3,
    imageUrl: $r('app.media.ic_holder_mouse'),
    imgRatio: 0.75,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '199',
    promotion: '',
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: $r('app.string.str_bonus_points_data_demo')
  },
  {
    id: 12,
    typeId: 5,
    imageUrl: $r('app.media.ic_holder_pad'),
    imgRatio: 1.33,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '3499',
    promotion: '',
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: $r('app.string.str_bonus_points_data_demo')
  },
  {
    id: 13,
    typeId: 1,
    imageUrl: $r('app.media.ic_holder_mate50'),
    imgRatio: 1,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '5499',
    promotion: '',
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: ''
  }
];

const loadingMoreFlowData: IProductItem[] = [
  {
    id: 1,
    typeId: 0,
    imageUrl: $r('app.media.ic_holder_computer'),
    imgRatio: 1,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '10099',
    promotion: $r('app.string.str_promotion_data_demo'),
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: ''
  },
  {
    id: 2,
    typeId: 1,
    imageUrl: $r('app.media.ic_holder_mouse'),
    imgRatio: 0.75,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '199',
    promotion: '',
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: $r('app.string.str_bonus_points_data_demo')
  },
  {
    id: 3,
    typeId: 2,
    imageUrl: $r('app.media.ic_holder_computer'),
    imgRatio: 0.75,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '10099',
    promotion: $r('app.string.str_promotion_data_demo'),
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: $r('app.string.str_bonus_points_data_demo')
  },
  {
    id: 4,
    typeId: 3,
    imageUrl: $r('app.media.ic_holder_mouse'),
    imgRatio: 1.33,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '199',
    promotion: '',
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: ''
  },
  {
    id: 5,
    typeId: 4,
    imageUrl: $r('app.media.ic_holder_xs2'),
    imgRatio: 1,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '9999',
    promotion: $r('app.string.str_promotion_data_demo'),
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: $r('app.string.str_bonus_points_data_demo')
  },
  {
    id: 6,
    typeId: 1,
    imageUrl: $r('app.media.ic_holder_50e'),
    imgRatio: 1.33,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '4088',
    promotion: '',
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: ''
  },
  {
    id: 7,
    typeId: 1,
    imageUrl: $r('app.media.ic_holder_60pro'),
    imgRatio: 0.75,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '1299',
    promotion: $r('app.string.str_promotion_data_demo'),
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: ''
  },
  {
    id: 8,
    typeId: 0,
    imageUrl: $r('app.media.ic_holder_50e'),
    imgRatio: 1.33,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '4088',
    promotion: '',
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: $r('app.string.str_bonus_points_data_demo')
  },
  {
    id: 9,
    typeId: 1,
    imageUrl: $r('app.media.ic_holder_xs2'),
    imgRatio: 1,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '9999',
    promotion: $r('app.string.str_promotion_data_demo'),
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: $r('app.string.str_bonus_points_data_demo')
  },
  {
    id: 10,
    typeId: 2,
    imageUrl: $r('app.media.ic_holder_computer'),
    imgRatio: 1,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '10099',
    promotion: $r('app.string.str_promotion_data_demo'),
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: ''
  },
  {
    id: 11,
    typeId: 3,
    imageUrl: $r('app.media.ic_holder_mouse'),
    imgRatio: 0.75,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '199',
    promotion: '',
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: $r('app.string.str_bonus_points_data_demo')
  },
  {
    id: 12,
    typeId: 5,
    imageUrl: $r('app.media.ic_holder_pad'),
    imgRatio: 1.33,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '3499',
    promotion: '',
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: $r('app.string.str_bonus_points_data_demo')
  },
  {
    id: 13,
    typeId: 1,
    imageUrl: $r('app.media.ic_holder_mate50'),
    imgRatio: 1,
    name: $r('app.string.str_name_data_demo'),
    discount: '',
    price: '5499',
    promotion: '',
    showType: FlowItemCardType.IMAGE,
    swiperUrls: [],
    bonusPoints: ''
  }
];

export { swiperImage, waterFlowData, loadingMoreFlowData };