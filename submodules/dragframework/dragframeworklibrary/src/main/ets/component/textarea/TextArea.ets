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

const TAG: string = '[TextArea]';

@Builder
export function PageTextAreaBuilder() {
  TextAreaDrag();
}

@Component
struct TextAreaDrag {
  @State dragStartContent: string = '';
  @State dropContent: ResourceStr = '';
  @State description: string = '';
  @State primaryModifier: TextModifier =
    new TextModifier().fontColor(Color.Gray).fontSize($r('sys.float.Subtitle_L')).fontWeight(FontWeight.Medium);
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @Consume(Constants.KEY_PATH_STACK) pageStack: NavPathStack;

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          TextArea({ placeholder: 'Please input words...' })
            .fontSize($r('sys.float.Body_L'))
            .backgroundColor($r('sys.color.comp_background_primary'))
            .borderRadius($r('sys.float.corner_radius_level8'))
            .copyOption(CopyOptions.InApp)
            .width('100%')
            .constraintSize({ maxWidth: '100%' })
            .height($r('app.float.textarea_height'))
            .draggable(true)
            .margin({
              left: $r('sys.float.padding_level8'),
              right: $r('sys.float.padding_level8'),
              top: $r('sys.float.padding_level8')
            })
            .padding({
              top: $r('sys.float.padding_level4'),
              bottom: $r('sys.float.padding_level4'),
              left: $r('sys.float.padding_level8'),
              right: $r('sys.float.padding_level8')
            })
            .lineHeight(Constants.LINE_HEIGHT)

          SubHeader({
            primaryTitle: $r('app.string.textarea_text_title'),
            primaryTitleModifier: this.primaryModifier
          })
          Column() {
            Text(this.dropContent)
              .fontSize($r('sys.float.Body_L'))
              .lineHeight(Constants.LINE_HEIGHT)
              .width('100%')
              .constraintSize({ maxWidth: '100%' })
              .margin({
                left: $r('sys.float.padding_level8'),
                right: $r('sys.float.padding_level8'),
                top: $r('sys.float.padding_level4'),
                bottom: $r('sys.float.padding_level4')
              })
              .textAlign(TextAlign.Start)
          }
          .height(Constants.COLUMN_HEIGHT)
          .width('100%')
          .constraintSize({ maxWidth: '100%' })
          .backgroundColor($r('sys.color.comp_background_primary'))
          .borderRadius($r('sys.float.corner_radius_level8'))
          .allowDrop([uniformTypeDescriptor.UniformDataType.TEXT,
            uniformTypeDescriptor.UniformDataType.PLAIN_TEXT])
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
            let record = dragData.getRecords();
            let size = record.length;
            if (size < 1) {
              this.dropContent = $r('app.string.none_data');
              return;
            }
            let text = (record[0]) as unifiedDataChannel.PlainText;
            this.dropContent = text.textContent;
          })
          .margin({
            left: $r('sys.float.padding_level8'),
            right: $r('sys.float.padding_level8')
          })

          SubHeader({
            primaryTitle: $r('app.string.textarea_none_text_title'),
            primaryTitleModifier: this.primaryModifier
          })
          Stack() {
            Column() {
              SymbolGlyph($r('sys.symbol.nosign'))
                .fontColor([$r('sys.color.icon_tertiary')])
                .fontSize($r('sys.float.Title_M'))
                .margin({
                  bottom: $r('sys.float.padding_level4')
                })
              Text($r('app.string.area_none_drag'))
                .fontColor($r('sys.color.font_tertiary'))
                .fontSize($r('sys.float.Body_L'))
                .fontFamily('HarmonyHeiTi')
            }
          }
          .allowDrop(null)
          .onDrop((event: DragEvent) => {
            event.setResult(DragResult.DROP_DISABLED);
          })
          .height(Constants.COLUMN_HEIGHT)
          .width('100%')
          .constraintSize({ maxWidth: '100%' })
          .borderRadius($r('sys.float.corner_radius_level8'))
          .backgroundColor($r('sys.color.comp_background_primary'))
          .margin({
            left: $r('sys.float.padding_level8'),
            right: $r('sys.float.padding_level8')
          })
        }
        .backgroundColor($r('sys.color.background_secondary'))
        .margin({
          bottom: $r('sys.float.padding_level8')
        })
      }
    }
    .title($r('app.string.textarea_title'))
    .backgroundColor($r('sys.color.background_secondary'))
  }
}