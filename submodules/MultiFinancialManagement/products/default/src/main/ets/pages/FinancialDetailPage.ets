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
import { HdsNavDestination } from '@kit.UIDesignKit';
import { CommonConstants, getWidthBpByWidth, WindowUtil } from 'financialbase';
import { BuyPanel, TimelineCard } from 'investment';
import { FeatureCard, ProductCard } from 'wealth';
import { BuyPage } from './BuyPage';

@ComponentV2
export struct FinancialDetailPage {
  @Local buySheetVisible: boolean = false;
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack();
  @Provider('navigationMode') navigationMode: NavigationMode = NavigationMode.Stack;
  @Local windowUtil: WindowUtil = AppStorageV2.connect(WindowUtil, CommonConstants.WINDOW_UTIL_KEY)!;
  @Provider('navPathStack') navPathStack: NavPathStack = new NavPathStack();
  @Local widthBreakpoint: WidthBreakpoint = WidthBreakpoint.WIDTH_SM
  @Env(SystemProperties.BREAK_POINT) breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Local pendingNavigation: boolean = false;

  get contentPadding(): number {
    return this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM &&
      this.breakpoint.heightBreakpoint === HeightBreakpoint.HEIGHT_MD ? 11 :
      CommonConstants.COMMON_PADDING[2].getValue(this.widthBreakpoint)
  }

  @Builder
  PagesMap(name: string) {
    if (name === CommonConstants.PAY_PAGE_NAME) {
      BuyPage()
    }
  }

  build() {
    HdsNavDestination() {
      Navigation(this.navPathStack) {
        Column() {
          this.titleBar()
          Scroll() {
            Column({ space: 16 }) {
              ProductCard({
                widthBreakpoint: this.widthBreakpoint
              })
              TimelineCard({
                widthBreakpoint: this.widthBreakpoint
              })
              FeatureCard()
            }
            .margin({
              top: this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM &&
                this.breakpoint.heightBreakpoint === HeightBreakpoint.HEIGHT_MD ? 8 : 16,
              bottom: 16
            })
            .padding({
              left: this.contentPadding,
              right: this.contentPadding,
            })
          }
          .width('100%')
          .layoutWeight(1)
          .scrollBar(BarState.Off)
          .align(Alignment.TopStart)

          this.BottomBar()
        }
        .width('100%')
        .height('100%')
        .onAreaChange((_: Area, newValue: Area) => {
          this.widthBreakpoint = getWidthBpByWidth(newValue.width);
          this.buySheetVisible = false;
        })
      }
      .navDestination(this.PagesMap)
      .mode(this.navigationMode)
      .navBarWidthRange(['360vp',
        this.getUIContext().px2vp(this.windowUtil.mainWindowInfo.windowSize.width) - 400])
      .navBarWidth(this.getUIContext().px2vp(this.windowUtil.mainWindowInfo.windowSize.width) - 400)
      .onNavigationModeChange((mode: NavigationMode) => {
        if (this.pendingNavigation && mode === NavigationMode.Split) {
          this.pendingNavigation = false;
          if (this.navPathStack.size() === 0) {
            this.navPathStack.pushPath({ name: CommonConstants.PAY_PAGE_NAME });
          }
        }
      })
      .linearGradient({
        direction: GradientDirection.Bottom,
        colors: [[$r('app.color.brand20'), 0.0], [$r('app.color.brand10'), 1.0]]
      })
      .height(LayoutPolicy.matchParent)
      .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP])
      .hideToolBar(true)
    }
    .hideTitleBar(true)
  }

  @Builder
  titleBar() {
    Row() {
      Button({ type: ButtonType.Circle }) {
        SymbolGlyph($r('sys.symbol.chevron_backward'))
          .fontColor([$r('app.color.font_primary')])
          .fontSize(24)
      }
      .height(40)
      .aspectRatio(1)
      .backgroundColor($r('app.color.comp_background_tertiary'))
      .onClick(() => {
        if (this.pageStack.size() > 0) {
          this.pageStack.pop();
        }
      })

      Text($r('app.string.financial_detail_title'))
        .fontColor($r('app.color.font_primary'))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ left: 8 })
    }
    .padding({
      left: CommonConstants.COMMON_PADDING[2].getValue(this.widthBreakpoint)
    })
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .height(56)
  }

  @Builder
  BottomBar() {
    Row({ space: 12 }) {
      Column({ space: 4 }) {
        SymbolGlyph($r('sys.symbol.plus_circle'))
          .fontSize(24)
          .fontColor([$r('app.color.icon_primary')])
        Text($r('app.string.financial_detail_follow'))
          .fontSize(14)
          .lineHeight(19)
          .fontColor($r('app.color.font_secondary'))
      }
      .width(52)
      .alignItems(HorizontalAlign.Center)

      Button($r('app.string.financial_detail_buy'))
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
        .height(40)
        .width(this.widthBreakpoint === WidthBreakpoint.WIDTH_SM ? '100%' : 448)
        .layoutWeight(this.widthBreakpoint === WidthBreakpoint.WIDTH_SM ? 1 : 0)
        .borderRadius('50%')
        .backgroundColor($r('app.color.brand'))
        .bindSheet(this.buySheetVisible, this.BuySheetContent, {
          detents: [SheetSize.LARGE, SheetSize.MEDIUM],
          preferType: SheetType.BOTTOM,
          showClose: false,
          dragBar: false,
          shouldDismiss: (dismiss) => {
            this.buySheetVisible = false;
            dismiss.dismiss();
          }
        })
        .onClick(() => {
          if (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) {
            this.buySheetVisible = true;
          } else {
            this.pendingNavigation = true;
            this.navigationMode = NavigationMode.Split;
          }
        })
    }
    .width('100%')
    .justifyContent(FlexAlign.End)
    .alignItems(VerticalAlign.Center)
    .constraintSize({
      minHeight: 72
    })
    .padding({
      top: this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM &&
        this.breakpoint.heightBreakpoint === HeightBreakpoint.HEIGHT_MD ? 12 : 16,
      left: CommonConstants.COMMON_PADDING[2].getValue(this.widthBreakpoint),
      right: CommonConstants.COMMON_PADDING[2].getValue(this.widthBreakpoint),
      bottom: this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM &&
        this.breakpoint.heightBreakpoint === HeightBreakpoint.HEIGHT_MD ? 12 : 0,
    })
    .background($r('app.color.background_primary'))
  }

  @Builder
  BuySheetContent() {
    BuyPanel({
      windowUtil: this.windowUtil,
      onClose: () => {
        this.buySheetVisible = false;
      }
    }).safeAreaPadding({
      top: 8,
    })
  }
}
