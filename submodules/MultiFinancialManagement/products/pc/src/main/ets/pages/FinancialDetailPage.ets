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

import { ConfigurationConstant } from '@kit.AbilityKit';
import { AppStorageV2 } from '@kit.ArkUI';
import { CommonConstants, getWidthBpByWidth, WindowUtil } from 'financialbase';
import { TimelineCard } from 'investment';
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
  @Local pendingNavigation: boolean = false;

  @Builder
  PagesMap(name: string) {
    if (name === CommonConstants.PAY_PAGE_NAME) {
      BuyPage()
    }
  }

  aboutToAppear(): void {
    this.windowUtil.setDecorButtonStyle(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)
  }

  onHidden(): void {
    this.windowUtil.setDecorButtonStyle()
  }

  build() {
    NavDestination() {
      Navigation(this.navPathStack) {
        Column() {
          this.titleBar()
          Scroll() {
            Column({ space: 16 }) {
              ProductCard({
                widthBreakpoint: this.widthBreakpoint,
                radius: [8, 4]
              })
              TimelineCard({
                widthBreakpoint: this.widthBreakpoint,
                radius: 8
              })
              FeatureCard({
                radius: 8
              })
            }
            .padding({
              top: 16,
              bottom: 16,
              left: 32,
              right: 32
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
        colors: [[$r('app.color.comp_emphasize_secondary'), 0.0], [$r('app.color.comp_background_gray'), 1.0]]
      })
      .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP])
      .hideToolBar(true)
    }
    .hideTitleBar(true)
    .onWillDisappear(() => this.onHidden())
  }

  @Builder
  titleBar() {
    Row() {
      SymbolGlyph($r('sys.symbol.chevron_backward'))
        .fontColor([$r('app.color.font_primary')])
        .fontSize(24)
        .onClick(() => {
          if (this.pageStack.size() > 0) {
            this.pageStack.pop();
          }
        })

      Text($r('app.string.financial_detail_title'))
        .fontColor($r('app.color.font_primary'))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ left: 12 })
    }
    .padding({
      left: 24
    })
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .height(56)
  }

  @Builder
  BottomBar() {
    Row({ space: 12 }) {
      Column() {
        SymbolGlyph($r('sys.symbol.plus_circle'))
          .fontSize(24)
          .fontColor([$r('app.color.icon_primary')])
        Text($r('app.string.financial_detail_follow'))
          .fontSize(14)
          .lineHeight(20)
          .fontColor($r('app.color.font_secondary'))
      }
      .width(52)
      .height(48)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Center)

      Button($r('app.string.financial_detail_buy'))
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
        .height(40)
        .width(this.widthBreakpoint === WidthBreakpoint.WIDTH_SM ? '100%' : 448)
        .layoutWeight(this.widthBreakpoint === WidthBreakpoint.WIDTH_SM ? 1 : 0)
        .borderRadius(8)
        .backgroundColor($r('app.color.brand'))
        .onClick(() => {
          this.pendingNavigation = true;
          this.navigationMode = NavigationMode.Split;
        })
    }
    .width('100%')
    .justifyContent(FlexAlign.End)
    .alignItems(VerticalAlign.Top)
    .padding({
      top: 16,
      left: 16,
      right: 16,
      bottom: 28
    })
    .background($r('app.color.background_primary'))
  }
}
