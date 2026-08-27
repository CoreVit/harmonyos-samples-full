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

import { KeyboardAvoidMode, SymbolGlyphModifier } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { CommonConstants } from '../common/constants/CommonConstants';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import Logger from '../utils/Logger';
import { WindowUtil } from '../utils/WindowUtil';

@Component
export struct MailPage {
  @StorageProp(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @State keyboardHeight: number = 0;
  private menuItems1: Array<NavigationMenuItem> = [
    {
      value: 'MenuItem1',
      symbolIcon: new SymbolGlyphModifier($r('sys.symbol.paperplane'))
    }
  ];
  private menuItems2: Array<NavigationMenuItem> = [
    {
      value: 'MenuItem1',
      symbolIcon: new SymbolGlyphModifier($r('sys.symbol.folder'))
    },
    {
      value: 'MenuItem2',
      symbolIcon: new SymbolGlyphModifier($r('sys.symbol.picture'))
    },
    {
      value: 'MenuItem3',
      symbolIcon: new SymbolGlyphModifier($r('sys.symbol.arrow_up_circle'))
    },
    {
      value: 'MenuItem4',
      symbolIcon: new SymbolGlyphModifier($r('sys.symbol.share'))
    },
    {
      value: 'MenuItem5',
      symbolIcon: new SymbolGlyphModifier($r('sys.symbol.paperplane'))
    }
  ];
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

  @Builder
  customSymbolBuilder(symbol: Resource) {
    SymbolGlyph(symbol)
      .fontSize($r('sys.float.padding_level12'))
      .fontColor([$r('sys.color.font_secondary')])
  }

  @Builder
  BottomToolbar() {
    Row({ space: 24 }) {
      this.customSymbolBuilder($r('sys.symbol.folder'));
      this.customSymbolBuilder($r('sys.symbol.picture'));
      this.customSymbolBuilder($r('sys.symbol.arrow_up_circle'));
      this.customSymbolBuilder($r('sys.symbol.share'));
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(56)
    .alignItems(VerticalAlign.Center)
    .border({
      width: { top: 1 },
      color: $r('sys.color.ohos_id_divider_color')
    })
  }

  @Builder
  EmailContent() {
    Column() {
      Row() {
        Text($r('app.string.from'))
          .fontColor($r('sys.color.font_primary'))
          .fontSize($r('sys.float.Body_L'))
        TextInput({ placeholder: $r('app.string.email_address') })
          .type(InputType.Email)
          .width(CommonConstants.FULL_PERCENT)
          .backgroundColor($r('sys.color.background_secondary'))
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(48)
      .border({
        width: { top: 1 },
        color: $r('sys.color.ohos_id_divider_color')
      })

      Row() {
        Text($r('app.string.to'))
          .fontColor($r('sys.color.font_primary'))
          .fontSize($r('sys.float.Body_L'))
        TextInput({ placeholder: $r('app.string.email_address') })
          .type(InputType.Email)
          .width(CommonConstants.FULL_PERCENT)
          .backgroundColor($r('sys.color.background_secondary'))
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(48)
      .border({
        width: { top: 1 },
        color: $r('sys.color.ohos_id_divider_color')
      })

      Row() {
        Text($r('app.string.subject'))
          .fontColor($r('sys.color.font_primary'))
          .fontSize($r('sys.float.Body_L'))
        TextInput({ placeholder: $r('app.string.subject') })
          .width(CommonConstants.FULL_PERCENT)
          .backgroundColor($r('sys.color.background_secondary'))
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(48)
      .border({
        width: {
          top: 1,
          bottom: 1
        },
        color: $r('sys.color.ohos_id_divider_color')
      })

      Row() {
        TextArea({ placeholder: $r('app.string.entry_content') })
          .height(CommonConstants.FULL_PERCENT)
          .backgroundColor($r('sys.color.background_secondary'))
      }
      .layoutWeight(1)
      .alignItems(VerticalAlign.Top)
      .width(CommonConstants.FULL_PERCENT)
      .margin({ top: $r('sys.float.padding_level6') })
    }
    .width(CommonConstants.FULL_PERCENT)
    .layoutWeight(1)
    .margin({ top: $r('sys.float.padding_level4') })
  }

  build() {
    NavDestination() {
      Column() {
        this.EmailContent()
        if (this.curBp !== BreakpointTypeEnum.LG) {
          this.BottomToolbar()
        }
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .padding({
        left: new BreakpointType({
          sm: $r('sys.float.padding_level8'),
          md: $r('sys.float.corner_radius_level12'),
          lg: $r('sys.float.corner_radius_level16')
        }).getValue(this.curBp),
        right: new BreakpointType({
          sm: $r('sys.float.padding_level8'),
          md: $r('sys.float.corner_radius_level12'),
          lg: $r('sys.float.corner_radius_level16')
        }).getValue(this.curBp)
      })
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .title($r('app.string.new_email'))
    .menus(this.curBp === BreakpointTypeEnum.LG ? this.menuItems2 : this.menuItems1)
    .padding({
      top: this.statusBarHeight,
      bottom: (this.keyboardHeight > 0) ? 0 : this.navigatorBarHeight
    })
  }
}