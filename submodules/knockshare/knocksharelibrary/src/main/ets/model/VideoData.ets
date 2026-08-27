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

export interface VideoData {
  url: string;
  name: string;
  description: string;
  head: string;
}

export const VIDEO_SOURCES: VideoData[] = [
  {
    url: 'kv-popup.mp4',
    name: 'Pura X 宣传视频',
    description: 'Pura X 宣传视频描述',
    head: 'video_cover_0.png',
  },
  {
    url: 'camera-intro-popup.mp4',
    name: 'Nova 系列宣传视频',
    head: 'video_cover_3.png',
    description: 'Nova 系列宣传视频描述',
  },
];

export const VIDEO_NAME: string[] = [
  'kvPopup',
  'cameraIntroPopup'
]