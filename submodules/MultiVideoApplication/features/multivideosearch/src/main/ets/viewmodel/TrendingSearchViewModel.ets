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

import { BreakpointConstants } from 'multivideobase';
import { SearchConstants } from '../constants/SearchConstants';
import { SearchVideoListModel, SearchVideoItemModel } from '../model/SearchVideoItemModel';

@Observed
export class TrendingSearchViewModel {
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
export class TrendingSearchArray extends Array<TrendingSearchViewModel> {
}

@Observed
export default class TrendingSearchListViewModel {
  @Track private itemsShow: TrendingSearchArray = new TrendingSearchArray();
  @Track private itemsOrigin: TrendingSearchArray = new TrendingSearchArray();

  loadSearchVideoData(): void {
    this.clearSearchVideoData();
    let searchVideoList = new SearchVideoListModel([]);
    searchVideoList.loadSearchVideoData(SearchConstants.VIDEO_COVER_TRENDING_SEARCH);
    for (let item of searchVideoList.getSearchVideoListModel()) {
      let trendingSearchViewModel = new TrendingSearchViewModel();
      trendingSearchViewModel.updateItem(item);
      this.itemsShow.push(trendingSearchViewModel);
      this.itemsOrigin.push(trendingSearchViewModel);
    }
  }

  getItems(): TrendingSearchArray {
    return this.itemsShow.slice();
  }

  updateTrendSearchList(currentWidthBreakpoint: string): void {
    if (currentWidthBreakpoint === BreakpointConstants.BREAKPOINT_SM) {
      this.itemsShow = this.itemsOrigin.slice(0, 5);
    } else if (currentWidthBreakpoint === BreakpointConstants.BREAKPOINT_MD) {
      this.itemsShow = this.itemsOrigin.slice(0, 10)
    } else {
      this.itemsShow = this.itemsOrigin;
    }
  }

  clearSearchVideoData(): void {
    this.itemsShow = new TrendingSearchArray();
    this.itemsOrigin = new TrendingSearchArray();
  }
}
