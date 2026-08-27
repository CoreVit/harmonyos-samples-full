/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { uiObserver } from '@kit.ArkUI';
import { WidthBreakpointType } from '../utils/WidthBreakpointType';
import { HomeHeaderState } from '../viewmodel/HomeHeaderState';

@ComponentV2
export struct HomeHeader {
  private context: Context = this.getUIContext().getHostContext()!;
  @Env(SystemProperties.BREAK_POINT) private breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Local private headerState: HomeHeaderState = new HomeHeaderState(this.context);

  build() {
    Column() {
      GridRow({ columns: { xs: 4, sm: 4, md: 11, lg: 12, xl: 12 } }) {
        GridCol({ span: { xs: 4, sm: 4, md: 7, lg: 8, xl: 8 } }) {
          this.topTabBar()
        }
        .height(56)

        GridCol({ span: { xs: 4, sm: 4, md: 4, lg: 4, xl: 4 } }) {
          this.searchBar()
        }
        .height(56)
      }
      .padding({
        right: new WidthBreakpointType(16, 16, 24, 24).getValue(this.breakpoint.widthBreakpoint)
      })
    }
    .width('100%')
  }

  @Builder
  private topTabBar() {
    List({
      space: new WidthBreakpointType(14, 14, 16, 16).getValue(this.breakpoint.widthBreakpoint)
    }) {
      ForEach(this.headerState.tabs, (item: string, index: number) => {
        ListItem() {
          Text(item)
            .fontSize(index === this.headerState.selectedIndex ? 24 : 18)
            .lineHeight(index === this.headerState.selectedIndex ? 32 : 24)
            .fontWeight(index === this.headerState.selectedIndex ? FontWeight.Medium : FontWeight.Normal)
            .fontColor(
              index === this.headerState.selectedIndex
                ? $r('app.color.text_primary')
                : $r('app.color.text_tertiary')
            )
        }
        .onClick(() => this.headerState.selectTab(index))
        .layoutWeight(1)
      }, (item: string, index: number) => `${item}${index}`)
    }
    .scrollBar(BarState.Off)
    .alignListItem(ListItemAlign.Center)
    .listDirection(Axis.Horizontal)
    .padding({
      left: new WidthBreakpointType(8, 8, 0, 0).getValue(this.breakpoint.widthBreakpoint),
      right: new WidthBreakpointType(16, 16, 24, 24).getValue(this.breakpoint.widthBreakpoint)
    })
    .width('100%')
    .height('100%')
  }

  @Builder
  private searchBar() {
    Row() {
      Stack({ alignContent: Alignment.Start }) {
        TextInput({ placeholder: $r('app.string.searching') })
          .placeholderFont({ size: 16, weight: FontWeight.Normal })
          .placeholderColor($r('sys.color.font_secondary'))
          .height(40)
          .fontSize(16)
          .padding({
            left: 36,
            right: 12
          })
          .borderRadius(20)
          .backgroundColor($r('app.color.overlay_low'))
          .width('100%')
          .enableKeyboardOnFocus(false)
        SymbolGlyph($r('sys.symbol.magnifyingglass'))
          .fontSize(16)
          .fontColor([$r('sys.color.font_secondary')])
          .margin({ left: 12 })
      }
      .alignSelf(ItemAlign.Center)
      .layoutWeight(1)

      SymbolGlyph($r('sys.symbol.line_viewfinder'))
        .fontSize(24)
        .margin({
          left: new WidthBreakpointType(16, 16, 24, 24).getValue(this.breakpoint.widthBreakpoint)
        })

      SymbolGlyph($r('sys.symbol.ellipsis_message'))
        .fontSize(24)
        .margin({
          left: new WidthBreakpointType(16, 16, 24, 24).getValue(this.breakpoint.widthBreakpoint)
        })
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
}