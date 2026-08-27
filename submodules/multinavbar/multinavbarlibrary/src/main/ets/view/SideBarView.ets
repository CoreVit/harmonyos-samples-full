/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { Constants } from '../common/Constants';
import { TabDataModel } from '../model/TabDataModel';

@Component
export struct SideBarView {
  @Link firstLevelIndex: number;
  @Link secondLevelIndex: number;
  @Link tabData: TabDataModel;
  @State isShow: boolean = true;

  build() {
    Column() {
      Row({ space: Constants.SPACE_8 }) {
        Image($r('app.media.startIcon'))
          .height($r('app.float.size_24'))
        Text($r('app.string.project_name'))
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
      }
      .padding({ left: $r('sys.float.padding_level4') })
      .height($r('app.float.size_56'))

      Column({ space: Constants.SPACE_2 }) {
        ForEach(this.tabData.getFirstList(), (item: string, index: number) => {
          Column() {
            Row() {
              Row({ space: Constants.SPACE_8 }) {
                SymbolGlyph($r('sys.symbol.person_crop_circle_fill_1'))
                  .fontSize($r('sys.float.Title_M'))
                  .fontColor(index === this.firstLevelIndex ? [$r('sys.color.font_emphasize')] :
                    [$r('sys.color.font_secondary')])
                Text(item)
                  .fontSize($r('sys.float.Body_L'))
                  .fontWeight(index === this.firstLevelIndex ? FontWeight.Bold : FontWeight.Medium)
              }

              if (this.tabData.getSecondList(item).length > 0) {
                SymbolGlyph((index === this.firstLevelIndex && this.isShow) ? $r('sys.symbol.chevron_up') :
                  $r('sys.symbol.chevron_down'))
                  .fontSize($r('sys.float.Title_S'))
                  .fontColor([$r('sys.color.font_primary')])
              }
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
            .height($r('app.float.size_40'))
            .padding({
              left: $r('sys.float.padding_level2')
            })

            Column({ space: Constants.SPACE_2 }) {
              ForEach(this.tabData.getSecondList(item), (item: string, index: number) => {
                Row() {
                  Text(item)
                    .fontSize($r('sys.float.Body_L'))
                    .fontWeight(index === this.secondLevelIndex ? FontWeight.Bold : FontWeight.Medium)
                    .margin({ left: $r('app.float.size_40') })
                }
                .width('100%')
                .height($r('app.float.size_40'))
                .borderRadius($r('sys.float.corner_radius_level4'))
                .backgroundColor(index === this.secondLevelIndex ? $r('app.color.tab_bar_color_selected') :
                  $r('app.color.tab_bar_color_normal'))
                .onClick(() => {
                  this.secondLevelIndex = index;
                })
              }, (item: string, index: number) => index + item)
            }
            .visibility((index === this.firstLevelIndex && this.isShow) ? Visibility.Visible : Visibility.None)
          }
          .alignItems(HorizontalAlign.Start)
          .onClick(() => {
            if (this.firstLevelIndex === index) {
              this.isShow = !this.isShow;
            }
            this.firstLevelIndex = index;
          })
        }, (item: string, index: number) => index + item)
      }
      .alignItems(HorizontalAlign.Start)
    }
    .alignItems(HorizontalAlign.Start)
    .backgroundColor($r('app.color.side_bar_backgroundColor'))
    .padding({
      left: $r('sys.float.padding_level8'),
      right: $r('sys.float.padding_level8')
    })
    .height('100%')
    .width('100%')
  }
}