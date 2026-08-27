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

export interface SleepSegment {
  startTime: number;
  endTime: number;
  time: number;
  type: 'deep' | 'light' | 'rem' | 'awake';
}

export interface TimeTab {
  label: Resource;
  value: string;
}

export interface SleepDetail {
  title: Resource;
  value: Resource | string;
  unit: Resource | string;
  state: Resource;
}

export interface HealthTask {
  id: string;
  name: Resource;
  target: Resource | string;
  current: Resource | string;
  icon: Resource;
  state: Resource;
  isCompleted: boolean;
}

export interface WeekDayItem {
  dayLabel: Resource;
  icon: Resource;
  completed: boolean;
}

export const WEEK_DAYS: WeekDayItem[] = [
  { dayLabel: $r('app.string.clover_weekday_1'), icon: $r('app.media.clover_half_gray'), completed: false },
  { dayLabel: $r('app.string.clover_weekday_2'), icon: $r('app.media.clover'), completed: true },
  { dayLabel: $r('app.string.clover_weekday_3'), icon: $r('app.media.clover'), completed: true },
  { dayLabel: $r('app.string.clover_weekday_4'), icon: $r('app.media.clover_gray'), completed: false },
  { dayLabel: $r('app.string.clover_weekday_5'), icon: $r('app.media.clover_gray'), completed: false },
  { dayLabel: $r('app.string.clover_weekday_6'), icon: $r('app.media.clover_gray'), completed: false },
  { dayLabel: $r('app.string.clover_weekday_7'), icon: $r('app.media.clover_gray'), completed: false }
];

export const TIME_TABS: TimeTab[] = [
  { label: $r('app.string.sleep_tab_day'), value: 'day' },
  { label: $r('app.string.sleep_tab_week'), value: 'week' },
  { label: $r('app.string.sleep_tab_month'), value: 'month' },
  { label: $r('app.string.sleep_tab_half_year'), value: 'halfYear' },
  { label: $r('app.string.sleep_tab_year'), value: 'year' }
];

export const STAGE_LEGENDS: Resource[] = [
  $r('app.string.sleep_stage_deep'),
  $r('app.string.sleep_stage_light'),
  $r('app.string.sleep_stage_rem'),
  $r('app.string.sleep_stage_awake')
];

export const STAGE_LEGENDS_PERCENT: (Resource | string)[] = [
  $r('app.string.sleep_stage_percent_deep'),
  $r('app.string.sleep_stage_percent_light'),
  $r('app.string.sleep_stage_percent_rem'),
];

export const STAGE_COLORS: Record<string, string> = {
  'deep': '#6a1b9a',
  'light': '#ab47bc',
  'rem': '#ff7043',
  'awake': '#ffca28'
};

export const STAGE_HEIGHTS: Record<string, number> = {
  'awake': 0.1,
  'rem': 0.3,
  'light': 0.6,
  'deep': 0.9
};

export const SLEEP_SEGMENTS: SleepSegment[] = [
  { startTime: 23 * 60 + 27, endTime: 23 * 60 + 45, time: 18, type: 'light' },
  { startTime: 23 * 60 + 45, endTime: 24 * 60 + 30, time: 45, type: 'deep' },
  { startTime: 24 * 60 + 30, endTime: 25 * 60 + 15, time: 45, type: 'light' },
  { startTime: 25 * 60 + 15, endTime: 26 * 60 + 0, time: 45, type: 'rem' },
  { startTime: 26 * 60 + 0, endTime: 27 * 60 + 30, time: 90, type: 'deep' },
  { startTime: 27 * 60 + 30, endTime: 28 * 60 + 20, time: 50, type: 'light' },
  { startTime: 28 * 60 + 20, endTime: 28 * 60 + 35, time: 15, type: 'awake' },
  { startTime: 28 * 60 + 35, endTime: 30 * 60 + 0, time: 85, type: 'light' },
  { startTime: 30 * 60 + 0, endTime: 31 * 60 + 15, time: 75, type: 'deep' },
  { startTime: 31 * 60 + 15, endTime: 33 * 60 + 0, time: 105, type: 'light' },
  { startTime: 33 * 60 + 0, endTime: 35 * 60 + 0, time: 120, type: 'rem' },
  { startTime: 35 * 60 + 0, endTime: 35 * 60 + 30, time: 30, type: 'awake' },
  { startTime: 35 * 60 + 30, endTime: 36 * 60 + 42, time: 12, type: 'light' }
];

export const HEALTH_TASK_LIST: HealthTask[] = [
  { id: 'wakeup_time', name: $r('app.string.task_wakeup_time'), target: '08:00', current: '07:30',
    icon: $r('app.media.wakeup_time'), state: $r('app.string.task_state_completed'), isCompleted: true },
  {
    id: 'exercise_time',
    name: $r('app.string.task_exercise_time'),
    target: $r('app.string.task_target_25_min'),
    current: '30',
    icon: $r('app.media.exercise_time'), state: $r('app.string.task_state_completed'), isCompleted: true },
  { id: 'stress', name: $r('app.string.task_stress'), target: '<60', current: '51',
    icon: $r('app.media.stress'), state: $r('app.string.task_state_completed'), isCompleted: true },
];

export const CUSTOM_HEALTH_TASK_LIST: HealthTask[] = [
  {
    id: 'step_count',
    name: $r('app.string.task_step_count'),
    target: $r('app.string.task_target_8000_steps'),
    current: '0',
    icon: $r('app.media.step_count'), state: $r('app.string.task_state_view'), isCompleted: false },
  { id: 'water_intake', name: $r('app.string.task_water_intake'), target: '2000ml', current: '0',
    icon: $r('app.media.water_intake'), state: $r('app.string.task_state_record'), isCompleted: false },
  {
    id: 'diet_record',
    name: $r('app.string.task_diet_record'),
    target: $r('app.string.task_target_3_times'),
    current: '0',
    icon: $r('app.media.diet_record'), state: $r('app.string.task_state_record'), isCompleted: false },
  {
    id: 'mindfulness',
    name: $r('app.string.task_mindfulness'),
    target: $r('app.string.task_target_1_time'),
    current: '0',
    icon: $r('app.media.mindfulness'), state: $r('app.string.task_state_meditate'), isCompleted: false },
  { id: 'early_sleep', name: $r('app.string.task_early_sleep'), target: '22:30', current: '0',
    icon: $r('app.media.early_sleep'), state: $r('app.string.task_state_sleep'), isCompleted: false },
  {
    id: 'blood_pressure',
    name: $r('app.string.task_blood_pressure'),
    target: $r('app.string.task_target_2_times'),
    current: '0',
    icon: $r('app.media.blood_pressure'), state: $r('app.string.task_state_record'), isCompleted: false },
  {
    id: 'medication',
    name: $r('app.string.task_medication'),
    target: $r('app.string.task_target_3_times'),
    current: '0',
    icon: $r('app.media.medication'), state: $r('app.string.task_state_take_medication'), isCompleted: false },
  {
    id: 'weight_measure',
    name: $r('app.string.task_weight_measure'),
    target: $r('app.string.task_target_1_time'),
    current: '0',
    icon: $r('app.media.weight_measure'), state: $r('app.string.task_state_record'), isCompleted: false },
];

export const SLEEP_DETAIL_INFO_LIST: SleepDetail[] = [
  {
    title: $r('app.string.sleep_metric_duration'),
    value: $r('app.string.sleep_value_duration'),
    unit: $r('app.string.sleep_ref_duration'),
    state: $r('app.string.sleep_state_normal')
  },
  {
    title: $r('app.string.sleep_metric_deep_percent'),
    value: '27%',
    unit: $r('app.string.sleep_ref_deep_percent'),
    state: $r('app.string.sleep_state_normal')
  },
  {
    title: $r('app.string.sleep_metric_light_percent'),
    value: '43%',
    unit: $r('app.string.sleep_ref_light_percent'),
    state: $r('app.string.sleep_state_normal')
  },
  {
    title: $r('app.string.sleep_metric_rem_percent'),
    value: '30%',
    unit: $r('app.string.sleep_ref_rem_percent'),
    state: $r('app.string.sleep_state_normal')
  },
  {
    title: $r('app.string.sleep_metric_continuity'),
    value: $r('app.string.sleep_value_continuity_score'),
    unit: $r('app.string.sleep_ref_continuity'),
    state: $r('app.string.sleep_state_normal')
  },
  {
    title: $r('app.string.sleep_metric_awake_count'),
    value: $r('app.string.sleep_value_1_time'),
    unit: $r('app.string.sleep_ref_awake_count'),
    state: $r('app.string.sleep_state_normal')
  },
  {
    title: $r('app.string.sleep_metric_stability'),
    value: '30%',
    unit: $r('app.string.sleep_ref_stability'),
    state: $r('app.string.sleep_state_normal')
  },
  {
    title: $r('app.string.sleep_metric_breathing'),
    value: $r('app.string.sleep_value_breathing_score'),
    unit: $r('app.string.sleep_ref_breathing'),
    state: $r('app.string.sleep_state_normal')
  },
  {
    title: $r('app.string.sleep_metric_avg_heart_rate'),
    value: $r('app.string.sleep_value_avg_heart_rate'),
    unit: $r('app.string.sleep_ref_avg_heart_rate'),
    state: $r('app.string.sleep_state_in_range')
  },
  {
    title: $r('app.string.sleep_metric_avg_hrv'),
    value: $r('app.string.sleep_value_avg_hrv'),
    unit: $r('app.string.sleep_ref_avg_hrv'),
    state: $r('app.string.sleep_state_in_range')
  },
  {
    title: $r('app.string.sleep_metric_avg_spo2'),
    value: '95%',
    unit: $r('app.string.sleep_ref_avg_spo2'),
    state: $r('app.string.sleep_state_in_range')
  },
  {
    title: $r('app.string.sleep_metric_avg_breathing_rate'),
    value: $r('app.string.sleep_value_avg_breathing_rate'),
    unit: $r('app.string.sleep_ref_avg_breathing_rate'),
    state: $r('app.string.sleep_state_in_range')
  },
];