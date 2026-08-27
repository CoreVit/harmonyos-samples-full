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

import { DetailConstants } from '../constants/DetailConstants';

export class RelatedVideoItemModel {
  private id: string = '0';
  private name: ResourceStr;
  private imageSrc: ResourceStr;

  constructor(id: string, name: ResourceStr, imageSrc: ResourceStr) {
    this.id = id;
    this.name = name;
    this.imageSrc = imageSrc;
  }

  getId(): string {
    return this.id;
  }

  getName(): ResourceStr {
    return this.name;
  }

  getImageSrc(): ResourceStr {
    return this.imageSrc;
  }
}

export default class RelatedVideoListModel {
  private relatedVideoListModel: RelatedVideoItemModel[] = [];

  constructor(relatedVideoListModel: RelatedVideoItemModel[]) {
    this.relatedVideoListModel = relatedVideoListModel;
  }

  loadRelatedVideoData(videoType: string): void {
    this.clearRelatedVideoList();
    if (videoType === DetailConstants.RELATED_VIDEO_TYPE) {
      this.relatedVideoListModel.push(new RelatedVideoItemModel('0', DetailConstants.RELATED_VIDEO_TITLES[0],
        $r('app.media.related_video_1')));
      this.relatedVideoListModel.push(new RelatedVideoItemModel('1', DetailConstants.RELATED_VIDEO_TITLES[1],
        $r('app.media.related_video_2')));
      this.relatedVideoListModel.push(new RelatedVideoItemModel('2', DetailConstants.RELATED_VIDEO_TITLES[2],
        $r('app.media.related_video_3')));
      this.relatedVideoListModel.push(new RelatedVideoItemModel('3', DetailConstants.RELATED_VIDEO_TITLES[3],
        $r('app.media.related_video_4')));
      this.relatedVideoListModel.push(new RelatedVideoItemModel('4', DetailConstants.RELATED_VIDEO_TITLES[4],
        $r('app.media.related_video_5')));
      this.relatedVideoListModel.push(new RelatedVideoItemModel('5', DetailConstants.RELATED_VIDEO_TITLES[5],
        $r('app.media.related_video_6')));
      this.relatedVideoListModel.push(new RelatedVideoItemModel('6', DetailConstants.RELATED_VIDEO_TITLES[6],
        $r('app.media.related_video_7')));
    } else if (videoType === DetailConstants.PERIPHERAL_VIDEO_TYPE) {
      this.relatedVideoListModel.push(new RelatedVideoItemModel('0', DetailConstants.PERIPHERAL_VIDEO_TITLE[0],
        $r('app.media.peripheral_video_1')));
      this.relatedVideoListModel.push(new RelatedVideoItemModel('1', DetailConstants.PERIPHERAL_VIDEO_TITLE[1],
        $r('app.media.peripheral_video_2')));
      this.relatedVideoListModel.push(new RelatedVideoItemModel('2', DetailConstants.PERIPHERAL_VIDEO_TITLE[2],
        $r('app.media.peripheral_video_3')));
      this.relatedVideoListModel.push(new RelatedVideoItemModel('3', DetailConstants.PERIPHERAL_VIDEO_TITLE[3],
        $r('app.media.peripheral_video_4')));
      this.relatedVideoListModel.push(new RelatedVideoItemModel('4', DetailConstants.PERIPHERAL_VIDEO_TITLE[4],
        $r('app.media.peripheral_video_5')));
    }
  }

  getRelatedVideoListModel(): RelatedVideoItemModel[] {
    return this.relatedVideoListModel.slice();
  }

  clearRelatedVideoList(): void {
    this.relatedVideoListModel = [];
  }
}
