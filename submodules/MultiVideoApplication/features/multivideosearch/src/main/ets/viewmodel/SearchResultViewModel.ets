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

import { SearchConstants } from '../constants/SearchConstants';
import { SearchVideoListModel, SearchVideoItemModel } from '../model/SearchVideoItemModel';

@Observed
export class SearchResultViewModel {
  @Track private id: string = '0';
  @Track private imgSrc: ResourceStr = '';
  @Track private title: ResourceStr = '';
  @Track private content: ResourceStr = '';
  @Track private otherInfo: ResourceStr = '';

  updateItem(searchVideoItemModel: SearchVideoItemModel): void {
    this.id = searchVideoItemModel.getId();
    this.imgSrc = searchVideoItemModel.getImgSrc();
    this.title = searchVideoItemModel.getTitle();
    this.content = searchVideoItemModel.getContent();
    this.otherInfo = searchVideoItemModel.getOtherInfo();
  }

  getId(): string { return this.id; }
  getImgSrc(): ResourceStr { return this.imgSrc; }
  getTitle(): ResourceStr { return this.title; }
  getContent(): ResourceStr { return this.content; }
  getOtherInfo(): ResourceStr { return this.otherInfo; }
}

@Observed
export class SearchResultArray extends Array<SearchResultViewModel> {
}

@Observed
export default class SearchResultListViewModel {
  @Track private items: SearchResultArray = new SearchResultArray();

  loadSearchVideoData(): void {
    this.clearSearchVideoData();
    let searchVideoList = new SearchVideoListModel([]);
    searchVideoList.loadSearchVideoData(SearchConstants.VIDEO_COVER_SEARCH_RESULT);
    for (let item of searchVideoList.getSearchVideoListModel()) {
      let searchResultViewModel = new SearchResultViewModel();
      searchResultViewModel.updateItem(item);
      this.items.push(searchResultViewModel);
    }
  }

  getItems(): SearchResultArray {
    return this.items.slice();
  }

  clearSearchVideoData(): void {
    this.items = new SearchResultArray();
  }
}
