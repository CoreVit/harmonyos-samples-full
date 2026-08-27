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

import { BusinessError } from '@kit.BasicServicesKit';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/CommonConstants';
import Logger from '../utils/Logger';

const TAG: string = '[LeftTab]';

@Builder
export function LeftTabBuilder() {
  LeftTab();
}

@Component
struct LeftTab {
  @State tabArray: Array<number> = [0, 1, 2];
  @State currentIndex: number = 0;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @Consume(CommonConstants.AS_KEY_PATH_STACK) pathStack: NavPathStack
  private controller: TabsController = new TabsController();
  private tabLeftOffset: number = 0;
  private animationDuration: number = 300;
  private tabStr: string = this.getResourceString($r('app.string.tab'));
  private pageStr: string = this.getResourceString($r('app.string.page'));
  private contentStr: string = this.getResourceString($r('app.string.page_content'));

  @Builder
  tab(tabName: string, _tabItem: number, tabIndex: number) {
    Row() {
      Text(tabName)
        .fontSize(16)
        .lineHeight(22)
        .fontColor(tabIndex === this.currentIndex ? $r('sys.color.brand') : $r('sys.color.font_primary'))
        .id(tabIndex.toString())
    }
    .justifyContent(FlexAlign.Start)
    .constraintSize({ minWidth: 35 })
    .width(64)
    .height(35)
    .onClick(() => {
      this.controller.changeIndex(tabIndex);
      this.currentIndex = tabIndex;
    })
  }

  build() {
    NavDestination() {
      Column() {
        Stack({ alignContent: Alignment.TopStart }) {
          // The text of tab.
          Row() {
            ForEach(this.tabArray, (item: number, index: number) => {
              this.tab(this.tabStr + item, item, index);
            }, (item: number, _index: number) => item.toString())
            Blank()
            Button({ type: ButtonType.Circle }) {
              SymbolGlyph($r('sys.symbol.plus'))
                .fontColor([$r('sys.color.font_primary')])
                .fontSize($r('sys.float.Subtitle_M'))
            }
            .margin({
              top: $r('sys.float.padding_level4'),
              left: $r('sys.float.padding_level4'),
            })
            .height(CommonConstants.INDEX_TITLE_HEIGHT)
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .aspectRatio(1)

            Button({ type: ButtonType.Circle }) {
              SymbolGlyph($r('sys.symbol.xmark'))
                .fontColor([$r('sys.color.icon_primary')])
                .fontSize($r('sys.float.Subtitle_M'))
            }
            .height(CommonConstants.INDEX_TITLE_HEIGHT)
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .aspectRatio(1)
            .margin({
              top: $r('sys.float.padding_level4'),
              left: $r('sys.float.padding_level4'),
            })
            .onClick(() => {
              this.pathStack.pop();
            })
          }
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
            }).getValue(this.curBp)
          })
          .justifyContent(FlexAlign.Start)
          .width('100%')
        }
        .height(56)
        .margin({ left: this.tabLeftOffset })

        Tabs({ controller: this.controller }) {
          ForEach(this.tabArray, (item: number) => {
            TabContent() {
              Row() {
                Text(this.pageStr + ' ' + item + ' ' + this.contentStr)
                  .fontColor($r('sys.color.font_primary'));
              }
              .justifyContent(FlexAlign.Center)
              .width('100%')
            }
          }, (item: number, _index: number) => item.toString())
        }
        .barWidth('100%')
        .barHeight(0)
        .width('100%')
        .height('100%')
        .animationDuration(this.animationDuration)
        // swipe by click tab.
        .onAnimationStart((_index: number, targetIndex: number, _event: TabsAnimationEvent) => {
          if (_index === targetIndex) {
            return;
          }
          this.currentIndex = targetIndex;
        })
      }
      .height('100%')
    }
    .hideTitleBar(true)
    .padding({
      top: this.statusBarHeight,
    })
    .backgroundColor($r('sys.color.background_secondary'))
  }

  getResourceString(resource: Resource): string {
    let resourceString = '';
    try {
      let hostContext = this.getUIContext().getHostContext();
      if (hostContext) {
        resourceString = hostContext.resourceManager.getStringSync(resource.id);
      }
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getResourceString catch error, errCode: ${err.code}, errMessage: ${err.message}.`);
    }
    return resourceString;
  }
}