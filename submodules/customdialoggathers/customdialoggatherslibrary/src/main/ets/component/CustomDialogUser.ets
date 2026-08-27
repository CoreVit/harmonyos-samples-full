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

@Builder
export function CustomDialogUserBuilder() {
  CustomDialogUser();
}

@CustomDialog
struct CustomDialogExample {
  controller?: CustomDialogController;

  build() {
    Column() {
      Text($r('app.string.click_successfully'))
        .fontSize($r('sys.float.Subtitle_M'))
        .fontColor($r('sys.color.font_primary'))
        .height($r('app.float.toast_height'))
    }
    .padding({
      left: $r('sys.float.padding_level8'),
      right: $r('sys.float.padding_level8')
    })
    .backgroundColor($r('sys.color.comp_background_primary'))
    .borderRadius($r('sys.float.corner_radius_level8'))
  }
}

@Component
struct CustomDialogUser {
  @StorageLink(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @State inputValue: ResourceStr = $r('app.string.click');
  @State buttonEnabled: boolean = true;
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogExample(),
    openAnimation: {
      duration: CommonConstants.DURATION,
      curve: Curve.Friction,
      delay: CommonConstants.DELAY,
      playMode: PlayMode.Alternate
    },
    closeAnimation: {
      duration: CommonConstants.DURATION,
      curve: Curve.Friction,
      delay: CommonConstants.DELAY,
      playMode: PlayMode.Alternate
    },
    alignment: DialogAlignment.Bottom,
    offset: { dx: CommonConstants.ZERO, dy: $r('app.float.offset_dy') },
    customStyle: true,
    cornerRadius: $r('sys.float.corner_radius_level12'),
    isModal: false
  });

  aboutToDisappear() {
    this.dialogController = null;
  }

  build() {
    NavDestination() {
      Navigation() {
        Column() {
          Button(this.inputValue)
            .width(this.curBp === 'sm' ? CommonConstants.FULL_PERCENT : CommonConstants.WIDTH_MD_LG)
            .height($r('app.integer.button_height_small'))
            .fontSize($r('sys.float.Subtitle_M'))
            .backgroundColor($r('sys.color.brand'))
            .margin({
              bottom: $r('sys.float.padding_level6')
            })
            .onClick(() => {
              this.buttonEnabled = false;
              this.dialogController?.open();
              setTimeout(() => {
                this.dialogController?.close();
                this.buttonEnabled = true;
              }, 3000);
            })
            .enabled(this.buttonEnabled)
        }
        .height(CommonConstants.FULL_PERCENT)
        .width(CommonConstants.FULL_PERCENT)
        .justifyContent(FlexAlign.End)
        .padding({
          right: this.curBp === 'sm' ? $r('sys.float.padding_level8') : $r('sys.float.padding_level0'),
          left: this.curBp === 'sm' ? $r('sys.float.padding_level8') : $r('sys.float.padding_level0')
        })
      }
      .title($r('app.string.toast_dialog'))
      .titleMode(NavigationTitleMode.Mini)
      .mode(NavigationMode.Stack)
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
    }
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}