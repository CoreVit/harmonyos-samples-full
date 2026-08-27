/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { dlpAntiPeep } from '@kit.DeviceSecurityKit';
import { deviceInfo } from '@kit.BasicServicesKit';
import { AlertDialog } from '@kit.ArkUI';
import { JSON } from '@kit.ArkTS';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { ItemInfo } from '../common/models/ItemInfo';
import { ConstValues } from '../common/CommonConstants';
import { CustomListItem } from '../view/CustomItemInfo';
import { ContentSubTitle, Title } from '../view/Titles';
import { AntiPeepGuideDialog } from '../view/AntiPeepGuideDialog';
import Logger from '../utils/Logger';
import { WindowUtil } from '../utils/WindowUtil';
import { BreakpointType } from '../utils/BreakpointSystem';
import {
  AntiPeepCallback,
  canUseAntiPeep,
  getAntiPeepInfo,
  isAntiPeepOn,
  listenOffAntiPeepStatus,
  listenOnAntiPeepStatus,
  showSystemMaskLayer,
} from '../utils/AntiPeepUtils';

const TAG = 'Index';

@Entry
@Component
struct Index {
  @State summaryMoney: ResourceStr = ConstValues.MONEY;
  @State summaryEarnings: ResourceStr = ConstValues.BENEFIT;
  @State itemInfos: ItemInfo[] = [new ItemInfo(), new ItemInfo(), new ItemInfo()];
  @State isShowToggle: boolean = false;
  @StorageProp(ConstValues.KEY_BREAK_POINT) curBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @StorageProp(ConstValues.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  private isToggleOpened: boolean = false;
  private isSystemLayerTriggered: boolean = false;
  private isAlertDialogShow: boolean = false;
  private isListenOn: boolean = false;
  private isRequestingAntiPeep: boolean = false;
  private antiPeepTimer: number = -1;
  @State private guideDialogMessage: ResourceStr = $r('app.string.anti_peep_not_enable');
  @State private guideDialogTitle: ResourceStr = $r('app.string.anti_peep_not_enable_title');
  // [Start 4_dlpAntiPeepOn-1]
  private antiPeepCB: AntiPeepCallback = {
    onStatusChanged: async (status: dlpAntiPeep.DlpAntiPeepStatus): Promise<void> => {
      await this.handleAntiPeepStatus(status);
    }
  };
  // [End 4_dlpAntiPeepOn-1]

  private antiPeepGuideDialogController: CustomDialogController = new CustomDialogController({
    builder: AntiPeepGuideDialog({ title: this.guideDialogTitle, message: this.guideDialogMessage }),
    onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
      dismissDialogAction.dismiss();
    },
    alignment: DialogAlignment.Center,
    autoCancel: true,
    cornerRadius: $r('sys.float.padding_level16')
  });

  private alertDialogController: CustomDialogController = new CustomDialogController({
    builder: AlertDialog({
      primaryTitle: $r('app.string.ignore_info_title'),
      content: $r('app.string.ignore_info'),
      primaryButton: {
        value: $r('app.string.Confirm'),
        action: () => {
          this.alertDialogController.close()
        }
      }
    }),
    autoCancel: false
  });

  /**
   * is the privacy information of the item hidden
   * */
  private itemsEnableShow(enableShow: boolean) {
    if (enableShow) {
      this.itemInfos[0].nameString = ConstValues.FLEXIBLE_ACCESS;
      this.itemInfos[0].valueString = ConstValues.MONEY;
      this.itemInfos[0].resultString = ConstValues.BENEFIT;
      this.itemInfos[0].resultColor = $r('sys.color.warning');

      this.itemInfos[1].nameString = ConstValues.STABLE_FINANCIAL_MANAGEMENT;
      this.itemInfos[1].valueString = ConstValues.DEFAULT_MONEY;
      this.itemInfos[1].resultString = ConstValues.DEFAULT_BENEFIT;

      this.itemInfos[2].nameString = ConstValues.ADVANCED_FINANCIAL_MANAGEMENT;
      this.itemInfos[2].valueString = ConstValues.DEFAULT_MONEY;
      this.itemInfos[2].resultString = ConstValues.DEFAULT_BENEFIT;
    } else {
      this.itemInfos[0].nameString = ConstValues.FLEXIBLE_ACCESS;
      this.itemInfos[0].valueString = ConstValues.DEFAULT_HIDE_INFO;
      this.itemInfos[0].resultString = ConstValues.DEFAULT_HIDE_INFO;
      this.itemInfos[0].resultColor = $r('sys.color.warning');

      this.itemInfos[1].nameString = ConstValues.STABLE_FINANCIAL_MANAGEMENT;
      this.itemInfos[1].valueString = ConstValues.DEFAULT_HIDE_INFO;
      this.itemInfos[1].resultString = ConstValues.DEFAULT_HIDE_INFO;

      this.itemInfos[2].nameString = ConstValues.ADVANCED_FINANCIAL_MANAGEMENT;
      this.itemInfos[2].valueString = ConstValues.DEFAULT_HIDE_INFO;
      this.itemInfos[2].resultString = ConstValues.DEFAULT_HIDE_INFO;
    }
  }

  private summaryShow(enableShow: boolean) {
    if (enableShow) {
      this.summaryMoney = ConstValues.MONEY;
      this.summaryEarnings = ConstValues.BENEFIT;
    } else {
      this.summaryMoney = ConstValues.DEFAULT_HIDE_INFO;
      this.summaryEarnings = ConstValues.DEFAULT_HIDE_INFO;
    }
  }

  /**
   * handle screen privacy status
   * */
  // [Start 3_handleAntiPeepStatus_2]
  private async handleAntiPeepStatus(status: dlpAntiPeep.DlpAntiPeepStatus) {
    if (canUseAntiPeep()) {
      switch (status) {
        case dlpAntiPeep.DlpAntiPeepStatus.PASS:
          this.summaryShow(true);
          this.itemsEnableShow(true);
          break;
          // [Start 5_setAntiPeepMaskLayer_1]
        case dlpAntiPeep.DlpAntiPeepStatus.HIDE:
          // [StartExclude 3_handleAntiPeepStatus_2]
          if (this.isShowToggle && this.isToggleOpened) {
            try {
              // The anti-peep overlay has not been triggered yet.
              if (!this.isSystemLayerTriggered && !this.isAlertDialogShow) {
                const id = AppStorage.get(ConstValues.WINDOW_ID_NAME) as number;
                this.isSystemLayerTriggered = await showSystemMaskLayer(id);
                // [StartExclude 5_setAntiPeepMaskLayer_1]
                if (this.isSystemLayerTriggered) {
                  this.antiPeepTimer = setTimeout(() => {
                    if (!this.isAlertDialogShow) {
                      this.isAlertDialogShow = true;
                      this.alertDialogController.open();
                    }
                  }, 0);
                }
              } else {
                // The anti-peep overlay has been triggered.
                Logger.info(TAG, `Ignore HIDE status`);
                // [EndExclude 5_setAntiPeepMaskLayer_1]
              }
            } catch (err) {
              Logger.error(TAG, `Show mask layer error:${JSON.stringify(err)}`);
            }
          }
          // [EndExclude 3_handleAntiPeepStatus_2]
          // [StartExclude 5_setAntiPeepMaskLayer_1]
          this.summaryShow(false);
          this.itemsEnableShow(false);
          // [EndExclude 5_setAntiPeepMaskLayer_1]
          break;
        // [End 5_setAntiPeepMaskLayer_1]
        default:
          this.summaryShow(true);
          this.itemsEnableShow(true);
          break;
      }
    } else {
      return
    }
  }
  // [End 3_handleAntiPeepStatus_2]

  private initAntiPeepStatus() {
    // [Start 3_handleAntiPeepStatus_1]
    // [Start 2_getAntiPeepInfo_1]
    if (canUseAntiPeep()) {
      isAntiPeepOn().then(async (opened) => {
        if (opened) {
          let info = getAntiPeepInfo();
          // [StartExclude 2_getAntiPeepInfo_1]
          this.handleAntiPeepStatus(info);
          // [StartExclude 3_handleAntiPeepStatus_1]
          this.isListenOn = listenOnAntiPeepStatus(this.antiPeepCB);
        } else {
          try {
            const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            if (deviceInfo.sdkApiVersion >= 23) {
              if (this.isRequestingAntiPeep) {
                return;
              }
              this.isRequestingAntiPeep = true;
              try {
                // [Start 0_requestAntiPeepOptions]
                // Request the system to obtain the configuration options for anti-peeping protection
                const result = await dlpAntiPeep.requestAntiPeepOptions(context);
                // [End 0_requestAntiPeepOptions]
                if (result === dlpAntiPeep.AntiPeepOptionsResult.SUCCESS ||
                  result === dlpAntiPeep.AntiPeepOptionsResult.ALREADY_ON) {
                  let info = getAntiPeepInfo();
                  this.handleAntiPeepStatus(info);
                  this.isListenOn = listenOnAntiPeepStatus(this.antiPeepCB);
                }
              } catch (error) {
                let err = error as BusinessError;
                if (err.code === 1020600004) {
                  this.guideDialogTitle = $r('app.string.anti_peep_face_not_enable_title');
                  this.guideDialogMessage = $r('app.string.anti_peep_face_not_enable');
                  this.antiPeepGuideDialogController.open();
                }
              } finally {
                this.isRequestingAntiPeep = false;
              }
            } else {
              this.antiPeepGuideDialogController.open();
            }
          } catch (error) {
            Logger.info(TAG, `show toast error:${JSON.stringify(error)}}`);
          }
          // [EndExclude 3_handleAntiPeepStatus_1]
          // [EndExclude 2_getAntiPeepInfo_1]
        }
      }).catch((error: BusinessError) => {
        Logger.error(TAG, `initAntiPeepStatus failed: ${JSON.stringify(error)}`);
      })
      // [StartExclude 2_getAntiPeepInfo_1]
      // [StartExclude 3_handleAntiPeepStatus_1]
    } else {
      try {
        this.getUIContext().getPromptAction().showToast({
          message: $r('app.string.device_not_supported')
        });
      } catch (error) {
        Logger.info(TAG, `show toast error:${JSON.stringify(error)}}`);
      }
      // [EndExclude 3_handleAntiPeepStatus_1]
      // [EndExclude 2_getAntiPeepInfo_1]
    }
    // [End 2_getAntiPeepInfo_1]
    // [End 3_handleAntiPeepStatus_1]
  }

  private initShowToggle() {
    this.isShowToggle = deviceInfo.sdkApiVersion >= 22;
  }

  private initData() {
    this.itemsEnableShow(true);
    this.summaryShow(true);
    this.initAntiPeepStatus();
    this.initShowToggle();
  }

  private showDivider(itemInfos: ItemInfo[], index: number) {
    if (this.curBp === WidthBreakpoint.WIDTH_SM) {
      return index < this.itemInfos.length - 1;
    } else if(this.curBp === WidthBreakpoint.WIDTH_MD) {
      return this.itemInfos.length % 2 === 0 ? index < this.itemInfos.length - 2 : index < this.itemInfos.length - 1;
    }
    return index < this.itemInfos.length - 1;
  }

  onPageShow(): void {
    this.initData();
  }

  onPageHide(): void {
    clearTimeout(this.antiPeepTimer);
    this.isSystemLayerTriggered = false;
    this.isAlertDialogShow = false;
    this.alertDialogController.close();
    this.antiPeepGuideDialogController.close();
  }

  // [Start 6_dlpAntiPeepOff_1]
  aboutToDisappear(): void {
    clearTimeout(this.antiPeepTimer);
    if (this.isListenOn) {
      listenOffAntiPeepStatus();
      this.isListenOn = false;
    }
    // [StartExclude 6_dlpAntiPeepOff_1]
    WindowUtil.unregisterBreakPoint();
    // [EndExclude 6_dlpAntiPeepOff_1]
  }
  // [End 6_dlpAntiPeepOff_1]

  build() {
    Scroll() {
      Column() {
        Title()
        Column() {
          ContentSubTitle()
          Row() {
            Text($r('app.string.my_assets'))
              .fontSize($r('app.float.size_14fp'))
              .height($r('app.float.size_19vp'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_on_secondary'))
            Blank()
            Text($r('app.string.yesterday_earnings'))
              .fontSize($r('app.float.size_14fp'))
              .height($r('app.float.size_19vp'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_on_secondary'))
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
          .padding({
            left: $r('app.float.size_12vp'),
            top: $r('app.float.size_16vp'),
            right: $r('app.float.size_12vp')
          })

          Row() {
            Text(this.summaryMoney)
              .fontSize($r('app.float.size_24fp'))
              .fontWeight(FontWeight.Regular)
              .fontColor($r('sys.color.font_on_primary'))
              .height($r('app.float.size_32vp'))
            Blank()
            Text(this.summaryEarnings)
              .fontSize($r('app.float.size_24fp'))
              .fontColor($r('sys.color.font_on_primary'))
              .fontWeight(FontWeight.Regular)
              .height($r('app.float.size_32vp'))
          }
          .justifyContent(FlexAlign.Start)
          .width('100%')
          .padding({
            left: $r('app.float.size_12vp'),
            bottom: $r('app.float.size_16vp'),
            right: $r('app.float.size_12vp')
          })

          Grid() {
            ForEach(this.itemInfos, (itemInfo: ItemInfo, index: number) => {
              GridItem() {
                Column() {
                  CustomListItem({
                    itemInfo: this.itemInfos[index]
                  })
                  if (this.showDivider(this.itemInfos, index)) {
                    Divider().height('1px')
                  }
                }
                .padding({
                  left: $r('app.float.size_12vp'),
                  right: $r('app.float.size_12vp')
                })
              }
            }, (itemInfo: ItemInfo, index: number) => {
              return itemInfo.nameString + index.toString();
            })
          }
          .columnsTemplate([WidthBreakpoint.WIDTH_MD,  WidthBreakpoint.WIDTH_LG].includes(this.curBp) ? '1fr 1fr' : '1fr')
          .columnsGap($r('app.float.size_12vp'))
          .backgroundColor($r('sys.color.background_primary'))
          .padding({
            top: $r('app.float.size_4vp'),
            bottom: $r('app.float.size_4vp')
          })
          .borderRadius($r('app.float.size_16vp'))
          .margin({
            top: $r('app.float.size_8vp'),
          })

          if (this.isShowToggle) {
            Row() {
              Text($r('app.string.privacy_screen'))
                .fontSize($r('app.float.size_16fp'))
                .fontWeight(FontWeight.Medium)
                .height($r('app.float.size_21vp'))
                .fontColor($r('sys.color.font_primary'))
              Blank()
              Toggle({ type: ToggleType.Switch, isOn: false })
                .selectedColor($r('sys.color.comp_background_emphasize'))
                .switchPointColor($r('sys.color.font_on_primary'))
                .onChange((isOn: boolean) => {
                  this.isToggleOpened = isOn;
                })
            }
            .constraintSize({
              minHeight: $r('app.float.size_56vp')
            })
            .width('100%')
            .backgroundColor($r('sys.color.comp_background_primary'))
            .padding({
              left: $r('app.float.size_12vp'),
              right: $r('app.float.size_12vp'),
            })
            .borderRadius($r('app.float.size_16vp'))
            .margin({
              top: $r('app.float.size_12vp'),
            })
          }
        }
        .backgroundColor($r('app.color.bg_money_main'))
        .borderRadius($r('app.float.content_margin'))
        .padding({
          left: $r('app.float.content_padding'),
          right: $r('app.float.content_padding'),
          bottom: $r('app.float.content_padding')
        })
        .margin({
          top: $r('app.float.size_8vp')
        })
      }
      .backgroundColor($r('sys.color.background_secondary'))
      .padding({ top: this.statusBarHeight })
      .margin({
        left: new BreakpointType({
          sm: $r('sys.float.margin_level1'),
          md: $r('sys.float.margin_level2'),
          lg: $r('sys.float.margin_level3')
        }).getValue(this.curBp),
        right: new BreakpointType({
          sm: $r('sys.float.margin_level1'),
          md: $r('sys.float.margin_level2'),
          lg: $r('sys.float.margin_level3')
        }).getValue(this.curBp),
      })
      .constraintSize({
        minHeight: '100%'
      })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('sys.color.background_secondary'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}