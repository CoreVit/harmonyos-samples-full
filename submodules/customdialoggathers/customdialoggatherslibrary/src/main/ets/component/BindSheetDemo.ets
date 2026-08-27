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
export function BindSheetDemoBuilder() {
  BindSheetDemo();
}

@Component
struct BindSheetDemo {
  @StorageLink(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @State isShowSheet: boolean = false;
  private menuList: ResourceStr[] = [
    $r('app.string.spicy'), $r('app.string.spicy1'), $r('app.string.spicy2'), $r('app.string.spicy3'),
    $r('app.string.spicy4'), $r('app.string.spicy5')];

  @Builder
  mySheet() {
    Column() {
      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
        ForEach(this.menuList, (item: string) => {
          Text(item)
            .height($r('sys.float.Display_S'))
            .fontSize($r('sys.float.Subtitle_M'))
            .fontColor($r('sys.color.font_primary'))
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .borderRadius($r('sys.float.corner_radius_level6'))
            .margin({
              right: $r('sys.float.corner_radius_level6'),
              bottom: $r('sys.float.corner_radius_level6')
            })
            .padding({
              top: $r('sys.float.corner_radius_level4'),
              right: $r('sys.float.corner_radius_level6'),
              bottom: $r('sys.float.corner_radius_level4'),
              left: $r('sys.float.corner_radius_level6')
            })
        }, (item: string, index: number) => (item + index).toString())
      }
      .borderRadius($r('sys.float.corner_radius_level8'))
      .backgroundColor($r('app.color.month_day_background'))
      .margin({
        top: $r('sys.float.corner_radius_level4'),
        right: $r('sys.float.corner_radius_level8'),
        left: $r('sys.float.corner_radius_level8')
      })
      .padding({
        top: $r('sys.float.corner_radius_level8'),
        right: $r('sys.float.corner_radius_level8'),
        bottom: $r('sys.float.corner_radius_level2'),
        left: $r('sys.float.corner_radius_level8')
      })
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .backgroundColor($r('app.color.bottom_bind_sheet_background'))
  }

  build() {
    NavDestination() {
      Navigation() {
        Column() {
          Text($r('app.string.tastes'))
            .fontSize($r('sys.float.Subtitle_L'))
            .fontColor($r('sys.color.font_primary'))
            .width(CommonConstants.FULL_PERCENT)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bold)
            .padding({
              top: $r('sys.float.padding_level16'),
              bottom: $r('sys.float.padding_level4')
            })
          Column() {
            Row() {
              Text($r('app.string.choose_flavors'))
                .fontColor($r('sys.color.font_primary'))
                .fontSize($r('sys.float.Subtitle_M'))
                .fontWeight(FontWeight.Medium)
              SymbolGlyph($r('sys.symbol.chevron_right'))
                .fontColor([$r('sys.color.font_primary')])
                .fontSize($r('sys.float.Title_L'))
            }
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.SpaceBetween)
            .width(CommonConstants.FULL_PERCENT)
            .borderRadius($r('sys.float.corner_radius_level6'))
            .width(CommonConstants.FULL_PERCENT)
            .padding($r('sys.float.padding_level8'))
            .backgroundColor($r('sys.color.comp_background_primary'))
            .bindSheet(this.isShowSheet, this.mySheet(), {
              title: { title: $r('app.string.select') },
              scrollSizeMode: ScrollSizeMode.FOLLOW_DETENT,
              height: new BreakpointType({ sm: 320, md: 120, lg: 140 }).getValue(this.curBp),
              width: this.curBp === 'sm' ? '100%' : $r('app.integer.bind_sheet_width'),
              preferType: SheetType.CENTER,
              backgroundColor: $r('app.color.bind_sheet_background'),
              onWillDisappear: () => {
                this.isShowSheet = !this.isShowSheet;
              }
            })
            .onClick(() => {
              this.isShowSheet = !this.isShowSheet;
            })
          }
          .width(CommonConstants.FULL_PERCENT)
        }
        .width(CommonConstants.FULL_PERCENT)
        .backgroundColor($r('sys.color.background_secondary'))
        .padding({
          right: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.curBp),
          left: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.curBp)
        })
      }
      .title($r('app.string.bind_sheet_dialog'))
      .titleMode(NavigationTitleMode.Mini)
      .mode(NavigationMode.Stack)
      .padding({
        top: this.statusBarHeight,
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
