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

import HomeFooterListModel, { HomeFooterItemModel } from '../model/HomeFooterItemModel';

@Observed
export class HomeFooterItemViewModel {
  @Track private id: string = '0';
  @Track private name: ResourceStr = '';
  @Track private icon: Resource = $r('sys.symbol.house_fill');

  updateItem(homeFooterItemModel: HomeFooterItemModel): void {
    this.id = homeFooterItemModel.getId();
    this.name = homeFooterItemModel.getName();
    this.icon = homeFooterItemModel.getIcon();
  }

  getId(): string {
    return this.id;
  }

  getName(): ResourceStr {
    return this.name;
  }

  getIcon(): Resource {
    return this.icon;
  }
}

@Observed
export class HomeFooterItemArray extends Array<HomeFooterItemViewModel> {
}

@Observed
export default class HomeFooterItemListViewModel {
  @Track private items: HomeFooterItemArray = new HomeFooterItemArray();

  loadHomeFooterData(): void {
    this.clearHomeFooterData();
    let homeFooterList = new HomeFooterListModel([]);
    homeFooterList.loadHomeFooterData();
    for (let item of homeFooterList.getHomeFooterListModel()) {
      let homeFooterItemViewModel = new HomeFooterItemViewModel();
      homeFooterItemViewModel.updateItem(item);
      this.items.push(homeFooterItemViewModel);
    }
  }

  getItems(): HomeFooterItemArray {
    return this.items.slice();
  }

  clearHomeFooterData(): void {
    this.items = new HomeFooterItemArray();
  }
}
