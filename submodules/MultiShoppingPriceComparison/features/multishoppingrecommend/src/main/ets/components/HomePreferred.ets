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
import { uiObserver } from '@kit.ArkUI';
import { WidthBreakpointType } from 'multishoppingbase';
import { HomePreferredItem } from '../model/HomePreferredModel';
import { HomePreferredState } from '../viewmodel/HomePreferredState';

@ComponentV2
export struct HomePreferred {
  private context: Context = this.getUIContext().getHostContext()!;
  @Env(SystemProperties.BREAK_POINT) private breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Local private state: HomePreferredState = new HomePreferredState(this.context);

  build() {
    Column() {
      Row() {
        Text(this.state.title)
          .fontSize(16)
          .lineHeight(22)
          .fontWeight(FontWeight.Medium)
        Blank()
        Text($r('app.string.BUTTON_TEXTS2'))
          .fontSize(12)
          .lineHeight(16)
          .fontColor($r('app.color.text_secondary'))
        SymbolGlyph($r('sys.symbol.chevron_right'))
          .fontSize(24)
          .fontColor([$r('app.color.text_secondary')])
          .margin({
            left:2
          })
      }
      .padding({ top: 12, bottom: 12, left: 12, right: 12 })
      .width('100%')

      GridRow({
        columns: {
          xs: 4,
          sm: 4,
          md: 12,
          lg: 15,
          xl: 15
        },
        gutter: (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
          this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? 10 :
          new WidthBreakpointType(10, 12, 8, 8).getValue(this.breakpoint.widthBreakpoint)
      }) {
        ForEach((this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
          this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? this.state.items.slice(0, 2) :
          this.state.items.slice(0, new WidthBreakpointType(2, 3, this.state.items.length, this.state.items.length)
            .getValue(this.breakpoint.widthBreakpoint)), (item: HomePreferredItem, index: number) => {
          GridCol({
            span: {
              xs: 2,
              sm: 2,
              md: 4,
              lg: 3,
              xl: 3
            }
          }) {
            Column() {
              Stack() {
                Image(item.image)
                  .objectFit(ImageFit.Contain)
                  .aspectRatio(1.29)
                  .width('100%')
                  .height('100%')

                if (item.isLive) {
                  Image($r('app.media.icon_is_living'))
                    .width(24)
                    .height(24)
                    .margin({ top: 8, right: 8 })
                }
              }
              .alignContent(Alignment.TopEnd)
              .width('100%')
              .margin({
                bottom: (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
                  this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? 12 :
                  new WidthBreakpointType(12, 8, 8, 8).getValue(this.breakpoint.widthBreakpoint)
              })

              Text(item.title)
                .fontSize(14)
                .lineHeight(19)
                .fontWeight(FontWeight.Medium)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })

              Text(item.info)
                .fontSize(12)
                .lineHeight(16)
                .fontColor($r('app.color.text_secondary'))
                .margin({ top: 2 })
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })

              Text(item.feature)
                .fontSize(9)
                .lineHeight(12)
                .fontColor('#D0092D')
                .padding({ left: 4, right: 4, top: 2, bottom: 2 })
                .borderRadius(4)
                .border({ width: 1, color: '#66D0092D' })
                .margin({ top: 6 })
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })

              Text(item.price)
                .fontSize(14)
                .lineHeight(19)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 10 })

              Text(item.comments)
                .fontSize(10)
                .lineHeight(14)
                .fontColor($r('app.color.text_secondary'))
                .margin({ top: 6, bottom: 12 })
            }
            .width('100%')
          }
          .width('100%')
        }, (_item: HomePreferredItem, index: number) => `preferred-${index}`)
      }
      .width('100%')
      .padding({ left: 12, right: 12 })
    }
    .width('100%')
    .borderRadius(12)
    .backgroundColor($r('app.color.surface_primary'))
    .margin({
      top: new WidthBreakpointType(16, 12, 16, 16).getValue(this.breakpoint.widthBreakpoint)
    })
  }
}