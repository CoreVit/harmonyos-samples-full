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
import { add, follow, friends, message, mine, recommend } from '../components/Builders';

export class MainTabsViewModel {
  private mainTabsData: MSVDataModel[] = [];

  constructor() {
    this.mainTabsData.push(new MSVDataModel(recommend, $r('app.string.recommend_title')));
    this.mainTabsData.push(new MSVDataModel(follow, $r('app.string.follow_title')));
    this.mainTabsData.push(new MSVDataModel(friends, $r('app.string.friend_title')));
    this.mainTabsData.push(new MSVDataModel(add, $r('app.string.add_title')));
    this.mainTabsData.push(new MSVDataModel(message, $r('app.string.message_title')));
    this.mainTabsData.push(new MSVDataModel(mine, $r('app.string.mine_title')));
  }

  getMainTabsData(): MSVDataModel[] {
    return this.mainTabsData;
  }
}