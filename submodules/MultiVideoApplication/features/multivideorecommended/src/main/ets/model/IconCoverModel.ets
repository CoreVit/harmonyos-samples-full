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

import { MainPageConstants } from '../constants/MainPageConstants';

export class IconCoverModel {
  private id: string = '0';
  // Label of the icon.
  private name: ResourceStr;
  // Icon image resource.
  private image: Resource;

  constructor(id: string, name: ResourceStr, image: Resource) {
    this.id = id;
    this.name = name;
    this.image = image;
  }

  getId(): string {
    return this.id;
  }

  getName(): ResourceStr {
    return this.name;
  }

  getImage(): Resource {
    return this.image;
  }
}

export class IconCoverListModel {
  private iconCoverListModel: IconCoverModel[] = [];

  constructor(iconCoverListModel: IconCoverModel[]) {
    this.iconCoverListModel = iconCoverListModel;
  }

  loadIconCoverData(): void {
    this.clearIconCoverList();
    if (MainPageConstants.ICON_LIST.length >= 9) {
      this.iconCoverListModel.push(new IconCoverModel('0', MainPageConstants.ICON_LIST[0], $r('app.media.icon_all')));
      this.iconCoverListModel.push(new IconCoverModel('1', MainPageConstants.ICON_LIST[1], $r('app.media.icon_weekly_hot')));
      this.iconCoverListModel.push(new IconCoverModel('2', MainPageConstants.ICON_LIST[2], $r('app.media.icon_free')));
      this.iconCoverListModel.push(new IconCoverModel('3', MainPageConstants.ICON_LIST[3], $r('app.media.icon_classic')));
      this.iconCoverListModel.push(new IconCoverModel('4', MainPageConstants.ICON_LIST[4], $r('app.media.icon_vip')));
      this.iconCoverListModel.push(new IconCoverModel('5', MainPageConstants.ICON_LIST[5], $r('app.media.icon_kid')));
      this.iconCoverListModel.push(new IconCoverModel('6', MainPageConstants.ICON_LIST[6], $r('app.media.icon_live')));
      this.iconCoverListModel.push(new IconCoverModel('7', MainPageConstants.ICON_LIST[7], $r('app.media.icon_fitness')));
      this.iconCoverListModel.push(new IconCoverModel('8', MainPageConstants.ICON_LIST[8], $r('app.media.icon_classes')));
    }
  }

  getIconCoverListModel(): IconCoverModel[] {
    return this.iconCoverListModel.slice();
  }

  clearIconCoverList(): void {
    this.iconCoverListModel = [];
  }
}
