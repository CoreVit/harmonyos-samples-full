/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { formInfo } from '@kit.FormKit';

export interface CardItemConfig {
  title: Resource | string;
  cardName: string;
  cardDimension: formInfo.FormDimension;
  mainImg: Resource;
  span: number;
  offset: GridColColumnOption;
}

export const CARD_ITEM_CONFIGS: CardItemConfig[] = [
  {
    title: $r('app.string.card_title_music'),
    cardName: 'MusicCard',
    cardDimension: formInfo.FormDimension.Dimension_2_4,
    mainImg: $r('app.media.musicImage'),
    span: 2,
    offset: { xs: 0, md: 1, lg: 2 }
  },
  {
    title: $r('app.string.card_title_exercise'),
    cardName: 'ExerciseCard',
    cardDimension: formInfo.FormDimension.Dimension_2_2,
    mainImg: $r('app.media.exerciseImage'),
    span: 1,
    offset: { xs: 0, md: 2, lg: 4 }
  },
  {
    title: $r('app.string.card_title_delivery'),
    cardName: 'DeliveryCard',
    cardDimension: formInfo.FormDimension.Dimension_2_2,
    mainImg: $r('app.media.deliveryImage'),
    span: 1,
    offset: { xs: 0, md: 0, lg: 0 }
  },
  {
    title: $r('app.string.card_title_sleep'),
    cardName: 'SleepCard',
    cardDimension: formInfo.FormDimension.Dimension_2_4,
    mainImg: $r('app.media.sleepImage'),
    span: 2,
    offset: { xs: 0, md: 2, lg: 4 }
  }
];