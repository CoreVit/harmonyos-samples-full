/*
* Copyright (C) 2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { WindowUtil } from '../utils/WindowUtil';
import { CommonConstants } from '../common/constants/CommonConstants';
import { Contact } from '../viewmodel/ContactData';
import { ChatListPage } from './ChatListPage';
import { CommentPage } from './CommentPage';
import { ContactPage } from './ContactPage';
import { MailPage } from './MailPage';

@Component
export struct KeyboardComponent {
  @StorageProp(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @Provide(CommonConstants.AS_KEY_PATH_STACK) pageStack: NavPathStack = new NavPathStack();

  aboutToDisappear(): void {
    WindowUtil.unRegisterBreakPoint();
  }

  @Builder
  PagesMap(name: string, param: object) {
    if (name === 'ChatListPage') {
      ChatListPage()
    } else if (name === 'MailPage') {
      MailPage()
    } else if (name === 'ContactPage') {
      ContactPage(param as Contact)
    } else if (name === 'CommentPage') {
      CommentPage()
    }
  }

  build() {
    Navigation(this.pageStack) {
      Column({ space: CommonConstants.CONTAINER_SPACE }) {
        Text($r('app.string.index_title'))
          .fontWeight(FontWeight.Bold)
          .fontSize($r('sys.float.Title_L'))
          .height($r('sys.float.ohos_id_textfield_height'))
          .width(CommonConstants.FULL_PERCENT)
          .fontColor($r('sys.color.font_primary'))
          .margin({ top: $r('app.float.title_margin_top'), bottom: $r('sys.float.padding_level6') })
        Blank()
        Button($r('app.string.chat_list'))
          .width(this.curBp === BreakpointTypeEnum.SM ? CommonConstants.FULL_PERCENT : CommonConstants.HOME_PAGE_WIDTH)
          .onClick(() => {
            this.pageStack.pushPathByName('ChatListPage', '');
          })
        Button($r('app.string.mail_page'))
          .width(this.curBp === BreakpointTypeEnum.SM ? CommonConstants.FULL_PERCENT : CommonConstants.HOME_PAGE_WIDTH)
          .onClick(() => {
            this.pageStack.pushPathByName('MailPage', '');
          })
        Button($r('app.string.comment_page'))
          .width(this.curBp === BreakpointTypeEnum.SM ? CommonConstants.FULL_PERCENT : CommonConstants.HOME_PAGE_WIDTH)
          .onClick(() => {
            this.pageStack.pushPathByName('CommentPage', '');
          })
      }
      .padding({
        top: this.statusBarHeight,
        left: $r('sys.float.padding_level8'),
        right: $r('sys.float.padding_level8'),
        bottom: this.navigatorBarHeight + CommonConstants.PADDING_SPACE_16
      })
      .height(CommonConstants.FULL_PERCENT)
      .width(CommonConstants.FULL_PERCENT)
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .navDestination(this.PagesMap)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}