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
 *
 */

import { AvDataSourceModel } from '../model/AvDataSourceModel';

export class AvDataSourceViewModel {
  private avDataSource: AvDataSourceModel[] = [];

  constructor() {
    this.avDataSource.push(new AvDataSourceModel('1_1.mp4'));
    this.avDataSource.push(new AvDataSourceModel('3_4.mp4'));
    this.avDataSource.push(new AvDataSourceModel('4_3.mp4'));
    this.avDataSource.push(new AvDataSourceModel('9_16.mp4'));
    this.avDataSource.push(new AvDataSourceModel('16_9.mp4'));
  }

  getAvDataSource(): AvDataSourceModel[] {
    return this.avDataSource;
  }
}