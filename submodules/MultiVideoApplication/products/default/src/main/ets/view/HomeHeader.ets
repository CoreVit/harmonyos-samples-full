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

import {
  BreakpointType,
  CommonConstants,
  ImmersiveType,
  WindowInfo,
  WindowUtil
} from 'multivideobase';
import { DefaultConstants, getTabIndex } from '../constants/DefaultConstants';

@Component
export struct DefaultHomeHeader {
  @ObjectLink @Watch('mainWindowInfoChange') mainWindowInfo: WindowInfo;
  @Consume('currentTopIndex') currentTopIndex: number = 0;
  @StorageLink(CommonConstants.WINDOW_UTIL) windowUtil: WindowUtil | undefined = undefined;
  @Consume('pageInfo') pageInfo: NavPathStack;
  @Link scrollHeight: number;
  @State topAvoidHeight: number = this.getUIContext().px2vp(this.mainWindowInfo.avoidSystem?.topRect.height);

  mainWindowInfoChange() {
    this.topAvoidHeight = this.getUIContext().px2vp(this.mainWindowInfo.avoidSystem?.topRect.height);
  }

  getSMBreakPointColSpans(): number {
    if (this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
      this.mainWindowInfo.heightBp >= HeightBreakpoint.HEIGHT_LG) {
      return 4;
    } else {
      return 2;
    }
  }

  getTopSearchBarPaddingTop(): string | Resource {
    if (this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
      this.mainWindowInfo.heightBp >= HeightBreakpoint.HEIGHT_LG) {
      return '0vp';
    }
    return '8vp'
  }

  getTopTabBarPaddingTop(): string | Resource {
    if (this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
      this.mainWindowInfo.heightBp >= HeightBreakpoint.HEIGHT_LG) {
      return this.topAvoidHeight + DefaultConstants.VP_UNIT;
    }
    return '8vp'
  }

  build() {
    Column() {
      GridRow({ columns: { sm: 4, md: 12, lg: 12, xl: 12 } }) {
        GridCol({ span: { sm: this.getSMBreakPointColSpans(), md: 7, lg: 7, xl: 7 } }) {
          this.TopTabBar()
        }
        .margin({ top: this.getTopTabBarPaddingTop() })
        .height(this.currentTopIndex === 2 && this.mainWindowInfo.widthBp > WidthBreakpoint.WIDTH_SM ?
          `${this.topAvoidHeight + 59}${DefaultConstants.VP_UNIT}` : '59vp')
        .padding({
          top: this.currentTopIndex === 2 && this.mainWindowInfo.widthBp > WidthBreakpoint.WIDTH_SM ?
            `${this.topAvoidHeight}${DefaultConstants.VP_UNIT}` : '0vp'
        })

        GridCol({ span: { sm: this.getSMBreakPointColSpans(), md: 5, lg: 5, xl: 5 } }) {
          this.searchBar()
        }
        .margin({ top: this.getTopSearchBarPaddingTop() })
        .height(this.currentTopIndex === 2 && this.mainWindowInfo.widthBp > WidthBreakpoint.WIDTH_SM ?
          `${this.topAvoidHeight + 59}${DefaultConstants.VP_UNIT}` : '59vp')
        .width('146vp')
        .padding({
          top: this.currentTopIndex === 2 && this.mainWindowInfo.widthBp > WidthBreakpoint.WIDTH_SM ?
            `${this.topAvoidHeight}${DefaultConstants.VP_UNIT}` : '0vp'
        })
      }
      .backgroundColor(this.scrollHeight >=
      new BreakpointType(DefaultConstants.BACKGROUND_CHANGE_HEIGHT[0], DefaultConstants.BACKGROUND_CHANGE_HEIGHT[0],
        DefaultConstants.BACKGROUND_CHANGE_HEIGHT[1], DefaultConstants.BACKGROUND_CHANGE_HEIGHT[2],
        DefaultConstants.BACKGROUND_CHANGE_HEIGHT[2])
        .getValue(this.mainWindowInfo.widthBp) && this.currentTopIndex === 2 ? $r('app.color.dft_home_content_background') :
        $r('app.color.dft_transparent'))
    }
    .width('100%')
  }

  @Builder
  TopTabBar() {
    Row() {
      Column() {
        List() {
          ForEach(DefaultConstants.TOP_TOPIC_LIST, (item: string, index: number) => {
            ListItem() {
              Text(item)
                .fontSize(this.currentTopIndex === index ? '24fp' : '18fp')
                .fontWeight(this.currentTopIndex === index ? 700 : 500)
                .textAlign(TextAlign.Center)
                .fontColor(this.currentTopIndex === 2 ? $r('app.color.dft_text_title_on_immersive') :
                  $r('app.color.dft_text_primary'))
                .focusable(true)
                .groupDefaultFocus(index === 0 ? true : false)
                .borderRadius(4)
                .opacity(this.currentTopIndex === index ? 1 : 0.6)
            }
            .align(Alignment.Center)
            .margin({
              top: this.currentTopIndex === index ? '12vp' : '16vp',
              bottom: this.currentTopIndex === index ? '11vp' : '15vp'
            })
            .padding({
              left: new BreakpointType(8, 8, 12, 18, 18).getValue(this.mainWindowInfo.widthBp),
              right: new BreakpointType(8, 8, 12, 18, 18).getValue(this.mainWindowInfo.widthBp)
            })
            .onClick(() => {
              this.currentTopIndex = index;
              this.scrollHeight = 0;
            })
          }, (item: number, index: number) => index + JSON.stringify(item))
        }
        .tabIndex(getTabIndex(DefaultConstants.DIRECTION_LIST[1]))
        .scrollBar(BarState.Off)
        .listDirection(Axis.Horizontal)
        .padding({ left: '24vp' })
        .width('100%')
        .height('100%')
      }
      .alignItems(HorizontalAlign.Center)
      .layoutWeight(1)

      Row() {
        Image($r('app.media.ic_public_more'))
          .width('24vp')
          .height('24vp')
          .fillColor(this.currentTopIndex === 2 ? $r('app.color.dft_header_icon_on_immersive') : $r('app.color.dft_header_icon'))
      }
      .backgroundColor(this.currentTopIndex === 2 ? $r('app.color.dft_header_icon_background_on_immersive') : $r('app.color.dft_header_icon_background'))
      .width('40vp')
      .height('40vp')
      .margin({
        left: '24vp',
        right: '24vp'
      })
      .border({
        width: 0,
        radius: 20
      })
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .visibility((this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
        this.mainWindowInfo.heightBp >= HeightBreakpoint.HEIGHT_LG) ? Visibility.Visible : Visibility.None)
    }
    .height('56vp')
    .width('100%')
  }

  @Builder
  searchBar() {
    Row() {
      Stack({ alignContent: Alignment.Start }) {
        TextInput({ placeholder: DefaultConstants.SEARCH_PLACEHOLDER })
          .placeholderFont({
            size: '16fp',
            weight: FontWeight.Normal
          })
          .placeholderColor(this.currentTopIndex === 2 ? $r('app.color.dft_search_placeholder_on_immersive') :
            $r('app.color.dft_search_placeholder'))
          .height('40vp')
          .fontSize('16fp')
          .padding({
            left: '36vp',
            right: '12vp'
          })
          .width('100%')
          .onClick(() => {
            this.pageInfo.pushPath({ name : DefaultConstants.PAGE_NAME_FOR_SEARCH });
          })
          .onSubmit((enterKey: EnterKeyType) => {
            if (enterKey === EnterKeyType.Go) {
              this.pageInfo.pushPath({ name : DefaultConstants.PAGE_NAME_FOR_SEARCH });
            }
          })
          .enterKeyType(EnterKeyType.Go)
          .enableKeyboardOnFocus(false)
          .backgroundColor(this.currentTopIndex === 2 ? $r('app.color.dft_search_input_background_on_immersive') :
            $r('app.color.dft_search_input_background'))
          .tabIndex(getTabIndex(DefaultConstants.DIRECTION_LIST[1]))
          .focusable(false)

        SymbolGlyph($r('sys.symbol.magnifyingglass'))
          .fontSize('16fp')
          .margin({ left: '12vp' })
          .fontColor([this.currentTopIndex === 2 ? $r('app.color.dft_search_placeholder_on_immersive') :
            $r('app.color.dft_search_placeholder')])
      }
      .alignSelf(ItemAlign.Center)
      .layoutWeight(1)
      .visibility((this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
        this.mainWindowInfo.heightBp <= HeightBreakpoint.HEIGHT_MD) ? Visibility.None : Visibility.Visible)

      Row() {
        SymbolGlyph($r('sys.symbol.magnifyingglass'))
          .fontSize('24fp')
          .fontColor([this.currentTopIndex === 2 ? $r('app.color.dft_header_icon_on_immersive') :
            $r('app.color.dft_header_icon')])
      }
      .backgroundColor(this.currentTopIndex === 2 ? $r('app.color.dft_header_icon_background_on_immersive') : $r('app.color.dft_header_icon_background'))
      .width('40vp')
      .height('40vp')
      .border({
        width: 0,
        radius: 20
      })
      .margin({ bottom: '4vp' })
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .visibility((this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
        this.mainWindowInfo.heightBp <= HeightBreakpoint.HEIGHT_MD) ? Visibility.Visible : Visibility.None)
      .onClick(() => {
        this.windowUtil?.setImmersiveType(ImmersiveType.IMMERSIVE);
        this.pageInfo.pushPath({ name: DefaultConstants.PAGE_NAME_FOR_SEARCH });
      })

      Row() {
        SymbolGlyph($r('sys.symbol.arrow_counterclockwise_clock'))
          .fontSize('24fp')
          .fontColor([this.currentTopIndex === 2 ? $r('app.color.dft_header_icon_on_immersive') :
            $r('app.color.dft_header_icon')])
      }
      .backgroundColor(this.currentTopIndex === 2 ? $r('app.color.dft_header_icon_background_on_immersive') : $r('app.color.dft_header_icon_background'))
      .width('40vp')
      .height('40vp')
      .margin({
        left: this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
          this.mainWindowInfo.heightBp <= HeightBreakpoint.HEIGHT_MD ? '8vp' : '15vp',
        bottom: '4vp' })
      .border({
        width: 0,
        radius: 20
      })
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)

      Row() {
        SymbolGlyph($r('sys.symbol.dot_grid_2x2'))
          .fontSize('24fp')
          .fontColor([this.currentTopIndex === 2 ? $r('app.color.dft_header_icon_on_immersive') :
            $r('app.color.dft_header_icon')])
      }
      .backgroundColor(this.currentTopIndex === 2 ? $r('app.color.dft_header_icon_background_on_immersive') : $r('app.color.dft_header_icon_background'))
      .width('40vp')
      .height('40vp')
      .margin({ left: '8vp', bottom: '4vp' })
      .border({
        width: 0,
        radius: 20
      })
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .visibility((this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
        this.mainWindowInfo.heightBp >= HeightBreakpoint.HEIGHT_LG) ? Visibility.None : Visibility.Visible)
    }
    .padding({
      left: this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
        this.mainWindowInfo.heightBp <= HeightBreakpoint.HEIGHT_MD ? '10.5vp' : '24vp',
      right: this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
        this.mainWindowInfo.heightBp <= HeightBreakpoint.HEIGHT_MD ? '10.5vp' : '24vp'
    })
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('56vp')
  }
}
