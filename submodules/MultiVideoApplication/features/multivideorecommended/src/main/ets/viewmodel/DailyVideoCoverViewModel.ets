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
export class DailyVideoCoverViewModel {
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
export class DailyVideoCoverArray extends Array<DailyVideoCoverViewModel> {
}

@Observed
export default class DailyVideoCoverListViewModel {
  @Track private covers: DailyVideoCoverArray = new DailyVideoCoverArray();
  @Track private mainDailyVideoCover: DailyVideoCoverViewModel = new DailyVideoCoverViewModel();

  loadVideoCoverData(): void {
    this.clearVideoCoverData();
    let dailyVideoCoverList = new VideoCoverListModel([]);
    dailyVideoCoverList.loadVideoCoverData(MainPageConstants.VIDEO_COVER_DAILY_VIDEO);
    for (let cover of dailyVideoCoverList.getVideoCoverListModel()) {
      let dailyVideoCoverViewModel = new DailyVideoCoverViewModel();
      dailyVideoCoverViewModel.updateCover(cover);
      this.covers.push(dailyVideoCoverViewModel);
    }
    let mainVideoCoverList = new VideoCoverListModel([]);
    mainVideoCoverList.loadVideoCoverData(MainPageConstants.VIDEO_COVER_MAIN_DAILY_VIDEO);
    if (mainVideoCoverList.getVideoCoverListModel().length > 0) {
      this.mainDailyVideoCover.updateCover(mainVideoCoverList.getVideoCoverListModel()[mainVideoCoverList
        .getVideoCoverListModel().length - 1])
    }
  }

  clearVideoCoverData() {
    this.covers = new DailyVideoCoverArray();
    this.mainDailyVideoCover = new DailyVideoCoverViewModel();
  }

  getCovers(): DailyVideoCoverArray {
    return this.covers;
  }

  getMainCover(): DailyVideoCoverViewModel {
    return this.mainDailyVideoCover;
  }
}