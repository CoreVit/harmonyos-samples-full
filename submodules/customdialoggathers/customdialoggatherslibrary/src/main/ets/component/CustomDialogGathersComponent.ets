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

import { BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/constants/CommonConstants';
import { TitleModel } from '../viewmodel/DateModel';
import { WindowUtil } from '../utils/WindowUtil';

@Component
export struct CustomDialogGathersComponent {
  @StorageLink(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @Provide(CommonConstants.AS_KEY_PATH_STACK) pathStack: NavPathStack = new NavPathStack();
  scroller: Scroller = new Scroller();
  titleList: Array<TitleModel> = [
    new TitleModel($r('app.string.scroll_option'), 'ScrollOption'),
    new TitleModel($r('app.string.dialog_name'), 'BindContentCoverDemo'),
    new TitleModel($r('app.string.bind_sheet_dialog'), 'BindSheetDemo'),
    new TitleModel($r('app.string.toast_dialog'), 'CustomDialogUser'),
    new TitleModel($r('app.string.full_screen'), 'FullScreen'),
    new TitleModel($r('app.string.calendar_dialog'), 'CalendarView'),
    new TitleModel($r('app.string.two_level_dialog'), 'TwoLevelPageSheet')
  ];

  @Builder
  Options(name: Resource, url: string, index: number, titleLength: number) {
    Column() {
      Row() {
        Text(name)
          .fontColor($r('sys.color.font_primary'))
          .fontSize($r('sys.float.Subtitle_M'))
          .fontWeight(FontWeight.Medium)
        SymbolGlyph($r('sys.symbol.chevron_right'))
          .fontColor([$r('sys.color.icon_fourth')])
          .fontSize($r('sys.float.Title_M'))
      }
      .height($r('app.integer.text_icon_height'))
      .width(CommonConstants.FULL_PERCENT)
      .justifyContent(FlexAlign.SpaceBetween)

      Divider()
        .vertical(false)
        .height(CommonConstants.FULL_PERCENT)
        .color($r('sys.color.comp_divider'))
        .visibility(this.curBp === 'sm' ? (index < titleLength - 1 ? Visibility.Visible : Visibility.None) :
          (index < titleLength - 2 ? Visibility.Visible : Visibility.None))
    }
    .borderRadius({
      topLeft: index === 0 ? $r('sys.float.corner_radius_level6') : 0,
      topRight: this.curBp === 'sm' ? (index === 0 ? $r('sys.float.corner_radius_level6') : 0) :
        (index === 1 ? $r('sys.float.corner_radius_level6') : 0),
      bottomLeft: this.curBp === 'sm' ? (index < titleLength - 1 ? 0 : $r('sys.float.corner_radius_level6')) :
        (index === titleLength - 2 ? $r('sys.float.corner_radius_level6') : 0),
      bottomRight: this.curBp === 'sm' ? (index < titleLength - 1 ? 0 : $r('sys.float.corner_radius_level6')) :
        (index === titleLength - 1 ? $r('sys.float.corner_radius_level6') : 0)
    })
    .backgroundColor($r('sys.color.comp_background_primary'))
    .width(CommonConstants.FULL_PERCENT)
    .height($r('app.integer.button_height'))
    .padding({
      top: this.curBp === 'sm' ? $r('sys.float.padding_level7') : $r('sys.float.padding_level9'),
      right: $r('sys.float.padding_level6'),
      bottom: this.curBp === 'sm' ? $r('sys.float.padding_level7') : $r('sys.float.padding_level9'),
      left: $r('sys.float.padding_level6')
    })
    .onClick(() => {
      this.pathStack.pushPathByName(url, null);
    })
  }

  aboutToDisappear(): void {
    WindowUtil.unregisterBreakPoint();
  }

  build() {
    Navigation(this.pathStack) {
      Column() {
        Grid() {
          ForEach(this.titleList, (item: TitleModel, index: number) => {
            GridItem() {
              this.Options(item.title, item.url, index, this.titleList.length)
            }
          }, (item: TitleModel) => item.title.id.toString())
        }
        .padding($r('sys.float.padding_level8'))
        .height(CommonConstants.FULL_PERCENT)
        .width(CommonConstants.FULL_PERCENT)
        .backgroundColor($r('sys.color.background_secondary'))
        .columnsTemplate(this.curBp === 'sm' ? '1fr' : '1fr 1fr')
      }
      .borderRadius($r('sys.float.corner_radius_level6'))
      .height(CommonConstants.FULL_PERCENT)
      .width(CommonConstants.FULL_PERCENT)
    }
    .title($r('app.string.index_name'))
    .titleMode(NavigationTitleMode.Full)
    .mode(NavigationMode.Stack)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}