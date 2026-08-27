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
import { textRecognition } from '@kit.CoreVisionKit';
import { image } from '@kit.ImageKit';
import { Constants } from '../../common/Constants';
import { BreakpointType, BreakpointTypeEnum } from '../../common/utils/BreakpointSystem';
import Logger from '../../common/utils/Logger';
import { Toast } from '../Toast';

const TAG = '[Sample_DragFramework]';

@Builder
export function PageAIRecognitionBuilder() {
  AIRecognitionDrag();
}

@Component
struct AIRecognitionDrag {
  @Consume(Constants.KEY_PATH_STACK) pageStack: NavPathStack;
  @State textContent: string = '';
  @State primaryModifier: TextModifier =
    new TextModifier().fontColor(Color.Gray).fontSize($r('sys.float.Subtitle_L')).fontWeight(FontWeight.Medium);
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(Constants.KEY_BREAKPOINT) curBp: string = BreakpointTypeEnum.SM;

  async recognizeTextFromImage(imageResource: unifiedDataChannel.Image) {
    let context = this.getUIContext().getHostContext();
    if (!context) {
      Logger.error(TAG, '%{public}s', 'can not get context');
      return;
    }
    const numberReg = new RegExp('[0-9]+');
    let idArray = imageResource.uri.match(numberReg);
    if (idArray !== null) {
      let id = idArray[0];
      let pixelMapInit: image.PixelMap | undefined;
      let pixelMap: image.PixelMap | undefined;
      try {
        let drawableDescriptor = context
          .resourceManager.getDrawableDescriptor(Number(id), 0, 1);
        pixelMapInit = drawableDescriptor.getPixelMap() as image.PixelMap;
        let imageHeight = pixelMapInit.getImageInfoSync().size.height;
        let imageWidth = pixelMapInit.getImageInfoSync().size.width;
        const readBuffer: ArrayBuffer = new ArrayBuffer(imageHeight * imageWidth * 4);
        pixelMapInit.readPixelsToBufferSync(readBuffer);
        let opts: image.InitializationOptions = {
          editable: true,
          size: { height: imageHeight, width: imageWidth },
          srcPixelFormat: pixelMapInit.getImageInfoSync().pixelFormat,
          pixelFormat: 3,
          alphaType: pixelMapInit.getImageInfoSync().alphaType,
          scaleMode: 0
        };
        pixelMap = image.createPixelMapSync(readBuffer, opts);
        let visionInfo: textRecognition.VisionInfo = { pixelMap: pixelMap };
        let data = await textRecognition.recognizeText(visionInfo);
        let recognitionString = data.value;
        this.textContent = recognitionString;
      } catch (err) {
        Logger.error(TAG, `recognizeText failed. code: ${err.code ?? ''}, message: ${err.message ?? ''}`);
      } finally {
        pixelMap?.release();
        pixelMapInit?.release();
      }
    }
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
            Image($r('app.media.architecture'))
              .width('100%')
              .height(new BreakpointType({
                sm: Constants.COLUMN_HEIGHT,
                md: Constants.COLUMN_HEIGHT * Constants.FOLD_IMAGE_RATE,
                lg: Constants.COLUMN_HEIGHT * Constants.FOLD_IMAGE_RATE
              }).getValue(this.curBp))
              .fitOriginalSize(true)
              .borderRadius($r('sys.float.corner_radius_level8'))
              .draggable(true)
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
            top: $r('sys.float.padding_level8')
          })

          SubHeader({
            primaryTitle: $r('app.string.area_can_drag'),
            primaryTitleModifier: this.primaryModifier
          })

          Column() {
            Text(this.textContent)
              .fontSize($r('sys.float.Body_L'))
              .lineHeight(Constants.LINE_HEIGHT)
              .width('100%')
              .align(Alignment.TopStart)
              .padding({
                top: $r('sys.float.padding_level4'),
              })
          }
          .backgroundColor($r('sys.color.comp_background_primary'))
          .width('100%')
          .height(new BreakpointType({
            sm: Constants.COLUMN_HEIGHT,
            md: Constants.COLUMN_HEIGHT * Constants.FOLD_IMAGE_RATE,
            lg: Constants.COLUMN_HEIGHT * Constants.FOLD_IMAGE_RATE
          }).getValue(this.curBp))
          .constraintSize({ maxWidth: '90%' })
          .allowDrop([uniformTypeDescriptor.UniformDataType.IMAGE])
          .onDrop(async (event?: DragEvent) => {
            let dragData: UnifiedData | undefined;
            try {
              dragData = (event as DragEvent).getData() as UnifiedData;
            } catch (err) {
              Logger.error(TAG, `event.getData failed. code: ${err.code ?? ''}, message: ${err.message ?? ''}`);
              return;
            }
            if (!dragData === undefined) {
              Logger.info(TAG, `%{public}s`, `ondrop undefined data`);
              return;
            }
            let record: unifiedDataChannel.UnifiedRecord[] = dragData.getRecords();
            if (record.length <= 0) {
              Logger.info(TAG, `%{public}s`, `dragData arr is null`);
              return;
            }
            let imageResource = record[0] as unifiedDataChannel.Image;
            const resourceReg = new RegExp('resource');
            if (resourceReg.test(imageResource.uri)) {
              await this.recognizeTextFromImage(imageResource);
            }
          })
          .borderRadius($r('sys.float.corner_radius_level8'))
          .padding({
            left: $r('sys.float.padding_level8'),
            right: $r('sys.float.padding_level8')
          })
        }
      }
    }
    .title($r('app.string.ai_recognition_title'))
    .backgroundColor($r('sys.color.background_secondary'))
  }
}