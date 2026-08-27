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

import { LiveProduct } from '../model/LiveProduct';
import { LiveShopListModel } from '../model/LiveShopListModel';

/**
 * Migrated from detail/LiveShopList.ets (V2).
 * When not on SM breakpoints, clicking a product notifies the parent via
 * {@link onOpenProductDetail} to update the half-sheet state.
 */
@ComponentV2
export struct LiveShopList {
  @Param public isSideListLayout: boolean = false;
  @Param public widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @Event public onOpenProductDetail: () => void = () => {
  };

  private context: Context = this.getUIContext().getHostContext()!;
  private scroller: Scroller = new Scroller();
  @Local private currentProductIndex: number = 0;
  @Local private liveProductList: LiveProduct[] = [];

  aboutToAppear(): void {
    this.applyLayout();
  }

  private applyLayout(): void {
    const all = LiveShopListModel.buildProductList(this.context);
    if (this.isSideListLayout) {
      this.liveProductList = [...all].reverse();
      this.currentProductIndex = this.liveProductList.length - 1;
    } else {
      this.liveProductList = all;
      this.currentProductIndex = 0;
    }
    this.scroller.scrollToIndex(this.currentProductIndex);
  }

  private isOnlySmBreakpoint(): boolean {
    return this.widthBp === WidthBreakpoint.WIDTH_XS || this.widthBp === WidthBreakpoint.WIDTH_SM;
  }

  build() {
    List({
      space: this.isSideListLayout ? 12 : 10,
      initialIndex: this.currentProductIndex,
      scroller: this.scroller
    }) {
      ForEach(this.liveProductList, (item: LiveProduct, index: number) => {
        ListItem() {
          Row() {
            Image(item.getImage())
              .width(this.isSideListLayout ? 72 : 60)
              .aspectRatio(1)
              .borderRadius(8)
            Column() {
              Text(item.getName())
                .fontSize(14)
                .lineHeight(19)
                .fontWeight(FontWeight.Medium)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({
                  bottom: this.isSideListLayout ? 6 : 4
                })
              Text(item.getPrice())
                .fontSize(14)
                .lineHeight(19)
                .fontWeight(FontWeight.Medium)
                .fontColor('#CF0A2C')
            }
            .alignItems(HorizontalAlign.Start)
            .visibility(index === this.currentProductIndex ? Visibility.Visible : Visibility.None)
            .padding({
              top: this.isSideListLayout ? 12 : 8,
              bottom: this.isSideListLayout ? 16 : 10,
              left: this.isSideListLayout ? 8 : 0
            })
            .layoutWeight(1)
            .height('100%')
          }
          .borderRadius(8)
          .backgroundColor($r('app.color.surface_primary'))
          .width(index === this.currentProductIndex ?
            (this.isSideListLayout ? 216 : 180) :
            (this.isSideListLayout ? 72 : 60))
          .height(this.isSideListLayout ? 72 : 60)
          .onClick(() => {
            if (!this.isOnlySmBreakpoint()) {
              this.onOpenProductDetail();
            }
          })
        }
      }, (item: LiveProduct, index: number) => `${index}-${item.getName()}`)
    }
    .edgeEffect(EdgeEffect.Fade)
    .alignListItem(this.isSideListLayout ? ListItemAlign.End : ListItemAlign.Start)
    .scrollBar(BarState.Off)
    .height(this.isSideListLayout ? 'auto' : 60)
    .width(this.isSideListLayout ? 216 : '100%')
    .listDirection(this.isSideListLayout ? Axis.Vertical : Axis.Horizontal)
  }
}
