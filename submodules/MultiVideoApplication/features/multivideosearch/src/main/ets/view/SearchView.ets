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

import { BusinessError } from '@kit.BasicServicesKit';
import { BreakpointType, CommonConstants, Logger, WindowInfo, WindowUtil } from 'multivideobase';
import { SearchConstants } from '../constants/SearchConstants';
import { SearchContent } from './SearchContent';
import { SearchByKeyword } from './SearchByKeyword';
import { SearchHeader } from './SearchHeader';
import { SearchResult } from './SearchResult';
import TrendingSearchListViewModel from '../viewmodel/TrendingSearchViewModel';
import SearchResultImgListViewModel from '../viewmodel/SearchResultImgViewModel';

const TAG = '[SearchView]';

@Component
export struct SearchView {
  @StorageLink(CommonConstants.WINDOW_UTIL) windowUtil: WindowUtil | undefined = undefined;
  @Consume('currentTopIndex') currentTopIndex: number = 0;
  @Consume('pageInfo') pageInfo: NavPathStack;
  @ObjectLink mainWindowInfo: WindowInfo;
  @State currentIndex: number = 0;
  @State trendingSearchListViewModel: TrendingSearchListViewModel = new TrendingSearchListViewModel();
  @State searchResultImgListViewModel: SearchResultImgListViewModel = new SearchResultImgListViewModel();
  @State searchInput: string = '';

  aboutToAppear(): void {
    this.trendingSearchListViewModel.loadSearchVideoData();
  }

  aboutToDisappear(): void {
    this.trendingSearchListViewModel.clearSearchVideoData();
  }

  build() {
    NavDestination() {
      GridRow({
        columns: {
          xs: 4,
          sm: 4,
          md: 12,
          lg: 12,
          xl: 12,
        }
      }) {
        GridCol({
          span: {
            xs: 4,
            sm: 4,
            md: 12,
            lg: 12,
            xl: 12
          }
        }) {
          Column() {
            SearchHeader({ searchInput: this.searchInput, mainWindowInfo: this.mainWindowInfo })
            SearchContent({
              trendingSearchListViewModel: this.trendingSearchListViewModel,
              mainWindowInfo: this.mainWindowInfo
            })
              .layoutWeight(1)
              .visibility(this.searchInput === this.convertResource2String(
                SearchConstants.SEARCH_INPUT_LIST[SearchConstants.SEARCH_INPUT_KEYWORD_ONE_INDEX]) ||
                this.searchInput === this.convertResource2String(
                  SearchConstants.SEARCH_INPUT_LIST[SearchConstants.SEARCH_INPUT_KEYWORD_TWO_INDEX]) ?
                Visibility.None : Visibility.Visible)
            SearchByKeyword({ searchInput: this.searchInput, mainWindowInfo: this.mainWindowInfo })
              .layoutWeight(1)
              .visibility(this.searchInput === this.convertResource2String(
                SearchConstants.SEARCH_INPUT_LIST[SearchConstants.SEARCH_INPUT_KEYWORD_ONE_INDEX]) ?
                Visibility.Visible : Visibility.None)
            SearchResult({
              mainWindowInfo: this.windowUtil?.mainWindowInfo,
              searchResultImgListViewModel: this.searchResultImgListViewModel
            })
              .layoutWeight(1)
              .visibility(this.searchInput === this.convertResource2String(
                SearchConstants.SEARCH_INPUT_LIST[SearchConstants.SEARCH_INPUT_KEYWORD_TWO_INDEX]) ?
                Visibility.Visible : Visibility.None)
          }
          .height('100%')
          .width('100%')
          .padding({
            left: new BreakpointType('16vp', '16vp', '24vp', '32vp', '32vp').getValue(this.mainWindowInfo.widthBp),
            right: new BreakpointType('16vp', '16vp', '24vp', '32vp', '32vp').getValue(this.mainWindowInfo.widthBp),
          })
        }
      }
      .onBreakpointChange((breakPoints) => {
        this.trendingSearchListViewModel.updateTrendSearchList(breakPoints);
      })
    }
    .hideTitleBar(true)
  }

  convertResource2String(input: Resource): string {
    try {
      let ret =  this.getUIContext().getHostContext()?.resourceManager.getStringSync(input.id);
      if (ret) {
        return ret;
      }
      return '';
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `convert resource to string failed, errCode = ${err.code}, errMessage = ${err.message}.`);
      return '';
    }
  }
}
