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

import { BreakpointType } from 'multivideobase';
import { BannerCoverListModel, BannerCoverModel } from '../model/BannerCoverModel';

@Observed
export class BannerCoverViewModel {
  @Track private id: string = '0';
  @Track private imgSrc: ResourceStr = '';
  @Track private imgSrcSm: ResourceStr = '';
  @Track private height: BreakpointType<Resource> =
    new BreakpointType($r('app.float.banner_height_sm'), $r('app.float.banner_height_sm'),
      $r('app.float.banner_height_md'), $r('app.float.banner_height_lg'), $r('app.float.banner_height_xl'));
  @Track private description: ResourceStr[] = [];
  @Track private fontSize: BreakpointType<Resource[]> =
    new BreakpointType([], [], [], [], []);
  @Track private fontWeight: number[] = [];
  @Track private lineHeight: BreakpointType<Resource[]> =
    new BreakpointType([], [], [], [], []);
  @Track private leftPosition: BreakpointType<string[]> =
    new BreakpointType([], [], [], [], []);
  @Track private topPosition: BreakpointType<string[]> =
    new BreakpointType([], [], [], [], []);
  @Track private isLeftCenter: BreakpointType<boolean> =
    new BreakpointType(true, true, true, true, true);
  @Track private isTopCenter: BreakpointType<boolean> =
    new BreakpointType(true, true, true, true, true);

  updateCover(bannerCoverModel: BannerCoverModel): void {
    this.id = bannerCoverModel.getId();
    this.imgSrc = bannerCoverModel.getImgSrc();
    this.imgSrcSm = bannerCoverModel.getImgSrcSm();
    this.height = bannerCoverModel.getHeight();
    this.description = bannerCoverModel.getDescription();
    this.fontSize = bannerCoverModel.getFontSize();
    this.fontWeight = bannerCoverModel.getFontWeight();
    this.lineHeight = bannerCoverModel.getLineHeight();
    this.leftPosition = bannerCoverModel.getLeftPosition();
    this.topPosition = bannerCoverModel.getTopPosition();
    this.isLeftCenter = bannerCoverModel.getIsLeftCenter();
    this.isTopCenter = bannerCoverModel.getIsTopCenter();
  }

  getId(): string {
    return this.id;
  }

  getImgSrc(): ResourceStr {
    return this.imgSrc;
  }

  getImgSrcSm(): ResourceStr {
    return this.imgSrcSm;
  }

  getHeight(): BreakpointType<Resource> {
    return this.height;
  }

  getDescription(): ResourceStr[] {
    return this.description;
  }

  getFontSize(): BreakpointType<Resource[]> {
    return this.fontSize;
  }

  getFontWeight(): number[] {
    return this.fontWeight;
  }

  getLineHeight(): BreakpointType<Resource[]> {
    return this.lineHeight;
  }

  getLeftPosition(): BreakpointType<string[]> {
    return this.leftPosition;
  }

  getTopPosition(): BreakpointType<string[]> {
    return this.topPosition;
  }

  getIsLeftCenter(): BreakpointType<boolean> {
    return this.isLeftCenter;
  }

  getIsTopCenter(): BreakpointType<boolean> {
    return this.isTopCenter;
  }
}

@Observed
export class BannerCoverArray extends Array<BannerCoverViewModel> {
}

@Observed
export default class BannerCoverListViewModel {
  @Track private covers: BannerCoverArray = new BannerCoverArray();

  loadBannerCoverData(): void {
    this.clearBannerCoverData();
    let bannerCoverList = new BannerCoverListModel([]);
    bannerCoverList.loadBannerCoverData();
    for (let cover of bannerCoverList.getBannerCoverListModel()) {
      let bannerCoverViewModel = new BannerCoverViewModel();
      bannerCoverViewModel.updateCover(cover);
      this.covers.push(bannerCoverViewModel);
    }
  }

  getCovers(): BannerCoverArray {
    return this.covers.slice();
  }

  clearBannerCoverData(): void {
    this.covers = new BannerCoverArray();
  }
}
