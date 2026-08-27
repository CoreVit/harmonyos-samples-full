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

import { Constants } from '../common/Constants';
import { BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { SubItem } from './SettingItem';

@Component
export struct WlanItem {
  @State netWorkStatus: Resource = $r('app.string.closed');
  @StorageProp(Constants.KEY_BREAKPOINT) currentBreakPoint: string = BreakpointTypeEnum.MD;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(Constants.KEY_NAV_INDICATOR_HEIGHT) navIndicatorHeight: number = 0;
  @Consume(Constants.KEY_PATH_STACK) pageStack: NavPathStack;

  @Builder
  CustomDivider() {
    Divider()
      .strokeWidth('1px')
      .color($r('sys.color.ohos_id_color_list_separator'))
      .margin({ left: $r('sys.float.padding_level4'), right: $r('sys.float.padding_level4') })
  }

  build() {
    NavDestination() {
      Row() {
        if (this.currentBreakPoint === BreakpointTypeEnum.SM) {
          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.chevron_backward'))
              .fontColor([$r('sys.color.icon_primary')])
              .fontSize($r('sys.float.Title_M'))
          }
          .height($r('app.float.button_height'))
          .aspectRatio(1)
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .onClick(() => {
            this.pageStack.pop();
          })
        }
        Text($r('app.string.WLAN'))
          .margin({ left: $r('sys.float.padding_level4') })
          .font({ size: $r('sys.float.Title_S'), weight: FontWeight.Bold })
          .fontColor($r('sys.color.font_primary'))
      }
      .width('100%')
      .height($r('app.float.item_height'))
      .zIndex(2)

      List({ space: Constants.LIST_SPACE }) {
        ListItem() {
          SubItem({ itemDesc: $r('app.string.WLAN'), isShowButton: true })
        }
        .width('100%')
        .borderRadius($r('sys.float.corner_radius_level8'))
        .backgroundColor($r('sys.color.comp_background_primary'))
        .padding({ top: $r('sys.float.padding_level2'), bottom: $r('sys.float.padding_level2') })
        .margin({ top: $r('sys.float.padding_level8') })

        ListItem() {
          SubItem({
            itemDesc: $r('app.string.networkAcceleration'),
            isShowRightArrow: true,
            itemStatusDesc: this.netWorkStatus
          })
        }.width('100%')
        .borderRadius($r('sys.float.corner_radius_level8'))
        .backgroundColor($r('sys.color.comp_background_primary'))
        .padding({ top: $r('sys.float.padding_level2'), bottom: $r('sys.float.padding_level2') })

        ListItem() {
          SubItem({ itemDesc: $r('app.string.moreWLANSettings'), isShowRightArrow: true })
        }.width('100%')
        .borderRadius($r('sys.float.corner_radius_level8'))
        .backgroundColor($r('sys.color.comp_background_primary'))
        .padding({ top: $r('sys.float.padding_level2'), bottom: $r('sys.float.padding_level2') })

        ListItem() {
          Column() {
            Text($r('app.string.wlanConnected'))
              .fontSize($r('sys.float.Body_S'))
              .fontColor($r('sys.color.font_secondary'))
              .width('100%')
              .padding({ left: $r('sys.float.padding_level6') })
            SubItem({
              itemDesc: $r('app.string.wifiName'),
              content: $r('app.string.connected'),
              src: $r('app.media.wlan2'),
              isLinkAddress: true
            })
              .margin({ top: $r('sys.float.padding_level4') })
              .width('100%')
              .borderRadius($r('sys.float.corner_radius_level8'))
              .backgroundColor($r('sys.color.comp_background_primary'))
              .padding({ top: $r('sys.float.padding_level2'), bottom: $r('sys.float.padding_level2') })
          }
        }

        ListItem() {
          Column() {
            Row() {
              Text($r('app.string.wlanUseful'))
                .fontSize($r('sys.float.Body_M'))
                .fontColor($r('sys.color.font_secondary'))
                .width('100%')
                .padding({ left: $r('sys.float.padding_level6') })
            }

            Column() {
              SubItem({
                itemDesc: $r('app.string.wifiName'),
                content: $r('app.string.useful'),
                src: $r('app.media.wlan1')
              })
              this.CustomDivider()
              SubItem({
                itemDesc: $r('app.string.wifiName'),
                content: $r('app.string.useful'),
                src: $r('app.media.wlan2')
              })
              this.CustomDivider()
              SubItem({
                itemDesc: $r('app.string.wifiName'),
                content: $r('app.string.useless'),
                src: $r('app.media.wlan3')
              })
            }
            .width('100%')
            .borderRadius($r('sys.float.corner_radius_level8'))
            .backgroundColor($r('sys.color.comp_background_primary'))
            .padding({ top: $r('sys.float.padding_level2'), bottom: $r('sys.float.padding_level2') })
            .margin({ top: $r('sys.float.padding_level4') })
          }
        }

        ListItem() {
          SubItem({ itemDesc: $r('app.string.addNetWork'), isLinkAddress: true })
        }
        .width('100%')
        .borderRadius($r('sys.float.corner_radius_level8'))
        .backgroundColor($r('sys.color.comp_background_primary'))
        .padding({ top: $r('sys.float.padding_level2'), bottom: $r('sys.float.padding_level2') })
        .margin({ bottom: this.navIndicatorHeight })

      }
      .scrollBar(BarState.Off)
      .width('100%')
      .height('92%')
    }
    .padding({
      left: $r('sys.float.padding_level8'),
      right: $r('sys.float.padding_level8'),
    })
    .hideTitleBar(true)
    .title($r('app.string.WLAN'))
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}