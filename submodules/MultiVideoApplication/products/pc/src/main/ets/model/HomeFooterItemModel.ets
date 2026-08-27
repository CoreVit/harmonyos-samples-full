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

export class HomeFooterItemModel {
  private id: string = '0';
  private name: Resource;
  private icon: Resource;

  constructor(id: string, name: Resource, icon: Resource) {
    this.id = id;
    this.name = name;
    this.icon = icon;
  }

  getId(): string {
    return this.id;
  }

  getName(): Resource {
    return this.name;
  }

  getIcon(): Resource {
    return this.icon;
  }
}

export default class HomeFooterListModel {
  private homeFooterListModel: HomeFooterItemModel[] = [];

  constructor(homeFooterListModel: HomeFooterItemModel[]) {
    this.homeFooterListModel = homeFooterListModel;
  }

  loadHomeFooterData(): void {
    this.homeFooterListModel.push(new HomeFooterItemModel('0', $r('app.string.tab_home'), $r('sys.symbol.house_fill')));
    this.homeFooterListModel.push(new HomeFooterItemModel('1', $r('app.string.tab_development'),
      $r('sys.symbol.discover_fill')));
    this.homeFooterListModel.push(new HomeFooterItemModel('2', $r('app.string.tab_member'),
      $r('sys.symbol.heart_square_stack_fill')));
    this.homeFooterListModel.push(new HomeFooterItemModel('3', $r('app.string.tab_mine'),
      $r('sys.symbol.person_crop_circle_fill_1')));
  }

  getHomeFooterListModel(): HomeFooterItemModel[] {
    return this.homeFooterListModel.slice();
  }

  clearHomeFooterList(): void {
    this.homeFooterListModel = [];
  }
}
