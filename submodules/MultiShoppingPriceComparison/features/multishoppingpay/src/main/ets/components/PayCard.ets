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

import { PayCardModel } from '../model/PayCardModel';
import { PayCardViewModel, SelectItem, SelectProjectItem } from '../viewmodel/PayCardViewModel';

@ComponentV2
export struct PayCard {
  @Param public isOpen: boolean = false;
  @Param public detailType: string = 'detailPayCard';
  @Param public widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @Event public onIsOpenChange: (value: boolean) => void = (_value: boolean) => {
  };
  @Event public onDetailTypeChange: (value: string) => void = (_value: string) => {
  };
  private context: Context = this.getUIContext().getHostContext()!;
  private payCardSelectList: SelectProjectItem[] = new PayCardViewModel(this.context).getPayCardSelectList();

  private isWidthSm(): boolean {
    const bp = this.widthBp;
    return bp === WidthBreakpoint.WIDTH_XS || bp === WidthBreakpoint.WIDTH_SM;
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          Row() {
            Image($r('app.media.pay_main_shop'))
              .height(60)
              .width(60)
              .borderRadius(10)
              .margin({ right: 8 })
            Text(PayCardModel.getCustomerServiceContents(this.context)[1])
              .fontColor('#CF0A2C')
              .fontSize(24)
            Blank()
            Image($r('app.media.icon_close_2'))
              .width(40)
              .height(40)
              .onClick(() => {
                if (this.detailType === 'detailPayCard') {
                  this.onIsOpenChange(false);
                } else {
                  this.onDetailTypeChange('ShopBag');
                }
              })
              .alignSelf(ItemAlign.Start)
              .visibility(this.isWidthSm() ? Visibility.None : Visibility.Visible)
            Image($r('app.media.icon_close_2'))
              .width(40)
              .height(40)
              .onClick(() => {
                if (this.detailType === 'detailPayCard') {
                  this.onIsOpenChange(false);
                } else {
                  this.onDetailTypeChange('ShopBag');
                }
              })
              .alignSelf(ItemAlign.Start)
              .visibility(this.isWidthSm() ? Visibility.Visible : Visibility.None)
          }
          .width('100%')
          .margin({ bottom: 12 })

          Row() {
            Image($r('app.media.icon_position'))
              .height(32)
              .width(32)
              .margin({ right: 12 })
            Column() {
              Text(PayCardModel.getPayInfo(this.context)[0])
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .width('100%')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ bottom: 2 })
              Text(PayCardModel.getPayInfo(this.context)[1])
                .fontSize(14)
                .fontColor($r('app.color.text_tertiary'))
                .width('100%')
                .maxLines(1)
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)
          }
          .margin({ bottom: 12 })
          .width('100%')
          .backgroundColor($r('app.color.surface_primary'))
          .borderRadius(12)
          .padding({
            top: 10,
            bottom: 10,
            left: 12,
            right: 12
          })

          Column() {
            ForEach(this.payCardSelectList, (item: SelectProjectItem, index: number) => {
              Column() {
                Text(item.getName())
                  .fontSize(14)
                  .alignSelf(ItemAlign.Start)
                  .margin({ bottom: 8 })
                  .lineHeight(19)
                  .fontWeight(FontWeight.Medium)
                Flex({
                  wrap: FlexWrap.Wrap,
                  justifyContent: FlexAlign.Start
                }) {
                  ForEach(item.getSelectItemList(), (selectItem: SelectItem, selectIndex: number) => {
                    Row() {
                      if (selectItem.getImage() !== null) {
                        Image(selectItem.getImage() as Resource)
                          .height(28)
                          .width(28)
                      }
                      Text(selectItem.getName())
                        .fontColor(selectIndex === 0 ? '#CF0A2C' : $r('app.color.text_primary'))
                        .fontSize(12)
                        .textAlign(TextAlign.Center)
                        .margin({ left: 12, right: 12 })
                    }
                    .backgroundColor(selectIndex === 0 ? '#0DCF0A2C' : $r('app.color.overlay_low'))
                    .border({
                      color: selectIndex === 0 ? '#CF0A2C' : $r('app.color.overlay_low'),
                      width: index === 0 ? 0.5 : 0,
                      radius: 8
                    })
                    .height(30)
                    .margin({ right: 12, bottom: 12 })
                  }, (selectItem: SelectItem, selectIndex: number) => `${item.getName()}-${selectIndex}`)
                }
                .width('100%')
              }
              .margin({ top: 20 })
              .width('100%')
            }, (item: SelectProjectItem, index: number) => `${item.getName()}-${index}`)
          }
          .width('100%')
          .margin({ bottom: 12 })
          .backgroundColor($r('app.color.surface_primary'))
          .borderRadius(12)
          .padding({ left: 12, right: 12 })

          Row() {
            Image($r('app.media.icon_pay'))
              .height(32)
              .width(32)
              .margin({ right: 5 })
            Text(PayCardModel.getPayInfo(this.context)[2])
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
            Blank()
            Checkbox()
              .selectedColor('#CF0A2C')
              .shape(CheckBoxShape.CIRCLE)
              .width(16)
          }
          .padding({
            top: 8,
            left: 12,
            bottom: 8,
            right: 12
          })
          .margin({ bottom: 12 })
          .borderRadius(12)
          .backgroundColor($r('app.color.surface_primary'))
          .width('100%')
        }
        .width('100%')
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .align(Alignment.Top)
      .width('100%')

      Button(PayCardModel.getPayInfo(this.context)[3])
        .width('100%')
        .backgroundColor('#CF0A2C')
        .height(40)
        .borderRadius(20)
    }
    .width('100%')
    .height('100%')
    .padding({
      left: 16,
      right:16,
      top:16,
      bottom:16
    })
  }
}
