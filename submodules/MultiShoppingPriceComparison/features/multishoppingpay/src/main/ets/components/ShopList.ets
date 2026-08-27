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

import { ShopBagProduct, ShopBagViewModel } from '../viewmodel/ShopBagViewModel';

@ComponentV2
export struct ShopList {
  @Param public widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @Builder payCardBuilder() {
  }
  @BuilderParam public payCardButton: () => void = this.payCardBuilder;
  @Local private products: ShopBagProduct[] = [];
  @Local private preferentialTitle: string = '';
  @Local private currencyPrefix: string = '';

  aboutToAppear(): void {
    const ctx = this.getUIContext().getHostContext();
    if (ctx !== undefined) {
      const vm = new ShopBagViewModel();
      this.products = vm.getProducts(ctx);
      this.preferentialTitle = vm.getPreferentialTitle(ctx);
      this.currencyPrefix = vm.getCurrencyPrefix(ctx);
    }
  }

  private isWidthLg(): boolean {
    return this.widthBp === WidthBreakpoint.WIDTH_LG || this.widthBp === WidthBreakpoint.WIDTH_XL;
  }

  build() {
    Column() {
      Row() {
        Text(this.preferentialTitle)
          .fontColor($r('sys.color.font_on_primary'))
          .fontSize(12)
          .lineHeight(16)
          .fontWeight(FontWeight.Medium)
      }
      .alignSelf(ItemAlign.Start)
      .backgroundColor('#CF0A2C')
      .height(28)
      .borderRadius(14)
      .padding({ left: 8, right: 8 })
      .margin({ bottom: this.isWidthLg() ? 16 : 12 })

      ForEach(this.products, (item: ShopBagProduct, index: number) => {
        Row() {
          Image(item.getImage())
            .width(this.isWidthLg() ? 124 : 134)
            .height(this.isWidthLg() ? 124 : 134)
          Column() {
            Text(item.getName())
              .fontWeight(FontWeight.Medium)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontSize(12)
              .margin({ bottom: 4 })
            Text(item.getRemark())
              .fontSize(9)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontColor($r('app.color.text_secondary_pay'))
              .margin({ bottom: 5 })
            Row() {
              ForEach(item.getDiscounts(), (discount: string, discountIndex: number) => {
                Text(discount)
                  .fontWeight(FontWeight.Regular)
                  .fontColor('#E84026')
                  .fontSize(9)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .padding({ top: 2, bottom: 2, left: 4, right: 4 })
                  .border({ radius: 4, color: '#FFD4CC', width: 0.5 })
                  .margin({ right: discountIndex === item.getDiscounts().length - 1 ? 0 : 5 })
              }, (discount: string, discountIndex: number) => `${discount}-${discountIndex}`)
            }
            .width('100%')
            Blank()
            Row() {
              Text(this.currencyPrefix + JSON.stringify(item.getPrice()))
                .fontColor('#CF0A2C')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .displayPriority(1)
              Blank()
                .displayPriority(2)
              this.payCardButton()
            }
            .width('100%')
          }
          .height(this.isWidthLg() ? 124 : 134)
          .padding({ top: 16, bottom: 12, left: 12, right: this.isWidthLg() ? 16 : 12 })
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Start)
        }
        .width('100%')
        .backgroundColor($r('app.color.surface_primary'))
        .borderRadius(12)
        .margin({ bottom: this.isWidthLg() ? 16 : 12 })
      }, (item: ShopBagProduct, index: number) => `${item.getName()}-${index}`)
    }
    .width('100%')
  }
}
