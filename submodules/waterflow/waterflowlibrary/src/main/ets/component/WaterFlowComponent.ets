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

import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/constants/CommonConstants';
import { SectionsHomePage } from './SectionsHomePage';
import { NavPage } from './NavPage';
import Logger from '../utils/Logger';
import { WindowUtil } from '../utils/WindowUtil';

const TAG = 'WaterFlowComponent';

@Component
export struct WaterFlowComponent {
  @StorageProp(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @Provide(CommonConstants.AS_KEY_PATH_STACK) pathStack: NavPathStack = new NavPathStack();
  scroller: Scroller = new Scroller();

  @Builder
  PagesMap(name: string, _: number) {
    if (name === 'SectionsHomePage') {
      SectionsHomePage()
    } else if (name === 'NavPage') {
      NavPage()
    }
  }

  aboutToDisappear(): void {
    WindowUtil.unregisterBreakPoint();
  }

  build() {
    Scroll(this.scroller) {
      Row() {
        Navigation(this.pathStack) {
          Column() {
            Button($r('app.string.scenario_sections'))
              .id('newFile')
              .fontSize(16)
              .width(this.curBp === 'sm' ? '100%' : 448)
              .height(40)
              .margin({ bottom: $r('sys.float.padding_level6') })
              .backgroundColor($r('sys.color.brand'))
              .onClick(() => {
                this.pathStack.pushPath({ name: 'SectionsHomePage' });
              })

            Button($r('app.string.scenario_embed'))
              .id('folder')
              .fontSize(16)
              .width(this.curBp === 'sm' ? '100%' : 448)
              .height(40)
              .margin({ bottom: $r('sys.float.padding_level6') })
              .backgroundColor($r('sys.color.brand'))
              .onClick(() => {
                this.pathStack.pushPath({ name: 'NavPage' });
              })
          }
          .height(CommonConstants.FULL_HEIGHT)
          .width(CommonConstants.FULL_WIDTH)
          .justifyContent(FlexAlign.End)
          .padding({
            top: this.statusBarHeight,
            bottom: this.navigatorBarHeight,
            right: new BreakpointType({
              sm: $r('sys.float.padding_level8'),
              md: $r('sys.float.padding_level4'),
              lg: $r('sys.float.padding_level8')
            }).getValue(this.curBp),
            left: new BreakpointType({
              sm: $r('sys.float.padding_level8'),
              md: $r('sys.float.padding_level4'),
              lg: $r('sys.float.padding_level8')
            }).getValue(this.curBp)
          })
        }
        .navDestination(this.PagesMap)
        .titleMode(NavigationTitleMode.Full)
        .mode(NavigationMode.Stack)
        .backgroundColor($r('sys.color.background_secondary'))
        .title(this.getTitle())
      }
      .height(CommonConstants.FULL_HEIGHT)
      .width(CommonConstants.FULL_WIDTH)
    }
  }

  getTitle(): string {
    try {
      const hostContext = this.getUIContext().getHostContext();
      if (!hostContext) {
        return '';
      }
      return hostContext.resourceManager.getStringSync($r('app.string.title').id);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getResourceString catch error, errCode: ${err.code}, errMessage: ${err.message}.`);
    }
    return '';
  }
}
