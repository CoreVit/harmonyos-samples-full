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

import { HashMap } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '@stock/base';
import { IAxisValueFormatter } from '@ohos/mpchart';

export class ChartAxisFormatter implements IAxisValueFormatter {
  private xAxis: HashMap<number, string> = new HashMap();

  constructor(xAxis: HashMap<number, string>) {
    this.xAxis = xAxis;
  }

  public getFormattedValue(value: number): string {
    try {
      return this.xAxis.get(value) ?? '';
    } catch (error) {
      Logger.error(`getFormattedValue failed: ${(error as BusinessError).message}`);
      return '';
    }
  }
}