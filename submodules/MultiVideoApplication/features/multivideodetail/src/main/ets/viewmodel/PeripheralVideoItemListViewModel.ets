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

import { DetailConstants } from '../constants/DetailConstants';
import RelatedVideoListModel, { RelatedVideoItemModel } from '../model/RelatedVideoItemModel';

@Observed
export class PeripheralVideoItemViewModel {
  @Track private id: string = '0';
  @Track private name: ResourceStr = '';
  @Track private imageSrc: ResourceStr = '';

  updateItem(peripheralVideoItemModel: RelatedVideoItemModel): void {
    this.id = peripheralVideoItemModel.getId();
    this.name = peripheralVideoItemModel.getName();
    this.imageSrc = peripheralVideoItemModel.getImageSrc();
  }

  getId(): string {
    return this.id;
  }

  getName(): ResourceStr {
    return this.name;
  }

  getImageSrc(): ResourceStr {
    return this.imageSrc;
  }
}

@Observed
export class PeripheralVideoItemArray extends Array<PeripheralVideoItemViewModel> {
}

@Observed
export default class PeripheralVideoItemListViewModel {
  @Track private items: PeripheralVideoItemArray = new PeripheralVideoItemArray();

  loadPeripheralVideoData(): void {
    this.clearPeripheralVideoData();
    let peripheralVideoList = new RelatedVideoListModel([]);
    peripheralVideoList.loadRelatedVideoData(DetailConstants.PERIPHERAL_VIDEO_TYPE);
    for (let item of peripheralVideoList.getRelatedVideoListModel()) {
      let peripheralVideoItemViewModel = new PeripheralVideoItemViewModel();
      peripheralVideoItemViewModel.updateItem(item);
      this.items.push(peripheralVideoItemViewModel);
    }
  }

  getItems(): PeripheralVideoItemArray {
    return this.items.slice();
  }

  clearPeripheralVideoData(): void {
    this.items = new PeripheralVideoItemArray();
  }
}
