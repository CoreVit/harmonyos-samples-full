/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 *
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { ProductModel } from '../model/ProductModel';
import { PayCardViewModel, SelectItem, SelectProjectItem } from '../model/PayCardViewModel';
import { CommonConstants } from '../constants/CommonConstants';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';

@Component
export struct OrderConfirm {
  @StorageProp(CommonConstants.KEY_PREFIX_NAVIGATOR_BAR_HEIGHT) bottomRectHeight: number = 0;
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) curBp: string = BreakpointTypeEnum.SM;
  @State productModel: ProductModel | undefined = undefined;
  @State detailStr: string = '';
  callBack: Function = () => {
  };
  private payCardSelectList: SelectProjectItem[] = new PayCardViewModel().getPayCardSelectList();

  aboutToAppear(): void {
    this.productModel = JSON.parse(this.detailStr) as ProductModel;
  }

  build() {
    Column() {
      Column() {
        Row() {
          Text($r('app.string.order_payment'))
            .fontColor($r('sys.color.font_primary'))
            .fontSize($r('sys.float.Title_S'))
            .fontWeight(FontWeight.Bold)
          if (this.curBp === 'sm') {
            Button() {
              SymbolGlyph($r('sys.symbol.xmark'))
                .fontSize($r('sys.float.padding_level12'))
                .fontColor([$r('sys.color.font_primary')])
            }
            .height(40)
            .aspectRatio(1)
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .onClick(() => {
              this.callBack();
            })
          } else {
            SymbolGlyph($r('sys.symbol.xmark'))
              .fontColor([$r('sys.color.font_primary')])
              .fontSize($r('sys.float.Title_M'))
              .onClick(() => {
                this.callBack();
              })
          }
        }
        .height(56)
        .width('100%')
        .margin({ bottom: this.curBp !== 'sm' ? $r('sys.float.padding_level6') : 0 })
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)

        Scroll() {
          Column() {
            Row() {
              Image($r('app.media.pay_main_shop'))
                .height(60)
                .width(60)
                .margin({ right: $r('sys.float.padding_level6') })
              Text('￥' + this.productModel?.price.toString())
                .fontColor('#CF0A2C')
                .fontSize($r('sys.float.Title_M'))
              Blank()
            }
            .width('100%')
            .margin({ bottom: $r('sys.float.padding_level6') })

            Row() {
              Image($r('app.media.icon_position'))
                .height($r('sys.float.padding_level12'))
                .width($r('sys.float.padding_level12'))
                .margin({ right: $r('sys.float.padding_level6') })
              Column() {
                Column()
                  .borderRadius($r('sys.float.corner_radius_level6'))
                  .height($r('sys.float.padding_level8'))
                  .backgroundColor($r('sys.color.comp_background_secondary'))
                  .width('100%')
                Column()
                  .borderRadius($r('sys.float.corner_radius_level6'))
                  .height($r('sys.float.padding_level8'))
                  .backgroundColor($r('sys.color.comp_background_secondary'))
                  .width('60%')
                  .margin({ top: $r('sys.float.padding_level3') })
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
            }
            .margin({ bottom: $r('sys.float.padding_level6') })
            .width('100%')
            .backgroundColor($r('sys.color.comp_background_primary'))
            .borderRadius($r('sys.float.corner_radius_level6'))
            .padding($r('sys.float.padding_level6'))

            Column() {
              ForEach(this.payCardSelectList, (item: SelectProjectItem, index: number) => {
                Column() {
                  Text(item.getName())
                    .fontSize($r('sys.float.Body_M'))
                    .alignSelf(ItemAlign.Start)
                    .margin({ bottom: $r('sys.float.padding_level4') })
                    .lineHeight(19)
                    .fontWeight(FontWeight.Medium)
                  Flex({
                    wrap: FlexWrap.Wrap,
                    justifyContent: FlexAlign.Start
                  }) {
                    ForEach(item.getSelectItemList(), (selectItem: SelectItem, selectIndex: number) => {
                      Row() {
                        if (selectItem.getImage()) {
                          Image(selectItem.getImage())
                            .height(30)
                            .width(30)
                          Column()
                            .borderRadius($r('sys.float.corner_radius_level6'))
                            .height($r('sys.float.padding_level8'))
                            .backgroundColor($r('sys.color.comp_background_secondary'))
                            .layoutWeight(1)
                            .margin({
                              left: $r('sys.float.padding_level6'),
                              right: $r('sys.float.padding_level6')
                            })
                        }
                      }
                      .width('26%')
                      .height(30)
                      .backgroundColor(selectIndex === 0 ? $r('sys.color.comp_background_secondary') :
                      $r('sys.color.comp_background_tertiary'))
                      .border({
                        color: selectIndex === 0 ? '#CF0A2C' : '#0D000000',
                        width: 0.5,
                        radius: $r('sys.float.corner_radius_level4')
                      })
                      .margin({
                        right: $r('sys.float.padding_level6'),
                        bottom: $r('sys.float.padding_level6')
                      })
                    }, (selectItem: SelectItem, selectIndex: number) => JSON.stringify(selectItem) + selectIndex)
                  }
                  .width('100%')
                }
                .margin({ top: $r('sys.float.padding_level10') })
                .width('100%')

              }, (item: SelectProjectItem, index: number) => JSON.stringify(item) + index)
            }
            .width('100%')
            .margin({ bottom: $r('sys.float.padding_level6') })
            .backgroundColor($r('sys.color.comp_background_primary'))
            .borderRadius($r('sys.float.corner_radius_level6'))
            .padding({
              left: $r('sys.float.padding_level6'),
              right: $r('sys.float.padding_level6')
            })

            Row() {
              Image($r('app.media.icon_pay'))
                .height($r('sys.float.padding_level12'))
                .width($r('sys.float.padding_level12'))
                .margin({ right: $r('sys.float.padding_level6') })
              Text($r('app.string.hw_wallet_payment'))
                .fontSize($r('sys.float.Body_L'))
                .fontWeight(FontWeight.Medium)
              Blank()
              Checkbox()
                .selectedColor('#CF0A2C')
                .shape(CheckBoxShape.CIRCLE)
                .width($r('sys.float.padding_level8'))
            }
            .padding($r('sys.float.padding_level6'))
            .margin({ bottom: $r('sys.float.padding_level6') })
            .borderRadius($r('sys.float.padding_level6'))
            .backgroundColor($r('sys.color.comp_background_primary'))
            .width('100%')
          }
          .width('100%')
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)
        .align(Alignment.Top)
        .width('100%')

        Button($r('app.string.btn_pay_now'))
          .backgroundColor('#CF0A2C')
          .width('100%')
          .margin({ bottom: $r('sys.float.padding_level8') })
      }
      .height('100%')
      .width(this.curBp === 'sm' ? '100%' : this.curBp === 'md' ? '60%' : '35%')
      .borderWidth({ left: this.curBp === 'sm' ? 0 : 1 })
      .borderColor($r('sys.color.background_tertiary'))
      .backgroundColor($r('sys.color.background_secondary'))
      .borderRadius($r('sys.float.corner_radius_level8'))
      .padding({
        left: new BreakpointType($r('sys.float.padding_level8'), $r('sys.float.padding_level12'),
          $r('sys.float.padding_level12')).getValue(this.curBp),
        right: new BreakpointType($r('sys.float.padding_level8'), $r('sys.float.padding_level12'),
          $r('sys.float.padding_level12')).getValue(this.curBp),
        bottom: this.curBp === 'sm' ? this.getUIContext().px2vp(this.bottomRectHeight) : 0
      })
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}