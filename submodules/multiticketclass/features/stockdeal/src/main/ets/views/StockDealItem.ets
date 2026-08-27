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

@Builder
export function StockDetails(title: ResourceStr = '', price: string = '', amount: number = 0, index: number = 0,
  isShowNumber: boolean = true) {
  Row() {
    Text(title) {
      Span(title)
      if (isShowNumber) {
        Span(index.toString())
      }
    }
    .textType()
    .fontColor($r('app.color.font_secondary'))

    Text(price)
      .textType()
      .fontColor(index % 2 === 0 ? '#FA4337' : '#1DB775')
    Text(amount.toString())
      .textType()
      .fontColor($r('app.color.font_secondary'))
      .alignSelf(ItemAlign.End)
  }
  .width('100%')
  .justifyContent(FlexAlign.SpaceBetween)
}

@Extend(Text)
function textType() {
  .fontWeight(FontWeight.Regular)
  .fontSize(10)
  .lineHeight(14)
}
