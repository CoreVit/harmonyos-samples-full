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

export interface DeliveryTrack {
  time: string;
  location: Resource;
  status: Resource;
  isActive: boolean;
}

export const DELIVERY_TRACKS: DeliveryTrack[] = [
  {
    time: '2026-05-08 14:30',
    location: $r('app.string.delivery_location_1'),
    status: $r('app.string.delivery_status_1'),
    isActive: true
  },
  {
    time: '2026-05-08 08:15',
    location: $r('app.string.delivery_location_2'),
    status: $r('app.string.delivery_status_2'),
    isActive: false
  },
  {
    time: '2026-05-07 20:45',
    location: $r('app.string.delivery_location_2'),
    status: $r('app.string.delivery_status_3'),
    isActive: false
  },
  {
    time: '2026-05-07 15:20',
    location: $r('app.string.delivery_location_3'),
    status: $r('app.string.delivery_status_4'),
    isActive: false
  },
  {
    time: '2026-05-07 10:00',
    location: $r('app.string.delivery_location_3'),
    status: $r('app.string.delivery_status_5'),
    isActive: false
  },
  {
    time: '2026-05-06 18:30',
    location: $r('app.string.delivery_location_4'),
    status: $r('app.string.delivery_status_6'),
    isActive: false
  },
  {
    time: '2026-05-06 14:00',
    location: $r('app.string.delivery_location_4'),
    status: $r('app.string.delivery_status_7'),
    isActive: false
  }
];