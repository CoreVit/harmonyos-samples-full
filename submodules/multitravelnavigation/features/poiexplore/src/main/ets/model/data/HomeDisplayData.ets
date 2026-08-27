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

import { BusinessError } from '@kit.BasicServicesKit';
import { ColumnTab, FunctionType, Logger } from 'multitravelbase/Index';
import { AttractionItem } from './AttractionItem';

const TAG = 'HomeDisplayData';

export class HomeDisplayData {
  public static readonly FUNCTIONS: FunctionType[] = [
    {
      id: 1,
      icon: $r('app.media.icon_drive'),
      desc: $r('app.string.drive')
    },
    {
      id: 2,
      icon: $r('app.media.icon_Metro'),
      desc: $r('app.string.metro')
    },
    {
      id: 3,
      icon: $r('app.media.icon_taxi'),
      desc: $r('app.string.taxi')
    },
    {
      id: 4,
      icon: $r('app.media.icon_bus'),
      desc: $r('app.string.bus')
    },
    {
      id: 5,
      icon: $r('app.media.icon_hotel'),
      desc: $r('app.string.hotel')
    },
    {
      id: 6,
      icon: $r('app.media.icon_Attractions'),
      desc: $r('app.string.attractions')
    },
    {
      id: 7,
      icon: $r('app.media.icon_buy'),
      desc: $r('app.string.buy')
    },
    {
      id: 8,
      icon: $r('app.media.icon_download'),
      desc: $r('app.string.download')
    },
    {
      id: 9,
      icon: $r('app.media.icon_drive2'),
      desc: $r('app.string.drive2')
    },
    {
      id: 10,
      icon: $r('app.media.icon_more'),
      desc: $r('app.string.more')
    }
  ];

  public static readonly DISCOUNT_ATTRACTIONS: AttractionItem[] = [
    {
      id: 1,
      icon: $r('app.media.attraction1'),
      name: $r('app.string.attraction1')
    },
    {
      id: 2,
      icon: $r('app.media.attraction2'),
      name: $r('app.string.attraction2')
    },
    {
      id: 3,
      icon: $r('app.media.attraction3'),
      name: $r('app.string.attraction3')
    },
    {
      id: 4,
      icon: $r('app.media.attraction4'),
      name: $r('app.string.attraction4')
    },
    {
      id: 5,
      icon: $r('app.media.attraction1'),
      name: $r('app.string.attraction1')
    },
    {
      id: 6,
      icon: $r('app.media.attraction2'),
      name: $r('app.string.attraction2')
    },
  ];

  private static readonly FOOTER_TOPIC_ICON_RESOURCES: Resource[] = [
    $r('sys.symbol.location_north_up_right_fill'),
    $r('sys.symbol.local_and_rectangle_fill'),
    $r('sys.symbol.car_fill'),
    $r('sys.symbol.person_crop_circle_fill_1')
  ];

  public static createFooterTabs(context: Context): ColumnTab[] {
    return [
      HomeDisplayData.createFooterTab(context, $r('app.string.tab_home').id, 0),
      HomeDisplayData.createFooterTab(context, $r('app.string.tab_locate').id, 1),
      HomeDisplayData.createFooterTab(context, $r('app.string.tab_taxi').id, 2),
      HomeDisplayData.createFooterTab(context, $r('app.string.tab_my').id, 3)
    ];
  }

  private static createFooterTab(context: Context, labelId: number, iconIndex: number): ColumnTab {
    return {
      name: HomeDisplayData.getString(context, labelId),
      icon: HomeDisplayData.FOOTER_TOPIC_ICON_RESOURCES[iconIndex]
    };
  }

  private static getString(context: Context, id: number): string {
    try {
      return context.resourceManager.getStringSync(id);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getStringSync failed, error code=${err.code}, message=${err.message}`);
      return '';
    }
  }
}
