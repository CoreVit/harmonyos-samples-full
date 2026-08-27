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

import { ChildRoute, Constants, Route } from '../common/Constants';
import { BreakpointType, BreakpointTypeEnum } from '../common/utils/BreakpointSystem';
import { UserFlow } from '../component/UserFlow';

@Component
export struct DragFrameworkView {
  @StorageProp(Constants.KEY_BREAKPOINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @Provide(Constants.KEY_PATH_STACK) pageStack: NavPathStack = new NavPathStack();
  private routes: Route = Constants.ROUTES;

  build() {
    Navigation(this.pageStack) {
      Column() {
        Text($r('app.string.index_title'))
          .fontWeight(FontWeight.Bold)
          .fontSize($r('sys.float.Title_L'))
          .height($r('app.float.title_height'))
          .width(Constants.FULL_WIDTH)
          .fontColor($r('sys.color.font_primary'))
          .margin({ top: $r('app.float.title_margin_top'), bottom: $r('sys.float.padding_level6') })
        Column() {
          List() {
            ForEach(this.routes.child, (item: ChildRoute, index: number) => {
              ListItem() {
                UserFlow({
                  name: item.name,
                  page: item.route,
                  isLast: index === this.routes.child.length - 1
                })
              }
            }, (item: ChildRoute, index: number) => item.name + index.toString())
          }
          .height(new BreakpointType({
            sm: Constants.LIST_HEIGHT[0] * 9 + Constants.BORDER_WIDTH * 8,
            md: Constants.LIST_HEIGHT[1] * 9 + Constants.BORDER_WIDTH * 8,
            lg: Constants.LIST_HEIGHT[2] * 9 + Constants.BORDER_WIDTH * 8
          }).getValue(this.curBp))
          .width(Constants.FULL_WIDTH)
        }
        .padding({
          top: $r('sys.float.padding_level2'),
          bottom: $r('sys.float.padding_level2')
        })
        .borderRadius($r('sys.float.padding_level8'))
        .backgroundColor($r('sys.color.comp_background_primary'))
      }
      .margin({ top: this.statusBarHeight })
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .padding({
        left: new BreakpointType({
          sm: $r('sys.float.padding_level8'),
          md: $r('sys.float.padding_level12'),
          lg: $r('sys.float.padding_level16')
        }).getValue(this.curBp),
        right: new BreakpointType({
          sm: $r('sys.float.padding_level8'),
          md: $r('sys.float.padding_level12'),
          lg: $r('sys.float.padding_level16')
        }).getValue(this.curBp)
      })
    }
    .mode(new BreakpointType({
      sm: NavigationMode.Stack,
      md: NavigationMode.Split,
      lg: NavigationMode.Split
    }).getValue(this.curBp))
    .navBarWidth(new BreakpointType({
      sm: $r('app.float.nav_bar_width_sm'),
      md: $r('app.float.nav_bar_width_md'),
      lg: $r('app.float.nav_bar_width_lg')
    }).getValue(this.curBp))
    .backgroundColor($r('sys.color.background_secondary'))
    .hideTitleBar(true)
  }
}