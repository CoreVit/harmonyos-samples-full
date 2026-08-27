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

export class CommonConstants {
  /**
   * Speed selection list.
   */
  public static readonly SPEED_CHOOSE: string[] = ['2.0', '1.75', '1.5', '1.25', '1.0', '0.75', '0.5'];
  /**
   * AppStorage key prefix
   */
  public static readonly KEY_PREFIX: string = 'videoCast';

}

export class VideoPlayParam {
  public videoType: string;
  public videoTime: number = 0;
  public videoIndex: number = 0;

  constructor(videoType: string, videoTime?: number, videoIndex?: number) {
    this.videoType = videoType;
    if (videoTime) {
      this.videoTime = videoTime;
    }
    if (videoIndex) {
      this.videoIndex = videoIndex;
    }
  }
}