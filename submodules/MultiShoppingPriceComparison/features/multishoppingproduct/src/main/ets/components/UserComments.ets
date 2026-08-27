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

import { ProductInfoState } from '../viewmodel/ProductInfoState';

@ComponentV2
export struct UserComments {
  @Param public widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @Param public state: ProductInfoState = new ProductInfoState(this.getUIContext().getHostContext()!);

  private isLargeWidth(): boolean {
    return this.widthBp === WidthBreakpoint.WIDTH_LG || this.widthBp === WidthBreakpoint.WIDTH_XL;
  }

  @Builder
  private commentsTag(tagText: string) {
    Row() {
      Text(tagText)
        .fontSize(12)
        .fontWeight(FontWeight.Normal)
    }
    .margin({ right: 8 })
    .padding({ left: 10, right: 10 })
    .borderRadius(12)
    .height(28)
    .backgroundColor($r('app.color.tag_background'))
  }

  @Builder
  private detailRightArrow(vis: Visibility) {
    Image($r('app.media.arrow_right'))
      .width(12)
      .height(12)
      .visibility(vis)
  }

  build() {
    Column() {
      Row() {
        Text(this.state.userCommentNames[0])
          .fontSize(16)
          .lineHeight(22)
          .fontWeight(FontWeight.Medium)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Blank()
        Text(this.state.userCommentNames[6])
          .fontSize(12)
          .lineHeight(18)
          .fontWeight(FontWeight.Normal)
          .opacity(0.55)
          .margin({ right: 8 })
          .visibility(this.isLargeWidth() ? Visibility.Visible : Visibility.None)
        this.detailRightArrow(this.isLargeWidth() ? Visibility.Visible : Visibility.None)
      }
      .height(28)
      .width('100%')
      .margin({ bottom: 12 })

      Scroll() {
        Row() {
          this.commentsTag(this.state.userCommentNames[1])
          this.commentsTag(this.state.userCommentNames[2])
          this.commentsTag(this.state.userCommentNames[3])
        }
      }
      .align(Alignment.Start)
      .width('100%')
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)

      Column() {
        Row() {
          Image($r('app.media.user_profile'))
            .width(48)
            .height(48)
            .margin({ right: 10 })
          Column() {
            Text(this.state.userCommentNames[4])
              .fontSize(13)
              .lineHeight(18)
              .fontWeight(FontWeight.Normal)
            Rating({ rating: 5, indicator: false })
              .stars(5)
              .stepSize(1)
              .height(14)
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .height('100%')
        }
        .height(48)
        .margin({ top: 8, bottom: 8 })

        Text(this.state.userCommentNames[5])
          .fontSize(13)
          .fontWeight(FontWeight.Normal)
          .lineHeight(20)
          .margin({ bottom: 8 })

        Image($r('app.media.shopping_card_1'))
          .width(240)
          .margin({ bottom: 8 })
          .borderColor('#E65486')
          .borderRadius(25)
          .borderWidth(1)

        Text(this.state.userCommentNames[7])
          .fontSize(10)
          .fontWeight(FontWeight.Normal)
          .lineHeight(20)
          .margin({ bottom: 8 })
      }
      .alignItems(HorizontalAlign.Start)
    }
    .backgroundColor($r('app.color.surface_primary'))
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .borderRadius(12)
    .padding(12)
  }
}
