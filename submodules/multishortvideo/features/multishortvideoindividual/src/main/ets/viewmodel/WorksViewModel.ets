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

import { WorksDataModel } from '../model/WorksDataModel';

export class WorksViewModel {
  private worksList: WorksDataModel[] = [];

  constructor() {
    this.worksList.push(new WorksDataModel(0, $r('app.media.cover0'), '1876'));
    this.worksList.push(new WorksDataModel(1, $r('app.media.cover1'), '1240'));
    this.worksList.push(new WorksDataModel(2, $r('app.media.cover2'), '343'));
    this.worksList.push(new WorksDataModel(3, $r('app.media.cover3'), '289'));
    this.worksList.push(new WorksDataModel(4, $r('app.media.cover4'), '5'));
  }

  getWorksList(): WorksDataModel[] {
    return this.worksList;
  }
}