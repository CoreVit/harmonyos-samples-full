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

import type { BusinessError } from '@kit.BasicServicesKit';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/constants/CommonConstants';
import { ToDo } from '../model/ToDo';
import { ToDoListItem } from './TodoListItem';
import Logger from '../utils/Logger';

const TAG: string = '[ToDoList]';

@Component
export struct ToDoList {
  @StorageProp(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_TODO_DATA) toDoData: ToDo[] = [];
  @StorageLink(CommonConstants.AS_KEY_ACHIEVE_DATA) achieveData: ToDo[] = [];
  @Consume(CommonConstants.AS_KEY_PATH_STACK) navPathStack: NavPathStack;
  @State selectIndex: number = 0;

  /**
   * Delete a to-do/completed item.
   */
  deleteTodoItem(item: ToDo) {
    if (item.isCompleted) {
      this.achieveData = this.achieveData.filter(todoItem => item.key !== todoItem.key);
    } else {
      this.toDoData = this.toDoData.filter(todoItem => item.key !== todoItem.key);
    }
    try {
      this.getUIContext().getPromptAction().showToast({ message: $r('app.string.deleted') });
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `showToast failed, errCode: ${err.code}, errMessage: ${err.message}.`);
    }
  }

  // Item Swipe left to display the toolbar.
  @Builder
  ItemEnd(item: ToDo) {
    Row({ space: 4 }) {
      Button() {
        SymbolGlyph($r('sys.symbol.trash_fill'))
          .fontSize($r('sys.float.padding_level10'))
          .fontColor([$r('sys.color.background_primary')])
      }
      .height(40)
      .aspectRatio(1)
      .backgroundColor($r('sys.color.warning'))
      .margin({ right: $r('sys.float.padding_level4') })
      .onClick(() => {
        this.deleteTodoItem(item);
      })
    }
    .padding({
      left: $r('sys.float.padding_level8')
    })
  }

  aboutToAppear(): void {
    let params = this.navPathStack.getParamByName('ToDoList') as number[];
    if (params && params.length > 0) {
      this.selectIndex = params[0];
    }
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          if (this.curBp === BreakpointTypeEnum.SM) {
            Button() {
              SymbolGlyph($r('sys.symbol.chevron_backward'))
                .fontSize($r('sys.float.padding_level12'))
                .fontColor([$r('sys.color.font_primary')])
            }
            .height(40)
            .aspectRatio(1)
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .margin({ right: $r('sys.float.padding_level4') })
            .onClick(() => {
              this.navPathStack.pop();
            })
          }

          Text(this.selectIndex === 0 ? $r('app.string.undo') : $r('app.string.done'))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('sys.color.font_primary'))
            .fontSize($r('sys.float.Title_S'))
        }
        .height(56)
        .width('100%')
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

        // The to-do data display list gadget is bound to the data variable toDoData.
        List({ space: 12 }) {
          ForEach(this.selectIndex === 0 ? this.toDoData : this.achieveData, (toDoItem: ToDo) => {
            ListItem() {
              ToDoListItem({
                toDoItem: toDoItem,
                achieveData: this.achieveData,
                toDoData: this.toDoData
              })
            }
            // Set the swipeAction property of the ListItem. When you swipe left, the customized UI view is displayed.
            .swipeAction({ end: this.ItemEnd(toDoItem), edgeEffect: SwipeEdgeEffect.Spring })
          }, (toDoItem: ToDo) => toDoItem.key)
        }
        .layoutWeight(1)
        .listDirection(Axis.Vertical)
        .edgeEffect(EdgeEffect.Spring)
        .padding({ bottom: this.navigatorBarHeight })
        .margin({
          top: $r('sys.float.padding_level6'),
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
      }
      .backgroundColor($r('sys.color.background_secondary'))
      .height('100%')
      .width('100%')
      .padding({ bottom: this.navigatorBarHeight })
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .hideTitleBar(true)
  }
}