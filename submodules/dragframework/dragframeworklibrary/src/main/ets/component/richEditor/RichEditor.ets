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
import { SubHeader, TextModifier } from '@kit.ArkUI';
import { Constants } from '../../common/Constants';
import Logger from '../../common/utils/Logger';
import { Toast } from '../Toast';

const TAG: string = '[RichEditor]';

@Builder
export function PageRichEditorBuilder() {
  RichEditorDrag();
}

@Component
struct RichEditorDrag {
  @State changeValue: string = '';
  @State submitValue: string = '';
  @State flag: boolean = true;
  controller1: RichEditorController = new RichEditorController();
  controller2: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller2 };
  @State primaryModifier: TextModifier =
    new TextModifier().fontColor(Color.Gray).fontSize($r('sys.float.Subtitle_L')).fontWeight(FontWeight.Medium);
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @Consume(Constants.KEY_PATH_STACK) pageStack: NavPathStack;

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          RichEditor(this.options)
            .onReady(() => {
              let context = this.getUIContext().getHostContext();
              if (!context) {
                Logger.error(TAG, `%{public}s`, `Failed to context`);
                return;
              }
              try {
                let content = context.resourceManager.getStringSync($r('app.string.rich_editor_text').id);
                let options: RichEditorTextSpanOptions = {
                  style:
                  {
                    fontSize: $r('sys.float.Body_L'),
                    lineHeight: Constants.LINE_HEIGHT
                  }
                };
                this.controller2.addTextSpan(content, options);
              } catch (err) {
                Logger.error(TAG, `getStringSync failed. code: ${err.code ?? ''}, message: ${err.message ?? ''}`);
              }
            })
            .borderRadius($r('sys.float.corner_radius_level8'))
            .height(Constants.COLUMN_HEIGHT)
            .backgroundColor($r('sys.color.comp_background_primary'))
            .draggable(this.flag)
            .onDragEnd((event) => {
              if (event.getResult() === DragResult.DRAG_SUCCESSFUL) {
                Toast.showShortToast($r('app.string.drag_successfully'));
              } else if (event.getResult() === DragResult.DRAG_FAILED) {
                Toast.showShortToast($r('app.string.drag_failed'));
              }
            })
            .margin({
              left: $r('sys.float.padding_level8'),
              right: $r('sys.float.padding_level8'),
              top: $r('sys.float.padding_level4')
            })

          SubHeader({
            primaryTitle: $r('app.string.rich_editor_text_title'),
            primaryTitleModifier: this.primaryModifier
          })
          RichEditor({ controller: this.controller1 })
            .margin({
              left: $r('sys.float.padding_level8'),
              right: $r('sys.float.padding_level8')
            })
            .height(Constants.COLUMN_HEIGHT)
            .backgroundColor($r('sys.color.comp_background_primary'))
            .borderRadius($r('sys.float.corner_radius_level8'))
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
              let records = dragData.getRecords();
              for (let record of records) {
                if (record.getType() === uniformTypeDescriptor.UniformDataType.PLAIN_TEXT) {
                  let text = record as unifiedDataChannel.PlainText;
                  this.controller1.addTextSpan(text.textContent, {
                    style:
                    {
                      fontSize: $r('sys.float.Body_L'),
                      lineHeight: Constants.LINE_HEIGHT
                    }
                  });
                  event.setResult(DragResult.DRAG_SUCCESSFUL);
                }
              }
            })
        }
        .alignItems(HorizontalAlign.Start)
        .backgroundColor($r('sys.color.background_secondary'))
        .margin({
          bottom: $r('sys.float.padding_level8')
        })
      }
    }
    .title($r('app.string.rich_editor_title'))
    .backgroundColor($r('sys.color.background_secondary'))
  }
}