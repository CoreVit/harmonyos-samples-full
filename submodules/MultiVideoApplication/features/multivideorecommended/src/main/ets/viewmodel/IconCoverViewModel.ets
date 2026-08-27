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

import { IconCoverListModel, IconCoverModel } from '../model/IconCoverModel';

@Observed
export class IconCoverViewModel {
  @Track private id: string = '0';
  // Label of the icon.
  @Track private name: ResourceStr = '';
  // Icon image resource.
  @Track private image: ResourceStr = '';

  updateCover(iconCoverModel: IconCoverModel): void {
    this.id = iconCoverModel.getId();
    this.name = iconCoverModel.getName();
    this.image = iconCoverModel.getImage();
  }

  getId(): string {
    return this.id;
  }

  getName(): ResourceStr {
    return this.name;
  }

  getImage(): ResourceStr {
    return this.image;
  }
}

@Observed
export class IconCoverArray extends Array<IconCoverViewModel> {
}

@Observed
export default class IconCoverListViewModel {
  @Track private covers: IconCoverArray = new IconCoverArray();

  loadIconCoverData(): void {
    this.clearIconCoverData();
    let iconCoverList = new IconCoverListModel([]);
    iconCoverList.loadIconCoverData();
    for (let cover of iconCoverList.getIconCoverListModel()) {
      let iconCoverViewModel = new IconCoverViewModel();
      iconCoverViewModel.updateCover(cover);
      this.covers.push(iconCoverViewModel);
    }
  }

  getCovers(): IconCoverArray {
    return this.covers.slice();
  }

  clearIconCoverData(): void {
    this.covers = new IconCoverArray();
  }
}
