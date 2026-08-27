/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import Logger from '../utils/Logger';
import ButtonUnitItem from './ButtonUnitItem';
import SampleUnitItem from './SampleUnitItem';

const TAG: string = '[DataSource]'

export class DataSource {
  public dataSource: BasicDataSource = new BasicDataSource();

  getData(): BasicDataSource {
    return this.dataSource;
  }
}

class BasicDataSource implements IDataSource {
  private imageArray1: Resource[] = [$r('app.media.picture2')];
  private imageArray3: Resource[] = [$r('app.media.picture3'), $r('app.media.picture4'), $r('app.media.picture5')];
  private imageArray4: Resource[] =
    [$r('app.media.picture1'), $r('app.media.picture2'), $r('app.media.picture3'), $r('app.media.picture4')];
  private imageArray8: Resource[] =
    [$r('app.media.picture1'), $r('app.media.picture2'), $r('app.media.picture3'), $r('app.media.picture4'),
      $r('app.media.picture5'), $r('app.media.picture6'), $r('app.media.picture7'), $r('app.media.picture8')];
  private imageArray9: Resource[] =
    [$r('app.media.picture1'), $r('app.media.picture2'), $r('app.media.picture3'), $r('app.media.picture4'),
      $r('app.media.picture5'), $r('app.media.picture6'), $r('app.media.picture7'), $r('app.media.picture8'),
      $r('app.media.picture9')];
  public data: SampleUnitItem[] = [];
  private listeners: DataChangeListener[] = [];

  constructor() {
    let buttonUnit: ButtonUnitItem =
      new ButtonUnitItem($r('sys.symbol.heart'), $r('sys.symbol.ellipsis_bubble'), $r('sys.symbol.star'),
        $r('sys.symbol.share'));
    this.data = [new SampleUnitItem('video', buttonUnit, this.imageArray1),
      new SampleUnitItem('pic', buttonUnit, this.imageArray3), new SampleUnitItem('pic', buttonUnit, this.imageArray4),
      new SampleUnitItem('pic', buttonUnit, this.imageArray8), new SampleUnitItem('pic', buttonUnit, this.imageArray9),
      new SampleUnitItem('pic', buttonUnit, this.imageArray3),
      new SampleUnitItem('video', buttonUnit, this.imageArray1),
      new SampleUnitItem('pic', buttonUnit, this.imageArray1), new SampleUnitItem('pic', buttonUnit, this.imageArray3)];
  }

  totalCount(): number {
    return this.data.length;
  }

  getData(index: number): SampleUnitItem {
    return this.data[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      Logger.info(TAG, 'add listener');
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      Logger.info(TAG, 'remove listener');
      this.listeners.splice(pos, 1);
    }
  }
}

export default new DataSource();