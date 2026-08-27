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
import { VideoCoverListModel, VideoCoverModel } from '../model/VideoCoverModel';

@Observed
export class PreviousVideoCoverViewModel {
  @Track private id: string = '0';
  // Image src of the video.
  @Track private imgSrc: ResourceStr = '';
  // Rating of the video.
  @Track private rating: string = '';
  // Title of the video.
  @Track private title: ResourceStr = '';
  // Content of the video.
  @Track private content: ResourceStr = '';
  // Other information of the video.
  @Track private otherInfo: ResourceStr = '';
  // Membership of the video.
  @Track private memberShipTag: ResourceStr = '';

  updateCover(videoCoverModel: VideoCoverModel) {
    this.id = videoCoverModel.getId();
    this.imgSrc = videoCoverModel.getImgSrc();
    this.rating = videoCoverModel.getRating();
    this.title = videoCoverModel.getTitle();
    this.content = videoCoverModel.getContent();
    this.otherInfo = videoCoverModel.getOtherInfo();
    this.memberShipTag = videoCoverModel.getMemberShipTag();
  }

  getId(): string {
    return this.id;
  }

  getImgSrc(): ResourceStr {
    return this.imgSrc;
  }

  getRating(): string {
    return this.rating;
  }

  getTitle(): ResourceStr {
    return this.title;
  }

  getContent(): ResourceStr {
    return this.content;
  }

  getOtherInfo(): ResourceStr {
    return this.otherInfo;
  }

  getMemberShipTag(): ResourceStr {
    return this.memberShipTag;
  }
}

@Observed
export class PreviousVideoCoverArray extends Array<PreviousVideoCoverViewModel> {
}

@Observed
export default class PreviousVideoCoverListViewModel {
  @Track private coversOne: PreviousVideoCoverArray = new PreviousVideoCoverArray();
  @Track private coversTwoOrigin: PreviousVideoCoverArray = new PreviousVideoCoverArray();
  @Track private coversTwoShow: PreviousVideoCoverArray = new PreviousVideoCoverArray();

  loadVideoCoverData() {
    this.clearVideoCoverData();
    let videoCoverList = new VideoCoverListModel([]);
    videoCoverList.loadVideoCoverData(MainPageConstants.VIDEO_COVER_PREVIOUS_VIDEO_ONE);
    for (let cover of videoCoverList.getVideoCoverListModel()) {
      let previousVideoCoverViewModel = new PreviousVideoCoverViewModel();
      previousVideoCoverViewModel.updateCover(cover);
      this.coversOne.push(previousVideoCoverViewModel);
    }
    videoCoverList.clearVideoCoverList();
    videoCoverList.loadVideoCoverData(MainPageConstants.VIDEO_COVER_PREVIOUS_VIDEO_TWO);
    for (let cover of videoCoverList.getVideoCoverListModel()) {
      let previousVideoCoverViewModel = new PreviousVideoCoverViewModel();
      previousVideoCoverViewModel.updateCover(cover);
      this.coversTwoOrigin.push(previousVideoCoverViewModel);
      this.coversTwoShow.push(previousVideoCoverViewModel);
    }
  }

  updateCoversTwoByBreakpoints(currentWidthBreakpoint: WidthBreakpoint): void {
    if (currentWidthBreakpoint === WidthBreakpoint.WIDTH_MD) {
      this.coversTwoShow = this.coversTwoOrigin;
    } else if (currentWidthBreakpoint === WidthBreakpoint.WIDTH_LG) {
      this.coversTwoShow = this.coversTwoOrigin.slice(1, 6);
    } else {
      this.coversTwoShow = this.coversTwoOrigin.slice(0, 4);
    }
  }

  clearVideoCoverData() {
    this.coversOne = new PreviousVideoCoverArray();
    this.coversTwoOrigin = new PreviousVideoCoverArray();
    this.coversTwoShow = new PreviousVideoCoverArray();
  }

  getCoversOne(): PreviousVideoCoverArray {
    return this.coversOne.slice();
  }

  getCoversTwo(): PreviousVideoCoverArray {
    return this.coversTwoShow.slice();
  }
}