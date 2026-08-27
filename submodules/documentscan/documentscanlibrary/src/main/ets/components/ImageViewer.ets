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

import { display } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import Constants from '../constants/Constants';
import Logger from '../constants/utils/Logger';

const TAG = 'ImageViewer';

@Builder
export function ImageViewerBuilder(name: string, param: string) {
  ImageViewer({ imageUri: param })
}

@Component
export struct ImageViewer {
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(Constants.KEY_NAV_INDICATOR_HEIGHT) navIndicatorHeight: number = 0;
  @Consume(Constants.KEY_PATH_STACK) navPathStack: NavPathStack;
  @State deviceWidth: number = Constants.DEFAULT_WIDTH;
  @State smallImgWidth: number = (Constants.DEFAULT_WIDTH - Constants.LIST_ITEM_SPACE * (Constants.SHOW_COUNT - 1)) /
  Constants.SHOW_COUNT;
  @State imageWidth: number = this.deviceWidth + this.smallImgWidth;
  @State isScaling: boolean = true;
  @State imgScale: number = 1;
  @State imgOffSetX: number = 0;
  @State imgOffSetY: number = 0;
  @Prop imageUri: string | undefined = undefined;
  preOffsetX: number = 0;
  preOffsetY: number = 0;
  currentScale: number = 1;

  aboutToAppear() {
    let displayClass: display.Display | undefined;
    try {
      displayClass = display.getDefaultDisplaySync();
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `Failed to get default display. Cause code: ${err.code}, message: ${err.message}`);
    }
    const width = displayClass ? displayClass.width / displayClass.densityPixels : Constants.DEFAULT_WIDTH;
    this.deviceWidth = width;
    this.smallImgWidth = (width - Constants.LIST_ITEM_SPACE * (Constants.SHOW_COUNT - 1)) / Constants.SHOW_COUNT;
    this.imageWidth = this.deviceWidth + this.smallImgWidth;
  }

  private resetImg(): void {
    this.imgScale = 1;
    this.currentScale = 1;
    this.preOffsetX = 0;
    this.preOffsetY = 0;
  }

  private handlePanEnd(): void {
    const initOffsetX = (this.imgScale - 1) * this.imageWidth + this.smallImgWidth;
    if (Math.abs(this.imgOffSetX) > initOffsetX) {
      this.isScaling = false;
      this.resetImg();
    }
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.TopStart }) {
        Image(this.imageUri)
          .position({ x: this.imgOffSetX, y: this.imgOffSetY })
          .scale({ x: this.imgScale, y: this.imgScale })
          .objectFit(ImageFit.Contain)
          .gesture(GestureGroup(GestureMode.Exclusive,
            PinchGesture({ fingers: Constants.DOUBLE_NUMBER })
              .onActionUpdate((event?: GestureEvent) => {
                if (event) {
                  this.imgScale = this.currentScale * event.scale;
                }
              })
              .onActionEnd(() => {
                if (this.imgScale < 1) {
                  this.resetImg();
                  this.imgOffSetX = 0;
                  this.imgOffSetY = 0;
                } else {
                  this.currentScale = this.imgScale;
                }
              }),
            PanGesture()
              .onActionStart(() => {
                this.preOffsetX = this.imgOffSetX;
                this.preOffsetY = this.imgOffSetY;
              })
              .onActionUpdate((event?: GestureEvent) => {
                if (event) {
                  this.imgOffSetX = this.preOffsetX + event.offsetX;
                  this.imgOffSetY = this.preOffsetY + event.offsetY;
                }
              })
              .onActionEnd(() => this.handlePanEnd())
          ))
          .width('100%')
          .height('100%')

        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.chevron_backward'))
            .fontColor([$r('sys.color.icon_primary')])
            .fontSize($r('sys.float.Title_M'))
        }
        .margin({
          left: $r('sys.float.padding_level8'),
          top: $r('sys.float.padding_level2')
        })
        .backgroundColor(Color.Transparent)
        .height($r('sys.float.ohos_id_navigation_bar_logo_icon_size'))
        .aspectRatio(1)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .onClick(() => {
          this.navPathStack.pop();
        })
      }
      .width('100%')
      .height('100%')
    }
    .padding({
      top: this.statusBarHeight
    })
    .backgroundColor($r('sys.color.background_secondary'))
    .hideTitleBar(true)
  }
}