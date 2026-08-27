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

import { BusinessError } from '@kit.BasicServicesKit';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/constants/CommonConstants';
import { GridNestListIndex } from './GridNestListIndex';
import { GridNextSwiperIndex } from './GridNestSwiperIndex';
import Logger from '../utils/Logger';
import { WindowUtil } from '../utils/WindowUtil';

const TAG: string = '[GridHybridComponent]';

class DirectoryItem {
  public title: ResourceStr = '';
  public id: string = '';
}

@Component
export struct GridHybridComponent {
  @Provide(CommonConstants.AS_KEY_PATH_STACK) pathStack: NavPathStack = new NavPathStack();
  @StorageLink(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  private directory: DirectoryItem[] = [
    {
      title: $r('app.string.grid_nest_list'),
      id: 'GridNestListIndex'
    },
    {
      title: $r('app.string.grid_nest_swiper'),
      id: 'GridNestSwiperIndex'
    }
  ];

  getResourceString(resource: Resource): string {
    let resourceString: string = '';
    try {
      let hostContext = this.getUIContext().getHostContext();
      if (hostContext) {
        resourceString = hostContext.resourceManager.getStringSync(resource.id);
      }
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `getResourceString failed, code: ${err.code}, message: ${err.message}`);
    }
    return resourceString;
  }

  @Builder
  PageMap(name: string) {
    if (name === 'GridNestListIndex') {
      GridNestListIndex();
    } else if (name === 'GridNestSwiperIndex') {
      GridNextSwiperIndex();
    }
  }

  aboutToDisappear(): void {
    WindowUtil.unregisterBreakPoint();
  }

  build() {
    Column() {
      Navigation(this.pathStack) {
        Column() {
          ForEach(this.directory, (item: DirectoryItem) => {
            Button(item.title)
              .id(item.id)
              .fontSize($r('sys.float.Subtitle_M'))
              .width(this.curBp === 'sm' ? CommonConstants.FULL_PERCENT : $r('app.float.button_width_others'))
              .height($r('app.float.button_height'))
              .margin({
                bottom: $r('sys.float.padding_level6')
              })
              .backgroundColor($r('sys.color.brand'))
              .onClick(() => {
                this.pathStack.pushPath({ name: item.id })
              })
          }, (item: DirectoryItem) => item.id.toString())
        }
        .height(CommonConstants.FULL_PERCENT)
        .width(CommonConstants.FULL_PERCENT)
        .justifyContent(FlexAlign.End)
        .padding({
          right: this.curBp === 'sm' ? $r('sys.float.padding_level8') : $r('sys.float.padding_level0'),
          left: this.curBp === 'sm' ? $r('sys.float.padding_level8') : $r('sys.float.padding_level0')
        })
      }
      .titleMode(NavigationTitleMode.Full)
      .mode(NavigationMode.Stack)
      .title(this.getResourceString($r('app.string.navigation_title')))
      .navDestination(this.PageMap)
    }
    .padding({
      top: this.statusBarHeight,
      right: new BreakpointType({
        sm: $r('sys.float.padding_level0'),
        md: $r('sys.float.padding_level4'),
        lg: $r('sys.float.padding_level8')
      }).getValue(this.curBp),
      bottom: this.navigatorBarHeight,
      left: new BreakpointType({
        sm: $r('sys.float.padding_level0'),
        md: $r('sys.float.padding_level4'),
        lg: $r('sys.float.padding_level8')
      }).getValue(this.curBp)
    })
    .height(CommonConstants.FULL_PERCENT)
    .width(CommonConstants.FULL_PERCENT)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}
