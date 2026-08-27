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
import RelatedVideoListModel, { RelatedVideoItemModel } from '../model/RelatedVideoItemModel';

@Observed
export class RelatedVideoItemViewModel {
  @Track private id: string = '0';
  @Track private name: ResourceStr = '';
  @Track private imageSrc: ResourceStr = '';

  updateItem(relatedVideoItemModel: RelatedVideoItemModel): void {
    this.id = relatedVideoItemModel.getId();
    this.name = relatedVideoItemModel.getName();
    this.imageSrc = relatedVideoItemModel.getImageSrc();
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

@Observed
export class RelatedVideoItemArray extends Array<RelatedVideoItemViewModel> {
}

@Observed
export default class RelatedVideoItemListViewModel {
  @Track private items: RelatedVideoItemArray = new RelatedVideoItemArray();

  loadRelatedVideoData(): void {
    this.clearRelatedVideoData();
    let relatedVideoList = new RelatedVideoListModel([]);
    relatedVideoList.loadRelatedVideoData(DetailConstants.RELATED_VIDEO_TYPE);
    for (let item of relatedVideoList.getRelatedVideoListModel()) {
      let relatedVideoItemViewModel = new RelatedVideoItemViewModel();
      relatedVideoItemViewModel.updateItem(item);
      this.items.push(relatedVideoItemViewModel);
    }
  }

  getItems(): RelatedVideoItemArray {
    return this.items.slice();
  }

  clearRelatedVideoData(): void {
    this.items = new RelatedVideoItemArray();
  }
}
