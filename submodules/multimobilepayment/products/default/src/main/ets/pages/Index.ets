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

import { deviceInfo } from '@kit.BasicServicesKit';
import { hdsMaterial, HdsTabs, HdsTabsController } from '@kit.UIDesignKit';
import {
  WidthBreakpointType,
  CommonConstants,
  WindowInfo,
  getWindowInfoState,
  WindowUtil
} from 'multimobilepaymentbase';
import { HomeContentView } from '../view/HomeContentView';
import { PaymentSheetView } from 'multimobilepaymentpay';
import { ScanSheetView, ScanViewModel } from 'multimobilepaymentscan';
import { TabBarModel } from '../model/TabBarModel';
import { TabBarViewModel } from '../viewmodel/TabBarViewModel';
import { AppStorageV2 } from '@kit.ArkUI';

@Entry
@ComponentV2
struct Index {
  @Local selectedIndex: number = 0;
  @Local isPaymentSheetVisible: boolean = false;
  @Local isScanSheetVisible: boolean = false;
  @Local scanViewModel: ScanViewModel = new ScanViewModel();
  @Local currentSheetType: 'payment' | 'scan' | undefined = undefined;
  @Local windowInfo: WindowInfo = getWindowInfoState();
  @Local isSheetCooldown: boolean = false;
  @Local windowUtil: WindowUtil = AppStorageV2.connect(WindowUtil, CommonConstants.KEY_WINDOWUTIL)!;
  private controller: HdsTabsController = new HdsTabsController();
  private tabBarList: TabBarModel[] = new TabBarViewModel().getTabList();

  private openSheet(type: 'payment' | 'scan'): void {
    if (this.isSheetCooldown) {
      this.windowUtil.getUIContext()?.showAlertDialog({
        message: $r('app.string.alert_dialog_message_calm')
      });
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
  tabBuilder(index: number) {
    Column() {
      SymbolGlyph(this.tabBarList[index].getIcon())
        .fontSize($r('app.float.tab_image_size'))
        .fontColor([index === this.selectedIndex ? $r('app.color.brand') : $r('app.color.primary90')])
      Text(this.tabBarList[index].getText())
        .fontColor(index === this.selectedIndex ? $r('app.color.brand') : $r('app.color.primary90'))
        .fontSize($r('app.float.tab_font_size'))
        .lineHeight($r('app.float.tab_font_line_height'))
        .margin({ top: $r('app.float.tab_space') })
    }
    .justifyContent(FlexAlign.Center)
    .height(CommonConstants.FULL_HEIGHT)
  }

  @Builder
  placeholderView(title: ResourceStr) {
    Column() {
      Text(title)
        .fontSize($r('app.float.place_holder_font_size'))
        .fontColor($r('app.color.text_secondary'))
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  sheetContentBuilder() {
    if (this.currentSheetType === 'payment') {
      PaymentSheetView({
        isCenterMode: new WidthBreakpointType(false, true, true, true).getValue(this.windowInfo.widthBp),
        onClose: () => {
          this.isPaymentSheetVisible = false;
          this.startCooldown();
        }
      })
    } else if (this.currentSheetType === 'scan') {
      ScanSheetView({
        viewModel: this.scanViewModel,
        isCenterMode: new WidthBreakpointType(false, true, true, true).getValue(this.windowInfo.widthBp),
        onClose: () => {
          this.isScanSheetVisible = false;
          this.startCooldown();
        },
        onPaymentClick: () => {
          this.isScanSheetVisible = false;
          this.currentSheetType = 'payment';
          this.isPaymentSheetVisible = true;
        }
      })
    }
  }

  build() {
    Column() {
      if (deviceInfo.distributionOSApiVersion >= 60100) {
        HdsTabs({ controller: this.controller }) {
          TabContent() {
            HomeContentView({
              onPaymentClick: () => {
                this.openSheet('payment');
              },
              onScanClick: () => {
                this.openSheet('scan');
              }
            })
          }
          .tabBar(this.tabBuilder(0))

          TabContent() {
            this.placeholderView(this.tabBarList[1].getText())
          }
          .tabBar(this.tabBuilder(1))

          TabContent() {
            this.placeholderView(this.tabBarList[2].getText())
          }
          .tabBar(this.tabBuilder(2))

          TabContent() {
            this.placeholderView(this.tabBarList[3].getText())
          }
          .tabBar(this.tabBuilder(3))

          TabContent() {
            this.placeholderView(this.tabBarList[4].getText())
          }
          .tabBar(this.tabBuilder(4))
        }
        .barOverlap(true)
        .vertical(false)
        .barFloatingStyle({
          barBottomMargin: (this.windowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
            this.windowInfo.heightBp <= HeightBreakpoint.HEIGHT_MD) ? 16 : this.windowInfo.navigationBarBottomVp,
          systemMaterialEffect: {
            materialType: hdsMaterial.MaterialType.IMMERSIVE,
            materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE
          }
        })
        .barHeight($r('app.float.bar_height'))
        .barPosition(BarPosition.End)
        .onSelected((index: number) => {
          this.selectedIndex = index;
        })
        .height(CommonConstants.FULL_HEIGHT)
        .width(CommonConstants.FULL_WIDTH)
      } else {
        Tabs({ controller: this.controller }) {
          TabContent() {
            HomeContentView({
              onPaymentClick: () => {
                this.openSheet('payment');
              },
              onScanClick: () => {
                this.openSheet('scan');
              }
            })
          }
          .tabBar(this.tabBuilder(0))

          TabContent() {
            this.placeholderView(this.tabBarList[1].getText())
          }
          .tabBar(this.tabBuilder(1))

          TabContent() {
            this.placeholderView(this.tabBarList[2].getText())
          }
          .tabBar(this.tabBuilder(2))

          TabContent() {
            this.placeholderView(this.tabBarList[3].getText())
          }
          .tabBar(this.tabBuilder(3))

          TabContent() {
            this.placeholderView(this.tabBarList[4].getText())
          }
          .tabBar(this.tabBuilder(4))
        }
        .barOverlap(true)
        .vertical(false)
        .barHeight($r('app.float.bar_height'))
        .barPosition(BarPosition.End)
        .onChange((index: number) => {
          this.selectedIndex = index;
        })
        .height(CommonConstants.FULL_HEIGHT)
        .width(CommonConstants.FULL_WIDTH)
      }
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
    .backgroundColor($r('app.color.on_primary'))
    .bindSheet((this.isPaymentSheetVisible || this.isScanSheetVisible) && !this.isSheetCooldown,
      this.sheetContentBuilder(), {
        detents: [SheetSize.FIT_CONTENT],
        dragBar: true,
        preferType: new WidthBreakpointType(SheetType.CONTENT_COVER, SheetType.CENTER, SheetType.CENTER,
          SheetType.CENTER).getValue(this.windowInfo.widthBp),
        onDisappear: () => {
          this.isPaymentSheetVisible = false;
          this.isScanSheetVisible = false;
          this.currentSheetType = undefined;
          this.startCooldown();
        }
      })
  }
}