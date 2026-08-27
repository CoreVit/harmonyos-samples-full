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
import { ProductDetailContent } from 'multishoppingproduct';
import { HdsNavDestination } from '@kit.UIDesignKit';
import { PayCard } from 'multishoppingpay';
import { SymbolGlyphModifier, uiObserver } from '@kit.ArkUI';
import { WidthBreakpointType } from 'multishoppingbase';
import { AbilityConstant, common, StartOptions, Want } from '@kit.AbilityKit';
import { deviceInfo } from '@kit.BasicServicesKit';

@ComponentV2
export struct ProductDetail {
  @Env(SystemProperties.BREAK_POINT) public breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Consumer('mainPageMap') private navPathStack: NavPathStack = new NavPathStack();
  @Local public isSplitMode: boolean = false;
  @Local public isDialogOpen: boolean = false;
  @Local public detailType: string = 'detailPayCard';
  private context: Context = this.getUIContext().getHostContext()!;
  private abilityName: string = (this.context as common.UIAbilityContext).abilityInfo.name;
  @Local public toolItems: Array<ToolbarItem> = [
    {
      value: 'toolItem2',
      symbolIcon: new SymbolGlyphModifier($r('sys.symbol.card_migration')),
      action: () => {
      }
    }
  ]

  @Builder
  private paySheetBody() {
    Column() {
      PayCard({
        isOpen: this.isDialogOpen,
        detailType: this.detailType,
        widthBp: this.breakpoint.widthBreakpoint,
        onIsOpenChange: (v: boolean) => {
          this.isDialogOpen = v;
        },
        onDetailTypeChange: (v: string) => {
          this.detailType = v;
        }
      })
    }
    // .padding({ top: 16, bottom:8 })
    .width('100%')
    .height('100%')
  }

  build() {
    if (deviceInfo.distributionOSApiVersion >= 60100) {
      HdsNavDestination() {
        ProductDetailContent({
          mainPageMap: this.navPathStack,
          onBuyClick: () => {
            this.detailType = 'detailPayCard';
            this.isDialogOpen = true;
          }
        })
          .bindSheet($$this.isDialogOpen, this.paySheetBody(), {
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
      }
      .titleBar({
        style: {
          originalStyle: {
            backgroundStyle: {
              backgroundColor: $r('app.color.title_bar_clear')
            },
            contentStyle: {
              backIconStyle: {
                backgroundColor: $r('app.color.title_bar_button_bg')
              },
              menuStyle: {
                backgroundColor: $r('app.color.title_bar_button_bg')
              },
            }
          }
        },
        content: {
          menu: {
            value: [{
              content: {
                label: 'menu1',
                icon: $r('sys.symbol.dot_grid_2x2'),
                isEnabled: true,
              }
            }, {
              content: {
                label: 'menu2',
                icon: $r('sys.symbol.rectangle_split_2x1'),
                isEnabled: true,
                action: () => {
                  if (!this.isSplitMode) {
                    let want: Want = {
                      bundleName: 'com.example.multishoppingpricecomparison',
                      abilityName: 'ShopSecondAbility'
                    };
                    let options: StartOptions = {
                      windowMode: AbilityConstant.WindowMode.WINDOW_MODE_SPLIT_PRIMARY
                    };
                    (this.context as common.UIAbilityContext).startAbility(want, options).catch(() => {
                    });
                  } else if (this.abilityName === 'ShopSecondAbility') {
                    (this.context as common.UIAbilityContext).terminateSelf().catch(() => {
                    });
                  }
                }
              }
            }]
          },
        },
        enableComponentSafeArea: new WidthBreakpointType(false, false, true,
          true).getValue(this.breakpoint.widthBreakpoint)
      })
    } else {
      NavDestination() {
        ProductDetailContent({
          mainPageMap: this.navPathStack,
          onBuyClick: () => {
            this.detailType = 'detailPayCard';
            this.isDialogOpen = true;
          }
        })
          .bindSheet($$this.isDialogOpen, this.paySheetBody(), {
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
      }
    }
  }
}
