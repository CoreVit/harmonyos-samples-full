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
import { image } from '@kit.ImageKit';
import { Constants } from '../../common/Constants';
import { BreakpointType, BreakpointTypeEnum } from '../../common/utils/BreakpointSystem';
import Logger from '../../common/utils/Logger';
import { Toast } from '../Toast';

const TAG = '[Sample_DragFramework]';

@Builder
export function PageBackgroundBuilder() {
  BackgroundDrag();
}

@Component
struct BackgroundDrag {
  @Consume(Constants.KEY_PATH_STACK) pageStack: NavPathStack;
  @State targetImage: string = '';
  @State primaryModifier: TextModifier =
    new TextModifier().fontColor(Color.Gray).fontSize($r('sys.float.Subtitle_L')).fontWeight(FontWeight.Medium);
  @State pixelMap: image.PixelMap | undefined = undefined;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(Constants.KEY_BREAKPOINT) curBp: string = BreakpointTypeEnum.SM;

  @Builder
  pixelMapBuilder() {
    Column() {
      Text($r('app.string.background_content'))
        .fontSize($r('sys.float.Body_L'))
        .margin({
          left: $r('sys.float.padding_level8'),
          right: $r('sys.float.padding_level8'),
          top: $r('sys.float.padding_level4'),
          bottom: $r('sys.float.padding_level4')
        })
    }
    .backgroundColor($r('sys.color.comp_background_primary'))
    .borderRadius($r('sys.float.corner_radius_level8'))
  }

  private getComponentSnapshot(): void {
    this.getUIContext().getComponentSnapshot().createFromBuilder(() => {
      this.pixelMapBuilder()
    }, (error: Error, pixmap: image.PixelMap) => {
      if (error) {
        Logger.error(TAG, `%{public}s`, error.message);
        return;
      }
      this.pixelMap = pixmap;
    })
  }

  private PreDragChange(preDragStatus: PreDragStatus): void {
    if (preDragStatus == PreDragStatus.ACTION_DETECTING_STATUS) {
      this.getComponentSnapshot();
    }
  }

  aboutToDisappear(): void {
    this.pixelMap?.release();
  }

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
              .fitOriginalSize(true)
              .borderRadius($r('sys.float.corner_radius_level8'))
              .draggable(true)
              .onPreDrag((status: PreDragStatus) => {
                this.PreDragChange(status);
              })
              .onDragStart(() => {
                let dragItemInfo: DragItemInfo = {
                  pixelMap: this.pixelMap,
                  builder: () => {
                    this.pixelMapBuilder()
                  },
                };
                return dragItemInfo;
              })
              .onDragEnd((event) => {
                if (event.getResult() === DragResult.DRAG_SUCCESSFUL) {
                  Toast.showShortToast($r('app.string.drag_successfully'));
                } else if (event.getResult() === DragResult.DRAG_FAILED) {
                  Toast.showShortToast($r('app.string.drag_failed'));
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
            primaryTitle: $r('app.string.area_can_drag'),
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
              .fitOriginalSize(true)
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
            event?.setResult(DragResult.DRAG_SUCCESSFUL);
          })
          .margin({
            left: $r('sys.float.padding_level8'),
            right: $r('sys.float.padding_level8')
          })
        }
        .margin({
          bottom: $r('sys.float.padding_level8')
        })
      }
    }
    .title($r('app.string.background_title'))
    .backgroundColor($r('sys.color.background_secondary'))
  }
}