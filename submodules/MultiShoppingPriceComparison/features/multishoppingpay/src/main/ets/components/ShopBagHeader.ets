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

import { ShopBagHeaderIcon, ShopBagViewModel } from '../viewmodel/ShopBagViewModel';

@ComponentV2
export struct ShopBagHeader {
  @Param public widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @Param public isMoreDetail: boolean = false;
  @Event private onIsMoreDetailChange: (value: boolean) => void = (_value: boolean) => {
  };
  @Local private icons: ShopBagHeaderIcon[] = [];
  @Local private title: string = '';

  aboutToAppear(): void {
    const ctx = this.getUIContext().getHostContext();
    if (ctx !== undefined) {
      const vm = new ShopBagViewModel();
      this.title = vm.getHeaderTitle(ctx);
      this.icons = vm.getHeaderIcons(ctx);
    }
  }

  private iconMarginRight(): number {
    if (this.widthBp === WidthBreakpoint.WIDTH_LG || this.widthBp === WidthBreakpoint.WIDTH_XL) {
      return 16;
    }
    return 12;
  }

  build() {
    Row() {
      Text(this.title.length > 0 ? this.title : ' ')
        .fontWeight(FontWeight.Medium)
        .fontSize(16)
        .lineHeight(22)
      Blank()
      if (this.icons.length >= 3) {
        ShopBagIconView({
          iconResource: this.icons[0].getIcon(),
          iconName: this.icons[0].getName(),
          widthBp: this.widthBp
        })
        ShopBagIconView({
          iconResource: this.icons[1].getIcon(),
          iconName: this.icons[1].getName(),
          widthBp: this.widthBp
        })
        ShopBagIconView({
          iconResource: this.icons[2].getIcon(),
          iconName: this.icons[2].getName(),
          widthBp: this.widthBp
        })
      }
      Image($r('app.media.icon_close_2'))
        .width(40)
        .height(40)
        .margin({ left: this.iconMarginRight() })
        .onClick(() => {
          this.onIsMoreDetailChange(false);
        })
    }
    .width('100%')
    .height(56)
  }
}

@ComponentV2
struct ShopBagIconView {
  @Param public widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @Param public iconResource: Resource = $r('sys.symbol.bag');
  @Param public iconName: string = '';

  private marginRight(): number {
    if (this.widthBp === WidthBreakpoint.WIDTH_LG || this.widthBp === WidthBreakpoint.WIDTH_XL) {
      return 16;
    }
    return 12;
  }

  build() {
    Column() {
      Image(this.iconResource)
        .width(20)
        .height(20)
        .margin({ bottom: 2 })
      Text(this.iconName)
        .fontSize(10)
        .lineHeight(14)
        .fontWeight(FontWeight.Medium)
    }
    .justifyContent(FlexAlign.End)
    .width(36)
    .margin({ right: this.marginRight() })
  }
}
