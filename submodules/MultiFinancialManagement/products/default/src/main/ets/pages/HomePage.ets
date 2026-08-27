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
import { deviceInfo } from '@kit.BasicServicesKit';
import { BankCard, MessageBar } from 'account';
import { BreakpointType, CommonConstants, WindowInfo, WindowUtil } from 'financialbase';
import { PensionCard, WealthSelectionCard } from 'recommend';
import { Menu } from '../model/HomeModel';
import { HomeViewModel } from '../viewmodel/HomeViewModel';

@ComponentV2
export struct HomePage {
  @Local windowUtil: WindowUtil = AppStorageV2.connect(WindowUtil, CommonConstants.WINDOW_UTIL_KEY)!;
  @Param mainWindowInfo: WindowInfo = new WindowInfo();
  @Param scrollY: number = 0;
  @Event updateScrollY: (value: number) => void;
  @Env(SystemProperties.BREAK_POINT) breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack();
  @Local homeViewModel: HomeViewModel = new HomeViewModel();
  @Local offsetValue: number = 0;
  private scroller: Scroller = new Scroller();

  get columnCount(): number {
    return new BreakpointType(4, 6, 8, 8).getValue(this.breakpoint.widthBreakpoint)
  }

  build() {
    Column() {
      Scroll(this.scroller) {
        Column() {
          this.HomeHeader()
          this.MainBusinessList()
          Column() {
            this.BusinessList()
            this.ResponsiveCardList()
            WealthSelectionCard({ widthBreakpoint: this.breakpoint.widthBreakpoint })
          }
          .padding({
            left: CommonConstants.COMMON_PADDING[2].getValue(this.breakpoint.widthBreakpoint),
            right: CommonConstants.COMMON_PADDING[2].getValue(this.breakpoint.widthBreakpoint)
          })

          if (deviceInfo.distributionOSApiVersion >= 60100) {
            Image(new BreakpointType($r('app.media.ic_home_phone_background'),
              $r('app.media.ic_home_fold_background'),
              $r('app.media.ic_home_tablet_background'),
              $r('app.media.ic_home_tablet_background')).getValue(this.breakpoint.widthBreakpoint))
              .width('100%')
              .objectFit(ImageFit.Cover)
              .position({
                top: 0 - this.mainWindowInfo.statusBarHeight,
                left: 0
              })
              .zIndex(-1)
          }
        }
        .width('100%')
        .padding({
          top: this.mainWindowInfo.statusBarHeight,
          bottom: Math.max(this.mainWindowInfo.naviIndicatorHeight, 16) +
            (deviceInfo.distributionOSApiVersion >= 60100 ? 66 : 0)
        })
        .layoutWeight(1)
      }
      .onWillScroll((_: number, yOffset: number) => {
        this.offsetValue = this.offsetValue - yOffset;
        if (this.offsetValue > 0) {
          this.offsetValue = 0;
        }
        this.updateScrollY(this.offsetValue)
      })
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .onAreaChange(() => {
      this.scroller.scrollTo({
        xOffset: 0,
        yOffset: 0
      })
      this.offsetValue = 0;
      this.updateScrollY(this.offsetValue)
    })
  }

  @Builder
  ToolbarIcon(icon: Resource) {
    Button({ type: ButtonType.Circle }) {
      SymbolGlyph(icon)
        .fontColor([$r('app.color.icon_on_primary')])
        .fontSize($r('sys.float.Title_M'))
    }
    .height(40)
    .aspectRatio(1)
    .backgroundColor($r('app.color.on_primary10'))
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

      Row({ space: 8 }) {
        if (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) {
          this.ToolbarIcon($r('sys.symbol.magnifyingglass'))
        } else {
          Search({ value: $r('app.string.search_value') })
            .width(328)
            .height(40)
            .borderRadius('50%')
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
        }
        this.ToolbarIcon($r('sys.symbol.envelope'))
        this.ToolbarIcon($r('sys.symbol.plus'))
      }
      .alignItems(VerticalAlign.Center)
    }
    .height(56)
    .width('100%')
    .padding({
      left: CommonConstants.COMMON_PADDING[2].getValue(this.breakpoint.widthBreakpoint),
      right: CommonConstants.COMMON_PADDING[2].getValue(this.breakpoint.widthBreakpoint)
    })
  }

  @Builder
  MainBusinessList() {
    Row() {
      ForEach(this.homeViewModel.mainBusinessList(), (item: Menu, index: number) => {
        Column() {
          if (this.breakpoint.widthBreakpoint >= WidthBreakpoint.WIDTH_LG) {
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
            .borderRadius(16)
            .backgroundColor($r('app.color.fg_color_unchecked'))
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.Center)
          } else {
            Column({ space: 8 }) {
              Stack() {
                SymbolGlyph(item.icon as Resource)
                  .fontSize(24)
                  .fontColor([$r('app.color.icon_on_primary')])
              }
              .width(44)
              .height(44)
              .borderRadius(22)
              .backgroundColor($r('app.color.fg_color_unchecked'))
              .alignContent(Alignment.Center)

              Text(item.name)
                .fontSize(14)
                .fontColor($r('app.color.font_on_primary'))
            }
            .alignItems(HorizontalAlign.Center)
          }
        }
        .onClick(() => {
          if (index === 3) {
            this.pageStack.pushPath({ name: CommonConstants.ASSET_PAGE_NAME })
          }
        })
      }, (item: Menu, index: number) => JSON.stringify(item) + index)
    }
    .padding({
      left: CommonConstants.COMMON_PADDING[4].getValue(this.breakpoint.widthBreakpoint),
      right: CommonConstants.COMMON_PADDING[4].getValue(this.breakpoint.widthBreakpoint)
    })
    .margin({ top: 16 })
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
    .margin({ top: 16 })
    .width('100%')
    .borderRadius(20)
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
      gutter: { x: this.breakpoint.widthBreakpoint >= WidthBreakpoint.WIDTH_LG ? 16 : 12, y: 12 }
    }) {
      GridCol({ span: { sm: 12, md: 12, lg: 4 } }) {
        MessageBar({
          count: new BreakpointType(2, 2, 3, 3).getValue(this.breakpoint.widthBreakpoint),
        })
      }

      GridCol({ span: { sm: 12, md: 6, lg: 4 } }) {
        BankCard()
      }

      GridCol({ span: { sm: 12, md: 6, lg: 4 } }) {
        PensionCard()
      }
    }
    .margin({ top: 12 })
    .width('100%')
  }
}
