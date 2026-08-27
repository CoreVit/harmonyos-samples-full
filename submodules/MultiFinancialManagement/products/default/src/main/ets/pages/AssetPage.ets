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

import { AppStorageV2, LengthMetrics, uiObserver, window } from '@kit.ArkUI';
import { deviceInfo } from '@kit.BasicServicesKit';
import { BlurStrategy, DividerShowType, hdsMaterial, HdsNavDestination, ScrollEffectType } from '@kit.UIDesignKit';
import { AccountOverviewPanel, DemandDepositSection, InvestmentSection, LiabilitySection } from 'account';
import { CommonConstants, WindowInfo, WindowUtil } from 'financialbase';
import { RecommendNoticeBar } from 'recommend';

@ComponentV2
export struct AssetPage {
  @Local windowUtil: WindowUtil = AppStorageV2.connect(WindowUtil, CommonConstants.WINDOW_UTIL_KEY)!;
  @Local mainWindowInfo: WindowInfo = this.windowUtil.mainWindowInfo;
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack();
  @Env(SystemProperties.BREAK_POINT) breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;

  build() {
    if (deviceInfo.distributionOSApiVersion >= 60100) {
      HdsNavDestination() {
        this.MainContent()
      }
      .titleBar({
        padding: {
          start: LengthMetrics.vp(16),
          end: LengthMetrics.vp(16)
        },
        style: {
          systemMaterialEffect: {
            materialType: hdsMaterial.MaterialType.IMMERSIVE,
            materialLevel: hdsMaterial.MaterialLevel.SMOOTH
          },
          blurStrategy: BlurStrategy.ADAPTIVE,
          scrollEffectOpts: {
            enableScrollEffect: this.breakpoint.widthBreakpoint < WidthBreakpoint.WIDTH_LG ? true : false,
            scrollEffectType: this.breakpoint.widthBreakpoint < WidthBreakpoint.WIDTH_LG ?
              ScrollEffectType.IMMERSIVE_GRADIENT_BLUR : ScrollEffectType.COMMON_BLUR,
            blurEffectiveStartOffset: LengthMetrics.vp(0),
            blurEffectiveEndOffset: LengthMetrics.vp(260)
          },
          originalStyle: {
            backgroundStyle: {
              backgroundColor: $r('sys.color.ohos_id_color_background_transparent'),
            },
            contentStyle: {
              titleStyle: { mainTitleColor: $r('sys.color.font_on_primary') },
              backIconStyle: {
                backgroundColor: $r('sys.color.comp_background_tertiary'),
                iconColor: $r('sys.color.icon_on_primary')
              }
            }
          },
          scrollEffectStyle: {
            backgroundStyle: {
              backgroundColor: $r('sys.color.ohos_id_color_background_transparent'),
            },
            contentStyle: {
              titleStyle: { mainTitleColor: $r('sys.color.font_primary') },
              backIconStyle: {
                backgroundColor: $r('sys.color.comp_background_tertiary'),
                iconColor: $r('sys.color.icon_primary')
              }
            }
          }
        },
        content: {
          title: {
            mainTitle: $r('app.string.account_overview_title')
          },
          backIcon: {
            label: 'backButton',
            icon: $r('sys.symbol.chevron_backward'),
            isEnabled: true,
          },
          divider: { showType: DividerShowType.OFF },
        }
      })
      .hideTitleBar(false)
      .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.ALL])
    } else {
      HdsNavDestination() {
        this.MainContent()
      }
      .titleBar({
        padding: {
          start: LengthMetrics.vp(Math.max(16, this.mainWindowInfo.avoidCutout?.leftRect.width || 0)),
          end: LengthMetrics.vp(16)
        },
        style: {
          blurStrategy: BlurStrategy.DISABLE,
          scrollEffectOpts: {
            enableScrollEffect: true,
            scrollEffectType: ScrollEffectType.GRADUAL_BLUR,
            blurEffectiveStartOffset: LengthMetrics.vp(0),
            blurEffectiveEndOffset: LengthMetrics.vp(260)
          },
          originalStyle: {
            backgroundStyle: {
              backgroundColor: $r('sys.color.ohos_id_color_background_transparent'),
            },
            contentStyle: {
              titleStyle: { mainTitleColor: $r('sys.color.font_on_primary') },
              backIconStyle: {
                backgroundColor: $r('sys.color.comp_background_tertiary'),
                iconColor: $r('sys.color.icon_on_primary')
              }
            }
          },
          scrollEffectStyle: {
            backgroundStyle: {
              backgroundColor: $r('sys.color.ohos_id_color_background_transparent'),
            },
            contentStyle: {
              titleStyle: { mainTitleColor: $r('sys.color.font_primary') },
              backIconStyle: {
                backgroundColor: $r('sys.color.comp_background_tertiary'),
                iconColor: $r('sys.color.icon_primary')
              }
            }
          }
        },
        content: {
          title: {
            mainTitle: $r('app.string.account_overview_title')
          },
          backIcon: {
            label: 'backButton',
            icon: $r('sys.symbol.chevron_backward'),
            isEnabled: true,
          },
          divider: { showType: DividerShowType.OFF },
        }
      })
      .hideTitleBar(false)
      .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.ALL])
    }
  }

  @Builder
  MainContent() {
    Stack() {
      if (this.breakpoint.widthBreakpoint < WidthBreakpoint.WIDTH_LG) {
        Scroll() {
          Column() {
            this.MainLayout()
          }
          .width('100%')
        }
        .align(Alignment.TopStart)
        .scrollBar(BarState.Off)
        .width('100%')
        .height('100%')
        .backgroundColor($r('app.color.background_secondary'))
      } else {
        this.MainLayout()
        if (this.mainWindowInfo.windowStatusType !== window.WindowStatusType.MAXIMIZE &&
          this.mainWindowInfo.windowStatusType !== window.WindowStatusType.FLOATING) {
          this.StatusCover()
        }
      }
    }
    .alignContent(Alignment.TopStart)
    .layoutWeight(1)
  }

  @Builder
  MainLayout() {
    GridRow({ columns: { sm: 4, md: 8, lg: 12 } }) {
      GridCol({ span: { sm: 4, md: 8, lg: 4 } }) {
        AccountOverviewPanel({
          mainWindowInfo: this.mainWindowInfo
        })
      }

      GridCol({ span: { sm: 4, md: 8, lg: 8 } }) {
        if (this.breakpoint.widthBreakpoint >= WidthBreakpoint.WIDTH_LG) {
          Scroll() {
            this.BodyContent()
          }
          .align(Alignment.TopStart)
          .scrollBar(BarState.Off)
          .width('100%')
          .height('100%')
          .background($r('app.color.background_secondary'))
        } else {
          this.BodyContent()
        }
      }
    }
    .width('100%')
  }

  @Builder
  BodyContent() {
    Column({ space: 24 }) {
      if (this.breakpoint.widthBreakpoint >= WidthBreakpoint.WIDTH_LG) {
        DemandDepositSection()
        RecommendNoticeBar({
          radius: 16
        })
        InvestmentSection()
        LiabilitySection()
      } else {
        RecommendNoticeBar()
        DemandDepositSection()
        InvestmentSection()
        LiabilitySection()
      }
    }
    .padding({
      left: CommonConstants.COMMON_PADDING[3].getValue(this.breakpoint.widthBreakpoint),
      right: CommonConstants.COMMON_PADDING[3].getValue(this.breakpoint.widthBreakpoint),
      bottom: Math.max(this.mainWindowInfo.naviIndicatorHeight, 16),
      top: this.breakpoint.widthBreakpoint >= WidthBreakpoint.WIDTH_LG ?
        this.mainWindowInfo.statusBarHeight + 17 : 0
    })
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .expandSafeArea()
    .background($r('app.color.background_secondary'))
  }

  @Builder
  StatusCover() {
    Row() {
    }
    .height(this.mainWindowInfo.statusBarHeight)
    .width('100%')
    .linearGradient({
      colors: [[$r('app.color.black30'), 0.0], [Color.Transparent, 0.9]],
      direction: GradientDirection.Bottom
    })
  }
}
