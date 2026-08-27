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

import { Common } from 'multitravelbase/Index';
import { HomeConstants } from '../../constants/HomeConstants';
import { AttractionItem } from '../../model/data/AttractionItem';
import { HomeDisplayData } from '../../model/data/HomeDisplayData';

@Component
export struct ListView {
  build() {
    Column() {
      Row() {
        Text($r('app.string.discount_attraction'))
          .fontSize($r('app.float.attraction_text_size'))
          .fontColor($r('app.color.black'))
        SymbolGlyph($r('sys.symbol.xmark'))
          .fontSize($r('app.float.close_image_size'))
          .fontColor([$r('sys.color.font_primary')])
      }
      .width(Common.FULL_WIDTH)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: 16,
        right: 16,
        bottom: 4
      })

      List() {
        ForEach(HomeDisplayData.DISCOUNT_ATTRACTIONS, (item: AttractionItem) => {
          ListItem() {
            Column({ space: HomeConstants.LIST_ITEM_SPACE }) {
              Image(item.icon)
                .height($r('app.float.attraction_icon_height'))
                .width($r('app.float.attraction_icon_width'))
                .borderRadius($r('app.float.list_item_border_radius'))
              Text(item.name)
                .fontSize($r('app.float.attraction_text_size'))
                .fontColor($r('app.color.black'))
            }
            .padding({ right: 12 })
          }
        }, (item: AttractionItem) => JSON.stringify(item))
      }
      .width(Common.FULL_WIDTH)
      .scrollBar(BarState.Off)
      .height($r('app.float.list_height'))
      .padding({
        top: 8,
        left: 16,
        bottom: 17
      })
      .listDirection(Axis.Horizontal)

      Row() {
        Text($r('app.string.have_more'))
          .fontSize($r('app.float.tip_font_size'))
          .fontColor($r('app.color.have_more_color'))
          .padding({ right: 4 })
        SymbolGlyph($r('sys.symbol.chevron_forward'))
          .fontSize(12)
          .fontColor([$r('sys.color.font_secondary')])
      }
    }
    .hitTestBehavior(HitTestMode.None)
    .padding({
      top: 12,
      bottom: 8
    })
    .height(168)
    .margin({ top: 20, bottom: 72})
    .borderRadius($r('app.float.border_radius'))
    .shadow({
      radius: $r('app.float.shadow_radius'),
      color: $r('app.color.blur')
    })
  }
}
