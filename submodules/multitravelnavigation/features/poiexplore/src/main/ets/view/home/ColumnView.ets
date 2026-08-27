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
import { PanelMode, PanelType } from 'multitravelbase/Index';

@Component
export struct ColumnView {
  @Prop panelMode: PanelMode = PanelMode.Half;
  @Prop panelType: PanelType = PanelType.Normal;

  build() {
    Column() {
      Column() {
        Row() {
          Text($r('app.string.frequent_locations'))
            .fontSize($r('app.float.add_font_size'))
            .fontColor($r('app.color.black'))

          Row() {
            Text($r('app.string.all'))
              .fontSize($r('app.float.tip_font_size'))
              .padding({ right: 4 })
            SymbolGlyph($r('sys.symbol.chevron_forward'))
              .fontSize(12)
              .fontColor([$r('sys.color.font_primary')])
          }
        }
        .width(Common.FULL_WIDTH)
        .padding({
          left: 16,
          right: 16
        })
        .justifyContent(FlexAlign.SpaceBetween)
        .visibility(this.panelMode !== PanelMode.High ? Visibility.None : Visibility.Visible)
        .layoutWeight(1)

        Row() {
          Row() {
            SymbolGlyph($r('sys.symbol.house'))
              .fontSize(16)
              .fontColor([$r('sys.color.font_secondary')])
            Text($r('app.string.add_home'))
              .fontSize($r('app.float.add_font_size'))
              .fontColor($r('app.color.font_add_color'))
              .padding({ left: 8 })
          }

          Row() {
            SymbolGlyph($r('sys.symbol.company'))
              .fontSize(16)
              .fontColor([$r('sys.color.font_secondary')])
            Text($r('app.string.add_comp'))
              .fontSize($r('app.float.add_font_size'))
              .fontColor($r('app.color.font_add_color'))
              .padding({ left: 8 })
          }
        }
        .width(Common.FULL_WIDTH)
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({
          left: 16,
          right: 16
        })
        .layoutWeight(1)

        Row() {
          SymbolGlyph($r('sys.symbol.local_badge_plus'))
            .fontSize(16)
            .fontColor([$r('sys.color.font_secondary')])
          Text($r('app.string.add_address'))
            .fontSize($r('app.float.add_font_size'))
            .fontColor($r('app.color.font_add_color'))
            .padding({ left: 8 })
        }
        .padding({ left: 16 })
        .width(Common.FULL_WIDTH)
      }
      .height(this.panelMode !== PanelMode.High ?
        $r('app.float.column_height_part') : $r('app.float.column_height_full'))
      .padding({ bottom: 17 })
      .margin({ top: 12 })
      .borderRadius($r('app.float.border_radius'))
      .shadow({
        radius: $r('app.float.shadow_radius'),
        color: $r('app.color.blur')
      })

      Column() {
        Row() {
          Text($r('app.string.recommend_location'))
            .fontSize($r('app.float.tip_font_size'))
            .fontColor($r('app.color.font_recommend_color'))
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

        Row() {
          Column() {
            Row() {
              Text($r('app.string.recommend'))
                .padding({ right: 4 })
                .fontSize($r('app.float.large_font_size'))
                .fontColor($r('app.color.black'))
              SymbolGlyph($r('sys.symbol.chevron_forward'))
                .fontSize(16)
                .fontColor([$r('sys.color.font_primary')])
            }
            .padding({ bottom: 4 })

            Text($r('app.string.direction_desc'))
              .fontColor($r('app.color.font_add_color'))
              .fontSize($r('app.float.tip_font_size'))
          }
          .alignItems(HorizontalAlign.Start)
          .width(HomeConstants.TEXT_WIDTH)

          Button($r('app.string.goto'))
            .height($r('app.float.button_height'))
            .width($r('app.float.button_width'))
        }
        .padding({
          left: 16,
          right: 16
        })
        .justifyContent(FlexAlign.SpaceBetween)
        .width(Common.FULL_WIDTH)
      }
      .padding({
        top: 12,
        bottom:12
      })
      .margin({
        top: 20,
      })
      .borderRadius($r('app.float.border_radius'))
      .shadow({
        radius: $r('app.float.shadow_radius'),
        color: $r('app.color.blur')
      })
    }
  }
}
