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

import { unifiedDataChannel, uniformTypeDescriptor } from '@kit.ArkData';
import { Constants } from '../../common/Constants';
import Logger from '../../common/utils/Logger';

const TAG: string = '[SelectTable]';

const LIST_SIZE = 8;

@Builder
export function PageListBuilder() {
  ListDrag();
}

@Component
struct SelectTableList {
  @State arr: Array<string> = [];
  @State selectedArr: Array<boolean> = [];
  public tag: string = '';

  build() {
    List({ space: Constants.SPACE_8 }) {
      ForEach(this.arr, (item: string, index) => {
        ListItem() {
          Row() {
            Checkbox()
              .shape(CheckBoxShape.CIRCLE)
              .select(this.selectedArr[index])
              .onChange((value: boolean) => {
                if (value) {
                  this.selectedArr[index] = true;
                } else {
                  this.selectedArr[index] = false;
                }
              })
              .mark({
                size: $r('sys.float.ohos_id_group_image_size')
              })
              .margin({ right: $r('sys.float.padding_level6') })
            Text(item)
          }.width('100%')
        }
        .draggable(this.selectedArr[index])
        .height($r('sys.float.ohos_id_checkbox_default_size'))
        .width('100%')
        .padding({ left: $r('sys.float.padding_level6') })
        .backgroundColor($r('sys.color.comp_background_primary'))
        .borderRadius($r('sys.float.corner_radius_level8'))
        .onDragStart((event: DragEvent) => {
          let unifiedData: unifiedDataChannel.UnifiedData | undefined = undefined;
          this.selectedArr.forEach((value: boolean, index: number) => {
            if (value) {
              let text = new unifiedDataChannel.PlainText();
              text.textContent = this.arr[index];
              if (unifiedData === undefined) {
                unifiedData = new unifiedDataChannel.UnifiedData(text);
              } else {
                unifiedData.addRecord(text);
              }
            }
          })
          if (unifiedData != undefined) {
            event.setData(unifiedData);
          }
        })
      }, (item: string, index) => item + this.selectedArr[index])
    }
    .width('100%')
    .height('100%')
    .allowDrop([uniformTypeDescriptor.UniformDataType.PLAIN_TEXT])
    .onDrop((event: DragEvent) => {
      let dragData: UnifiedData | undefined;
      try {
        dragData = event.getData() as UnifiedData;
      } catch (err) {
        Logger.error(TAG, `event.getData failed. code: ${err.code ?? ''}, message: ${err.message ?? ''}`);
        return;
      }
      if (dragData === undefined) {
        return;
      }
      let records: unifiedDataChannel.UnifiedRecord[] = dragData.getRecords();
      records.forEach((value: unifiedDataChannel.UnifiedRecord) => {
        let newValue: unifiedDataChannel.PlainText = value as unifiedDataChannel.PlainText;
        let textIndex = this.arr.indexOf(newValue.textContent);
        if (textIndex < 0) {
          this.arr.splice(this.arr.length, 0, newValue.textContent);
          this.selectedArr.push(false);
        }
      })
    })
  }

  aboutToAppear() {
    for (let i = 0; i < LIST_SIZE; i++) {
      this.arr.push(this.tag + ' item' + i);
    }
  }
}

@Entry
@Component
struct ListDrag {
  @Consume(Constants.KEY_PATH_STACK) pageStack: NavPathStack;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;

  build() {
    NavDestination() {
      Row({ space: Constants.SPACE_8 }) {
        SelectTableList({ tag: 'List1' }).layoutWeight(1);
        SelectTableList({ tag: 'List2' }).layoutWeight(1);
      }
      .width('100%')
      .constraintSize({ maxWidth: '100%' })
      .backgroundColor($r('sys.color.background_secondary'))
      .margin({
        top: $r('sys.float.padding_level4'),
        bottom: $r('sys.float.padding_level8'),
        left: $r('sys.float.padding_level8'),
        right: $r('sys.float.padding_level8')
      })
    }
    .title($r('app.string.list_title'))
    .backgroundColor($r('sys.color.background_secondary'))
  }
}