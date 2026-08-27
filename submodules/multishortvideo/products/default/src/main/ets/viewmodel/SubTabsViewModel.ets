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

import { MSVDataModel } from 'multishortvideobase';
import { follow, live, mall, purchase, recommend } from '../components/Builders';

export class SubTabsViewModel {
  private subTabsData: MSVDataModel[] = [];

  constructor() {
    this.subTabsData.push(new MSVDataModel(purchase, $r('app.string.purchase_title')));
    this.subTabsData.push(new MSVDataModel(live, $r('app.string.live_title')));
    this.subTabsData.push(new MSVDataModel(follow, $r('app.string.follow_title')));
    this.subTabsData.push(new MSVDataModel(mall, $r('app.string.mall_title')));
    this.subTabsData.push(new MSVDataModel(recommend, $r('app.string.recommend_title')));
  }

  getSubTabsData(): MSVDataModel[] {
    return this.subTabsData;
  }
}