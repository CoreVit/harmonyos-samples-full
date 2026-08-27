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

export interface CoverConfig {
  x: number;
  y: number;
  rotateX: number;
  rotateY: number;
  rotateZ: number;
  scale: number;
  visible: boolean;
}

export const COVER_CONFIGS: CoverConfig[] = [
  { x: 0, y: 0, rotateX: 0, rotateY: 0, rotateZ: 0, scale: 1.00, visible: false },
  { x: 0, y: 0, rotateX: 0, rotateY: 0, rotateZ: 0, scale: 1.00, visible: false },
  { x: 0, y: 0, rotateX: 0, rotateY: 0, rotateZ: 0, scale: 1.00, visible: false },
  { x: 0, y: 0, rotateX: 0, rotateY: 0, rotateZ: 0, scale: 1.00, visible: false },
  { x: 0, y: 0, rotateX: 0, rotateY: 0, rotateZ: 0, scale: 1.00, visible: false },
  { x: 0, y: 0, rotateX: 0, rotateY: 0, rotateZ: 0, scale: 1.00, visible: false },
  { x: 0, y: 0, rotateX: 0, rotateY: 0, rotateZ: 0, scale: 1.00, visible: false },
  { x: 0, y: 0, rotateX: 0, rotateY: 0, rotateZ: 0, scale: 1.00, visible: false },
  { x: 0, y: 0, rotateX: 0, rotateY: 0, rotateZ: 0, scale: 1.00, visible: false },
  { x: 0, y: 0, rotateX: 0, rotateY: 0, rotateZ: 0, scale: 1.00, visible: false },
  { x: 0, y: 0, rotateX: 0, rotateY: 0, rotateZ: 0, scale: 1.00, visible: false },
  { x: -9, y: 61, rotateX: 0, rotateY: 65, rotateZ: 0, scale: 0.75, visible: true },
  { x: -2.5, y: 61, rotateX: 0, rotateY: 65, rotateZ: 0, scale: 0.75, visible: true },
  { x: 0, y: 61, rotateX: 0, rotateY: 69, rotateZ: 0, scale: 0.75, visible: true },
  { x: 3, y: 60, rotateX: 0, rotateY: 62, rotateZ: 0, scale: 0.75, visible: true },
  { x: 3, y: 60, rotateX: 0, rotateY: 70, rotateZ: 0, scale: 0.75, visible: true },
  { x: 9, y: 57, rotateX: 0, rotateY: -57, rotateZ: 0, scale: 0.75, visible: true },
  { x: 8, y: 42, rotateX: 0, rotateY: -4, rotateZ: 0, scale: 0.75, visible: true },
  { x: 8, y: 38, rotateX: 0, rotateY: -4, rotateZ: 0, scale: 0.75, visible: true },
  { x: 9, y: 38, rotateX: 0, rotateY: -4, rotateZ: 0, scale: 0.75, visible: true },
  { x: 10, y: 38, rotateX: 0, rotateY: -4, rotateZ: 0, scale: 0.75, visible: true },
  { x: 13, y: 38, rotateX: 0, rotateY: -4, rotateZ: 0, scale: 0.75, visible: true },
  { x: 14, y: 38, rotateX: 0, rotateY: -4, rotateZ: 0, scale: 0.75, visible: true },
  { x: 15, y: 38, rotateX: 0, rotateY: 0, rotateZ: 0, scale: 0.80, visible: true },
  { x: 18, y: 38, rotateX: 0, rotateY: 0, rotateZ: 0, scale: 0.80, visible: true },
  { x: 18, y: 38, rotateX: 0, rotateY: 0, rotateZ: 0, scale: 0.80, visible: true },
];

export const SWITCH_FRAME_IMAGES: Resource[] = [
  $rawfile('music/animate/music_animate_1_01.png'),
  $rawfile('music/animate/music_animate_1_02.png'),
  $rawfile('music/animate/music_animate_1_03.png'),
  $rawfile('music/animate/music_animate_1_04.png'),
  $rawfile('music/animate/music_animate_1_05.png'),
  $rawfile('music/animate/music_animate_1_06.png'),
  $rawfile('music/animate/music_animate_1_07.png'),
  $rawfile('music/animate/music_animate_1_08.png'),
  $rawfile('music/animate/music_animate_1_09.png'),
  $rawfile('music/animate/music_animate_1_10.png'),
  $rawfile('music/animate/music_animate_1_11.png'),
  $rawfile('music/animate/music_animate_1_12.png'),
  $rawfile('music/animate/music_animate_1_13.png'),
  $rawfile('music/animate/music_animate_1_14.png'),
  $rawfile('music/animate/music_animate_1_15.png'),
  $rawfile('music/animate/music_animate_1_16.png'),
  $rawfile('music/animate/music_animate_1_17.png'),
  $rawfile('music/animate/music_animate_1_19.png'),
  $rawfile('music/animate/music_animate_1_20.png'),
  $rawfile('music/animate/music_animate_1_21.png'),
  $rawfile('music/animate/music_animate_1_22.png'),
  $rawfile('music/animate/music_animate_1_23.png'),
  $rawfile('music/animate/music_animate_1_25.png'),
  $rawfile('music/animate/music_animate_1_26.png'),
  $rawfile('music/animate/music_animate_1_27.png'),
];

export const SWITCH_FRAME_IMAGES_STR: string[] = [
  'music/animate/music_animate_1_01.png',
  'music/animate/music_animate_1_02.png',
  'music/animate/music_animate_1_03.png',
  'music/animate/music_animate_1_04.png',
  'music/animate/music_animate_1_05.png',
  'music/animate/music_animate_1_06.png',
  'music/animate/music_animate_1_07.png',
  'music/animate/music_animate_1_08.png',
  'music/animate/music_animate_1_09.png',
  'music/animate/music_animate_1_10.png',
  'music/animate/music_animate_1_11.png',
  'music/animate/music_animate_1_12.png',
  'music/animate/music_animate_1_13.png',
  'music/animate/music_animate_1_14.png',
  'music/animate/music_animate_1_15.png',
  'music/animate/music_animate_1_16.png',
  'music/animate/music_animate_1_17.png',
  'music/animate/music_animate_1_19.png',
  'music/animate/music_animate_1_20.png',
  'music/animate/music_animate_1_21.png',
  'music/animate/music_animate_1_22.png',
  'music/animate/music_animate_1_23.png',
  'music/animate/music_animate_1_25.png',
  'music/animate/music_animate_1_26.png',
  'music/animate/music_animate_1_27.png',
];

export const DANCE_FRAME_IMAGES: Resource[] = [
  $rawfile('music/animate/music_dance_frame_04.png'),
  $rawfile('music/animate/music_dance_frame_05.png'),
  $rawfile('music/animate/music_dance_frame_06.png'),
  $rawfile('music/animate/music_dance_frame_07.png'),
  $rawfile('music/animate/music_dance_frame_08.png'),
  $rawfile('music/animate/music_dance_frame_09.png'),
  $rawfile('music/animate/music_dance_frame_10.png'),
  $rawfile('music/animate/music_dance_frame_11.png'),
  $rawfile('music/animate/music_dance_frame_12.png'),
  $rawfile('music/animate/music_dance_frame_13.png'),
  $rawfile('music/animate/music_dance_frame_14.png'),
  $rawfile('music/animate/music_dance_frame_15.png'),
  $rawfile('music/animate/music_dance_frame_16.png'),
  $rawfile('music/animate/music_dance_frame_17.png'),
  $rawfile('music/animate/music_dance_frame_18.png'),
  $rawfile('music/animate/music_dance_frame_19.png'),
  $rawfile('music/animate/music_dance_frame_20.png'),
  $rawfile('music/animate/music_dance_frame_21.png'),
  $rawfile('music/animate/music_dance_frame_22.png'),
  $rawfile('music/animate/music_dance_frame_23.png'),
  $rawfile('music/animate/music_dance_frame_24.png'),
  $rawfile('music/animate/music_dance_frame_25.png'),
  $rawfile('music/animate/music_dance_frame_26.png'),
  $rawfile('music/animate/music_dance_frame_27.png'),
  $rawfile('music/animate/music_dance_frame_28.png'),
];