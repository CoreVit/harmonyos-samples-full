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

import { ColorConstants } from '../../common/ColorConstants';

export interface OverviewStat {
  value: string;
  unit: Resource;
  valueFontSize?: number;
}

export interface DetailStat {
  icon: Resource;
  iconBg: string;
  title: Resource;
  value: string;
  unit: Resource;
  time: string;
  date: string;
  cost?: string;
  speed?: string;
  perUnit?: Resource;
}

export const DEFAULT_OVERVIEW_STATS: OverviewStat[] = [
  { value: '832.58', unit: $r('app.string.exercise_unit_hour'), valueFontSize: 40 },
  { value: '428', unit: $r('app.string.exercise_unit_count'), valueFontSize: 24 },
  { value: '8500', unit: $r('app.string.exercise_unit_calories'), valueFontSize: 24 }
];

export const OVERVIEW_STATS_BY_MONTH: OverviewStat[] = [
  { value: '29.65', unit: $r('app.string.exercise_unit_running_km'), valueFontSize: 24 },
  { value: '12.35', unit: $r('app.string.exercise_unit_walking_km'), valueFontSize: 24 },
  { value: '4500', unit: $r('app.string.exercise_unit_swimming_m'), valueFontSize: 24 },
  { value: '3689', unit: $r('app.string.exercise_unit_jumping_count'), valueFontSize: 24 },
  { value: '32', unit: $r('app.string.exercise_unit_fitness_min'), valueFontSize: 24 },
  { value: '1', unit: $r('app.string.exercise_unit_golf_times'), valueFontSize: 24 }
];

export const DETAIL_STATS: DetailStat[] = [
  { title: $r('app.string.outdoor_run'), icon: $r('sys.symbol.figure_running'), iconBg: ColorConstants.EXERCISE_ORANGE, value: '5.67', unit: $r('app.string.exercise_unit_km'),
    time: '00:50:44', date: '7/24 17:56', cost: '267' },
  { title: $r('app.string.basketball'), icon: $r('sys.symbol.figure_basketball'), iconBg: ColorConstants.EXERCISE_ORANGE, value: '29', unit: $r('app.string.exercise_unit_point'),
    time: '00:04:44', date: '7/21 17:46' },
  { title: $r('app.string.pool_swim'), icon: $r('sys.symbol.figure_pool_swim'), iconBg: '#1F71FF', value: '875', unit: $r('app.string.exercise_unit_m'),
    time: '00:04:44', date: '7/16 18:30', speed: '6\'20\"', perUnit: $r('app.string.exercise_unit_per_100m') },
  { title: $r('app.string.indoor_run'), icon: $r('sys.symbol.figure_run_treadmill'), iconBg: '#64BB5C', value: '8.67', unit: $r('app.string.exercise_unit_km'),
    time: '00:53:44', date: '7/15 15:30', speed: '5\'17\"', perUnit: $r('app.string.exercise_unit_per_km') }
];