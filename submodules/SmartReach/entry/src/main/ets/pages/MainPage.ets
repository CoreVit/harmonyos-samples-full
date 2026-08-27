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

import { AppStorageV2, curves, LengthMetrics } from '@kit.ArkUI';
// [Start gesture_change]
import { motion } from '@kit.MultimodalAwarenessKit';
// [StartExclude gesture_change]
import {
  hdsMaterial,
  HdsNavigation,
  HdsNavigationTitleMode,
  HdsTabs,
  HdsTabsController,
  ScrollEffectType,
} from '@kit.UIDesignKit';
import { StorageKey } from '../common/CommonConstants';
import { WaterFlowView } from '../component/WaterFlowView';
import { GlobalInfoModel } from '../model/GlobalInfoModel';
import { SCROLLER_LIST, TabsBarModel } from '../model/TabsBarModel';
import { BreakpointType } from '../util/BreakpointSystem';
import Logger from '../util/Logger';
import { PreferenceManager } from '../util/PreferenceManager';

const NEVER_ALERT_KEY: string = 'NEVER_ALERT';
const TAG: string = '[MainPage]';

@Entry
@ComponentV2
struct MainPage {
  @Local globalInfoModel: GlobalInfoModel =
    AppStorageV2.connect(GlobalInfoModel, StorageKey.GLOBAL_INFO) ?? new GlobalInfoModel();
  private controller: HdsTabsController = new HdsTabsController();
  private tabsBar: BottomTabBarStyle[] = TabsBarModel.getTabBarByPage() ?? [];
  private dialogComponentId?: number;
  private preferenceManager = PreferenceManager.getInstance();
  // [Start gesture_animate]
  @Local floatingAlignRules: AlignRuleOption = {
    right: { anchor: '__container__', align: HorizontalAlign.End },
    bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
  }
  // [End gesture_animate]
  // [EndExclude gesture_change]
  handleHoldingHandChange: Callback<motion.HoldingHandStatus> = (status: motion.HoldingHandStatus) => {
    // [StartExclude gesture_change]
    Logger.info(TAG, `handle on holdingHandChanged:::${status}`);
    // [Start gesture_animate]
    this.getUIContext().animateTo({ curve: curves.interpolatingSpring(0, 1, 288, 30) }, () => {
      if (canIUse('SystemCapability.MultimodalAwareness.Motion')) {
        if (status === motion.HoldingHandStatus.LEFT_HAND_HELD) {
          this.floatingAlignRules = {
            left: { anchor: '__container__', align: HorizontalAlign.Start },
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          };
        } else if (status === motion.HoldingHandStatus.RIGHT_HAND_HELD) {
          this.floatingAlignRules = {
            right: { anchor: '__container__', align: HorizontalAlign.End },
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          };
        }
      }
    });
    // [End gesture_animate]
    // [EndExclude gesture_change]
  }

  aboutToAppear(): void {
    // [StartExclude gesture_change]
    this.showAlert();
    // [EndExclude gesture_change]
    try {
      if (canIUse('SystemCapability.MultimodalAwareness.Motion')) {
        motion.on('holdingHandChanged', this.handleHoldingHandChange);
        Logger.info(TAG, `Succeed handle on holdingHandChanged`);
      } else {
        Logger.error(TAG, `Can not handle on holdingHandChanged`);
      }
    } catch (error) {
      Logger.error(TAG, `Failed on holdingHandChanged. cause${error.message}`);
    }
  }

  aboutToDisappear(): void {
    try {
      if (canIUse('SystemCapability.MultimodalAwareness.Motion')) {
        motion.off('holdingHandChanged', this.handleHoldingHandChange);
      } else {
        Logger.error(TAG, `Can not handle off holdingHandChanged`);
      }
    } catch (error) {
      Logger.error(TAG, `Failed off holdingHandChanged. cause${error.message}`);
    }
  }
  // [StartExclude gesture_change]
  showAlert() {
    try {
      const promptAction = this.getUIContext().getPromptAction();
      promptAction.openCustomDialog({
        builder: () => {
          this.alertBuilder();
        },
        autoCancel: false,
      })
        .then((dialogId: number) => {
          this.dialogComponentId = dialogId;
        })
        .catch((error: BusinessError) => {
          Logger.error(TAG, `show alert failed. cause code: ${error.code}; msg: ${error.message}`);
        });
    } catch (error) {
      Logger.error(TAG, `show alert failed. cause code: ${error.code}; msg: ${error.message}`);
    }
  }

  closeAlert() {
    if (this.dialogComponentId) {
      try {
        this.getUIContext().getPromptAction().closeCustomDialog(this.dialogComponentId);
        this.dialogComponentId = undefined;
      } catch (error) {
        Logger.error(TAG, `close alert failed. cause code: ${error.code}; msg: ${error.message}`);
      }
    }
  }

  @Builder
  alertBuilder() {
    Column() {
      Row() {
        Text($r('app.string.alert_title'))
          .fontSize($r('sys.float.Title_S'))
          .fontColor($r('sys.color.font_primary'))
          .fontWeight(FontWeight.Bold)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .height(56)

      Column() {
        Text($r('app.string.alert_msg'))
          .fontSize($r('sys.float.Subtitle_M'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
          .margin({ top: $r('sys.float.padding_level1') })
      }
      .padding({ left: $r('sys.float.padding_level8'), right: $r('sys.float.padding_level8') })

      Image($r('app.media.ic_smart_reach_alert'))
        .width('70%')
      Column() {
        Text($r('app.string.alert_desc'))
          .fontSize($r('sys.float.Subtitle_S'))
          .fontColor($r('sys.color.font_tertiary'))

        Row({ space: 16 }) {
          Button($r('app.string.okay'))
            .onClick(() => {
              this.closeAlert();
            })
            .buttonStyle(ButtonStyleMode.EMPHASIZED)
            .height(40)
            .width('50%')
        }
        .padding({
          top: $r('sys.float.padding_level4'),
        })
        .justifyContent(FlexAlign.Center)
        .width('100%')
      }
      .padding({
        left: $r('sys.float.padding_level8'),
        top: $r('sys.float.padding_level4'),
        right: $r('sys.float.padding_level8'),
        bottom: $r('sys.float.padding_level8'),
      })
    }
  }

  build() {
    HdsNavigation() {
      // [Start gesture_animate]
      RelativeContainer() {
        // [Start gesture_reach]
        HdsTabs({ controller: this.controller }) {
          // [StartExclude gesture_animate]
          Repeat(this.tabsBar).each((repeatItem: RepeatItem<BottomTabBarStyle>) => {
            TabContent() {
              // [StartExclude gesture_reach]
              WaterFlowView({
                currentTabIndex: repeatItem.index,
              })
              // [EndExclude gesture_reach]
            }
            .tabBar(repeatItem.item)
          })
          // [EndExclude gesture_animate]
        }
        // [StartExclude gesture_animate]
        .width('100%')
        .height('100%')
        .barOverlap(true)
        .vertical(false)
        .barPosition(BarPosition.End)
        .barFloatingStyle({
          adaptToHandedness: true,
          barBottomMargin: this.globalInfoModel.naviIndicatorHeight > 0 ? this.globalInfoModel.naviIndicatorHeight :
            $r('sys.float.padding_level8'),
          // [StartExclude gesture_reach]
          systemMaterialEffect: {
            materialType: hdsMaterial.MaterialType.ADAPTIVE,
            materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE,
          },
          // [EndExclude gesture_reach]
        })
        // [EndExclude gesture_animate]
        // [End gesture_reach]
        Row() {
          SymbolGlyph($r('sys.symbol.square_and_pencil_fill'))
            .fontColor([$r('sys.color.icon_on_primary')])
            .fontSize($r('sys.float.Title_M'))
        }
        .alignRules(this.floatingAlignRules)
        // [StartExclude gesture_animate]
        .margin({
          left: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.globalInfoModel.widthBreakpoint),
          right: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.globalInfoModel.widthBreakpoint),
          bottom: 100,
        })
        .backgroundColor($r('sys.color.background_emphasize'))
        .borderRadius('50%')
        .clip(true)
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width(56)
        .aspectRatio(1)
        // [EndExclude gesture_animate]
      }
      // [End gesture_animate]
    }
    .hideBackButton(true)
    .titleMode(HdsNavigationTitleMode.MINI)
    .mode(NavigationMode.Stack)
    .titleBar({
      content: {
        title: {
          mainTitle: $r('app.string.SmartReachAbility_label'),
        },
      },
      style: {
        scrollEffectOpts: {
          enableScrollEffect: true,
          scrollEffectType: ScrollEffectType.GRADIENT_BLUR,
          blurEffectiveEndOffset: LengthMetrics.vp(64),
        },
        systemMaterialEffect: {
          materialType: hdsMaterial.MaterialType.ADAPTIVE,
          materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE,
        },
      },
      avoidLayoutSafeArea: false,
      enableComponentSafeArea: false,
    })
    .bindToScrollable(SCROLLER_LIST)
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
  }
}
// [EndExclude gesture_change]
// [End gesture_change]