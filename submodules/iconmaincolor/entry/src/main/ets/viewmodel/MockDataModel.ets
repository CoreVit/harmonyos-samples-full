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
import { AppInfo } from './AppInfoModel';

interface AppConfig {
  icon: string;
  name: Resource;
  desc: Resource;
}

export default class MockDataModel {
  private arrayAppInfo: Array<AppInfo> = [];

  constructor() {
    const appConfigs: AppConfig[] = [
      {
        icon: 'ic_app_icon_cloud_space.png',
        name: $r('app.string.cloud_space'),
        desc: $r('app.string.cloud_space_description')
      },
      {
        icon: 'ic_app_icon_settings.png',
        name: $r('app.string.settings'),
        desc: $r('app.string.settings_description')
      },
      {
        icon: 'ic_app_icon_phone.png',
        name: $r('app.string.phone'),
        desc: $r('app.string.phone_description')
      },
      {
        icon: 'ic_app_icon_v_mall.png',
        name: $r('app.string.v_mall'),
        desc: $r('app.string.v_mall_description')
      }
    ];
    this.arrayAppInfo = appConfigs.map(config => new AppInfo(config.icon, config.name, config.desc));
  }

  public getArrayAppInfo(): Array<AppInfo> {
    return this.arrayAppInfo.slice();
  }
}