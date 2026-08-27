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
import { ShareIndex } from '@stock/base';

const SHARE_INDEX_DATA: ShareIndex[] = [
  new ShareIndex($r('app.string.certain_index'), '3088.10', '+19.8 +0.64%'),
  new ShareIndex($r('app.string.deep_number'), '3088.10', '+19.8 -0.64%'),
  new ShareIndex($r('app.string.science_technology'), '3088.10', '+19.8 +0.64%'),
  new ShareIndex($r('app.string.certain_index'), '3088.10', '+19.8 -0.64%'),
  new ShareIndex($r('app.string.deep_number'), '3088.10', '+19.8 +0.64%'),
];

export class StockMarketDataService {
  private shareIndexData: ShareIndex[] = SHARE_INDEX_DATA;

  getShareIndexData(): ShareIndex[] {
    return this.shareIndexData;
  }

  getShareIndexByIndex(index: number): ShareIndex | undefined {
    if (index >= 0 && index < this.shareIndexData.length) {
      return this.shareIndexData[index];
    }
    return undefined;
  }

  getShareIndexCount(): number {
    return this.shareIndexData.length;
  }
}