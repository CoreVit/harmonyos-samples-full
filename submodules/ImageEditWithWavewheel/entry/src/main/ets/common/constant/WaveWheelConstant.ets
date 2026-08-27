/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { SimpleWaveWheelOption } from 'wavewheel';

// [Start wavewheel_constants]
export default class WaveWheelConstants {
  /**
   * Routes
   */
  public static readonly waveWheelOptions: SimpleWaveWheelOption[] = [
    {
      id: 'crop',
      title: $r('app.string.wheel_crop'),
      icon: $r('app.media.wavewheel_crop'),
      useSysImg: false,
      enable: true
    },
    {
      id: 'brightness',
      title: $r('app.string.wheel_brightness'),
      icon: $r('app.media.wavewheel_brightness'),
      useSysImg: false,
      enable: true
    },
    {
      id: 'transparency',
      title: $r('app.string.wheel_transparency'),
      icon: $r('app.media.wavewheel_transparency'),
      useSysImg: false,
      enable: true
    },
    // [StartExclude wavewheel_constants]
    {
      id: 'saturation',
      title: $r('app.string.wheel_saturation'),
      icon: $r('app.media.wavewheel_saturation'),
      useSysImg: false,
      enable: true
    },
    {
      id: 'camera_filters',
      title: $r('app.string.wheel_filter'),
      icon: $r('app.media.wavewheel_camera_filters'),
      useSysImg: false,
      enable: true
    },
    {
      id: 'square_portrait_svg',
      title: $r('app.string.wheel_translate'),
      icon: $r('app.media.wavewheel_square_portrait'),
      useSysImg: false,
      enable: true
    },
    {
      id: 'checkered_magnifyingglass',
      title: $r('app.string.wheel_zoom'),
      icon: $r('app.media.wavewheel_checkered_magnifyingglass'),
      useSysImg: false,
      enable: true
    }
    // [EndExclude wavewheel_constants]
  ];
}
// [End wavewheel_constants]