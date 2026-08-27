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

import { ChildRoute, CommonConstants, Route } from '../common/CommonConstants';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { WindowUtil } from '../utils/WindowUtil';

@Component
export struct MultiTabNavigationComponent {
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @Provide(CommonConstants.AS_KEY_PATH_STACK) pathStack: NavPathStack = new NavPathStack();
  private routes: Route[] = CommonConstants.ROUTES;

  aboutToDisappear(): void {
    WindowUtil.unregisterBreakPoint();
  }

  build() {
    Navigation(this.pathStack) {
      Column() {
        Scroll() {
          Column() {
            ForEach(this.routes, (item: Route) => {
              Row() {
                Text(item.title)
                  .width(CommonConstants.INDEX_CONTENT_WIDTH)
                  .fontSize($r('app.float.double_sub_title_size'))
                  .fontColor($r('sys.color.font_secondary'))
              }
              .margin({ top: $r('sys.float.padding_level12'), bottom: $r('sys.float.padding_level4') })
              .padding({ left: $r('sys.float.padding_level6') })
              .alignSelf(ItemAlign.Start)
              .height(CommonConstants.CARD_TITLE_HEIGHT)

              WaterFlow() {
                ForEach(item.child, (itemChild: ChildRoute, index: number) => {
                  if ((itemChild.text === '' && this.curBp !== 'sm') || (itemChild.text !== '')) {
                    FlowItem() {
                      Column() {
                        Row() {
                          Text(itemChild.text)
                            .fontColor($r('sys.color.font_primary'))
                            .width(CommonConstants.FULL_WIDTH)
                            .height(CommonConstants.FULL_HEIGHT)
                            .fontWeight(FontWeight.Medium)
                            .fontSize($r('app.float.text_size'))
                            .textAlign(TextAlign.Start)
                          if (itemChild.text !== '') {
                            SymbolGlyph($r('sys.symbol.chevron_forward'))
                              .fontSize($r('app.float.text_size'))
                              .fontColor([$r('sys.color.icon_tertiary')])
                          }
                        }
                        .padding({ right: $r('app.float.padding_bottom_tab') })
                        .justifyContent(FlexAlign.SpaceBetween)
                        .borderWidth({
                          top: this.curBp === 'sm' ? (index === 0 ? 0 : 0.5) : (index !== 0 && index !== 1) ? 0.5 : 0
                        })
                        .borderColor($r('sys.color.comp_divider'))
                        .width(CommonConstants.FULL_WIDTH)
                        .height(new BreakpointType({ sm: 48, md: 56, lg: 56 }).getValue(this.curBp))
                      }
                      .padding({ left: $r('app.float.padding_bottom_tab'), right: $r('app.float.padding_bottom_tab') })
                      .backgroundColor($r('sys.color.comp_background_primary'))
                      .onClick(() => {
                        if (itemChild.text === '' && itemChild.to === '') {
                          return;
                        }
                        this.pathStack.pushPathByName(itemChild.to, null);
                      })
                      .width(CommonConstants.FULL_WIDTH)
                      .height(new BreakpointType({ sm: 48, md: 56, lg: 56 }).getValue(this.curBp))
                    }
                  }
                }, (item: ChildRoute) => JSON.stringify(item.id))
              }
              .borderRadius(16)
              .columnsTemplate(this.curBp === 'sm' ? '1fr' : '1fr 1fr')
            }, (item: Route,) => JSON.stringify(item.id))
          }
          .width(CommonConstants.FULL_WIDTH)
        }
        .align(Alignment.Top)
        .padding({
          left: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.curBp),
          right: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }
          ).getValue(this.curBp)
        })
        .height('100%')
        .scrollBar(BarState.Auto)
      }
      .width(CommonConstants.FULL_WIDTH)
      .height(CommonConstants.FULL_HEIGHT)
      .padding({
        bottom: this.navigatorBarHeight,
        right: new BreakpointType({
          sm: $r('sys.float.padding_level0'),
          md: $r('sys.float.padding_level4'),
          lg: $r('sys.float.padding_level8')
        }).getValue(this.curBp),
        left: new BreakpointType({
          sm: $r('sys.float.padding_level0'),
          md: $r('sys.float.padding_level4'),
          lg: $r('sys.float.padding_level8')
        }).getValue(this.curBp)
      })
      .alignItems(HorizontalAlign.Center)
    }
    .title($r('app.string.title'))
    .titleMode(NavigationTitleMode.Full)
    .mode(NavigationMode.Stack)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}