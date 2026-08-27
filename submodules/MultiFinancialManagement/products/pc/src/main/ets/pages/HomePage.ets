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

import { AppStorageV2, uiObserver } from '@kit.ArkUI';
import { BankCard, MessageBar } from 'account';
import { BreakpointType, CommonConstants, getWidthBpByWidth, WindowInfo, WindowUtil } from 'financialbase';
import { PensionCard, WealthSelectionCard } from 'recommend';
import { Menu } from '../model/HomeModel';
import { HomeViewModel } from '../viewmodel/HomeViewModel';

@ComponentV2
export struct HomePage {
  @Local currentBp: WidthBreakpoint = WidthBreakpoint.WIDTH_LG;
  @Local offsetValue: number = 0;
  @Local windowUtil: WindowUtil = AppStorageV2.connect(WindowUtil, CommonConstants.WINDOW_UTIL_KEY)!;
  @Param mainWindowInfo: WindowInfo = new WindowInfo();
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack();
  @Env(SystemProperties.BREAK_POINT) breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Local homeViewModel: HomeViewModel = new HomeViewModel();

  get columnCount(): number {
    return new BreakpointType(4, 6, 6, 8).getValue(this.breakpoint.widthBreakpoint)
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Scroll() {
        Column() {
          Column() {
            this.MainBusinessList()
            this.BusinessList()
            this.ResponsiveCardList()
            WealthSelectionCard({
              radius: 8,
              widthBreakpoint: this.breakpoint.widthBreakpoint
            })
              .margin({ top: 8 })
          }
          .width('100%')
          .constraintSize({
            maxWidth: 1200
          })
        }
        .padding({
          top: 56,
          left: 32,
          right: 32,
          bottom: 24
        })
        .layoutWeight(1)
        .width('100%')
        .backgroundImage(this.currentBp >= WidthBreakpoint.WIDTH_LG ?
          $r('app.media.home_bg_lg') : $r('app.media.home_bg'))
        .backgroundImageSize(ImageSize.Contain)
      }
      .scrollBar(BarState.Off)
      .width('100%')
      .onDidScroll((_: number, yOffset: number) => {
        this.offsetValue = this.offsetValue - yOffset;
        if (this.offsetValue > 0) {
          this.offsetValue = 0;
        }
      })

      this.HomeHeader()
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_secondary'))
    .onAreaChange((_: Area, newValue: Area) => {
      this.currentBp = getWidthBpByWidth(newValue.width);
    })
  }

  @Builder
  HomeHeader() {
    Row() {
      Row({ space: 4 }) {
        SymbolGlyph($r('sys.symbol.local'))
          .fontSize(24)
          .fontColor([$r('app.color.icon_on_primary')])
        Text($r('app.string.city_name'))
          .fontSize(16)
          .lineHeight(21)
          .fontColor($r('app.color.font_on_primary'))
      }
      .alignItems(VerticalAlign.Center)

      Blank()

      Row({ space: 24 }) {
        Search({ value: $r('app.string.search_value') })
          .width(328)
          .height(40)
          .borderRadius(10)
          .fontColor($r('app.color.font_on_primary'))
          .searchIcon({
            size: 16,
            color: $r('app.color.icon_on_secondary'),
            src: $r('sys.symbol.magnifyingglass')
          })
          .cancelButton({
            icon: {
              size: 16,
              color: $r('app.color.icon_on_secondary'),
              src: $r('sys.symbol.xmark')
            }
          })
          .backgroundColor($r('app.color.on_primary10'))
        this.ToolbarIcon($r('sys.symbol.envelope'))
        this.ToolbarIcon($r('sys.symbol.plus'))
      }
      .alignItems(VerticalAlign.Center)
      .padding({ right: 8 })
    }
    .height(56)
    .width('100%')
    .padding({
      left: 32,
      right: this.mainWindowInfo.titleButtonRect?.width ?? 0
    })
    .backgroundColor(this.offsetValue < -24 ? $r('app.color.brand') : Color.Transparent)
  }

  @Builder
  ToolbarIcon(icon: Resource) {
    SymbolGlyph(icon)
      .fontColor([$r('app.color.icon_on_primary')])
      .fontSize(24)
  }

  @Builder
  MainBusinessList() {
    Row() {
      ForEach(this.homeViewModel.mainBusinessList(), (item: Menu, index: number) => {
        Column() {
          Row({ space: 17 }) {
            SymbolGlyph(item.icon as Resource)
              .fontSize(38)
              .fontColor([$r('app.color.icon_on_primary')])
            Text(item.name)
              .fontSize(18)
              .fontColor($r('app.color.font_on_primary'))
              .fontWeight(500)
          }
          .height(72)
          .width(180)
          .borderRadius(8)
          .backgroundColor($r('app.color.fg_color_unchecked'))
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)
        }
        .onClick(() => {
          if (index === 3) {
            this.pageStack.pushPath({ name: CommonConstants.ASSET_PAGE_NAME })
          }
        })
      }, (item: Menu, index: number) => JSON.stringify(item) + index)
    }
    .margin({ top: 24 })
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  BusinessList() {
    Grid() {
      ForEach(this.homeViewModel.displayList(this.columnCount), (item: Menu) => {
        GridItem() {
          this.BusinessItem(item)
        }
        .width('100%')
      }, (item: Menu, index: number) => JSON.stringify(item) + index)
    }
    .columnsTemplate(`repeat(${this.columnCount}, 1fr)`)
    .columnsGap(0)
    .padding({ top: 16 })
    .margin({ top: 24 })
    .width('100%')
    .borderRadius(8)

    .backgroundColor($r('app.color.ohos_id_color_list_card_bg'))
  }

  @Builder
  BusinessItem(item: Menu) {
    Column({ space: 8 }) {
      this.BusinessIcon(item)
      Text(item.name)
        .fontSize(14)
        .lineHeight(19)
        .fontColor($r('app.color.font_primary'))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .margin({ bottom: 16 })
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  BusinessIcon(item: Menu) {
    Stack() {
      SymbolGlyph(item.icon as Resource)
        .fontSize(24)
        .shaderStyle([new LinearGradientStyle({
          angle: 180,
          colors: [[$r('app.color.brand'), 0.0], [$r('app.color.brand70'), 1.0]]
        })])
    }
    .height(44)
    .width(44)
    .borderRadius(22)
    .alignContent(Alignment.Center)
    .backgroundColor($r('app.color.comp_emphasize_tertiary'))
  }

  @Builder
  ResponsiveCardList() {
    GridRow({
      columns: 12,
      gutter: { x: 16, y: 24 }
    }) {
      GridCol({
        span: {
          sm: 12,
          md: 12,
          lg: 12,
          xl: 12
        }
      }) {
        MessageBar({ isPc: true })
      }

      GridCol({
        span: {
          sm: 12,
          md: 6,
          lg: 6,
          xl: 6
        }
      }) {
        BankCard({ radius: 8 })
      }

      GridCol({
        span: {
          sm: 12,
          md: 6,
          lg: 6,
          xl: 6
        }
      }) {
        PensionCard({ radius: 8 })
      }
    }
    .margin({ top: 24 })
    .width('100%')
  }
}