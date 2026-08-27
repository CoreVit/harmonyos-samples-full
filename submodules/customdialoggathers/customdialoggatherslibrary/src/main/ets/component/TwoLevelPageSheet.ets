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
export function TwoLevelPageSheetBuilder() {
  TwoLevelPageSheet();
}

@Component
struct TwoLevelPageSheet {
  @StorageLink(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @State isShow: boolean = false
  @State isShow2: boolean = false
  @State sheetHeight: string = '50%';
  @State sheetHeight2: number = 200;
  @State showDragBar: boolean = true;
  @State showDragBar2: boolean = true;

  @Builder
  bindSheetBuilder() {
    Column() {
      Row() {
        TextInput({ placeholder: $r('app.string.please_enter') })
      }
      .width(CommonConstants.FULL_PERCENT)

      Column() {
        Button($r('app.string.button_three'))
          .fontSize($r('sys.float.Subtitle_M'))
          .width(this.curBp === 'sm' ? CommonConstants.FULL_PERCENT : CommonConstants.WIDTH_MD_LG)
          .height($r('app.integer.button_height_small'))
          .margin({ bottom: $r('sys.float.padding_level6') })
          .backgroundColor($r('sys.color.brand'))
          .onClick(() => {
            this.isShow2 = true;
          })
          .bindSheet(this.isShow2, this.bindSheetBuilder2(), {
            height: this.sheetHeight2,
            dragBar: this.showDragBar2,
            preferType: SheetType.CENTER,
            backgroundColor: $r('sys.color.comp_background_primary'),
            onWillDisappear: () => {
              this.isShow2 = false;
            }
          })

        Button($r('app.string.button_two'))
          .fontSize($r('sys.float.Subtitle_M'))
          .width(this.curBp === 'sm' ? CommonConstants.FULL_PERCENT : CommonConstants.WIDTH_MD_LG)
          .height($r('app.integer.button_height_small'))
          .backgroundColor($r('sys.color.brand'))
          .onClick(() => {
            this.isShow = false;
          })
      }
      .margin({
        bottom: this.curBp === 'lg' && this.navigatorBarHeight === 0 ?
          $r('sys.float.padding_level12') : $r('sys.float.padding_level6')
      })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .padding({
      top: $r('app.integer.padding_max'),
      right: $r('sys.float.padding_level8'),
      bottom: this.navigatorBarHeight,
      left: $r('sys.float.padding_level8')
    })
  }

  @Builder
  bindSheetBuilder2() {
    Column() {
      Button($r('app.string.button_four'))
        .fontSize($r('sys.float.Subtitle_M'))
        .width(this.curBp === 'sm' ? CommonConstants.FULL_PERCENT : CommonConstants.WIDTH_MD_LG)
        .height($r('app.integer.button_height_small'))
        .margin({ bottom: $r('sys.float.padding_level6') })
        .backgroundColor($r('sys.color.brand'))
        .onClick(() => {
          this.isShow2 = false;
        })
      Button($r('app.string.button_five'))
        .fontSize($r('sys.float.Subtitle_M'))
        .width(this.curBp === 'sm' ? CommonConstants.FULL_PERCENT : CommonConstants.WIDTH_MD_LG)
        .height($r('app.integer.button_height_small'))
        .backgroundColor($r('sys.color.brand'))
        .margin({
          bottom: this.curBp === BreakpointTypeEnum.LG && this.navigatorBarHeight === 0 ?
          $r('sys.float.padding_level12') : $r('sys.float.padding_level6')
        })
        .onClick(() => {
          this.isShow = false;
          this.isShow2 = false;
        })
    }
    .justifyContent(FlexAlign.End)
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .padding({
      top: $r('app.integer.padding_max'),
      right: this.curBp === 'sm' ? $r('sys.float.padding_level8') : $r('sys.float.padding_level0'),
      bottom: this.navigatorBarHeight,
      left: this.curBp === 'sm' ? $r('sys.float.padding_level8') : $r('sys.float.padding_level0')
    })
  }

  build() {
    NavDestination() {
      Navigation() {
        Column() {
          Button($r('app.string.button_one'))
            .onClick(() => {
              this.isShow = true;
            })
            .fontSize($r('sys.float.Subtitle_M'))
            .width(this.curBp === 'sm' ? CommonConstants.FULL_PERCENT : CommonConstants.WIDTH_MD_LG)
            .height($r('app.integer.button_height_small'))
            .margin({ bottom: $r('sys.float.padding_level6') })
            .backgroundColor($r('sys.color.brand'))
            .bindSheet(this.isShow, this.bindSheetBuilder(), {
              height: this.sheetHeight,
              dragBar: this.showDragBar,
              preferType: SheetType.CENTER,
              backgroundColor: $r('sys.color.comp_background_primary'),
              onWillDisappear: () => {
                this.isShow = false;
              }
            })
        }
        .width(CommonConstants.FULL_PERCENT)
        .height(CommonConstants.FULL_PERCENT)
        .justifyContent(FlexAlign.End)
        .padding({
          right: this.curBp === 'sm' ? $r('sys.float.padding_level8') : $r('sys.float.padding_level0'),
          left: this.curBp === 'sm' ? $r('sys.float.padding_level8') : $r('sys.float.padding_level0')
        })
      }
      .title($r('app.string.two_level_dialog'))
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