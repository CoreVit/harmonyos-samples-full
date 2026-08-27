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
export struct ProductDiscount {
  @Param public widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @Param public state: ProductInfoState = new ProductInfoState(this.getUIContext().getHostContext()!);

  @Builder
  private detailRightArrow() {
    Image($r('app.media.arrow_right'))
      .width(12)
      .height(12)
  }

  build() {
    Column() {
      Text(this.state.discountNames[0])
        .fontSize(16)
        .lineHeight(22)
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 8 })
      Text(this.state.discountNames[1])
        .fontSize(12)
        .fontColor('#CF0A2C')
        .lineHeight(18)
        .fontWeight(FontWeight.Normal)
        .margin({ bottom: 8 })
      Row() {
        Text(this.state.discountNames[2])
          .fontSize(12)
          .fontColor('#CF0A2C')
          .fontWeight(FontWeight.Normal)
          .margin({ right: 8 })
        Text(this.state.discountNames[3])
          .layoutWeight(1)
          .fontSize(12)
          .fontWeight(FontWeight.Normal)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Blank()
        this.detailRightArrow()
      }
      .padding({ left: 12, right: 12, top:4, bottom:4})
      .borderRadius(20)
      .backgroundColor('#1ACF0A2C')
      .width('100%')
    }
    .alignItems(HorizontalAlign.Start)
    .backgroundColor($r('app.color.surface_secondary'))
    .width('100%')
    .borderRadius(12)
    .padding(12)
    .margin({
      bottom: new WidthBreakpointType(12, 14, 16, 16).getValue(this.widthBp)
    })
  }
}
