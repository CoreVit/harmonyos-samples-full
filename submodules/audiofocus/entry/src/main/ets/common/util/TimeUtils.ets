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

import { CommonConstants } from '../constants/CommonConstants';

export class TimeUtil {
  static secondToTime(seconds: number): string {
    let hourUnit = CommonConstants.HOUR_UNIT * CommonConstants.HOUR_UNIT;
    let hour: number = Math.floor(seconds / hourUnit);
    let minute: number = Math.floor((seconds - hour * hourUnit) / CommonConstants.HOUR_UNIT);
    let second: number = seconds - hour * hourUnit - minute * CommonConstants.HOUR_UNIT;
    let hourStr: string = hour < CommonConstants.TIME_CONST_TEN ? `0${hour.toString()}` : `${hour.toString()}`;
    let minuteStr: string = minute < CommonConstants.TIME_CONST_TEN ? `0${minute.toString()}` : `${minute.toString()}`;
    let secondStr: string = second < CommonConstants.TIME_CONST_TEN ? `0${second.toString()}` : `${second.toString()}`;
    if (hour > 0) {
      return `${hourStr}:${minuteStr}:${secondStr}`;
    }
    if (minute > 0) {
      return `${minuteStr}:${secondStr}`;
    } else {
      return `00:${secondStr}`;
    }
  }

  static millisecondsToTime(milliseconds: number): string {
    let hourUnit = CommonConstants.HOUR_UNIT * CommonConstants.HOUR_UNIT * CommonConstants.SECOND_TO_MS;
    let minuteUnit = CommonConstants.HOUR_UNIT * CommonConstants.SECOND_TO_MS;
    let secondUnit = CommonConstants.SECOND_TO_MS;

    let hour: number = Math.floor(milliseconds / hourUnit);
    let minute: number = Math.floor((milliseconds - hour * hourUnit) / minuteUnit);
    let second: number = Math.floor((milliseconds - hour * hourUnit - minute * minuteUnit) / secondUnit);

    return `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}:${second.toString()
      .padStart(2, '0')}`;
  }
}

const MILLISECONDS_PER_MINUTE = 60000;
const MILLISECONDS_PER_SECOND = 1000;
const SECONDS_PAD_THRESHOLD = 10;

export function timeConvert(time: number): string {
  let min: number = Math.floor(time / MILLISECONDS_PER_MINUTE);
  let second: string = ((time % MILLISECONDS_PER_MINUTE) / MILLISECONDS_PER_SECOND).toFixed(0);
  return `${min}:${(Number(second) < SECONDS_PAD_THRESHOLD ? '0' : '') + second}`;
}