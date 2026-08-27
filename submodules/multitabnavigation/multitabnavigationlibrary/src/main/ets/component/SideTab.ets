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

import { CommonConstants } from '../common/CommonConstants';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { ClassifyModel } from '../viewmodel/TabItem';
import { initSideData } from '../viewmodel/TabViewModel';

@Builder
export function SideTabBuilder() {
  SideTab();
}

@Component
struct ClassifyItem {
  @Prop isSelected: boolean = false;
  classifyName: string | Resource = '';
  onClickAction = (): void => {
  }

  build() {
    Text(this.classifyName)
      .fontSize(14)
      .fontColor(this.isSelected ? $r('sys.color.brand') : $r('sys.color.font_primary'))
      .fontFamily(this.isSelected ? $r('app.string.hei_ti_medium') : $r('app.string.hei_ti'))
      .fontWeight(this.isSelected ? FontWeight.Medium : FontWeight.Normal)
      .textAlign(TextAlign.Center)
      .backgroundColor(this.isSelected ? $r('sys.color.comp_background_primary') : $r('sys.color.background_secondary'))
      .width('100%')
      .height(52)
      .onClick(this.onClickAction)
  }
}

@Component
struct SideTab {
  @State currentClassify: number = 0;
  @State classifyArray: ClassifyModel[] = initSideData();
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @Consume(CommonConstants.AS_KEY_PATH_STACK) pathStack: NavPathStack;

  classifyChangeAction(index: number): void {
    if (this.currentClassify !== index) {
      this.currentClassify = index;
    }
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.TopEnd }) {
        Row() {
          List() {
            ForEach(this.classifyArray, (item: ClassifyModel, index: number) => {
              ListItem() {
                ClassifyItem({
                  classifyName: item.classifyName,
                  isSelected: this.currentClassify === index,
                  onClickAction: () => {
                    this.classifyChangeAction(index);
                  }
                })
              }
            }, (item: ClassifyModel) => JSON.stringify(item.classifyId))
          }
          .height('100%')
          .width(new BreakpointType({ sm: '30%', md: '25%', lg: '20%' }).getValue(this.curBp))
          .scrollBar(BarState.Off)
          .borderWidth({ right: 0.5 })
          .borderColor($r('sys.color.comp_divider'))
          .padding({
            top: this.statusBarHeight + CommonConstants.PADDING_12
          })

          Column() {
            ForEach(this.classifyArray, (item: ClassifyModel, index: number) => {
              Text(this.currentClassify === index ? item.classifyName : '')
                .fontColor($r('sys.color.font_primary'))
                .fontSize(30)
            }, (item: ClassifyModel) => JSON.stringify(item.classifyId))
          }
          .padding({
            top: this.statusBarHeight
          })
          .width('72.2%')
        }
        .width('100%')

        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.xmark'))
            .fontColor([$r('sys.color.icon_primary')])
            .fontSize($r('sys.float.Title_M'))
        }
        .height(CommonConstants.INDEX_TITLE_HEIGHT)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .aspectRatio(1)
        .margin({
          top: this.statusBarHeight + CommonConstants.PADDING_TOP_SMALL,
          right: $r('sys.float.padding_level12')
        })
        .onClick(() => {
          this.pathStack.pop();
        })
      }
    }
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}