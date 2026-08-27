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
import { MainItem } from '../component/SettingItem';
import { WlanItem } from '../component/WlanItem';
import { BreakpointTypeEnum } from '../utils/BreakpointSystem';

@Builder
export function SettingsBuilder() {
  SettingsView();
}

@Component
export struct SettingsView {
  @State pathInfo: NavPathStack = new NavPathStack();
  @StorageProp(Constants.KEY_BREAKPOINT) currentBreakPoint: string = BreakpointTypeEnum.MD;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(Constants.KEY_NAV_INDICATOR_HEIGHT) navIndicatorHeight: number = 0;

  @Builder
  myRouter(name: string) {
    if (name === 'wlan') {
      WlanItem()
    }
  }

  @Builder
  CustomDivider() {
    Divider()
      .strokeWidth(0.5)
      .color($r('sys.color.ohos_id_color_list_separator'))
      .margin({ left: $r('sys.float.padding_level4'), right: $r('sys.float.padding_level4') })
  }

  aboutToAppear() {
    this.pathInfo.pushPath({ name: 'wlan' });
  }

  build() {
    NavDestination() {
      GridRow() {
        GridCol({ span: Constants.GRID_SPACE }) {
          Navigation(this.pathInfo) {
            List({ space: Constants.GRID_SPACE }) {
              ListItem() {
                Search({ placeholder: $r('app.string.search') })
                  .backgroundColor($r('sys.color.comp_background_primary'))
                  .margin({ top: $r('sys.float.padding_level8') })
              }
              .width('100%')

              ListItem() {
                MainItem({ isUserItem: true, src: $r('app.media.ic_mine_normal') })
                  .backgroundColor($r('sys.color.comp_background_primary'))
                  .borderRadius($r('sys.float.corner_radius_level8'))
                  .padding({ top: $r('sys.float.padding_level6'), bottom: $r('sys.float.padding_level6') })
              }

              ListItem() {
                Column() {
                  MainItem({
                    itemDesc: $r('app.string.WLAN'),
                    src: $r('app.media.wlan'),
                    itemStatusDesc: $r('app.string.closed')
                  })
                  this.CustomDivider()
                  MainItem({
                    itemDesc: $r('app.string.bluetooth'),
                    src: $r('app.media.blueTooth'),
                    itemStatusDesc: $r('app.string.closed')
                  })
                  this.CustomDivider()
                  MainItem({ itemDesc: $r('app.string.mobileData'), src: $r('app.media.mobileData') })
                  this.CustomDivider()
                  MainItem({
                    itemDesc: $r('app.string.moreConnections'),
                    src: $r('app.media.ic_settings_more_connections')
                  })
                }.width('100%')
                .borderRadius($r('sys.float.corner_radius_level8'))
                .backgroundColor($r('sys.color.comp_background_primary'))
                .padding({ top: $r('sys.float.padding_level2'), bottom: $r('sys.float.padding_level2') })
              }

              ListItem() {
                Column() {
                  MainItem({ itemDesc: $r('app.string.desktopAndWallpaper'), src: $r('app.media.desk') })
                  this.CustomDivider()
                  MainItem({
                    itemDesc: $r('app.string.displayAndBrightness'),
                    src: $r('app.media.displayAndBrightness')
                  })
                }.width('100%')
                .borderRadius($r('sys.float.corner_radius_level8'))
                .backgroundColor($r('sys.color.comp_background_primary'))
                .padding({ top: $r('sys.float.padding_level2'), bottom: $r('sys.float.padding_level2') })
              }

              ListItem() {
                Column() {
                  MainItem({ itemDesc: $r('app.string.soundAndVibration'), src: $r('app.media.volume') })
                  this.CustomDivider()
                  MainItem({ itemDesc: $r('app.string.notice'), src: $r('app.media.notify') })
                  this.CustomDivider()
                  MainItem({ itemDesc: $r('app.string.storage'), src: $r('app.media.storage') })
                  this.CustomDivider()
                  MainItem({ itemDesc: $r('app.string.safe'), src: $r('app.media.security') })
                  this.CustomDivider()
                  MainItem({ itemDesc: $r('app.string.privacy'), src: $r('app.media.privacy') })
                }.width('100%')
                .borderRadius($r('sys.float.corner_radius_level12'))
                .backgroundColor($r('sys.color.comp_background_primary'))
                .padding({ top: $r('sys.float.padding_level2'), bottom: $r('sys.float.padding_level2') })
              }

              ListItem() {
                Column() {
                  MainItem({ itemDesc: $r('app.string.userAccounts'), src: $r('app.media.userAccounts') })
                  this.CustomDivider()
                  MainItem({ itemDesc: $r('app.string.system'), src: $r('app.media.system') })
                  this.CustomDivider()
                  MainItem({ itemDesc: $r('app.string.aboutDevice'), src: $r('app.media.aboutDevice') })
                }.width('100%')
                .borderRadius($r('sys.float.corner_radius_level8'))
                .backgroundColor($r('sys.color.comp_background_primary'))
                .padding($r('sys.float.padding_level2'))
              }
              .margin({
                bottom: this.navIndicatorHeight === 0 ? Constants.PADDING_BOTTOM_INDEX : this.navIndicatorHeight
              })
            }
            .scrollBar(BarState.Off)
            .width('100%')
            .height('100%')
            .padding({
              left: $r('sys.float.padding_level8'),
              right: $r('sys.float.padding_level8')
            })
          }
          .navBarWidth($r('app.float.setting_navBar_width'))
          .title($r('app.string.settings'))
          .titleMode(NavigationTitleMode.Mini)
          .backgroundColor($r('sys.color.background_secondary'))
          .width('100%')
          .height('100%')
          .navDestination(this.myRouter)
        }
      }
      .borderWidth({ right: 0.5 })
      .borderColor({ right: $r('sys.color.comp_divider') })
    }
    .hideTitleBar(true)
    .padding({ top: this.statusBarHeight })
    .backgroundColor($r('sys.color.background_secondary'))
  }
}