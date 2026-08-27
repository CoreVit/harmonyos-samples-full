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
import { works, privacy, collection, like } from '../components/Builders';

export class IndividualTabsViewModel {
  private individualTabsData: MSVDataModel[] = [];

  constructor() {
    this.individualTabsData.push(new MSVDataModel(works, $r('app.string.ind_work')));
    this.individualTabsData.push(new MSVDataModel(privacy, $r('app.string.ind_private')));
    this.individualTabsData.push(new MSVDataModel(collection, $r('app.string.ind_collection')));
    this.individualTabsData.push(new MSVDataModel(like, $r('app.string.ind_like')));
  }

  getIndividualTabsData(): MSVDataModel[] {
    return this.individualTabsData;
  }
}