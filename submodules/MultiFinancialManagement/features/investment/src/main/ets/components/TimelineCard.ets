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

import { CommonConstants } from 'financialbase';
import { TimelineItem } from '../model/InvestmentModel';
import { InvestmentViewModel } from '../viewmodel/InvestmentViewModel';

@ComponentV2
export struct TimelineCard {
  @Param radius: number = 16;
  @Param @Require widthBreakpoint: WidthBreakpoint;
  private readonly viewModel: InvestmentViewModel = new InvestmentViewModel();

  build() {
    Column({ space: 12 }) {
      Column({ space: 12 }) {
        Grid() {
          ForEach(this.viewModel.getTimelineList(), (item: TimelineItem, index: number) => {
            GridItem() {
              Column({ space: 12 }) {
                Column() {
                  Text(item.date)
                    .fontSize(12)
                    .lineHeight(16)
                    .height(16)
                    .fontColor($r('app.color.font_secondary'))
                  Text(item.action)
                    .fontSize(12)
                    .lineHeight(16)
                    .fontColor($r('app.color.font_primary'))
                    .maxLines(this.widthBreakpoint === WidthBreakpoint.WIDTH_SM ? 2 : 1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .width('100%')
                .height(36)
                .alignItems(item.alignEnd ? HorizontalAlign.End : HorizontalAlign.Start)

                this.TimelineSegmentBar(item.barColor, item.showLeftBorder)
              }
              .width('100%')
            }
            .width('100%')
            .margin({ right: index < this.viewModel.getTimelineList().length - 2 ? 2 : 0 })
          }, (item: TimelineItem, index: number) => JSON.stringify(item) + index)
        }
        .columnsGap(0)
        .columnsTemplate('3fr 3fr 3fr 2fr')
        .width('100%')
        .constraintSize({ maxWidth: 816 })

        Row({ space: 4 }) {
          Row()
            .width(8)
            .height(8)
            .borderRadius('50%')
            .backgroundColor($r('app.color.brand_font'))
            .margin({ top: 6.5 })
          Text($r('app.string.financial_detail_timeline_tip'))
            .fontSize(16)
            .lineHeight(21)
            .fontColor($r('app.color.font_primary'))
        }
        .width('100%')
        .constraintSize({ maxWidth: 816 })
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Top)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .borderRadius(this.radius)
    .alignItems(HorizontalAlign.Start)
    .padding({
      top: 24,
      bottom: 24,
      left: CommonConstants.COMMON_PADDING[1].getValue(this.widthBreakpoint),
      right: CommonConstants.COMMON_PADDING[1].getValue(this.widthBreakpoint)
    })
    .backgroundColor($r('app.color.background_fourth'))
  }

  @Builder
  TimelineSegmentBar(bgColor: ResourceColor, showLeftBorder: boolean) {
    Stack() {
      Column() {
        Blank().height(30)
        Stack()
          .height(30)
          .width('100%')
          .backgroundColor(bgColor)
      }
      .width('100%')

      if (showLeftBorder) {
        Stack()
          .width(2)
          .height(60)
          .backgroundColor($r('app.color.container10'))
      }
    }
    .width('100%')
    .height(60)
    .alignContent(Alignment.TopStart)
  }
}
