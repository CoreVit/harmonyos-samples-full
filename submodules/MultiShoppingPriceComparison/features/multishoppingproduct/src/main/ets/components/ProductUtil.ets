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
import { ProductUtilState } from '../viewmodel/ProductUtilState';

/** Product detail bottom action bar and payment half-sheet (V2); PayCard syncs local state via @Param + @Event. */
@ComponentV2
export struct ProductUtil {
  @Param public widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @Param public isMoreDetail: boolean = false;
  @Param public isLivePage: boolean = false;
  @Param public isSplitMode: boolean = false;
  @Param public isShowingSidebar: boolean = false;
  @Event private onBuyClick: () => void = () => {
  };
  private labelState: ProductUtilState = new ProductUtilState(this.getUIContext().getHostContext()!);

  build() {
    Row() {
      SymbolGlyph($r('sys.symbol.house'))
        .fontSize(24)
        .margin({
          right: this.widthBp === WidthBreakpoint.WIDTH_SM ?0:12
        })
        .fontColor([$r('app.color.text_primary')])
      SymbolGlyph($r('sys.symbol.bag'))
        .fontSize(24)
        .fontColor([$r('app.color.text_primary')])
        .margin({
          right: this.widthBp === WidthBreakpoint.WIDTH_SM ?0:12
        })
      SymbolGlyph($r('sys.symbol.message'))
        .fontSize(24)
        .fontColor([$r('app.color.text_primary')])
        .margin({
          right: this.widthBp === WidthBreakpoint.WIDTH_SM ?0:12
        })
      if (this.widthBp !== WidthBreakpoint.WIDTH_SM) {
        Blank()
          .layoutWeight(1)
          .displayPriority(1)
      }
      Button(this.labelState.addCartLabel)
        .fontSize(16)
        .fontColor('#CF0A2C')
        .fontWeight(FontWeight.Medium)
        .height(40)
        .borderRadius(20)
        .backgroundColor($r('app.color.buy_outline_background'))
        .backgroundBlurStyle(
          BlurStyle.Thin,
          {
            colorMode: ThemeColorMode.LIGHT,
            scale: 1.0
          })
        .margin({ right: this.widthBp === WidthBreakpoint.WIDTH_SM ?0:12 })
        .width(new WidthBreakpointType(128, 188, 140, 140).getValue(this.widthBp))
      Button(this.labelState.buyLabel)
        .fontSize(16)
        .fontColor($r('sys.color.font_on_primary'))
        .fontWeight(FontWeight.Medium)
        .height(40)
        .width(new WidthBreakpointType(64, 188, 140, 140).getValue(this.widthBp))
        .borderRadius(20)
        .backgroundColor('#CF0A2C')
        .onClick(() => {
          if (this.isLivePage || this.isSplitMode) {
            return;
          }
          this.onBuyClick();
        })
    }
    .layoutWeight(1)
    .justifyContent(this.widthBp !== WidthBreakpoint.WIDTH_SM ? FlexAlign.Start : FlexAlign.SpaceBetween)
    .backgroundBlurStyle(
      BlurStyle.Thin,
      {
        colorMode: ThemeColorMode.SYSTEM,
        adaptiveColor: AdaptiveColor.DEFAULT,
        scale: 1.0
      })
    .height(48)
    .borderRadius(24)
    .width('100%')
    .padding({
      left: new WidthBreakpointType(12, 24, 32, 32).getValue(this.widthBp),
      right: 2
    })
  }
}
