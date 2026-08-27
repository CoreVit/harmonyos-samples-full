/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { ResourceUtil } from '../common/utils/ResourceUtil';
import { TabDataModel } from '../model/TabDataModel';

const TAG: string = '[TabDataModel]';

export class TabViewModel {
  private tabMap: TabDataModel;
  private resources: Resource[] = [$r('app.string.selected'), $r('app.string.video'), $r('app.string.community'), $r('app.string.news')];

  constructor() {
    let tabMap: Map<string, Resource[]> = new Map();
    tabMap.set(ResourceUtil.getFormatString($r('app.string.tab_home')), this.resources);
    tabMap.set(ResourceUtil.getFormatString($r('app.string.tab_moments')), this.resources);
    tabMap.set(ResourceUtil.getFormatString($r('app.string.tab_shopping')), this.resources);
    tabMap.set(ResourceUtil.getFormatString($r('app.string.tab_me')), this.resources);
    this.tabMap = new TabDataModel(tabMap);
  }

  getTabMap(): TabDataModel {
    return this.tabMap;
  }

  getTabNameOfFirstLevel(index: number): string {
    if (this.tabMap?.getFirstList() && index >= 0 && index < this.tabMap.getFirstList().length) {
      return this.tabMap.getFirstList()[index];
    }
    return '';
  }

  getTabNameOfSecondLevel(firstTab: string, index: number): Resource | undefined {
    if (this.tabMap?.getSecondList(firstTab) && index >= 0 && index < this.tabMap.getSecondList(firstTab).length) {
      return this.tabMap.getSecondList(firstTab)[index];
    }
    return undefined;
  }
}