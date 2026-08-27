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

import { HdsSideBar } from '@kit.UIDesignKit';
import { RecommendationView, BusinessView, WealthSectionView } from 'multimobilepaymentrecommend';
import { PaymentSheetView } from 'multimobilepaymentpay';
import { ScanSheetView, ScanViewModel } from 'multimobilepaymentscan';
import { TabBarModel } from '../model/TabBarModel';
import { TabBarViewModel } from '../viewmodel/TabBarViewModel';
import { CommonConstants, getWindowInfoState, WindowInfo } from 'multimobilepaymentbase';

@Entry
@ComponentV2
struct Index {
  @Local selectedIndex: number = 0;
  @Local isPaymentSheetVisible: boolean = false;
  @Local isScanSheetVisible: boolean = false;
  @Local scanViewModel: ScanViewModel = new ScanViewModel();
  @Local windowInfo: WindowInfo = getWindowInfoState();
  @Local currentSheetType: 'payment' | 'scan' | undefined = undefined;
  @Local isSheetCooldown: boolean = false;
  private tabBarList: TabBarModel[] = new TabBarViewModel().getTabList();

  private openSheet(type: 'payment' | 'scan'): void {
    if (this.isSheetCooldown) {
      return;
    }
    this.currentSheetType = type;
    if (type === 'payment') {
      this.isPaymentSheetVisible = true;
    } else {
      this.isScanSheetVisible = true;
    }
  }

  private startCooldown(): void {
    this.isSheetCooldown = true;
    setTimeout(() => {
      this.isSheetCooldown = false;
    }, CommonConstants.COOLDOWN_DURATION);
  }

  @Builder
  sideBarPanelBuilder() {
    Column({ space: $r('app.float.sidebar_column_space') }) {
      Row({ space: $r('app.float.sidebar_tab_row_space') }) {
        Image($r('app.media.startIcon'))
          .height($r('app.float.sidebar_tab_icon_size'))
        Text($r('app.string.PcAbility_label'))
          .fontSize($r('app.float.sidebar_tab_text_size'))
      }
      .width(CommonConstants.FULL_WIDTH)
      .height($r('app.float.label_height'))
      .padding({ left: $r('app.float.sidebar_tab_padding_left') })

      ForEach(this.tabBarList, (item: TabBarModel, index: number) => {
        Row({ space: $r('app.float.sidebar_tab_row_space') }) {
          SymbolGlyph(item.getIcon())
            .fontSize($r('app.float.sidebar_tab_icon_size'))
            .fontColor([index === this.selectedIndex ? $r('app.color.brand') : $r('app.color.primary60')])

          Text(item.getText())
            .fontColor(index === this.selectedIndex ? $r('app.color.brand') : $r('app.color.primary60'))
            .fontSize($r('app.float.sidebar_tab_text_size'))
            .lineHeight($r('app.float.sidebar_tab_line_height'))
        }
        .width(CommonConstants.FULL_WIDTH)
        .height($r('app.float.sidebar_tab_height'))
        .borderRadius($r('app.float.sidebar_tab_radius'))
        .backgroundColor(index === this.selectedIndex ? $r('app.color.primary5') : Color.Transparent)
        .padding({ left: $r('app.float.sidebar_tab_padding_left') })
        .onClick(() => {
          this.selectedIndex = index;
        })
      }, (item: TabBarModel, index: number) => JSON.stringify(item) + index)
    }
    .height(CommonConstants.FULL_HEIGHT)
    .padding({
      left: $r('app.float.sidebar_padding_horizontal'),
      right: $r('app.float.sidebar_padding_horizontal')
    })
    .backgroundColor($r('app.color.card_background'))
  }

  @Builder
  homeContentBuilder() {
    Scroll() {
      Stack({ alignContent: Alignment.TopStart }) {
        Image($r('app.media.header_background'))
          .width(CommonConstants.FULL_WIDTH)
          .height(CommonConstants.BACKGROUND_IMAGE_HEIGHT + this.windowInfo.statusBarTopVp)
          .objectFit(ImageFit.Fill)

        Column() {
          RecommendationView({
            onPaymentClick: () => {
              this.openSheet('payment');
            },
            onScanClick: () => {
              this.openSheet('scan');
            }
          })

          BusinessView()

          WealthSectionView()
        }
        .padding({ top: $r('app.float.home_content_padding_top') })
      }
      .width(CommonConstants.FULL_WIDTH)
    }
    .padding({
      bottom: $r('app.float.home_scroll_padding_bottom')
    })
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
    .scrollBar(BarState.Off)
    .background(this.windowInfo.widthBp <= WidthBreakpoint.WIDTH_MD ? $r('app.color.on_primary') :
      $r('app.color.gray_01'))
  }

  @Builder
  sheetContentBuilder() {
    if (this.currentSheetType === 'payment') {
      PaymentSheetView({
        isCenterMode: true,
        onClose: () => {
          this.isPaymentSheetVisible = false;
          this.startCooldown();
        }
      })
    } else if (this.currentSheetType === 'scan') {
      ScanSheetView({
        viewModel: this.scanViewModel,
        isCenterMode: true,
        onClose: () => {
          this.isScanSheetVisible = false;
          this.startCooldown();
        },
        onPaymentClick: () => {
          this.currentSheetType = 'payment';
          this.isScanSheetVisible = false;
          this.isPaymentSheetVisible = true;
        }
      })
    }
  }

  @Builder
  placeholderView(title: ResourceStr) {
    Column() {
      Text(title)
        .fontSize($r('app.float.placeholder_title_font_size'))
        .fontColor($r('app.color.text_secondary'))
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  contentPanelBuilder() {
    if (this.selectedIndex === 0) {
      this.homeContentBuilder()
    } else if (this.selectedIndex === 1) {
      this.placeholderView($r('app.string.finance'))
    } else if (this.selectedIndex === 2) {
      this.placeholderView($r('app.string.life'))
    } else if (this.selectedIndex === 3) {
      this.placeholderView($r('app.string.message'))
    } else if (this.selectedIndex === 4) {
      this.placeholderView($r('app.string.mine'))
    }
  }

  build() {
    Column() {
      HdsSideBar({
        sideBarPanelBuilder: (): void => {
          this.sideBarPanelBuilder()
        },
        contentPanelBuilder: (): void => {
          this.contentPanelBuilder()
        }
      })
    }
    .height(CommonConstants.FULL_HEIGHT)
    .width(CommonConstants.FULL_WIDTH)
    .backgroundColor($r('app.color.on_primary'))
    .bindSheet((this.isPaymentSheetVisible || this.isScanSheetVisible) && !this.isSheetCooldown,
      this.sheetContentBuilder(), {
        dragBar: true,
        preferType: 1,
        onWillDisappear: () => {
          this.isPaymentSheetVisible = false;
          this.isScanSheetVisible = false;
          this.currentSheetType = undefined;
          this.startCooldown();
        }
      })
  }
}
