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

import Constants, { Route } from '../common/Constants';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { MediaNews } from './MediaNews';
import { NewsChannel } from './NewsChannel';
import { NewsListPage } from './NewsListPage';

@Component
export struct MultiNewsReadView {
  @StorageProp(Constants.KEY_BREAKPOINT) curBp: string = Constants.BREAKPOINTS[1];
  @StorageProp(Constants.KEY_NAV_INDICATOR_HEIGHT) navIndicatorHeight: number = 0;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @Provide(Constants.KEY_PATH_STACK) pathInfos: NavPathStack = new NavPathStack();
  private routes: Route[] = Constants.ROUTES;

  @Builder
  PageMap(name: string) {
    if (name === 'MediaNews') {
      MediaNews()
    } else if (name === 'NewsChannel') {
      NewsChannel()
    } else if (name === 'NewsListPage') {
      NewsListPage()
    }
  }

  build() {
    Navigation(this.pathInfos) {
      Column() {
        Text($r('app.string.project_name'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.font_primary'))
          .fontSize($r('sys.float.Title_L'))
          .alignSelf(ItemAlign.Start)
          .margin({
            left: new BreakpointType({
              sm: $r('sys.float.padding_level0'),
              md: $r('sys.float.padding_level4'),
              lg: $r('sys.float.padding_level8')
            }).getValue(this.curBp)
          })
        Column() {
          ForEach(this.routes, (item: Route) => {
            Button(item.text)
              .fontSize($r('sys.float.Subtitle_M'))
              .fontColor($r('sys.color.font_on_primary'))
              .width(this.curBp === BreakpointTypeEnum.SM ? '100%' : $r('app.float.index_button_width_lg'))
              .height($r('app.float.button_height'))
              .margin({ top: $r('sys.float.padding_level6') })
              .backgroundColor($r('sys.color.comp_background_emphasize'))
              .onClick(() => {
                this.pathInfos.pushPath({ name: item.to });
              })
          }, (item: Route) => JSON.stringify(item))
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
    .navDestination(this.PageMap)
  }
}