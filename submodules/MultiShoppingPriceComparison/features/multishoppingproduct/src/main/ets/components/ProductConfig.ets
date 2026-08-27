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

import { WidthBreakpointType } from 'multishoppingbase';
import { ProductInfoState } from '../viewmodel/ProductInfoState';

@ComponentV2
export struct ProductConfig {
  @Param public widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @Param public state: ProductInfoState = new ProductInfoState(this.getUIContext().getHostContext()!);

  @Builder
  private configLine(text: string, marginRight: number = 0) {
    Text(text)
      .fontSize(12)
      .lineHeight(18)
      .fontWeight(FontWeight.Normal)
      .margin({ right: marginRight })
  }

  @Builder
  private detailRightArrow() {
    Image($r('app.media.arrow_right'))
      .width(12)
      .height(12)
  }

  build() {
    Column() {
      Column() {
        Row() {
          this.configLine(this.state.configNames[0], 12)
          Column() {
            Row() {
              this.configLine(this.state.configNames[1])
              Blank()
              this.detailRightArrow()
            }
            .width('100%')
            .margin({ bottom: 8 })

            List({ space: 12 }) {
              ForEach(this.state.colorImages, (item: Resource, index: number) => {
                ListItem() {
                  Image(item)
                    .width(48)
                    .height(48)
                }
              }, (item: Resource, index: number) => `color-${index}`)
            }
            .listDirection(Axis.Horizontal)
            .width('100%')
            .margin({ bottom: 8 })

            Divider()
              .width('100%')
              .strokeWidth(1)
              .color($r('app.color.divider_color'))
          }
          .layoutWeight(1)
        }
        .alignItems(VerticalAlign.Top)
        .margin({ bottom: 12 })

        Row() {
          Column() {
            this.configLine(this.state.configNames[2])
            this.configLine(this.state.configNames[3])
          }
          .width(24)
          .height(36)
          .alignItems(HorizontalAlign.Start)
          .margin({ right: 12 })

          Column() {
            Row() {
              List({ space: 12 }) {
                ForEach(this.state.recommendImages, (item: Resource, index: number) => {
                  ListItem() {
                    Image(item)
                      .width(48)
                      .height(48)
                  }
                }, (item: Resource, index: number) => `rec-${index}`)
              }
              .scrollBar(BarState.Off)
              .listDirection(Axis.Horizontal)
              .layoutWeight(1)
              .margin({ bottom: 8 })

              this.detailRightArrow()
            }
            .width('100%')

            Divider()
              .width('100%')
              .strokeWidth(1)
              .color($r('app.color.divider_color'))
          }
          .layoutWeight(1)
        }
        .alignItems(VerticalAlign.Top)
        .margin({ bottom: 12 })

        Row() {
          this.configLine(this.state.configNames[4], 12)
          this.configLine(this.state.configNames[5])
          Blank()
          this.detailRightArrow()
        }
        .width('100%')
        .margin({ bottom: 12 })
      }
      .width('100%')
      .padding({ left: 12, right: 12 })

      Scroll() {
        Row() {
          Image($r('app.media.ic_public_todo'))
            .width(10)
            .height(10)
            .borderRadius(2)
            .opacity(0.45)
            .margin({ right: 4 })
          Text(this.state.configNames[6])
            .opacity(0.55)
            .fontSize(8)
            .fontWeight(FontWeight.Normal)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ right: 12 })
          Image($r('app.media.ic_public_todo'))
            .width(10)
            .height(10)
            .borderRadius(2)
            .opacity(0.45)
            .margin({ right: 4 })
          Text(this.state.configNames[7])
            .opacity(0.55)
            .fontSize(8)
            .fontWeight(FontWeight.Normal)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)
        }
        .height('100%')
        .width('100%')
      }
      .align(Alignment.Start)
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Horizontal)
      .width('100%')
      .backgroundColor($r('app.color.surface_tertiary'))
      .height(32)
      .padding({ left: 12, right: 12 })
    }
    .alignItems(HorizontalAlign.Start)
    .backgroundColor($r('app.color.surface_primary'))
    .width('100%')
    .borderRadius(12)
    .padding({ top: 12 })
    .margin({
      bottom: new WidthBreakpointType(12, 16, 24, 24).getValue(this.widthBp)
    })
  }
}
