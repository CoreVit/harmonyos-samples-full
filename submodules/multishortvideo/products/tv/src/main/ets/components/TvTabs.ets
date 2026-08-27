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
import { CommonConstants } from 'multishortvideobase';

@ComponentV2
export struct TVTabs {
  @Consumer('currentBottomIndex') currentBottomIndex: number = 2;
  @Local iconList: Array<Resource> = [$r('sys.symbol.person_fill'), $r('sys.symbol.magnifyingglass')];
  @Local btnList: Array<Resource> =
    [$r('app.string.recommend_title'), $r('app.string.follow_title'), $r('app.string.friend_title'),
      $r('app.string.add_title'), $r('app.string.message_title'), $r('app.string.mine_title')];

  build() {
    Row({ space: 20 }) {
      List({ space: 10 }) {
        Repeat<Resource>(this.iconList)
          .each((item: RepeatItem<Resource>) => {
            ListItem() {
              Row() {
                SymbolGlyph(item.item)
                  .fontSize(24)
                  .fontColor(['#BFC4C7'])
              }
              .backgroundColor(Color.Transparent)
              .width(40)
              .height(CommonConstants.FULL_PERCENT)
              .border({
                width: 0,
                radius: 20
              })
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Center)
            }

          })
          .key((item: Resource) => JSON.stringify(item))
      }
      .listDirection(Axis.Horizontal)
      .height('40vp')
      .width('auto')

      List() {
        Repeat<Resource>(this.btnList)
          .each((item: RepeatItem<Resource>) => {
            ListItem() {
              Row() {
                Text(item.item)
                  .fontSize(20)
                  .fontWeight($r('sys.float.font_weight_medium'))
                  .fontColor(this.currentBottomIndex === item.index + this.iconList.length ? $r('sys.color.font_on_primary') :
                    $r('sys.color.font_on_secondary'))
              }
              .backgroundColor(
                this.currentBottomIndex === item.index + this.iconList.length ? $r('app.color.tv_tab_bg') :
                  Color.Transparent)
              .width('78vp')
              .height('100%')
              .border({
                width: 0,
                radius: 25
              })
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .onClick(() => {
                this.currentBottomIndex = item.index + this.iconList.length;
              })
            }
          })
          .key((item: Resource) => JSON.stringify(item))
      }
      .listDirection(Axis.Horizontal)
      .height('48vp')
      .width('auto')
    }
    .backgroundColor($r('app.color.tv_header_bg'))
    .borderRadius(50)
    .height('64vp')
    .padding({
      left: '12vp',
      right: '18vp'
    })
    .margin({ top: '20vp' })
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}