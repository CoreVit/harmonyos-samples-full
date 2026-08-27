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

export class SearchKeyboardItemModel {
  private id: string = '0';
  private label: ResourceStr;
  private columnStart?: number;
  private columnEnd?: number;

  constructor(id: string, label: ResourceStr, columnStart?: number, columnEnd?: number) {
    this.id = id;
    this.label = label;
    this.columnStart = columnStart;
    this.columnEnd = columnEnd;
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

export class SearchKeyboardListModel {
  private static readonly BACKSPACE_START: number = 7;
  private static readonly BACKSPACE_END: number = 10;
  private static readonly ZERO_START: number = 1;
  private static readonly ZERO_END: number = 4;

  private letterKeyboardListModel: SearchKeyboardItemModel[] = [];
  private digitKeyboardListModel: SearchKeyboardItemModel[] = [];

  constructor(letterKeyboardListModel: SearchKeyboardItemModel[],
    digitKeyboardListModel: SearchKeyboardItemModel[]) {
    this.letterKeyboardListModel = letterKeyboardListModel;
    this.digitKeyboardListModel = digitKeyboardListModel;
  }

  loadLetterKeyboardData(): void {
    this.clearLetterKeyboardList();
    const letterKeys: ResourceStr[] = [
      'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P',
      'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L',
      SearchConstants.SEARCH_ACTION[SearchConstants.SEARCH_ACTION_CLEAR_INDEX],
      'Z', 'X', 'C', 'V', 'B', 'N', 'M',
      SearchConstants.SEARCH_ACTION[SearchConstants.SEARCH_ACTION_DELETE_INDEX]
    ];
    this.letterKeyboardListModel = letterKeys.map((label: ResourceStr, index: number) => {
      if (label === SearchConstants.SEARCH_ACTION[SearchConstants.SEARCH_ACTION_DELETE_INDEX]) {
        return new SearchKeyboardItemModel(index.toString(), label,
          SearchKeyboardListModel.BACKSPACE_START, SearchKeyboardListModel.BACKSPACE_END);
      }
      return new SearchKeyboardItemModel(index.toString(), label);
    });
  }

  loadDigitKeyboardData(): void {
    this.clearDigitKeyboardList();
    const digitKeys: ResourceStr[] = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
    this.digitKeyboardListModel = digitKeys.map((label: ResourceStr, index: number) => {
      if (label === '0') {
        return new SearchKeyboardItemModel(index.toString(), label,
          SearchKeyboardListModel.ZERO_START, SearchKeyboardListModel.ZERO_END);
      }
      return new SearchKeyboardItemModel(index.toString(), label);
    });
  }

  getLetterKeyboardListModel(): SearchKeyboardItemModel[] {
    return this.letterKeyboardListModel.slice();
  }

  getDigitKeyboardListModel(): SearchKeyboardItemModel[] {
    return this.digitKeyboardListModel.slice();
  }

  clearLetterKeyboardList(): void {
    this.letterKeyboardListModel = [];
  }

  clearDigitKeyboardList(): void {
    this.digitKeyboardListModel = [];
  }
}
