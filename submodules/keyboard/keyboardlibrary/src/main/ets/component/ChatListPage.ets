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

import type { BusinessError } from '@kit.BasicServicesKit';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import Logger from '../utils/Logger';
import { CommonConstants } from '../common/constants/CommonConstants';
import { Contact, contactList } from '../viewmodel/ContactData';
import { ContactPage } from './ContactPage';

const TAG: string = '[ChatListPage]';

@Component
export struct ChatListPage {
  @StorageProp(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @Consume(CommonConstants.AS_KEY_PATH_STACK) pageStack: NavPathStack;
  @Provide(CommonConstants.AS_KEY_CHAT_LIST_PATH_STACK) chatNavStack: NavPathStack = new NavPathStack();

  @Builder
  PagesMap(name: string, param: object) {
    if (name === 'ContactPage') {
      ContactPage(param as Contact)
    }
  }

  aboutToAppear(): void {
    if (this.curBp !== BreakpointTypeEnum.SM) {
      this.chatNavStack.pushPathByName('ContactPage', contactList[1]);
    }
  }

  aboutToDisappear(): void {
    this.chatNavStack?.clear();
  }

  build() {
    NavDestination() {
      Navigation(this.chatNavStack) {
        Column() {
          Row() {
            Button({ type: ButtonType.Circle }) {
              SymbolGlyph($r('sys.symbol.chevron_backward'))
                .fontSize($r('sys.float.Title_M'))
                .fontColor([$r('sys.color.icon_primary')])
            }
            .height(40)
            .aspectRatio(1)
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .onClick(() => {
              this.pageStack.pop();
            })

            Search({ placeholder: $r('app.string.Search_text') })
              .height(40)
              .layoutWeight(1)
              .margin({ left: $r('sys.float.padding_level6') })
              .onSubmit(() => {
                try {
                  this.getUIContext().getPromptAction().showToast({ message: $r('app.string.prompt_text') })
                } catch (error) {
                  const err: BusinessError = error as BusinessError;
                  Logger.error(TAG, `showToast failed, ErrorCode: ${err.code}, Message: ${err.message}`)
                }
              })
          }
          .width(CommonConstants.FULL_PERCENT)
          .height(56)
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({
            left: new BreakpointType({
              sm: $r('sys.float.padding_level8'), md: $r('sys.float.padding_level12'),
              lg: $r('sys.float.padding_level16')
            }).getValue(this.curBp),
            right: new BreakpointType({
              sm: $r('sys.float.padding_level8'), md: $r('sys.float.padding_level12'),
              lg: $r('sys.float.padding_level16')
            }).getValue(this.curBp)
          })

          List() {
            ForEach(contactList, (item: Contact) => {
              ListItem() {
                Row() {
                  if (item.avatar !== undefined) {
                    Image(item.avatar)
                      .height(40)
                      .margin({ right: $r('sys.float.padding_level6') })
                  }

                  Text(item.name)
                    .fontSize(item.avatar === undefined ? $r('sys.float.Body_M') : $r('sys.float.Body_L'))
                    .fontWeight(FontWeight.Medium)
                    .fontColor($r('sys.color.font_primary'))
                }
                .width(CommonConstants.FULL_PERCENT)
                .height(item.avatar === undefined ? $r('app.float.row_height_48') : $r('app.float.row_height_64'))
              }
              .onClick(() => {
                if (item.avatar !== undefined) {
                  this.chatNavStack.replacePathByName('ContactPage',
                    { avatar: item.avatar, name: item.name } as Contact, true);
                }
              })
            }, (item: Contact) => JSON.stringify(item))
          }
          .scrollBar(BarState.Off)
          .width(CommonConstants.FULL_PERCENT)
          .height(CommonConstants.FULL_PERCENT)
          .layoutWeight(1)
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
        .padding({
          top: this.statusBarHeight,
          bottom: this.navigatorBarHeight
        })
      }
      .navBarWidth(new BreakpointType({
        sm: CommonConstants.FULL_PERCENT,
        md: CommonConstants.FIFTY_PERCENT,
        lg: CommonConstants.FORTY_PERCENT
      }).getValue(this.curBp))
      .hideTitleBar(true)
      .navDestination(this.PagesMap)
      .height(CommonConstants.FULL_PERCENT)
      .width(CommonConstants.FULL_PERCENT)
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .hideTitleBar(true)
  }
}