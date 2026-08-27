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

@Component
struct CommentItemView {
  @State content: ResourceStr = '';

  build() {
    Row() {
      SymbolGlyph($r('sys.symbol.person_crop_circle_fill'))
        .fontSize(40)
        .fontColor([$r('sys.color.font_tertiary')])
        .margin({
          right: $r('sys.float.padding_level6'),
          top: $r('sys.float.padding_level6')
        })

      Column() {
        Text($r('app.string.commenter_name'))
          .fontSize($r('sys.float.Body_L'))
          .margin({ bottom: $r('sys.float.padding_level1') })
          .fontColor($r('sys.color.font_primary'))
        Text($r('app.string.comment_time'))
          .fontSize($r('sys.float.Body_S'))
          .margin({ bottom: $r('sys.float.padding_level8') })
          .fontColor($r('sys.color.font_tertiary'))
        Text(this.content)
          .fontSize($r('sys.float.Body_M'))
          .margin({ bottom: $r('sys.float.padding_level4') })
          .fontColor($r('sys.color.font_primary'))

        Row({ space: 12 }) {
          SymbolGlyph($r('sys.symbol.hand_thumbsup'))
            .fontSize($r('sys.float.padding_level9'))
            .fontColor([$r('sys.color.font_secondary')])

          SymbolGlyph($r('sys.symbol.hand_thumbsdown'))
            .fontSize($r('sys.float.padding_level9'))
            .fontColor([$r('sys.color.font_secondary')])
        }
      }
      .alignItems(HorizontalAlign.Start)
      .padding({
        top: $r('sys.float.padding_level6'),
        bottom: $r('sys.float.padding_level4')
      })
    }
    .alignItems(VerticalAlign.Top)
  }
}

@Component
export struct CommentPage {
  @StorageProp(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @Consume(CommonConstants.AS_KEY_PATH_STACK) pageStack: NavPathStack;
  @State keyboardHeight: number = 0;
  private listData: ResourceStr[] =
    [$r('app.string.comment1'), $r('app.string.comment2'), $r('app.string.comment3'), $r('app.string.comment4'),
      $r('app.string.comment5'), $r('app.string.comment6'), $r('app.string.comment7'), $r('app.string.comment8')];
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
          List() {
            ForEach(this.listData, (item: ResourceStr) => {
              ListItem() {
                CommentItemView({ content: item })
              }
            }, (item: string) => JSON.stringify(item))
          }
          .divider({
            strokeWidth: 1,
            color: $r('sys.color.ohos_id_divider_color')
          })
          .scrollBar(BarState.Off)
          .height(CommonConstants.FULL_PERCENT)
          .width(CommonConstants.FULL_PERCENT)
          .layoutWeight(1)
          .padding({
            top: this.curBp === BreakpointTypeEnum.SM ? 0 : this.statusBarHeight
          })

          Row() {
            TextInput({ placeholder: $r('app.string.comment_input_placeholder') })
              .height(40)
              .margin({
                top: $r('sys.float.padding_level2'),
                bottom: $r('sys.float.padding_level2')
              })
          }
        }
        .width(this.curBp === BreakpointTypeEnum.SM ? CommonConstants.FULL_PERCENT : CommonConstants.FORTY_PERCENT)
        .height(this.curBp === BreakpointTypeEnum.SM ? CommonConstants.SEVENTY_FIVE_PERCENT :
          CommonConstants.FULL_PERCENT)
        .backgroundColor($r('sys.color.comp_background_primary'))
        .borderRadius({
          topLeft: this.curBp === BreakpointTypeEnum.SM ? $r('sys.float.corner_radius_level8') : 0,
          topRight: this.curBp === BreakpointTypeEnum.SM ? $r('sys.float.corner_radius_level8') : 0
        })
        .padding({
          bottom: (this.keyboardHeight > 0) ? 0 : this.navigatorBarHeight,
          left: $r('sys.float.padding_level8'),
          right: $r('sys.float.padding_level8')
        })
      }
      .height(CommonConstants.FULL_PERCENT)
      .width(CommonConstants.FULL_PERCENT)
      .justifyContent(FlexAlign.End)
      .alignItems(HorizontalAlign.End)
      .onClick(() => {
        this.pageStack.pop();
      })
    }
    .mode(NavDestinationMode.DIALOG)
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.black'))
    .backgroundImageSize({
      width: this.curBp === BreakpointTypeEnum.SM ? CommonConstants.ZERO_PERCENT : CommonConstants.SIXTY_PERCENT,
      height: new BreakpointType({
        sm: CommonConstants.ZERO_PERCENT,
        md: CommonConstants.FORTY_SIX_PERCENT,
        lg: CommonConstants.SEVENTY_PERCENT
      }).getValue(this.curBp)
    })
    .backgroundImagePosition(Alignment.Start)
    .backgroundImage(new BreakpointType({
      sm: null,
      md: $r('app.media.foldable_background'),
      lg: $r('app.media.pad_background')
    }).getValue(this.curBp))
  }
}