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

import { Constants } from '../common/Constants';
import { BreakpointType, BreakpointTypeEnum } from '../common/utils/BreakpointSystem';
import { ResourceUtil } from '../common/utils/ResourceUtil';
import { TabDataModel } from '../model/TabDataModel';
import { VideoInfoView } from './VideoInfoView';

const TAG: string = '[TopTabView]';

@Component
export struct TopTabView {
  @StorageLink(Constants.KEY_BREAKPOINT) currentWidthBreakpoint: string = BreakpointTypeEnum.SM;
  @StorageLink(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @State secondLevelIndex: number = 0;
  @Link tabData: TabDataModel;
  private firstLevel: string = '';

  aboutToAppear(): void {
    this.firstLevel = ResourceUtil.getString($r('app.string.tab_home'));
  }

  build() {
    Column() {
      List() {
        ForEach(this.tabData.getSecondList(this.firstLevel), (item: string, index: number) => {
          ListItem() {
            Button(item)
              .width($r('app.float.top_tab_button_width'))
              .height($r('app.float.size_36'))
              .buttonStyle(index === this.secondLevelIndex ? ButtonStyleMode.EMPHASIZED : ButtonStyleMode.NORMAL)
              .fontSize($r('sys.float.Body_M'))
              .fontColor(index === this.secondLevelIndex ? $r('sys.color.font_on_primary') :
                $r('sys.color.font_primary'))
              .fontWeight(FontWeight.Medium)
          }
          .align(Alignment.Center)
          .padding({
            right: new BreakpointType({
              sm: $r('sys.float.padding_level4'),
              md: $r('sys.float.padding_level6'),
              lg: $r('sys.float.padding_level9'),
              xl: $r('sys.float.padding_level0')
            }).getValue(this.currentWidthBreakpoint)
          })
          .onClick(() => {
            this.secondLevelIndex = index;
          })
        }, (item: string, index: number) => index + item)
      }
      .scrollBar(BarState.Off)
      .listDirection(Axis.Horizontal)
      .padding({
        left: new BreakpointType({
          sm: $r('sys.float.padding_level8'),
          md: $r('sys.float.padding_level12'),
          lg: $r('app.float.padding_level18'),
          xl: $r('sys.float.padding_level12')
        }).getValue(this.currentWidthBreakpoint),
        right: new BreakpointType({
          sm: $r('sys.float.padding_level8'),
          md: $r('sys.float.padding_level12'),
          lg: $r('app.float.padding_level18'),
          xl: $r('sys.float.padding_level12')
        }).getValue(this.currentWidthBreakpoint),
        top: $r('sys.float.padding_level5')
      })
      .height($r('app.float.size_56'))
      .width('100%')

      VideoInfoView({ secondLevelIndex: this.secondLevelIndex })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({
      top: this.statusBarHeight
    })
  }
}