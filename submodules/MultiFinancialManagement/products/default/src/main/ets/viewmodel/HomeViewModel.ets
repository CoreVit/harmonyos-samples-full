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

import { HomeModel, Menu } from '../model/HomeModel';

@ObservedV2
export class HomeViewModel {
  private model: HomeModel = new HomeModel();

  mainBusinessList(): Menu[] {
    return this.model.getBusinessList().filter(item => item.isMain);
  }

  displayList(columnCount: number): Menu[] {
    const totalSlots = columnCount * 2;
    const secondaryList = this.model.getBusinessList().filter(item => !item.isMain);
    if (secondaryList.length === 0) {
      return [];
    }
    const moreItem = secondaryList[secondaryList.length - 1];
    const otherItems = secondaryList.slice(0, secondaryList.length - 1);
    const displayItems = otherItems.slice(0, totalSlots - 1);
    displayItems.push(moreItem);
    return displayItems;
  }
}