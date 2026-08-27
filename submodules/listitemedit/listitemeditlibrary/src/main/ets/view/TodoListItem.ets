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

import { ToDo } from '../model/ToDo';

@Component
export struct ToDoListItem {
  @Link achieveData: ToDo[];
  @Link toDoData: ToDo[];
  @ObjectLink toDoItem: ToDo;
  @State isEdited: boolean = false;

  /**
   * Add a completed data item.
   */
  addAchieveData() {
    this.toDoItem.isCompleted = !this.toDoItem.isCompleted;
    this.getUIContext().animateTo({ duration: 600 }, () => {
      if (this.toDoItem.isCompleted) {
        let tempData = this.toDoData.filter(item => item.key !== this.toDoItem.key);
        this.toDoData = tempData;
        this.achieveData.push(this.toDoItem);
      } else {
        let tempData = this.achieveData.filter(item => item.key !== this.toDoItem.key);
        this.achieveData = tempData;
        this.toDoData.push(this.toDoItem);
      }
    });
  }

  build() {
    Row({ space: 4 }) {
      if (!this.isEdited) {
        SymbolGlyph(this.toDoItem.isCompleted ? $r('sys.symbol.checkmark_circle_fill') : $r('sys.symbol.circle'))
          .fontSize($r('sys.float.padding_level12'))
          .fontColor(this.toDoItem.isCompleted ? [$r('sys.color.brand')] : [$r('sys.color.font_secondary')])
          .transition(TransitionEffect.IDENTITY)
          .margin({ right: $r('sys.float.padding_level4') })
          .onClick(() => {
            this.addAchieveData();
          })

        Text(this.toDoItem.name)
          .maxLines(1)
          .fontSize($r('sys.float.ohos_id_text_size_headline9'))
          .fontColor(this.toDoItem.isCompleted ? $r('sys.color.font_secondary') : $r('sys.color.font_primary'))
          .layoutWeight(1)
          .decoration({
            type: this.toDoItem.isCompleted ? TextDecorationType.LineThrough : TextDecorationType.None,
            color: $r('sys.color.font_secondary')
          })
      } else {
        TextInput({ text: this.toDoItem.name })
          .maxLines(1)
          .fontSize($r('sys.float.ohos_id_text_size_headline9'))
          .layoutWeight(1)
          .backgroundColor(Color.Transparent)
          .id('textEdit')
          .onChange((value: string) => {
            // Update to-do data.
            this.toDoItem.name = value;
          })
          .onAppear(() => {
            // Requests the input box to obtain the focus.
            focusControl.requestFocus('textEdit');
          })
      }
      Blank()
      if (this.isEdited) {
        SymbolGlyph($r('sys.symbol.checkmark'))
          .fontSize($r('sys.float.padding_level12'))
          .fontColor([$r('sys.color.font_primary')])
          .onClick(() => {
            this.isEdited = false;
          })
      } else {
        Text($r('app.string.edit'))
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .onClick(() => {
            this.isEdited = true;
          })
      }
    }
    .width('100%')
    .height(56)
    .padding({
      left: $r('sys.float.padding_level6'),
      right: $r('sys.float.padding_level6'),
    })
    .borderRadius($r('sys.float.corner_radius_level8'))
    .backgroundColor($r('sys.color.comp_background_primary'))
  }
}