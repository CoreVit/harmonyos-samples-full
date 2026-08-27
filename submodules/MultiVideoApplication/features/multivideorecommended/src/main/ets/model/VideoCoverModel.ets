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

export class VideoCoverModel {
  private id: string = '0';
  // Image src of the video.
  private imgSrc: Resource;
  // Rating of the video.
  private rating: string;
  // Title of the video.
  private title: ResourceStr;
  // Content of the video.
  private content: ResourceStr;
  // Other information of the video.
  private otherInfo: ResourceStr;
  // Membership of the video.
  private memberShipTag: Resource | ResourceStr;

  constructor(id: string, imgSrc: Resource, rating: string, title: ResourceStr, content: ResourceStr,
    otherInfo: ResourceStr, memberShipTag: Resource | ResourceStr) {
    this.id = id;
    this.imgSrc = imgSrc;
    this.rating = rating;
    this.title = title;
    this.content = content;
    this.otherInfo = otherInfo;
    this.memberShipTag = memberShipTag;
  }

  getId(): string {
    return this.id;
  }

  getImgSrc(): Resource {
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

  getMemberShipTag(): Resource | ResourceStr {
    return this.memberShipTag;
  }
}

export class VideoCoverListModel {
  private videoCoverListModel: VideoCoverModel[] = [];

  constructor(videoCoverListModel: VideoCoverModel[]) {
    this.videoCoverListModel = videoCoverListModel;
  }

  loadVideoCoverData(videoCoverType: string): void {
    this.clearVideoCoverList();
    if (videoCoverType === MainPageConstants.VIDEO_COVER_NEW_VIDEO_RELEASE) {
      this.videoCoverListModel.push(new VideoCoverModel('0', $r('app.media.new_video_1'),
        MainPageConstants.NEW_VIDEO_RATES[0], MainPageConstants.NEW_VIDEO_NAMES[0], MainPageConstants.NEW_VIDEO_CONTENTS[0], '',
        ''));
      this.videoCoverListModel.push(new VideoCoverModel('1', $r('app.media.new_video_2'),
        MainPageConstants.NEW_VIDEO_RATES[1], MainPageConstants.NEW_VIDEO_NAMES[1], MainPageConstants.NEW_VIDEO_CONTENTS[1], '',
        ''));
      this.videoCoverListModel.push(new VideoCoverModel('2', $r('app.media.new_video_3'),
        MainPageConstants.NEW_VIDEO_RATES[2], MainPageConstants.NEW_VIDEO_NAMES[2], MainPageConstants.NEW_VIDEO_CONTENTS[2], '',
        ''));
      this.videoCoverListModel.push(new VideoCoverModel('3', $r('app.media.new_video_4'),
        MainPageConstants.NEW_VIDEO_RATES[3], MainPageConstants.NEW_VIDEO_NAMES[3], MainPageConstants.NEW_VIDEO_CONTENTS[3], '',
        ''));
      this.videoCoverListModel.push(new VideoCoverModel('4', $r('app.media.new_video_5'),
        MainPageConstants.NEW_VIDEO_RATES[4], MainPageConstants.NEW_VIDEO_NAMES[4], MainPageConstants.NEW_VIDEO_CONTENTS[4], '',
        ''));
      this.videoCoverListModel.push(new VideoCoverModel('5', $r('app.media.new_video_6'),
        MainPageConstants.NEW_VIDEO_RATES[5], MainPageConstants.NEW_VIDEO_NAMES[5], MainPageConstants.NEW_VIDEO_CONTENTS[5], '',
        ''));
      this.videoCoverListModel.push(new VideoCoverModel('6', $r('app.media.new_video_7'),
        MainPageConstants.NEW_VIDEO_RATES[6], MainPageConstants.NEW_VIDEO_NAMES[6], MainPageConstants.NEW_VIDEO_CONTENTS[6], '',
        ''));
    } else if (videoCoverType === MainPageConstants.VIDEO_COVER_POPULAR_VIDEO) {
      this.videoCoverListModel.push(new VideoCoverModel('0', $r('app.media.ic_video_grid_1'), MainPageConstants.VIDEO_GRID_RATES[0],
        MainPageConstants.VIDEO_GRID_NAMES[0], MainPageConstants.VIDEO_GRID_CONTENTS[0], '', $r('app.string.exclusive')));
      this.videoCoverListModel.push(new VideoCoverModel('1', $r('app.media.ic_video_grid_2'), MainPageConstants.VIDEO_GRID_RATES[1],
        MainPageConstants.VIDEO_GRID_NAMES[1], MainPageConstants.VIDEO_GRID_CONTENTS[1], '', $r('app.string.Membership')));
      this.videoCoverListModel.push(new VideoCoverModel('2', $r('app.media.ic_video_grid_3'), MainPageConstants.VIDEO_GRID_RATES[2],
        MainPageConstants.VIDEO_GRID_NAMES[2], MainPageConstants.VIDEO_GRID_CONTENTS[2], '', $r('app.string.Membership')));
      this.videoCoverListModel.push(new VideoCoverModel('3', $r('app.media.ic_video_grid_4'), MainPageConstants.VIDEO_GRID_RATES[3],
        MainPageConstants.VIDEO_GRID_NAMES[3], MainPageConstants.VIDEO_GRID_CONTENTS[3], '', $r('app.string.Membership')));
      this.videoCoverListModel.push(new VideoCoverModel('4', $r('app.media.ic_video_grid_5'), MainPageConstants.VIDEO_GRID_RATES[4],
        MainPageConstants.VIDEO_GRID_NAMES[4], MainPageConstants.VIDEO_GRID_CONTENTS[4], '', $r('app.string.Membership')));
      this.videoCoverListModel.push(new VideoCoverModel('5', $r('app.media.ic_video_grid_6'), MainPageConstants.VIDEO_GRID_RATES[5],
        MainPageConstants.VIDEO_GRID_NAMES[5], MainPageConstants.VIDEO_GRID_CONTENTS[5], '', $r('app.string.Membership')));
      this.videoCoverListModel.push(new VideoCoverModel('6', $r('app.media.ic_video_grid_7'), MainPageConstants.VIDEO_GRID_RATES[6],
        MainPageConstants.VIDEO_GRID_NAMES[6], MainPageConstants.VIDEO_GRID_CONTENTS[6], '', $r('app.string.Membership')));
      this.videoCoverListModel.push(new VideoCoverModel('7', $r('app.media.ic_video_grid_8'), MainPageConstants.VIDEO_GRID_RATES[7],
        MainPageConstants.VIDEO_GRID_NAMES[7], MainPageConstants.VIDEO_GRID_CONTENTS[7], '', $r('app.string.Membership')));
      this.videoCoverListModel.push(new VideoCoverModel('8', $r('app.media.ic_video_grid_9'), MainPageConstants.VIDEO_GRID_RATES[8],
        MainPageConstants.VIDEO_GRID_NAMES[8], MainPageConstants.VIDEO_GRID_CONTENTS[8], '', $r('app.string.Membership')));
      this.videoCoverListModel.push(new VideoCoverModel('9', $r('app.media.ic_video_grid_10'), MainPageConstants.VIDEO_GRID_RATES[9],
        MainPageConstants.VIDEO_GRID_NAMES[9], MainPageConstants.VIDEO_GRID_CONTENTS[9], '', $r('app.string.Membership')));
    } else if (videoCoverType === MainPageConstants.VIDEO_COVER_MAIN_DAILY_VIDEO) {
      this.videoCoverListModel.push(new VideoCoverModel('0', $r('app.media.daily_video'), MainPageConstants.MAIN_DAILY_VIDEO_RATE,
        MainPageConstants.MAIN_DAILY_VIDEO_NAME, MainPageConstants.MAIN_DAILY_VIDEO_CONTENT, MainPageConstants.MAIN_DAILY_VIDEO_MORE, $r('app.string.Membership')));
    } else if (videoCoverType === MainPageConstants.VIDEO_COVER_DAILY_VIDEO) {
      this.videoCoverListModel.push(new VideoCoverModel('0', $r('app.media.daily_video_1'), MainPageConstants.DAILY_VIDEO_RATES[0],
        MainPageConstants.DAILY_VIDEO_NAMES[0], MainPageConstants.DAILY_VIDEO_CONTENTS[0], '', $r('app.string.Membership')));
      this.videoCoverListModel.push(new VideoCoverModel('1', $r('app.media.daily_video_2'), MainPageConstants.DAILY_VIDEO_RATES[1],
        MainPageConstants.DAILY_VIDEO_NAMES[1], MainPageConstants.DAILY_VIDEO_CONTENTS[1], '', $r('app.string.Membership')));
      this.videoCoverListModel.push(new VideoCoverModel('2', $r('app.media.daily_video_3'), MainPageConstants.DAILY_VIDEO_RATES[2],
        MainPageConstants.DAILY_VIDEO_NAMES[2], MainPageConstants.DAILY_VIDEO_CONTENTS[2], '', ''));
      this.videoCoverListModel.push(new VideoCoverModel('3', $r('app.media.daily_video_4'), MainPageConstants.DAILY_VIDEO_RATES[3],
        MainPageConstants.DAILY_VIDEO_NAMES[3], MainPageConstants.DAILY_VIDEO_CONTENTS[3], '', ''));
    } else if (videoCoverType === MainPageConstants.VIDEO_COVER_PREVIOUS_VIDEO_ONE) {
      this.videoCoverListModel.push(new VideoCoverModel('0', $r('app.media.previous_video_1'), '',
        MainPageConstants.PREVIOUS_VIDEO_NAMES_ONE[0], MainPageConstants.PREVIOUS_VIDEO_CONTENTS_ONE[0],
        MainPageConstants.PREVIOUS_VIDEO_MORE_ONE[0], ''));
      this.videoCoverListModel.push(new VideoCoverModel('1', $r('app.media.previous_video_2'), '',
        MainPageConstants.PREVIOUS_VIDEO_NAMES_ONE[1], MainPageConstants.PREVIOUS_VIDEO_CONTENTS_ONE[1],
        MainPageConstants.PREVIOUS_VIDEO_MORE_ONE[1], ''));
      this.videoCoverListModel.push(new VideoCoverModel('2', $r('app.media.previous_video_3'), '',
        MainPageConstants.PREVIOUS_VIDEO_NAMES_ONE[2], MainPageConstants.PREVIOUS_VIDEO_CONTENTS_ONE[2],
        MainPageConstants.PREVIOUS_VIDEO_MORE_ONE[2], ''));
    } else if (videoCoverType === MainPageConstants.VIDEO_COVER_PREVIOUS_VIDEO_TWO) {
      this.videoCoverListModel.push(new VideoCoverModel('0', $r('app.media.previous_video_4'), '',
        MainPageConstants.PREVIOUS_VIDEO_NAMES_TWO[0], MainPageConstants.PREVIOUS_VIDEO_CONTENTS_TWO[0], '', ''));
      this.videoCoverListModel.push(new VideoCoverModel('1', $r('app.media.previous_video_5'), '',
        MainPageConstants.PREVIOUS_VIDEO_NAMES_TWO[1], MainPageConstants.PREVIOUS_VIDEO_CONTENTS_TWO[1], '', ''));
      this.videoCoverListModel.push(new VideoCoverModel('2', $r('app.media.previous_video_6'), '',
        MainPageConstants.PREVIOUS_VIDEO_NAMES_TWO[2], MainPageConstants.PREVIOUS_VIDEO_CONTENTS_TWO[2], '', ''));
      this.videoCoverListModel.push(new VideoCoverModel('3', $r('app.media.previous_video_7'), '',
        MainPageConstants.PREVIOUS_VIDEO_NAMES_TWO[3], MainPageConstants.PREVIOUS_VIDEO_CONTENTS_TWO[3], '', ''));
      this.videoCoverListModel.push(new VideoCoverModel('4', $r('app.media.previous_video_8'), '',
        MainPageConstants.PREVIOUS_VIDEO_NAMES_TWO[4], MainPageConstants.PREVIOUS_VIDEO_CONTENTS_TWO[4], '', ''));
      this.videoCoverListModel.push(new VideoCoverModel('5', $r('app.media.previous_video_9'), '',
        MainPageConstants.PREVIOUS_VIDEO_NAMES_TWO[5], MainPageConstants.PREVIOUS_VIDEO_CONTENTS_TWO[5], '', ''));
    } else if (videoCoverType === MainPageConstants.VIDEO_COVER_TV_PREVIOUS_VIDEO_ONE) {
      this.videoCoverListModel.push(new VideoCoverModel('0', $r('app.media.previous_video_1'), '',
        MainPageConstants.PREVIOUS_VIDEO_NAMES_ONE[0], MainPageConstants.PREVIOUS_VIDEO_CONTENTS_ONE[0],
        MainPageConstants.PREVIOUS_VIDEO_MORE_ONE[0], ''));
      this.videoCoverListModel.push(new VideoCoverModel('1', $r('app.media.previous_video_2'), '',
        MainPageConstants.PREVIOUS_VIDEO_NAMES_ONE[1], MainPageConstants.PREVIOUS_VIDEO_CONTENTS_ONE[1],
        MainPageConstants.PREVIOUS_VIDEO_MORE_ONE[1], ''));
      this.videoCoverListModel.push(new VideoCoverModel('2', $r('app.media.previous_video_3'), '',
        MainPageConstants.PREVIOUS_VIDEO_NAMES_ONE[2], MainPageConstants.PREVIOUS_VIDEO_CONTENTS_ONE[2],
        MainPageConstants.PREVIOUS_VIDEO_MORE_ONE[2], ''));
      this.videoCoverListModel.push(new VideoCoverModel('3', $r('app.media.previous_video_6'), '',
        MainPageConstants.PREVIOUS_VIDEO_NAMES_ONE[2], MainPageConstants.PREVIOUS_VIDEO_CONTENTS_ONE[2],
        MainPageConstants.PREVIOUS_VIDEO_MORE_ONE[2], ''));
    } else if (videoCoverType === MainPageConstants.VIDEO_COVER_TV_PREVIOUS_VIDEO_TWO) {
      this.videoCoverListModel.push(new VideoCoverModel('0', $r('app.media.previous_video_7'), '',
        MainPageConstants.PREVIOUS_VIDEO_NAMES_TWO[0], MainPageConstants.PREVIOUS_VIDEO_CONTENTS_TWO[0], '', ''));
      this.videoCoverListModel.push(new VideoCoverModel('1', $r('app.media.previous_video_10'), '',
        MainPageConstants.PREVIOUS_VIDEO_NAMES_TWO[1], MainPageConstants.PREVIOUS_VIDEO_CONTENTS_TWO[1], '', ''));
      this.videoCoverListModel.push(new VideoCoverModel('2', $r('app.media.previous_video_11'), '',
        MainPageConstants.PREVIOUS_VIDEO_NAMES_TWO[2], MainPageConstants.PREVIOUS_VIDEO_CONTENTS_TWO[2], '', ''));
      this.videoCoverListModel.push(new VideoCoverModel('3', $r('app.media.previous_video_12'), '',
        MainPageConstants.PREVIOUS_VIDEO_NAMES_TWO[3], MainPageConstants.PREVIOUS_VIDEO_CONTENTS_TWO[3], '', ''));
    }
  }

  getVideoCoverListModel(): VideoCoverModel[] {
    return this.videoCoverListModel.slice();
  }

  clearVideoCoverList(): void {
    this.videoCoverListModel = [];
  }
}