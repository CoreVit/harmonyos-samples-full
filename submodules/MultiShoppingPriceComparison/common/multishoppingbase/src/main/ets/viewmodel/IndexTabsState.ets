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
import { IndexTabItemModel } from '../model/IndexTabItemModel';
import { getDefaultTabItems } from '../model/IndexTabsModel';

@ObservedV2
export class IndexTabsState {
  public items: IndexTabItemModel[] = getDefaultTabItems();
  @Trace public selectedIndex: number = 0;

  public selectTab(index: number): void {
    if (index < 0 || index >= this.items.length || index === this.selectedIndex) {
      return;
    }
    this.selectedIndex = index;
  }
}

