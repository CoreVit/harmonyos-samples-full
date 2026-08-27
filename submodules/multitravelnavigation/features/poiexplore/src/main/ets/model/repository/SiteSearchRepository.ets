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

import { mapCommon, site } from '@kit.MapKit';
import { i18n } from '@kit.LocalizationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { CommonConstants, Logger } from 'multitravelbase/Index';

const TAG = 'SiteSearchRepository';

export class SiteSearchRepository {
  public async searchByText(position: mapCommon.LatLng, text: string): Promise<site.SearchByTextResult | undefined> {
    let params: site.SearchByTextParams = {
      query: text,
      location: position,
      language: CommonConstants.languageMap.get(i18n.System.getSystemLanguage()),
      radius: 10000,
    };
    try {
      let result = await site.searchByText(params);
      Logger.info(TAG, `TextSearch success, site count=${result.sites?.length ?? 0}`);
      return result;
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `TextSearch fail, error code=${error.code}, message=${error.message}`);
      return undefined;
    }
  }
}
