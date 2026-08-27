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
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { WindowUtil } from '../utils/WindowUtil';
import SampleUnitView from '../view/SampleUnitView';
import BasicDataSource from '../viewmodel/BasicDataSource';
import SampleUnitItem from '../viewmodel/SampleUnitItem';

const LIST_SPACE = 10;

@Component
export struct FluentBlogComponent {
  @State rotateAngle: number = 0;
  @StorageLink(Constants.KEY_PREFIX + 'CurrentBreakpoint') curBp: string = BreakpointTypeEnum.SM;
  @StorageLink(Constants.KEY_PREFIX + 'StatusBarHeight') statusBarHeight: number = 0;
  @Provide('NavPathStack') pageStack: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pageStack) {
      List({ space: LIST_SPACE }) {
        LazyForEach(BasicDataSource.getData(), (item: SampleUnitItem) => {
          ListItem() {
            SampleUnitView({
              type: item.type,
              buttonUnit: item.button,
              imageArray: item.pic,
            })
              .padding({
                left: new BreakpointType({
                  sm: Constants.PICTURE_GRID_MARGIN[0], md: Constants.PICTURE_GRID_MARGIN[1],
                  lg: Constants.PICTURE_GRID_MARGIN[2]
                }).getValue(this.curBp),
                right: new BreakpointType({
                  sm: Constants.PICTURE_GRID_MARGIN[0], md: Constants.PICTURE_GRID_MARGIN[1],
                  lg: Constants.PICTURE_GRID_MARGIN[2]
                }).getValue(this.curBp)
              })
              .backgroundColor($r('sys.color.comp_background_primary'))
          }
        }, (item: string) => item);
      }
      .cachedCount(2)
      .margin({ top: this.statusBarHeight })
      .backgroundColor($r('sys.color.background_secondary'))
      .scrollBar(BarState.Off)
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
  }
}