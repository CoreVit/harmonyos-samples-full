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

import { Constants } from '../common/Constants';
import { ConfigMapKey, ResourceUtil } from '../common/ResourceUtil';
import { BreakpointType, BreakpointTypeEnum } from '../common/utils/BreakpointSystem';
import { getNWeb } from './WebPage';

@Component
export struct WebPreRenderView {
  @State isShowSheet: boolean = false;
  @StorageProp(Constants.KEY_BREAKPOINT) curBp: string = Constants.BREAKPOINTS[1];
  @StorageProp(Constants.KEY_NAV_INDICATOR_HEIGHT) navIndicatorHeight: number = 0;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;

  @Builder
  mySheet() {
    if (getNWeb(ResourceUtil.getRawFileStringByKey(ConfigMapKey.GALLERY_URL))) {
      Column() {
        NodeContainer(getNWeb(ResourceUtil.getRawFileStringByKey(ConfigMapKey.GALLERY_URL)))
          .height($r('app.string.full_height_width'))
          .width($r('app.string.full_height_width'))
      }
      .padding({
        top: $r('app.float.index_tab'),
        left: $r('sys.float.padding_level8'),
        right: $r('sys.float.padding_level8')
      })
      .width($r('app.string.full_height_width'))
      .height($r('app.string.full_height_width'))
      .backgroundColor($r('sys.color.comp_background_primary'))
    }
  }

  build() {
    Column() {
      Column() {
        Text($r('app.string.title'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.font_primary'))
          .fontSize($r('sys.float.Title_L'))
          .alignSelf(ItemAlign.Start)
          .margin({
            left: new BreakpointType({
              sm: $r('sys.float.padding_level0'),
              md: $r('sys.float.padding_level4'),
              lg: $r('sys.float.padding_level8'),
              xl: $r('sys.float.padding_level8')
            }).getValue(this.curBp)
          })
        Column() {
          Button($r('app.string.text_name'))
            .fontSize($r('sys.float.Subtitle_M'))
            .fontColor($r('sys.color.font_on_primary'))
            .width(this.curBp === BreakpointTypeEnum.SM ? '100%' : $r('app.float.index_button_width_lg'))
            .height($r('app.float.button_height'))
            .margin({ top: $r('sys.float.padding_level6') })
            .backgroundColor($r('sys.color.comp_background_emphasize'))
            .bindSheet(this.isShowSheet, this.mySheet(), {
              height: new BreakpointType({
                sm: $r('app.float.bind_sheet_height_sm'),
                md: $r('app.float.bind_sheet_height_non_sm'),
                lg: $r('app.float.bind_sheet_height_non_sm')
              }).getValue(this.curBp),
              width: this.curBp === BreakpointTypeEnum.SM ? '100%' : $r('app.float.bind_sheet_width'),
              preferType: SheetType.CENTER,
              backgroundColor: $r('sys.color.comp_background_primary'),
              onWillDisappear: () => {
                this.isShowSheet = !this.isShowSheet;
              }
            })
            .onClick(() => {
              this.isShowSheet = !this.isShowSheet;
            })
        }
        .width(Constants.FULL_WIDTH)
      }
      .backgroundColor($r('sys.color.background_secondary'))
      .width(Constants.FULL_WIDTH)
      .height(Constants.FULL_HEIGHT)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: $r('sys.float.padding_level8'),
        right: $r('sys.float.padding_level8'),
        top: Constants.PADDING_TOP_INDEX + this.statusBarHeight,
        bottom: Constants.PADDING_BOTTOM_INDEX + this.navIndicatorHeight
      })
    }
    .width($r('app.string.full_height_width'))
    .height($r('app.string.full_height_width'))
    .backgroundColor($r('sys.color.background_secondary'))
  }
}