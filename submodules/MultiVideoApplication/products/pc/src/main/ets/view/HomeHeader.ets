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

import { common } from '@kit.AbilityKit';
import {
  BreakpointType,
  CommonConstants,
  SetDecorButtonStyleUtil,
  WindowInfo,
  WindowUtil
} from 'multivideobase';
import { PcConstants, getTabIndex } from '../constants/PcConstants';

@Component
export struct PcHomeHeader {
  @ObjectLink @Watch('mainWindowInfoChange') mainWindowInfo: WindowInfo;
  @Consume('currentTopIndex') currentTopIndex: number = 0;
  @StorageLink(CommonConstants.WINDOW_UTIL) windowUtil: WindowUtil | undefined = undefined;
  @Consume('pageInfo') pageInfo: NavPathStack;
  @Link scrollHeight: number;
  @Link decorWidth: number;
  @Link decorHeight: number;
  @State topAvoidHeight: number = this.getUIContext().px2vp(this.mainWindowInfo.avoidSystem?.topRect.height);

  mainWindowInfoChange() {
    this.topAvoidHeight = this.getUIContext().px2vp(this.mainWindowInfo.avoidSystem?.topRect.height);
    if (!(this.pageInfo.getAllPathName().length > 0 &&
      this.pageInfo.getAllPathName()[this.pageInfo.getAllPathName().length - 1] === PcConstants.PAGE_NAME_FOR_VIDEO)) {
      SetDecorButtonStyleUtil.setDecorButtonForImmersive(this.currentTopIndex, this.pageInfo, this.windowUtil,
        this.getUIContext().getHostContext() as common.UIAbilityContext);
    }
  }

  getSMBreakPointColSpans(): number {
    if (this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
      this.mainWindowInfo.heightBp >= HeightBreakpoint.HEIGHT_LG) {
      return 4;
    } else {
      return 2;
    }
  }

  build() {
    Column() {
      GridRow({ columns: { sm: 4, md: 12, lg: 12, xl: 12 } }) {
        GridCol({ span: { lg: 5, xl: 5 } }) {
          this.TopTabBar()
        }

        GridCol({ span: { lg: 7, xl: 7 } }) {
          this.searchBar()
        }
        .margin({ right: this.decorWidth })
      }
      .backgroundColor(this.scrollHeight >=
        new BreakpointType(PcConstants.BACKGROUND_CHANGE_HEIGHT[0], PcConstants.BACKGROUND_CHANGE_HEIGHT[0],
          PcConstants.BACKGROUND_CHANGE_HEIGHT[1], PcConstants.BACKGROUND_CHANGE_HEIGHT[2],
          PcConstants.BACKGROUND_CHANGE_HEIGHT[2])
          .getValue(this.mainWindowInfo.widthBp) && this.currentTopIndex === 2 ? $r('app.color.pc_home_content_background') :
        $r('app.color.pc_transparent'))
    }
    .width('100%')
    .height(this.decorHeight)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  TopTabBar() {
    Row() {
      Column() {
        List() {
          ForEach(PcConstants.TOP_TOPIC_LIST, (item: string, index: number) => {
            ListItem() {
              Text(item)
                .fontSize(this.currentTopIndex === index ? '24fp' : '18fp')
                .fontWeight(this.currentTopIndex === index ? 700 : 500)
                .textAlign(TextAlign.Center)
                .fontColor(this.currentTopIndex === 2 ? $r('app.color.pc_text_title_on_immersive') :
                  $r('app.color.pc_text_primary'))
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
              SetDecorButtonStyleUtil.setDecorButtonForImmersive(index, this.pageInfo, this.windowUtil,
                this.getUIContext().getHostContext() as common.UIAbilityContext);
            })
          }, (item: number, index: number) => index + JSON.stringify(item))
        }
        .tabIndex(getTabIndex(PcConstants.DIRECTION_LIST[1]))
        .scrollBar(BarState.Off)
        .listDirection(Axis.Horizontal)
        .padding({ left: '24vp' })
        .width('100%')
        .height('100%')
        .alignListItem(ListItemAlign.Center)
      }
      .alignItems(HorizontalAlign.Center)
      .layoutWeight(1)
      .height('100%')
    }
    .height(this.decorHeight)
    .width('100%')
  }

  @Builder
  searchBar() {
    Row() {
      Stack({ alignContent: Alignment.Start }) {
        TextInput({ placeholder: PcConstants.SEARCH_PLACEHOLDER })
          .placeholderFont({
            size: '16fp',
            weight: FontWeight.Normal
          })
          .placeholderColor(this.currentTopIndex === 2 ? $r('app.color.pc_search_placeholder_on_immersive') :
            $r('app.color.pc_search_placeholder'))
          .height('40vp')
          .fontSize('16fp')
          .padding({
            left: '36vp',
            right: '12vp'
          })
          .width('100%')
          .onClick(() => {
            this.pageInfo.pushPath({ name : PcConstants.PAGE_NAME_FOR_SEARCH });
          })
          .onSubmit((enterKey: EnterKeyType) => {
            if (enterKey === EnterKeyType.Go) {
              this.pageInfo.pushPath({ name : PcConstants.PAGE_NAME_FOR_SEARCH });
            }
          })
          .enterKeyType(EnterKeyType.Go)
          .enableKeyboardOnFocus(false)
          .backgroundColor(this.currentTopIndex === 2 ? $r('app.color.pc_search_input_background_on_immersive') :
            $r('app.color.pc_search_input_background'))
          .tabIndex(getTabIndex(PcConstants.DIRECTION_LIST[1]))
          .focusable(false)

        SymbolGlyph($r('sys.symbol.magnifyingglass'))
          .fontSize('16fp')
          .margin({ left: '12vp' })
          .fontColor([this.currentTopIndex === 2 ? $r('app.color.pc_search_placeholder_on_immersive') :
            $r('app.color.pc_search_placeholder')])
      }
      .alignSelf(ItemAlign.Center)
      .layoutWeight(1)
      .visibility((this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
        this.mainWindowInfo.heightBp <= HeightBreakpoint.HEIGHT_MD) ? Visibility.None : Visibility.Visible)

      SymbolGlyph($r('sys.symbol.arrow_counterclockwise_clock'))
        .fontSize('24fp')
        .fontColor([this.currentTopIndex === 2 ? $r('app.color.pc_header_icon_on_immersive') :
          $r('app.color.pc_header_icon')])
        .margin({ left: '15vp'})

      SymbolGlyph($r('sys.symbol.dot_grid_2x2'))
        .fontSize('24fp')
        .fontColor([this.currentTopIndex === 2 ? $r('app.color.pc_header_icon_on_immersive') :
          $r('app.color.pc_header_icon')])
        .margin({ left: '15vp'})
    }
    .padding({ left: '24vp' })
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(this.decorHeight)
  }
}
