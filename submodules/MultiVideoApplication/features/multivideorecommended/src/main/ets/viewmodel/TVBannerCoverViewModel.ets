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

import { TVBannerCoverListModel, TVBannerCoverModel } from '../model/TVBannerCoverModel';

@Observed
export class TVBannerCoverViewModel {
  @Track private id: string = '0';
  @Track private imgHorizontal: ResourceStr = '';
  @Track private imgVertical: ResourceStr = '';
  @Track private title: ResourceStr = '';

  updateCover(tvBannerCoverModel: TVBannerCoverModel): void {
    this.id = tvBannerCoverModel.getId();
    this.imgHorizontal = tvBannerCoverModel.getImgHorizontal();
    this.imgVertical = tvBannerCoverModel.getImgVertical();
    this.title = tvBannerCoverModel.getTitle();
  }

  getId(): string {
    return this.id;
  }

  getImgHorizontal(): ResourceStr {
    return this.imgHorizontal;
  }

  getImgVertical(): ResourceStr {
    return this.imgVertical;
  }

  getTitle(): ResourceStr {
    return this.title;
  }
}

@Observed
export class TVBannerCoverArray extends Array<TVBannerCoverViewModel> {
}

@Observed
export default class TVBannerCoverListViewModel {
  @Track private covers: TVBannerCoverArray = new TVBannerCoverArray();
  @Track private scales: Array<ScaleOptions> = [];

  loadTVBannerCoverData(): void {
    this.clearTVBannerCoverData();
    let tvBannerCoverList = new TVBannerCoverListModel([], []);
    tvBannerCoverList.loadTVBannerCoverData();
    for (let cover of tvBannerCoverList.getTVBannerCoverListModel()) {
      let tvBannerCoverViewModel = new TVBannerCoverViewModel();
      tvBannerCoverViewModel.updateCover(cover);
      this.covers.push(tvBannerCoverViewModel);
    }
  }

  loadTVBannerScaleData(): void {
    this.clearTVBannerScaleData();
    let tvBannerCoverList = new TVBannerCoverListModel([], []);
    tvBannerCoverList.loadTVBannerScaleData();
    this.scales = tvBannerCoverList.getTVBannerScaleListModel();
  }

  getCovers(): TVBannerCoverArray {
    return this.covers.slice();
  }

  getScales(): Array<ScaleOptions> {
    return this.scales;
  }

  clearTVBannerCoverData(): void {
    this.covers = new TVBannerCoverArray();
  }

  clearTVBannerScaleData(): void {
    this.scales = [];
  }
}
