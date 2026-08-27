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

import { MainPageConstants } from '../constants/MainPageConstants';

export class TVBannerCoverModel {
  private id: string = '0';
  private imgHorizontal: Resource;
  private imgVertical: Resource;
  private title: Resource;

  constructor(id: string, imgHorizontal: Resource, imgVertical: Resource, title: Resource) {
    this.id = id;
    this.imgHorizontal = imgHorizontal;
    this.imgVertical = imgVertical;
    this.title = title;
  }

  getId(): string {
    return this.id;
  }

  getImgHorizontal(): Resource {
    return this.imgHorizontal;
  }

  getImgVertical(): Resource {
    return this.imgVertical;
  }

  getTitle(): Resource {
    return this.title;
  }
}

export class TVBannerCoverListModel {
  private tvBannerCoverListModel: TVBannerCoverModel[] = [];
  private tvBannerScaleListModel: Array<ScaleOptions> = [];

  constructor(tvBannerCoverListModel: TVBannerCoverModel[], tvBannerScaleListModel: Array<ScaleOptions>) {
    this.tvBannerCoverListModel = tvBannerCoverListModel;
    this.tvBannerScaleListModel = tvBannerScaleListModel;
  }

  loadTVBannerCoverData(): void {
    this.clearTVBannerCoverList();
    this.tvBannerCoverListModel = [
      new TVBannerCoverModel('0', $r('app.media.ic_banner_6'), $r('app.media.ic_banner_vertical_6'), $r('app.string.sutra')),
      new TVBannerCoverModel('1', $r('app.media.ic_banner_5'), $r('app.media.ic_banner_vertical_5'), $r('app.string.lonely')),
      new TVBannerCoverModel('2', $r('app.media.ic_banner_2'), $r('app.media.ic_banner_vertical_2'), $r('app.string.source')),
      new TVBannerCoverModel('3', $r('app.media.ic_banner_3'), $r('app.media.ic_banner_vertical_3'), $r('app.string.science')),
      new TVBannerCoverModel('4', $r('app.media.ic_banner_4'), $r('app.media.ic_banner_vertical_4'), $r('app.string.lonely')),
      new TVBannerCoverModel('5', $r('app.media.ic_banner_6'), $r('app.media.ic_banner_vertical_6'), $r('app.string.lonely')),
      new TVBannerCoverModel('6', $r('app.media.ic_banner_5'), $r('app.media.ic_banner_vertical_5'), $r('app.string.lonely')),
      new TVBannerCoverModel('7', $r('app.media.ic_banner_4'), $r('app.media.ic_banner_vertical_4'), $r('app.string.lonely'))
    ];
  }

  loadTVBannerScaleData(): void {
    this.clearTVBannerScaleList();
    this.tvBannerScaleListModel = [
      MainPageConstants.TV_BANNER_IMAGE_SCALE_1,
      MainPageConstants.TV_BANNER_IMAGE_SCALE_2,
      MainPageConstants.TV_BANNER_IMAGE_SCALE_3,
      MainPageConstants.TV_BANNER_IMAGE_SCALE_2,
      MainPageConstants.TV_BANNER_IMAGE_SCALE_1,
      MainPageConstants.TV_BANNER_IMAGE_SCALE_1,
      MainPageConstants.TV_BANNER_IMAGE_SCALE_1,
      MainPageConstants.TV_BANNER_IMAGE_SCALE_1
    ];
  }

  getTVBannerCoverListModel(): TVBannerCoverModel[] {
    return this.tvBannerCoverListModel;
  }

  getTVBannerScaleListModel(): Array<ScaleOptions> {
    return this.tvBannerScaleListModel;
  }

  clearTVBannerCoverList(): void {
    this.tvBannerCoverListModel = [];
  }

  clearTVBannerScaleList(): void {
    this.tvBannerScaleListModel = [];
  }
}
