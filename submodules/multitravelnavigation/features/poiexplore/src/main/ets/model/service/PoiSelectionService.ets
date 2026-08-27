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

import { site } from '@kit.MapKit';
import { SelectedSite } from 'multitravelbase/Index';

export class PoiSelectionService {
  public toSelectedSite(item: site.Site): SelectedSite {
    let abstractText: string = item.poi?.abstractText ?? '';
    return new SelectedSite(item.name, this.getSiteAddress(item), this.getSiteDistance(item), item.location,
      this.getOpeningHours(item), abstractText);
  }

  public getOpeningHours(item: site.Site): string {
    if (!item.poi?.openingHours?.texts || item.poi.openingHours.texts.length === 0) {
      return '';
    }
    return item.poi.openingHours.texts[0].split(': ')[1] ?? item.poi.openingHours.texts[0];
  }

  public getSiteAddress(item: site.Site): string {
    return item.addressComponent?.adminLevel3 ?? '';
  }

  public getSiteDistance(item: site.Site): number {
    return item.distance ?? 0;
  }
}
