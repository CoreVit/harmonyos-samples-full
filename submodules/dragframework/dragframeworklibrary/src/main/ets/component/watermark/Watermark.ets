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
import { drawing } from '@kit.ArkGraphics2D';
import { display, SubHeader, TextModifier } from '@kit.ArkUI';
import { BusinessError, systemDateTime } from '@kit.BasicServicesKit';
import { fileUri, fileIo as fs } from '@kit.CoreFileKit';
import { image } from '@kit.ImageKit';
import { resourceManager } from '@kit.LocalizationKit';
import { Constants } from '../../common/Constants';
import { BreakpointType, BreakpointTypeEnum } from '../../common/utils/BreakpointSystem';
import Logger from '../../common/utils/Logger';
import { Toast } from '../Toast';

const TAG = '[Watermark]';

@Builder
export function PageWatermarkBuilder() {
  WatermarkDrag();
}

@Component
struct WatermarkDrag {
  private timerId: number = -1;
  private context: Context | undefined = this.getUIContext().getHostContext();
  @Consume(Constants.KEY_PATH_STACK) pageStack: NavPathStack;
  @State targetImage: string = '';
  @State primaryModifier: TextModifier =
    new TextModifier().fontColor(Color.Gray).fontSize($r('sys.float.Subtitle_L')).fontWeight(FontWeight.Medium);
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(Constants.KEY_BREAKPOINT) curBp: string = BreakpointTypeEnum.SM;
  time: string = '0';

  aboutToDisappear(): void {
    this.clearTimer();
  }

  getTimeWatermark(str: number): string {
    let time: string = '';
    let date: Date = new Date(str);
    try {
      let year: number = date.getFullYear();
      let month: string | number = (date.getMonth() + 1) < 10 ? '0' + (date.getMonth() + 1) : (date.getMonth() + 1);
      let day: string | number = date.getDate() < 10 ? '0' + date.getDate() : date.getDate();
      let hour: string | number = date.getHours() < 10 ? '0' + date.getHours() : date.getHours();
      let min: string | number = date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes();
      let second: string | number = date.getSeconds() < 10 ? '0' + date.getSeconds() : date.getSeconds();
      time = year + '-' + month + '-' + day + ' ' + hour + ':' + min + ':' + second;
      Logger.info(TAG, `%{public}s`, `getTimeWatermark`);
    } catch (error) {
      Logger.error(TAG,
        `Failed to get currentTime, code = ${(error as BusinessError).code}, message = ${(error as BusinessError).message}`);
    }
    return time;
  }

  getDataFromUdmfRetry(event: DragEvent, callback: (data: DragEvent) => void) {
    try {
      let data: UnifiedData = event.getData();
      if (!data) {
        return false;
      }
      let records: unifiedDataChannel.UnifiedRecord[] = data.getRecords();
      if (!records || records.length <= 0) {
        return false;
      }
      callback(event);
      return true;
    } catch (error) {
      Logger.error(TAG,
        `getData failed, code = ${(error as BusinessError).code}, message = ${(error as BusinessError).message}`);
      return false;
    }
  }

  getDataFromUdmf(event: DragEvent, callback: (data: DragEvent) => void) {
    if (this.getDataFromUdmfRetry(event, callback)) {
      return;
    }
    this.clearTimer();
    this.timerId = setTimeout(() => {
      this.getDataFromUdmfRetry(event, callback);
      this.clearTimer();
    }, 1500);
  }

  private clearTimer() {
    if (this.timerId !== -1) {
      clearTimeout(this.timerId);
      this.timerId = -1;
    }
  }

  addWaterMark(watermark: string, pixelMap: image.PixelMap) {
    try {
      if (!canIUse('SystemCapability.Graphics.Drawing')) {
        Logger.error(TAG, `%{public}s`, `watermark is not supported`);
        return pixelMap;
      }

      this.context ??= this.getUIContext().getHostContext();
      if (!this.context) {
        Logger.error(TAG, '%{public}s', 'can not get context');
        return pixelMap;
      }
      watermark = this.context.resourceManager.getStringSync($r('app.string.drag_time').id) + watermark;
      const imageInfo: image.Size = pixelMap.getImageInfoSync().size;
      const imageWidth: number = imageInfo.width;
      const imageHeight: number = imageInfo.height;
      const imageScale: number = imageWidth / display.getDefaultDisplaySync().width;
      const canvas: drawing.Canvas = new drawing.Canvas(pixelMap);
      const pen: drawing.Pen = new drawing.Pen();
      const brush: drawing.Brush = new drawing.Brush();
      pen.setColor({
        alpha: 102,
        red: 255,
        green: 255,
        blue: 255
      });
      brush.setColor({
        alpha: 102,
        red: 255,
        green: 255,
        blue: 255
      });
      const font: drawing.Font = new drawing.Font();
      font.setSize(new BreakpointType({ sm: 48, md: 60, lg: 72 }).getValue(this.curBp) * imageScale);
      let textWidth: number = font.measureText(watermark, drawing.TextEncoding.TEXT_ENCODING_UTF8);
      const textBlob: drawing.TextBlob =
        drawing.TextBlob.makeFromString(watermark, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
      canvas.attachBrush(brush);
      canvas.attachPen(pen);
      canvas.drawTextBlob(textBlob, imageWidth - 24 * imageScale - textWidth, imageHeight - 32 * imageScale);
      canvas.detachBrush();
      canvas.detachPen();
    } catch (error) {
      Logger.error(TAG, '%{public}s', 'addWaterMark failed:', (error as BusinessError).message);
    }
    return pixelMap;
  }

  getImageSource(context: Context): image.ImageSource | undefined {
    let imageSource: image.ImageSource | undefined;
    const resourceMgr: resourceManager.ResourceManager = context.resourceManager;
    try {
      const rawFileDescriptor = resourceMgr.getRawFdSync('river.png');
      imageSource = image.createImageSource(rawFileDescriptor);
      return imageSource;
    } catch (e) {
      Logger.error(TAG, `onDragStart failed. code: ${e.code ?? ''}, message: ${e.message ?? e}`);
      return imageSource;
    } finally {
      try {
        resourceMgr.closeRawFdSync('river.png');
      } catch (e) {
        Logger.error(TAG, '%{public}s', `closeRawFdSync failed: ${e.message}`);
      }
    }
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
            Image($rawfile('river.png'))
              .objectFit(ImageFit.Fill)
              .width('100%')
              .height(new BreakpointType({
                sm: Constants.IMAGE_HEIGHT_LARGE,
                md: Constants.IMAGE_HEIGHT_LARGE * Constants.FOLD_IMAGE_RATE,
                lg: Constants.IMAGE_HEIGHT_LARGE * Constants.FOLD_IMAGE_RATE
              }).getValue(this.curBp))
              .fitOriginalSize(true)
              .borderRadius($r('sys.float.corner_radius_level8'))
              .draggable(true)
              .onDragStart((event: DragEvent) => {
                this.context ??= this.getUIContext().getHostContext();
                if (!this.context) {
                  Logger.error(TAG, '%{public}s', 'can not get context');
                  return;
                }
                let imageSource: image.ImageSource | undefined = this.getImageSource(this.context);
                if (!imageSource) {
                  Logger.error(TAG, '%{public}s', 'can not get imageSource');
                  return;
                }
                let pixelMap: image.PixelMap | undefined;
                let markPixelMap: image.PixelMap | undefined;
                let imagePacker: image.ImagePacker | undefined;
                let file: fs.File | undefined;
                try {
                  pixelMap = imageSource.createPixelMapSync();
                  this.time = this.getTimeWatermark(systemDateTime.getTime(false));
                  markPixelMap = this.addWaterMark(this.time, pixelMap);
                  const packOpts: image.PackingOption = { format: 'image/png', quality: 20 };
                  file = fs.openSync(`${this.context.filesDir}/watermark.png`,
                    fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
                  imagePacker = image.createImagePacker();
                  imagePacker.packToFile(markPixelMap, file.fd, packOpts).catch((err: BusinessError) => {
                    Logger.error(TAG, `packToFile failed. Cause: ${err.code}, ${err.message}`);
                  });
                  const img: unifiedDataChannel.Image = new unifiedDataChannel.Image();
                  img.imageUri = fileUri.getUriFromPath(`${this.context.filesDir}/watermark.png`);
                  const data: unifiedDataChannel.UnifiedData = new unifiedDataChannel.UnifiedData(img);
                  (event as DragEvent).setData(data);
                } catch (err) {
                  Logger.error(TAG, `onDragStart failed. code: ${err.code ?? ''}, message: ${err.message ?? ''}`);
                } finally {
                  imagePacker?.release();
                  pixelMap?.release();
                  markPixelMap?.release();
                  imageSource?.release();
                  try {
                    if (file) {
                      fs.closeSync(file.fd);
                    }
                  } catch (e) {
                    Logger.error(TAG, '%{public}s', `close file failed: ${e.message}`);
                  }
                }
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
            top: $r('sys.float.padding_level8')
          })

          SubHeader({
            primaryTitle: $r('app.string.area_can_drag'),
            primaryTitleModifier: this.primaryModifier
          })
          Column() {
            Image(this.targetImage)
              .objectFit(ImageFit.Fill)
              .constraintSize({ maxWidth: '100%' })
              .width('100%')
              .height(new BreakpointType({
                sm: Constants.IMAGE_HEIGHT_LARGE,
                md: Constants.IMAGE_HEIGHT_LARGE * Constants.FOLD_IMAGE_RATE,
                lg: Constants.IMAGE_HEIGHT_LARGE * Constants.FOLD_IMAGE_RATE
              }).getValue(this.curBp))
              .fitOriginalSize(true)
              .borderRadius($r('sys.float.corner_radius_level8'))
              .draggable(true)
          }
          .alignItems(HorizontalAlign.Center)
          .allowDrop([uniformTypeDescriptor.UniformDataType.IMAGE])
          .onDrop((dragEvent?: DragEvent) => {
            this.getDataFromUdmf((dragEvent as DragEvent), (event: DragEvent) => {
              try {
                let records: unifiedDataChannel.UnifiedRecord[] = event.getData().getRecords();
                this.targetImage = (records[0] as unifiedDataChannel.Image).imageUri;
                event.useCustomDropAnimation = false;
                event.setResult(DragResult.DRAG_SUCCESSFUL);
              } catch (err) {
                Logger.error(TAG, `event.getData failed. code: ${err.code ?? ''}, message: ${err.message ?? ''}`);
              }
            })
          })
          .backgroundColor($r('sys.color.comp_background_primary'))
          .constraintSize({ maxWidth: '100%' })
          .borderRadius($r('sys.float.corner_radius_level8'))
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
    .title($r('app.string.watermark_title'))
    .backgroundColor($r('sys.color.background_secondary'))
  }
}