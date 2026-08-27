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
import { BreakpointType, BreakpointTypeEnum } from '../../common/utils/BreakpointSystem';
import Logger from '../../common/utils/Logger';

const TAG = '[Sample_DragFramework]';

@Builder
export function PageImageBuilder() {
  ImageDrag();
}

@Component
struct ImageDrag {
  @State uri: string = '';
  @State blockArr: string[] = [];
  @State targetImage: string = '';
  @State visible: Visibility = Visibility.Visible;
  @State dragSuccess: Boolean = false;
  @State primaryModifier: TextModifier =
    new TextModifier().fontColor(Color.Gray).fontSize($r('sys.float.Subtitle_L')).fontWeight(FontWeight.Medium);
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(Constants.KEY_BREAKPOINT) curBp: string = BreakpointTypeEnum.SM;
  @Consume(Constants.KEY_PATH_STACK) pageStack: NavPathStack;

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
            Image($r('app.media.mount'))
              .width('100%')
              .height(new BreakpointType({
                sm: Constants.IMAGE_HEIGHT,
                md: Constants.IMAGE_HEIGHT * Constants.FOLD_IMAGE_RATE,
                lg: Constants.IMAGE_HEIGHT * Constants.FOLD_IMAGE_RATE
              }).getValue(this.curBp))
              .borderRadius($r('sys.float.corner_radius_level8'))
              .visibility(this.visible)
              .draggable(true)
              .onDragEnd((event: DragEvent) => {
                let ret = event.getResult();
                if (ret === 0) {
                  Logger.info(TAG, `%{public}s`, `enter ret === 0`);
                } else {
                  Logger.info(TAG, `%{public}s`, `enter ret !== 0`);
                  this.visible = Visibility.Visible;
                }
              })
          }
          .padding({
            left: $r('sys.float.padding_level8'),
            right: $r('sys.float.padding_level8')
          })
          .margin({
            top: $r('sys.float.padding_level4')
          })

          SubHeader({
            primaryTitle: $r('app.string.image_text_title'),
            primaryTitleModifier: this.primaryModifier
          })
          Column() {
            Image(this.targetImage)
              .width('100%')
              .height(new BreakpointType({
                sm: Constants.IMAGE_HEIGHT,
                md: Constants.IMAGE_HEIGHT * Constants.FOLD_IMAGE_RATE,
                lg: Constants.IMAGE_HEIGHT * Constants.FOLD_IMAGE_RATE
              }).getValue(this.curBp))
              .constraintSize({ maxWidth: '100%' })
              .borderRadius($r('sys.float.corner_radius_level8'))
          }
          .constraintSize({ maxWidth: '100%' })
          .backgroundColor($r('sys.color.comp_background_primary'))
          .borderRadius($r('sys.float.corner_radius_level8'))
          .allowDrop([uniformTypeDescriptor.UniformDataType.IMAGE])
          .onDrop((event?: DragEvent) => {
            let dragData: UnifiedData | undefined;
            try {
              dragData = event?.getData() as UnifiedData;
            } catch (err) {
              Logger.error(TAG, `event.getData failed. code: ${err.code ?? ''}, message: ${err.message ?? ''}`);
              return;
            }
            if (dragData !== undefined) {
              let arr: unifiedDataChannel.UnifiedRecord[] = dragData.getRecords();
              if (arr.length > 0) {
                this.targetImage = (arr[0] as unifiedDataChannel.Image).imageUri;
              } else {
                Logger.info(TAG, `%{public}s`, `dragData arr is null`);
              }
            } else {
              Logger.info(TAG, `%{public}s`, `dragData is undefined`);
            }
            this.dragSuccess = true;
          })
          .margin({
            left: $r('sys.float.padding_level8'),
            right: $r('sys.float.padding_level8')
          })

          SubHeader({
            primaryTitle: $r('app.string.image_none_text_title'),
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
            .allowDrop(null)
            .onDrop((event: DragEvent, extraParams?: string) => {
              if (extraParams) {
                try{
                  this.uri = JSON.parse(extraParams as string).extraInfo;
                  this.blockArr.splice(JSON.parse(extraParams as string).insertIndex, 0, this.uri);
                } catch (err) {
                  Logger.error(TAG, `JSON.parse failed. code: ${err.code ?? ''}, message: ${err.message ?? ''}`);
                }
              }
              event.setResult(DragResult.DROP_DISABLED);
            })
          }
          .padding({
            left: $r('sys.float.padding_level8'),
            right: $r('sys.float.padding_level8')
          })
          .margin({
            left: $r('sys.float.padding_level8'),
            right: $r('sys.float.padding_level8')
          })
          .constraintSize({ maxWidth: '100%' })
          .width('100%')
          .height(new BreakpointType({
            sm: Constants.IMAGE_HEIGHT,
            md: Constants.IMAGE_HEIGHT * Constants.FOLD_IMAGE_RATE,
            lg: Constants.IMAGE_HEIGHT * Constants.FOLD_IMAGE_RATE
          }).getValue(this.curBp))
          .borderRadius($r('sys.float.corner_radius_level8'))
          .backgroundColor($r('sys.color.comp_background_primary'))
        }
        .backgroundColor($r('sys.color.background_secondary'))
        .margin({
          bottom: $r('sys.float.padding_level8')
        })
      }
    }
    .title($r('app.string.image_title'))
    .backgroundColor($r('sys.color.background_secondary'))
  }
}