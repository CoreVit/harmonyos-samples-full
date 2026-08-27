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

import Constants from '../common/Constants';
import { GlobalBuilderContext } from '../common/GlobalBuilderContext';
import { BreakpointType } from '../common/utils/BreakpointSystem';
import { NavDestinationItem } from '../viewmodel/NavDestinationItem';

@Component
export struct VerificationCodeScenarioView {
  private navDestinationData: NavDestinationItem[] = Constants.NAV_DESTINATION_DATA;
  @Provide(Constants.KEY_PATH_STACK) pathInfos: NavPathStack = new NavPathStack();
  @StorageProp(Constants.KEY_BREAKPOINT) curBp: string = Constants.BREAKPOINTS[0];
  @StorageProp(Constants.KEY_NAV_INDICATOR_HEIGHT) navIndicatorHeight: number = 0;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;

  @Builder
  PagesMap(name: string) {
    if ((GlobalBuilderContext.getContext().getObject(name)) !== undefined) {
      (GlobalBuilderContext.getContext().getObject(name) as WrappedBuilder<[string, number]>)
        .builder(name, Constants.ZERO);
    }
  }

  aboutToAppear(): void {
    AppStorage.setOrCreate('listData', this.navDestinationData);
  }

  build() {
    Navigation(this.pathInfos) {
      Column() {
        Text($r('app.string.project_name'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.font_primary'))
          .fontSize($r('sys.float.Title_L'))
          .height($r('app.float.bar_height'))
          .alignSelf(ItemAlign.Start)
          .margin({
            left: new BreakpointType({
              sm: $r('sys.float.padding_level0'),
              md: $r('sys.float.padding_level4'),
              lg: $r('sys.float.padding_level8')
            }).getValue(this.curBp)
          })
          .padding({ top: $r('sys.float.padding_level8') })
        Column() {
          ForEach(this.navDestinationData, (item: NavDestinationItem, index: number) => {
            Button(item.detail)
              .fontSize($r('sys.float.Subtitle_M'))
              .fontColor($r('sys.color.font_on_primary'))
              .width(this.curBp === 'sm' ? '100%' : $r('app.float.index_button_width_lg'))
              .height($r('app.float.button_height'))
              .margin({ top: $r('sys.float.padding_level6') })
              .backgroundColor($r('sys.color.comp_background_emphasize'))
              .onClick(() => {
                this.pathInfos.pushPathByName(item.name, Constants.ZERO);
              })
          }, (item: NavDestinationItem) => JSON.stringify(item))
        }
        .width(Constants.FULL_WIDTH)
      }
      .backgroundColor($r('sys.color.background_primary'))
      .width(Constants.FULL_WIDTH)
      .height(Constants.FULL_HEIGHT)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: $r('sys.float.padding_level8'),
        right: $r('sys.float.padding_level8'),
        top: Constants.PADDING_TOP_INDEX + this.statusBarHeight,
        bottom: Constants.PADDING_BOTTOM_INDEX + this.navIndicatorHeight
      })
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .navDestination(this.PagesMap)
  }
}