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

import {
  WindowInfo,
  CommSlide,
  BreakpointType,
  TitleIcon,
  StockForm,
  StockDetailsParams,
  KEY_MAIN_WINDOW_INFO
} from '@stock/base';
import { BuyPopUp, RegularWayPopUp, StockDealDetails, StockKLineChart } from '@stock/stockdeal';
import { StockDetailsInfo } from '../views/StockDetailsInfo';
import { TopTitleBar } from '../views/TopTitleBar';
import { StockDetailViewModel } from '../viewmodels/StockDetailViewModel';

@Component
export struct StockDetailsPage {
  @StorageLink(KEY_MAIN_WINDOW_INFO) mainWindowInfo: WindowInfo = new WindowInfo();
  @Consume('pageInfos') pageInfos: NavPathStack;
  @Consume('tabletMode') tabletMode: NavigationMode;
  @State closeInfoCarousel: boolean = false;
  private scroller: Scroller = new Scroller();
  private cardList: number[] = [1, 2, 3];
  private isHiding: boolean = false;
  private viewModel: StockDetailViewModel = new StockDetailViewModel();
  @Provide('isFirstBulletBox') isFirstBulletBox: boolean = true;
  @Provide('popUpBoxIsShow') @Watch('bindSheetMonitor') popUpBoxIsShow: boolean = false;
  @Provide('currentStockPrice') currentStockPrice: number = 20;
  @Provide('purchaseQuantity') purchaseQuantity: number = 100;
  @Provide('buyIsShow') buyIsShow: boolean = false;
  @Provide('isExpand') isExpand: boolean = false;
  @State firstTabIndexSelected: number = 0;
  @State secondTabIndexSelected: number = 0;
  @State topToolbar: number = new BreakpointType(56, 56, 62, 62, 62).getValue(this.mainWindowInfo.widthBp);
  @State bottomToolbar: number = 78;
  @State barOpacity: number = 1;
  @State currentYOffset: number = 0;
  @State topBlank: number = 18;
  @State stockInForm: StockForm | undefined = undefined;
  isPcStockTable: boolean = false;

  bindSheetMonitor(): void {
    if (!this.popUpBoxIsShow) {
      this.isFirstBulletBox = true;
    }
  }

  @Builder
  myBuilder() {
    if (this.isFirstBulletBox) {
      RegularWayPopUp()
    } else {
      BuyPopUp()
    }
  }

  showToolbars() {
    this.getUIContext().animateTo({
      duration: 600
    }, () => {
      this.bottomToolbar = 78;
      this.topToolbar = new BreakpointType(56, 56, 62, 62, 62).getValue(this.mainWindowInfo.widthBp);
      this.barOpacity = 1;
      this.currentYOffset = 0;
      this.isHiding = false;
      this.topBlank = 18;
    });
  }

  build() {
    NavDestination() {
      // Top toolbar
      Row()
        .height(this.mainWindowInfo.isSmMdBreakpoint() ? this.topBlank : 0)
      TopTitleBar({ stockInForm: this.stockInForm, isPcStockTable: this.isPcStockTable })
        .bindSheet($$this.popUpBoxIsShow, this.myBuilder(), {
          detents: [400],
          backgroundColor: $r('app.color.sheet_background_color'),
          showClose: false,
          maskColor: $r('sys.color.mask_fourth'),
          preferType: SheetType.CENTER
        })
        .margin({ top: this.isPcStockTable ? 56 : 0 })
        .height(this.topToolbar)
        .opacity(this.barOpacity)

      // Content Area
      Scroll(this.scroller) {
        Column() {
          // Stock details information
          StockDetailsInfo({ stockInForm: this.stockInForm })
          // Stock Notification
          Row() {
            Row() {
              Text($r('app.string.information'))
                .fontSize(12)
                .lineHeight(16)
                .fontColor($r('sys.color.icon_primary'))
                .fontWeight(FontWeight.Bold)
                .margin({
                  right: 16
                })
              Text($r('app.string.announcement'))
                .fontSize(11)
                .lineHeight(15)
                .fontColor($r('sys.color.font_primary'))
            }

            Blank()

            SymbolGlyph($r('sys.symbol.xmark'))
              .fontColor([$r('sys.color.icon_primary')])
              .fontSize(12)
              .onClick(() => {
                this.closeInfoCarousel = true;
              })
          }
          .width('100%')
          .height(40)
          .backgroundColor($r('app.color.card_background_color'))
          .visibility(this.closeInfoCarousel ? Visibility.None : Visibility.Visible)
          .padding({
            right: new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp),
            left: new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp)
          })
          .margin({
            top: this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_LG ||
              this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_XL ? 8 : 4
          })

          // Stock trading time period area
          Row() {
            Column() {
              CommSlide({
                commSlideData: this.viewModel.cycleTitleList,
                tabIndexSelected: this.firstTabIndexSelected
              })
            }
            .width('100%')
            .height(40)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .backgroundColor($r('app.color.card_background_color'))
            .margin({
              top: (this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_LG ||
                this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_XL) ? 8 : 4,
              bottom: this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_SM ? 4 : 1
            })
          }

          // [Start Stock_candlestick_chart_area]
          Row() {
            StockKLineChart()

            // Stock price details
            StockDealDetails()
          }
          .width('100%')
          .height(new BreakpointType(294, 294, 286, 376, 376).getValue(this.mainWindowInfo.widthBp))
          // [End Stock_candlestick_chart_area]
          .justifyContent(FlexAlign.SpaceBetween)
          .backgroundColor($r('app.color.card_background_color'))
          .padding({
            right: new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp),
            left: new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp)
          })

          // Stock Circle
          Row() {
            Column() {
              CommSlide({
                commSlideData: this.viewModel.otherTitleList,
                tabIndexSelected: this.secondTabIndexSelected
              })
            }
            .width('100%')
            .height(40)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .backgroundColor($r('app.color.card_background_color'))
            .margin({
              top: 4,
              bottom: 8
            })
          }

          // List of stock cards
          Column({ space: 12 }) {
            ForEach(this.cardList, (item: number) => {
              Blank()
                .id(item.toString())
                .width('100%')
                .borderRadius(12)
                .backgroundColor($r('sys.color.comp_background_primary'))
                .height(40 * item)
            }, (item: number, index: number) => (index + item).toString())
          }
          .margin({
            right: new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp),
            left: new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp)
          })
        }
      }
      .backgroundColor($r('sys.color.comp_background_gray'))
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .padding({
        bottom: 8
      })
      .onScrollFrameBegin((offset: number) => {
        if (!this.mainWindowInfo.isSmMdBreakpoint()) {
          if (this.isHiding) {
            this.showToolbars()
          }
          return { offsetRemain: offset };
        }
        if (offset > 0) {
          this.currentYOffset += offset;
          if (this.currentYOffset <= 10) {
            this.topToolbar = this.topToolbar * (1 - this.currentYOffset / 100);
            this.bottomToolbar = this.bottomToolbar * (1 - this.currentYOffset / 100);
            this.barOpacity = 1 - this.currentYOffset / 100;
          } else {
            this.topToolbar = 0;
            this.bottomToolbar = 0;
            this.barOpacity = 0;
            this.topBlank = 0;
          }
          this.isHiding = true;
        }
        if (offset < 0 && this.isHiding) {
          this.showToolbars()
        }
        return { offsetRemain: offset };
      })

      // [Start trading_operation_line]
      // Bottom toolbar
      Row() {
        Row({ space: 24 }) {
          TitleIcon($r('sys.symbol.dot_grid_2x2'), $r('app.string.self_selected_settings'))
          TitleIcon($r('sys.symbol.Investment_stable_value_add'), $r('app.string.stock_pk'))
          TitleIcon($r('sys.symbol.more'), $r('app.string.more'))
        }
        .margin({
          right: new BreakpointType(32, 32, 101, 32, 32).getValue(this.mainWindowInfo.widthBp)
        })

        Blank()
          .visibility((this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_LG ||
            this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_XL) &&
            this.tabletMode === NavigationMode.Stack ? Visibility.None : Visibility.Visible)

        Row() {
          Text($r('app.string.go_trade'))
          // [StartExclude trading_operation_line]
            .fontSize(16)
            .lineHeight(21)
            .fontWeight(500)
            .fontColor($r('sys.color.font_on_primary'))
          // [EndExclude trading_operation_line]
        }
        .layoutWeight(this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_LG ||
          this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_XL ? 0 : 1)
        .width((this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_LG ||
          this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_XL) && this.tabletMode === NavigationMode.Stack ?
          448 : 360)
        .flexShrink(1)
        // [StartExclude trading_operation_line]
        .height(40)
        .borderRadius(this.isPcStockTable ? 8 : 20)
        .justifyContent(FlexAlign.Center)
        .backgroundColor($r('app.color.button_primary_color'))
        .padding({
          top: 2
        })
        // [EndExclude trading_operation_line]
        .onClick(() => {
          this.buyIsShow = false;
          this.popUpBoxIsShow = true;
        })
      }
      // [End trading_operation_line]
      .width('100%')
      .height(this.bottomToolbar)
      .opacity(this.barOpacity)
      .backgroundColor($r('sys.color.ohos_id_color_background'))
      .alignItems(VerticalAlign.Top)
      .justifyContent(this.isPcStockTable ? FlexAlign.SpaceBetween :
        (this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_LG ? FlexAlign.End : FlexAlign.Start))
      .padding({
        top: 6,
        right: new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp),
        left: new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp)
      })
      .margin({ bottom: -6 })
      .border({
        width: { top: 0.5 },
        color: { top: $r('app.color.divider_color') },
        style: { top: BorderStyle.Solid }
      })
    }
    .title('StockDetailsPage')
    .hideTitleBar(true)
    .width('100%')
    .backgroundColor($r('app.color.card_background_color'))
    .padding({
      top: this.mainWindowInfo.isSmMdBreakpoint() ? 0 :
        this.getUIContext().px2vp(this.mainWindowInfo.avoidSystem?.topRect.height)
    })
    .onBackPressed(() => {
      if (this.tabletMode === NavigationMode.Stack) {
        this.tabletMode = NavigationMode.Split;
        return true;
      }
      return false;
    })
    .onReady((context) => {
      this.viewModel.loadData();
      const params = context.pathInfo?.param as StockDetailsParams | undefined;
      if (params?.item) {
        this.stockInForm = params.item as StockForm;
        this.viewModel.setCurrentStockFormByItem(params.item);
      } else if (this.viewModel.currentStockForm) {
        this.stockInForm = this.viewModel.currentStockForm;
      }
      this.isPcStockTable = params?.isPcStockTable ?? false;
    })
  }
}