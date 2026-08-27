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
import { ToDo } from '../model/ToDo';
import { ToDoList } from '../view/ToDoList';
import { WindowUtil } from '../utils/WindowUtil';

@Component
struct SelectItem {
  @StorageProp(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @Consume navPathStack: NavPathStack;
  @Prop selectIndex: number;
  @Prop itemTitle: Resource;
  @Link currentIndex: number;

  build() {
    Row() {
      Text(this.itemTitle)
        .fontColor($r('sys.color.font_primary'))
        .fontSize($r('sys.float.Subtitle_M'))
        .fontWeight(500)

      SymbolGlyph($r('sys.symbol.chevron_forward'))
        .fontSize($r('sys.float.padding_level12'))
        .fontColor([$r('sys.color.font_tertiary')])
    }
    .height($r('sys.float.padding_level24'))
    .borderRadius($r('sys.float.padding_level8'))
    .backgroundColor(this.selectIndex === this.currentIndex && this.curBp !== BreakpointTypeEnum.SM ?
    $r('sys.color.ohos_id_select_selected_color') :
    $r('sys.color.comp_background_primary'))
    .padding({
      left: this.curBp === BreakpointTypeEnum.SM ? $r('sys.float.padding_level6') : $r('sys.float.padding_level4'),
      right: this.curBp === BreakpointTypeEnum.SM ? $r('sys.float.padding_level6') : $r('sys.float.padding_level4')
    })
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .onClick(() => {
      this.currentIndex = this.selectIndex;
      if (this.curBp === BreakpointTypeEnum.SM) {
        this.navPathStack.pushPathByName('ToDoList', this.currentIndex);
      } else {
        this.navPathStack.replacePathByName('ToDoList', this.currentIndex);
      }
    })
  }
}

@Component
export struct ListItemEditComponent {
  @Provide(CommonConstants.AS_KEY_PATH_STACK) navPathStack: NavPathStack = new NavPathStack();
  @StorageProp(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_TODO_DATA) toDoData: ToDo[] = [];
  @StorageLink(CommonConstants.AS_KEY_ACHIEVE_DATA) achieveData: ToDo[] = [];
  @State currentIndex: number = -1;
  @State availableThings: Resource[] =
    [$r('app.string.available_thing1'), $r('app.string.available_thing2'), $r('app.string.available_thing3'),
      $r('app.string.available_thing4'), $r('app.string.available_thing5'), $r('app.string.available_thing6')];

  @Builder
  PageMap(name: string) {
    if (name === 'ToDoList') {
      ToDoList()
    }
  }

  aboutToAppear(): void {
    if (this.curBp !== BreakpointTypeEnum.SM) {
      this.navPathStack.pushPathByName('ToDoList', 0);
      this.currentIndex = 0;
    }
  }

  aboutToDisappear(): void {
    WindowUtil.unregisterBreakPoint();
  }

  build() {
    Navigation(this.navPathStack) {
      Column() {
        Column() {
          SelectItem({ itemTitle: $r('app.string.undo'), selectIndex: 0, currentIndex: this.currentIndex })
          if (this.curBp === BreakpointTypeEnum.SM) {
            Divider()
              .strokeWidth(0.5)
              .color($r('sys.color.comp_divider'))
          }
          SelectItem({ itemTitle: $r('app.string.done'), selectIndex: 1, currentIndex: this.currentIndex })
        }
        .borderRadius($r('sys.float.padding_level8'))
        .padding(this.curBp === BreakpointTypeEnum.SM ? 0 : $r('sys.float.padding_level2'))
        .backgroundColor($r('sys.color.comp_background_primary'))
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

        Blank()

        Button() {
          SymbolGlyph($r('sys.symbol.plus'))
            .fontSize($r('sys.float.padding_level12'))
            .fontColor([$r('sys.color.comp_background_primary')])
        }
        .height(45)
        .aspectRatio(1)
        .backgroundColor($r('sys.color.brand'))
        .margin({
          right: $r('sys.float.padding_level4'),
          bottom: $r('sys.float.padding_level11')
        })
        .onClick(() => {
          this.getUIContext().showTextPickerDialog({
            range: $r('app.strarray.available_things'),
            onAccept: (value: TextPickerResult) => {
              this.toDoData.unshift(new ToDo(this.availableThings[Number(value.index)]));
            },
          });
        })
      }
      .height('100%')
    }
    .mode(this.curBp === BreakpointTypeEnum.SM ? NavigationMode.Stack : NavigationMode.Split)
    .navDestination(this.PageMap)
    .navBarWidth(new BreakpointType({ sm: '100%', md: '50%', lg: '40%' }).getValue(this.curBp))
    .height('100%')
    .width('100%')
    .title($r('app.string.todo'))
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({
      top: this.statusBarHeight,
      bottom: this.navigatorBarHeight
    })
  }
}