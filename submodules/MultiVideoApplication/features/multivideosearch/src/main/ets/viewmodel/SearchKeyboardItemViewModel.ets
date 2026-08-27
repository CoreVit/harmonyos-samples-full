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

import { SearchKeyboardItemModel, SearchKeyboardListModel } from '../model/SearchKeyboardItemModel';

@Observed
export class SearchKeyboardItemViewModel {
  @Track private id: string = '0';
  @Track private label: ResourceStr = '';
  @Track private columnStart?: number;
  @Track private columnEnd?: number;

  updateItem(searchKeyboardItemModel: SearchKeyboardItemModel): void {
    this.id = searchKeyboardItemModel.getId();
    this.label = searchKeyboardItemModel.getLabel();
    this.columnStart = searchKeyboardItemModel.getColumnStart();
    this.columnEnd = searchKeyboardItemModel.getColumnEnd();
  }

  getId(): string {
    return this.id;
  }

  getLabel(): ResourceStr {
    return this.label;
  }

  getColumnStart(): number | undefined {
    return this.columnStart;
  }

  getColumnEnd(): number | undefined {
    return this.columnEnd;
  }
}

@Observed
export class SearchKeyboardItemArray extends Array<SearchKeyboardItemViewModel> {
}

@Observed
export default class SearchKeyboardItemListViewModel {
  @Track private letterItems: SearchKeyboardItemArray = new SearchKeyboardItemArray();
  @Track private digitItems: SearchKeyboardItemArray = new SearchKeyboardItemArray();

  loadLetterKeyboardData(): void {
    this.clearLetterKeyboardData();
    let searchKeyboardList = new SearchKeyboardListModel([], []);
    searchKeyboardList.loadLetterKeyboardData();
    for (let item of searchKeyboardList.getLetterKeyboardListModel()) {
      let searchKeyboardItemViewModel = new SearchKeyboardItemViewModel();
      searchKeyboardItemViewModel.updateItem(item);
      this.letterItems.push(searchKeyboardItemViewModel);
    }
  }

  loadDigitKeyboardData(): void {
    this.clearDigitKeyboardData();
    let searchKeyboardList = new SearchKeyboardListModel([], []);
    searchKeyboardList.loadDigitKeyboardData();
    for (let item of searchKeyboardList.getDigitKeyboardListModel()) {
      let searchKeyboardItemViewModel = new SearchKeyboardItemViewModel();
      searchKeyboardItemViewModel.updateItem(item);
      this.digitItems.push(searchKeyboardItemViewModel);
    }
  }

  getLetterItems(): SearchKeyboardItemArray {
    return this.letterItems.slice();
  }

  getDigitItems(): SearchKeyboardItemArray {
    return this.digitItems.slice();
  }

  clearLetterKeyboardData(): void {
    this.letterItems = new SearchKeyboardItemArray();
  }

  clearDigitKeyboardData(): void {
    this.digitItems = new SearchKeyboardItemArray();
  }
}
