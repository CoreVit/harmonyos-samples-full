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

import { KEY_MAIN_WINDOW_INFO, WindowInfo, StockFormItem, BreakpointType, StockInForm } from '@stock/base';

@Component
export struct StockInFormList {
  @StorageLink(KEY_MAIN_WINDOW_INFO) mainWindowInfo: WindowInfo = new WindowInfo();
  public item?: StockInForm;
  public index: number = 0;
  private breakpointType = new BreakpointType(16, 16, 24, 32, 32)
  @Consume('isExpand') isExpand: boolean;

  build() {
    Row() {
      Column({ space: 3 }) {
        ForEach(this.item?.items, (stockItem: StockFormItem) => {
          this.stockItemBuilder(stockItem.title, stockItem.value, stockItem.color)
        }, (stockItem: StockFormItem, idx: number) => stockItem.title.toString() + idx)
      }
      .padding({
        right: this.breakpointType.getValue(this.mainWindowInfo.widthBp),
        left: this.breakpointType.getValue(this.mainWindowInfo.widthBp)
      })

      Divider()
        .vertical(true)
        .height('85%')
        .color($r('app.color.text_tertiary_color'))
        .visibility(this.getDividerVisibility())
    }
    .width('100%')
    .height(51)
    .margin({
      bottom: 6
    })
    .visibility(this.getItemVisibility())
  }

  @Builder
  private stockItemBuilder(title: string | Resource | undefined, value: string | Resource | undefined,
    color: ResourceColor | undefined) {
    Row() {
      Text(title)
        .textStocksTitle()
      Text(value)
        .fontColor(color)
        .textStocksValue()
    }
    .textStocksTitleValue()
  }

  private getDividerVisibility(): Visibility {
    const widthBp = this.mainWindowInfo.widthBp;
    const index = this.index;

    if (widthBp === WidthBreakpoint.WIDTH_SM) {
      return (index + 1) % 2 === 0 ? Visibility.Hidden : Visibility.Visible;
    }
    if (widthBp === WidthBreakpoint.WIDTH_MD) {
      return (index + 1) % 3 === 0 || index === 3 ? Visibility.Hidden : Visibility.Visible;
    }
    return (index + 1) % 4 === 0 ? Visibility.Hidden : Visibility.Visible;
  }

  private getItemVisibility(): Visibility {
    const widthBp = this.mainWindowInfo.widthBp;
    const index = this.index;
    const isExpand = this.isExpand;

    let threshold: number;
    if (widthBp === WidthBreakpoint.WIDTH_SM) {
      threshold = 2;
    } else if (widthBp === WidthBreakpoint.WIDTH_MD) {
      threshold = 3;
    } else {
      threshold = 4;
    }

    if (index + 1 > threshold) {
      return isExpand ? Visibility.Visible : Visibility.None;
    }
    return Visibility.Visible;
  }
}

@Extend(Text)
function textStocksTitle() {
  .fontSize(11)
  .fontColor($r('app.color.text_secondary_color'))
}

@Extend(Text)
function textStocksValue() {
  .fontSize(11)
  .fontWeight(FontWeight.Medium)
}

@Extend(Row)
function textStocksTitleValue() {
  .width('100%')
  .justifyContent(FlexAlign.SpaceBetween)
}
