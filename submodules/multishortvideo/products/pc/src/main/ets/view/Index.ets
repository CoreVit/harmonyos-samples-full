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

import { SymbolGlyphModifier } from '@kit.ArkUI';
import { MSVDataModel, WindowInfo, getWindowInfoState, MSVTextIcon, CommonConstants } from 'multishortvideobase';
import { add, follow, friends, message, mine, recommend } from '../components/Builders';
import { ContentParamsModel } from '../model/ContentParamsModel';
import { MainTabsViewModel } from '../viewmodel/MainTabsViewModel';

@Entry
@ComponentV2
struct Index {
  @Local windowInfo: WindowInfo = getWindowInfoState();
  @Local data: MSVDataModel[] = [];
  @Provider('isDark') isDark: boolean = false;
  @Provider('pathStack') pathStack: NavPathStack = new NavPathStack();
  @Provider('showSideComment') showSideComment: boolean = false;
  @Provider('showSideIndividual') showSideIndividual: boolean = false;
  @Local isShowSidebar: boolean = true;
  @Local selectedIndex: number = 0;

  aboutToAppear(): void {
    this.data = new MainTabsViewModel().getMainTabsData();
  }

  @Builder
  ContentBuilder(params: ContentParamsModel) {
    if (params.index === 0) {
      Navigation(this.pathStack) {
        Stack({ alignContent: Alignment.TopEnd }) {
          recommend()
          if (!this.showSideIndividual && !this.showSideComment) {
            Row() {
              Search({ placeholder: $r('app.string.search_placeholder') })
                .width(240)
                .height(40)
                .searchIcon(new SymbolGlyphModifier($r('sys.symbol.magnifyingglass')).fontColor(
                  [$r('sys.color.icon_on_secondary')]))
                .backgroundColor($r('app.color.all_icon_bg_10'))
                .placeholderColor($r('sys.color.white'))
            }
            .height(56)
            .alignItems(VerticalAlign.Center)
            .padding({
              right: 160
            })
          }
        }
        .width(CommonConstants.FULL_PERCENT)
        .height(CommonConstants.FULL_PERCENT)
        .hitTestBehavior(this.showSideComment || this.showSideIndividual ? HitTestMode.Block :
          HitTestMode.Default)
        .gesture(TapGesture())
        .onGestureRecognizerJudgeBegin((event, current) => {
          if (current) {
            if (current.getType() === GestureControl.GestureType.TAP_GESTURE ||
              current.getType() === GestureControl.GestureType.CLICK) {
              if (this.showSideComment || this.showSideIndividual) {
                this.pathStack.pop();
                this.showSideComment = false;
                this.showSideIndividual = false;
                return GestureJudgeResult.REJECT;
              } else {
                return GestureJudgeResult.CONTINUE;
              }
            }
          }
          return GestureJudgeResult.CONTINUE;
        })
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .navBarWidthRange(['66%', '100%'])
      .navBarWidth('66%')
      .divider({ startMargin: 0, endMargin: 0 })
      .hideBackButton(true)
      .hideTitleBar(true)
      .mode(this.showSideComment || this.showSideIndividual ? NavigationMode.Split : NavigationMode.Stack)
      .enableModeChangeAnimation(false)
    } else if (params.index === 1) {
      follow()
    } else if (params.index === 2) {
      friends()
    } else if (params.index === 3) {
      add()
    } else if (params.index === 4) {
      message()
    } else if (params.index === 5) {
      mine()
    }
  }

  build() {
    SideBarContainer(SideBarContainerType.Embed) {
      Column() {
        MSVTextIcon({ src: $r('app.media.startIcon'), iconSize: 24 })
          .margin({
            left: 24,
            top: 16
          })
        List() {
          Repeat<MSVDataModel>(this.data)
            .each((item: RepeatItem<MSVDataModel>) => {
              ListItem() {
                Row({ space: 8 }) {
                  MSVTextIcon(
                    { src: this.selectedIndex === item.index ? item.item.icon : item.item.iconDark, iconSize: 24 })
                  Text(item.item.text)
                    .fontSize($r('sys.float.Body_L'))
                    .fontColor(this.selectedIndex === item.index ? '#ffffff' :
                      '#c7c7c8')
                    .fontWeight($r('sys.float.font_weight_medium'))
                }
                .width(CommonConstants.FULL_PERCENT)
                .height(40)
                .borderRadius(8)
                .alignItems(VerticalAlign.Center)
                .justifyContent(FlexAlign.Center)
                .backgroundColor(this.selectedIndex === item.index ? $r('app.color.all_icon_bg_10') :
                  Color.Transparent)
              }
              .onClick(() => {
                this.selectedIndex = item.index
              })
            })
            .key((item: MSVDataModel) => JSON.stringify(item))
            .virtualScroll({ totalCount: this.data.length })
        }
        .width(CommonConstants.FULL_PERCENT)
        .height('auto')
        .margin({ top: 40 })
        .padding({
          left: 8,
          right: 8
        })
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .backgroundColor($r('sys.color.black'))
      .alignItems(HorizontalAlign.Start)

      Column() {
        this.ContentBuilder({ index: this.selectedIndex })
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
    }
    .sideBarWidth(112)
    .divider({ strokeWidth: 0.5, color: '#ff646466' })
    .showControlButton(false)
  }
}
