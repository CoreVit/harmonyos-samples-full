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

import { KeyboardAvoidMode } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { CommonConstants } from '../common/constants/CommonConstants';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import Logger from '../utils/Logger';
import { WindowUtil } from '../utils/WindowUtil';
import { Chat, chatList } from '../viewmodel/ChatData';

@Component
export struct ContactPage {
  @Consume(CommonConstants.AS_KEY_CHAT_LIST_PATH_STACK) chatNavStack: NavPathStack;
  @StorageProp(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @State avatar: Resource | undefined = undefined;
  @State name: string = '';
  @State keyboardHeight: number = 0;
  private changeCallback: Callback<number, void> = (height) => {
    this.keyboardHeight = height;
  };

  aboutToAppear(): void {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
    try {
      WindowUtil.getWindowClass().on('keyboardHeightChange', this.changeCallback);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(CommonConstants.TAG,
        `Register keyboardHeightChange fail, error code: ${err.code}, message: ${err.message}`);
    }
  }

  aboutToDisappear(): void {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.OFFSET);
    try {
      WindowUtil.getWindowClass()?.off('keyboardHeightChange', this.changeCallback);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(CommonConstants.TAG,
        `UnRegister keyboardHeightChange fail, error code: ${err.code}, message: ${err.message}`);
    }
  }

  build() {
    NavDestination() {
      Column() {
        Column() {
          Blank()
            .height(this.statusBarHeight)
            .backgroundColor($r('sys.color.background_secondary'))
          Row() {
            if (this.curBp === BreakpointTypeEnum.SM) {
              Button({ type: ButtonType.Circle }) {
                SymbolGlyph($r('sys.symbol.chevron_backward'))
                  .fontSize($r('sys.float.Title_M'))
                  .fontColor([$r('sys.color.icon_primary')])
              }
              .height(40)
              .aspectRatio(1)
              .backgroundColor($r('sys.color.comp_background_tertiary'))
              .margin({ right: $r('sys.float.padding_level4') })
              .onClick(() => {
                this.chatNavStack.pop();
              })
            }
            Text(this.name)
              .fontSize($r('sys.float.Title_S'))
              .fontWeight(FontWeight.Bold)
              .fontColor($r('sys.color.font_primary'))
          }
          .backgroundColor($r('sys.color.background_secondary'))
          .width(CommonConstants.FULL_PERCENT)
          .height(56)
        }
        .expandSafeArea([SafeAreaType.KEYBOARD])
        .zIndex(1)

        List() {
          ForEach(chatList, (item: Chat) => {
            ListItem() {
              Row() {
                if (item.sender === 'others') {
                  Image(this.avatar)
                    .height(40)
                    .margin({ right: $r('sys.float.padding_level4') })

                  Row() {
                    Text(item.message)
                      .fontSize($r('sys.float.Body_L'))
                      .lineHeight($r('sys.float.padding_level11'))
                      .textAlign(TextAlign.Start)
                      .constraintSize({ maxWidth: CommonConstants.SEVENTY_PERCENT })
                  }
                  .borderRadius({
                    topLeft: $r('sys.float.corner_radius_level2'),
                    topRight: $r('sys.float.corner_radius_level8'),
                    bottomLeft: $r('sys.float.corner_radius_level8'),
                    bottomRight: $r('sys.float.corner_radius_level8')
                  })
                  .padding({
                    top: $r('sys.float.padding_level4'),
                    bottom: $r('sys.float.padding_level4'),
                    left: $r('sys.float.padding_level6'),
                    right: $r('sys.float.padding_level6')
                  })
                  .backgroundColor($r('sys.color.comp_background_primary'))
                } else {
                  Row() {
                    Text(item.message)
                      .fontSize($r('sys.float.Body_L'))
                      .lineHeight($r('sys.float.padding_level11'))
                      .textAlign(TextAlign.Start)
                      .constraintSize({ maxWidth: CommonConstants.SEVENTY_PERCENT })
                  }
                  .borderRadius({
                    topLeft: $r('sys.float.corner_radius_level8'),
                    topRight: $r('sys.float.corner_radius_level2'),
                    bottomLeft: $r('sys.float.corner_radius_level8'),
                    bottomRight: $r('sys.float.corner_radius_level8')
                  })
                  .padding({
                    top: $r('sys.float.padding_level4'),
                    bottom: $r('sys.float.padding_level4'),
                    left: $r('sys.float.padding_level6'),
                    right: $r('sys.float.padding_level6')
                  })
                  .margin({ right: $r('sys.float.padding_level4') })
                  .backgroundColor($r('sys.color.multi_color_11'))

                  Image($r('app.media.avatar_blue'))
                    .height(40)
                }
              }
              .width(CommonConstants.FULL_PERCENT)
              .padding({
                top: $r('sys.float.padding_level5'),
                bottom: $r('sys.float.padding_level5')
              })
              .justifyContent(item.sender === 'others' ? FlexAlign.Start : FlexAlign.End)
            }
            .width(CommonConstants.FULL_PERCENT)
            .margin({ bottom: $r('app.float.margin_12') })
          }, (item: Chat) => JSON.stringify(item))
        }
        .scrollBar(BarState.Off)
        .width(CommonConstants.FULL_PERCENT)
        .layoutWeight(1)
        .backgroundColor($r('sys.color.background_secondary'))

        Row() {
          SymbolGlyph($r('sys.symbol.face_smiling'))
            .fontSize($r('sys.float.Title_L'))
            .fontColor([$r('sys.color.font_secondary')])
            .onClick(() => {
              this.getUIContext().getPromptAction().showToast({ message: $r('app.string.prompt_text2') })
            })

          TextInput()
            .layoutWeight(1)
            .height(40)
            .margin({
              right: $r('sys.float.padding_level8'),
              left: $r('sys.float.padding_level8')
            })

          SymbolGlyph($r('sys.symbol.plus_circle'))
            .fontSize($r('sys.float.Title_L'))
            .fontColor([$r('sys.color.font_secondary')])
            .onClick(() => {
              this.getUIContext().getPromptAction().showToast({ message: $r('app.string.prompt_text2') })
            })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width(CommonConstants.FULL_PERCENT)
        .height(56)
      }
      .backgroundColor($r('sys.color.background_secondary'))
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
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
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({
      bottom: (this.keyboardHeight > 0) ? 0 : this.navigatorBarHeight
    })
  }
}