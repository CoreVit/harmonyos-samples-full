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

import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import { BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { cameraCapture } from '../utils/CameraUtils';
import { CommonConstants } from '../common/constants/CommonConstants';
import { CameraImageListView } from './CameraImageListView';
import { WindowUtil } from '../utils/WindowUtil';
import Logger from '../utils/Logger';

const MAX_SELECT_IMAGE: number = 9;
const ID_TEXT_INPUT: string = 'id_text_input';
const ID_IMAGE_CAMERA: string = 'id_image_camera';
const ID_TEXT_PUSH: string = 'id_text_publish';
const TAG: string = '[CommentInputDialog]';

@CustomDialog
@Component
export struct CommentInputDialog {
  @State selectedImages: string[] = [];
  @State text: string = '';
  @Link textInComment: string;
  @Link imagesInComment: string[];
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @State keyboardHeight: number = 0;
  controller?: CustomDialogController;
  publish: () => void = (): void => {
  };
  private keyboardHeightChangeCallback = (height: number): void => {
    this.keyboardHeight = height;
  }

  aboutToAppear(): void {
    try {
      WindowUtil.getWindowClass().on('keyboardHeightChange', this.keyboardHeightChangeCallback);
    } catch (err) {
      Logger.error(TAG, `Failed to on keyboardHeightChange. Cause: ${err.code}`);
    }
  }

  aboutToDisappear(): void {
    try {
      WindowUtil.getWindowClass().off('keyboardHeightChange', this.keyboardHeightChangeCallback);
    } catch (err) {
      Logger.error(TAG, `Failed to off keyboardHeightChange. Cause: ${err.code}`);
    }
  }

  build() {
    Column() {
      RelativeContainer() {
        TextInput()
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .height($r('app.integer.text_input_height'))
          .padding({
            left: $r('sys.float.padding_level5'),
            right: $r('app.integer.text_input_padding_right'),
          })
          .margin({ right: $r('sys.float.padding_level5') })
          .onChange((textInComment: string) => {
            this.text = textInComment;
          })
          .defaultFocus(true)
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            left: { anchor: '__container__', align: HorizontalAlign.Start },
            right: { anchor: ID_TEXT_PUSH, align: HorizontalAlign.Start }
          })
          .id(ID_TEXT_INPUT)
        SymbolGlyph($r('sys.symbol.camera'))
          .fontColor([$r('sys.color.icon_tertiary')])
          .fontSize($r('sys.float.Title_M'))
          .onClick(async () => {
            if (this.curBp === BreakpointTypeEnum.XL) {
              this.getUIContext().getPromptAction().showToast({
                message: $r('app.string.2in1_not_support'),
                duration: CommonConstants.TOAST_DURATION,
                showMode: promptAction.ToastShowMode.DEFAULT,
                bottom: CommonConstants.TOAST_BOTTOM_MARGIN
              });
            } else {
              if (this.selectedImages.length >= MAX_SELECT_IMAGE) {
                this.getUIContext().getPromptAction().showToast({ message: $r('app.string.most_select_image') });
                return;
              }
              const image: string =
                await cameraCapture(this.getUIContext().getHostContext() as common.UIAbilityContext);
              if (image !== '') {
                this.selectedImages.push(image);
              }
            }
          })
          .margin({
            right: $r('app.integer.image_camera_margin_top')
          })
          .alignRules({
            top: { anchor: ID_TEXT_INPUT, align: VerticalAlign.Top },
            bottom: { anchor: ID_TEXT_INPUT, align: VerticalAlign.Bottom },
            right: { anchor: ID_TEXT_INPUT, align: HorizontalAlign.End }
          })
          .id(ID_IMAGE_CAMERA)
        Button($r('app.string.publish'))
          .width($r('app.integer.button_publish_width'))
          .height($r('app.integer.button_publish_height'))
          .borderRadius($r('app.integer.border_radius'))
          .backgroundColor($r('app.color.button_publish_background'))
          .fontSize($r('sys.float.Body_M'))
          .onClick(() => {
            if (this.controller) {
              this.textInComment = this.text;
              this.imagesInComment = this.selectedImages;
              this.publish();
              this.controller.close();
              this.textInComment = '';
              this.imagesInComment = [];
            }
          })
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            right: { anchor: '__container__', align: HorizontalAlign.End }
          })
          .id(ID_TEXT_PUSH)
      }
      .height($r('app.integer.relative_container_input_height'))
      .margin({
        bottom: (this.keyboardHeight > 0) ? 0 : this.navigatorBarHeight
      })

      if (this.selectedImages.length > 0) {
        CameraImageListView({ selectedImages: this.selectedImages })
      }
    }
    .backgroundColor($r('sys.color.background_primary'))
    .padding({
      left: $r('sys.float.padding_level8'),
      right: $r('sys.float.padding_level8'),
    })
    .offset({ y: (this.keyboardHeight > 0) ? $r('sys.float.padding_level8') : 0 })
  }
}