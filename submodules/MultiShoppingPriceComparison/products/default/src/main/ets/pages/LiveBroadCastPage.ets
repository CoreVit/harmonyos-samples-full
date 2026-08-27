/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { LiveBroadCast, LiveHeader } from 'multishoppinglive';
import { PayCard, ShopBag } from 'multishoppingpay';
import { uiObserver } from '@kit.ArkUI';
import { PipWindowUtil, WidthBreakpointType } from 'multishoppingbase';
import { HdsNavDestination } from '@kit.UIDesignKit';
import { deviceInfo } from '@kit.BasicServicesKit';

@ComponentV2
export struct LiveBroadCastPage {
  private static readonly LIVE_NAVIGATION_ID: string = 'navid';
  @Env(SystemProperties.BREAK_POINT) public breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Consumer('mainPageMap') public mainPageMap: NavPathStack = new NavPathStack();
  @Local public isDialogOpen: boolean = false;
  @Local public isMoreDetail: boolean = true;
  @Local public panelType: string = 'ShopBag';
  private pipWindowUtil: PipWindowUtil | undefined = PipWindowUtil.getPipWindowUtil(this.getUIContext());

  aboutToDisappear(): void {
    if (this.pipWindowUtil === undefined) {
      return;
    }
    this.pipWindowUtil.stopPip();
  }

  private isSideMode(): boolean {
    const bp = this.breakpoint.widthBreakpoint;
    return bp === WidthBreakpoint.WIDTH_MD || bp === WidthBreakpoint.WIDTH_LG || bp === WidthBreakpoint.WIDTH_XL;
  }

  private getLiveRenderWidthBp(): WidthBreakpoint {
    if (this.isDialogOpen && this.isSideMode()) {
      return new WidthBreakpointType(WidthBreakpoint.WIDTH_SM, WidthBreakpoint.WIDTH_SM, WidthBreakpoint.WIDTH_MD,
        WidthBreakpoint.WIDTH_MD)
        .getValue(this.breakpoint.widthBreakpoint);
    }
    return this.breakpoint.widthBreakpoint;
  }

  private onLiveClose(): void {
    if (this.pipWindowUtil !== undefined) {
      const hostContext: Context | undefined = this.getUIContext().getHostContext() as Context | undefined;
      if (hostContext !== undefined) {
        this.pipWindowUtil.startPip(
          LiveBroadCastPage.LIVE_NAVIGATION_ID,
          this.pipWindowUtil.getXComponentController(),
          hostContext,
          this.mainPageMap
        );
        return;
      }
    }
    this.mainPageMap.pop();
  }

  @Builder
  private payCardButton() {
    Text($r('app.string.LIVE_PAGE_BUY_NOW'))
      .padding({
        left: 12,
        right: 12
      })
      .height(28)
      .fontColor($r('sys.color.font_on_primary'))
      .border({ radius: 14 })
      .fontSize(12)
      .backgroundColor('#CF0A2C')
      .textAlign(TextAlign.Center)
      .displayPriority(3)
      .onClick(() => {
        this.panelType = 'detailPayCard';
        this.isDialogOpen = true;
      })
  }

  @Builder
  private panelContent() {
    Column() {
      ShopBag({
        widthBp: this.breakpoint.widthBreakpoint,
        isMoreDetail: this.isMoreDetail,
        onIsMoreDetailChange: (value: boolean) => {
          this.isMoreDetail = value;
          if (!value) {
            this.isDialogOpen = false;
          }
        },
        payCardButton: () => {
          this.payCardButton();
        }
      })
        .visibility(this.panelType === 'ShopBag' ? Visibility.Visible : Visibility.None)

      PayCard({
        isOpen: this.isDialogOpen,
        detailType: this.panelType,
        widthBp: this.breakpoint.widthBreakpoint,
        onIsOpenChange: (value: boolean) => {
          this.isDialogOpen = value;
        },
        onDetailTypeChange: (value: string) => {
          this.panelType = value;
          if (value === 'ShopBag') {
            this.isDialogOpen = true;
          }
        }
      })
        .visibility(this.panelType === 'detailPayCard' ? Visibility.Visible : Visibility.None)
    }
    .padding({ top: 8 })
    .width('100%')
    .height('100%')
  }

  @Builder
  private sidePanel() {
    Column() {
      this.panelContent()
    }
    .width('50%')
    .height('100%')
    .background($r('app.color.surface_secondary'))
  }

  build() {
    if (deviceInfo.distributionOSApiVersion >= 60100) {
      HdsNavDestination() {
        if (this.isSideMode()) {
          Row() {
            Column() {
              LiveHeader({
                widthBp: this.getLiveRenderWidthBp(),
                onClose: () => {
                  this.onLiveClose();
                }
              })
              LiveBroadCast({
                widthBp: this.getLiveRenderWidthBp(),
                onOpenShopBag: () => {
                  this.panelType = 'ShopBag';
                  this.isMoreDetail = true;
                  this.isDialogOpen = true;
                },
                onClose: () => {
                  this.onLiveClose();
                }
              })
                .layoutWeight(1)
            }
            .width(this.isDialogOpen ? '50%' : '100%')
            .height('100%')
            .background($r('app.color.live_stage_background'))

            if (this.isDialogOpen) {
              this.sidePanel()
            }
          }
          .width('100%')
          .height('100%')
        } else {
          Column() {
            LiveHeader({
              widthBp: this.getLiveRenderWidthBp(),
              onClose: () => {
                this.onLiveClose();
              }
            })
            LiveBroadCast({
              widthBp: this.getLiveRenderWidthBp(),
              onOpenShopBag: () => {
                this.panelType = 'ShopBag';
                this.isMoreDetail = true;
                this.isDialogOpen = true;
              },
              onClose: () => {
                this.onLiveClose();
              }
            })
              .layoutWeight(1)
          }
          .bindSheet($$this.isDialogOpen, this.panelContent(), {
            height: '620vp',
            preferType: SheetType.CENTER,
            dragBar: false,
            enableOutsideInteractive: false,
            onDisappear: () => {
              this.isDialogOpen = false;
            },
            showClose: false,
            backgroundColor: $r('app.color.surface_secondary')
          })
          .width('100%')
          .height('100%')
        }
      }
      .id(LiveBroadCastPage.LIVE_NAVIGATION_ID)
      .hideTitleBar(true)
      .systemTransition(NavigationSystemTransitionType.NONE)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      .background($r('app.color.live_stage_background'))
      .width('100%')
      .height('100%')
    } else {
      NavDestination() {
        if (this.isSideMode()) {
          Row() {
            Column() {
              LiveHeader({
                widthBp: this.getLiveRenderWidthBp(),
                onClose: () => {
                  this.onLiveClose();
                }
              })
              LiveBroadCast({
                widthBp: this.getLiveRenderWidthBp(),
                onOpenShopBag: () => {
                  this.panelType = 'ShopBag';
                  this.isMoreDetail = true;
                  this.isDialogOpen = true;
                },
                onClose: () => {
                  this.onLiveClose();
                }
              })
                .layoutWeight(1)
            }
            .width(this.isDialogOpen ? '50%' : '100%')
            .height('100%')
            .background($r('app.color.live_stage_background'))

            if (this.isDialogOpen) {
              this.sidePanel()
            }
          }
          .width('100%')
          .height('100%')
        } else {
          Column() {
            LiveHeader({
              widthBp: this.getLiveRenderWidthBp(),
              onClose: () => {
                this.onLiveClose();
              }
            })
            LiveBroadCast({
              widthBp: this.getLiveRenderWidthBp(),
              onOpenShopBag: () => {
                this.panelType = 'ShopBag';
                this.isMoreDetail = true;
                this.isDialogOpen = true;
              },
              onClose: () => {
                this.onLiveClose();
              }
            })
              .layoutWeight(1)
          }
          .bindSheet($$this.isDialogOpen, this.panelContent(), {
            height: '620vp',
            preferType: SheetType.CENTER,
            dragBar: false,
            enableOutsideInteractive: false,
            onDisappear: () => {
              this.isDialogOpen = false;
            },
            showClose: false,
            backgroundColor: $r('app.color.surface_secondary')
          })
          .width('100%')
          .height('100%')
        }
      }
      .id(LiveBroadCastPage.LIVE_NAVIGATION_ID)
      .hideTitleBar(true)
      .systemTransition(NavigationSystemTransitionType.NONE)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      .background($r('app.color.live_stage_background'))
      .width('100%')
      .height('100%')
    }
  }
}