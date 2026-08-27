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
import Logger from '../utils/Logger';

const TAG = '[QueryTicketList]';

@Builder
export function DefaultListBuilder() {
  QueryTicketList()
}

@Component
export struct QueryTicketList {
  @StorageLink(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  private defaultListData: Array<number> = [1, 2, 3, 4, 5];

  getResourceString(resource: Resource): string {
    let resourceString: string = '';
    try {
      let hostContext = this.getUIContext().getHostContext();
      if (hostContext) {
        resourceString = hostContext.resourceManager.getStringSync(resource.id);
      }
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `getResourceString catch error, code: ${err.code}, message: ${err.message}`);
    }
    return resourceString;
  }

  @Builder
  defaultListPage() {
    Row() {
    }
    .backgroundColor($r('sys.color.comp_background_primary'))
    .height($r('app.integer.blank_height'))
    .width(CommonConstants.FULL_PERCENT)
    .borderRadius($r('sys.float.corner_radius_level6'))
    .margin({
      top: $r('sys.float.padding_level8'),
      right: $r('sys.float.padding_level8'),
      left: $r('sys.float.padding_level8')
    })
  }

  build() {
    NavDestination() {
      Column() {
        ForEach(this.defaultListData, () => {
          this.defaultListPage()
        }, (item: number, index: number) => (index + item).toString())
      }
      .margin({
        right: $r('sys.float.padding_level8'),
        left: $r('sys.float.padding_level8')
      })
    }
    .title(this.getResourceString($r('app.string.ticket_list')))
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({
      right: new BreakpointType({
        sm: $r('sys.float.padding_level0'),
        md: $r('sys.float.padding_level0'),
        lg: $r('sys.float.padding_level2')
      }).getValue(this.curBp),
      left: new BreakpointType({
        sm: $r('sys.float.padding_level0'),
        md: $r('sys.float.padding_level0'),
        lg: $r('sys.float.padding_level8')
      }).getValue(this.curBp)
    })
  }
}