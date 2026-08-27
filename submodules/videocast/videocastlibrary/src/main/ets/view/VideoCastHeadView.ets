/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { avSession } from '@kit.AVSessionKit';
import { CommonConstants } from '../common/constants/CommonConstants';
import Logger from '../common/utils/Logger';
import { IconButton } from './CommonView'
import { AVCastController } from '../controller/AVCastController';
import { VideoSessionController } from '../controller/VideoSessionController';

const TAG: string = '[VideoCastHeadView]';

@Component
export struct VideoCastHeadView {
  @StorageLink(CommonConstants.KEY_PREFIX + 'Breakpoint') currentWidthBreakpoint: string = 'sm';
  @StorageLink(CommonConstants.KEY_PREFIX + 'AvCastController') avCastPlayerController?: AVCastController = undefined;
  @StorageLink('castAvSessionController') avSessionController ?: VideoSessionController = undefined;
  @StorageLink('avplayerContinueTime') avplayerContinueTime: number = 0;
  @StorageLink('avplayerContinueIndex') avplayerContinueIndex: number = 0;
  @StorageLink('deviceName') deviceName: string = '';
  @Link path: NavPathStack;
  showDeviceName: boolean = true;

  build() {
    Row() {
      IconButton({ iconResource: $r('sys.symbol.chevron_left') })
        .margin({
          right: 8
        })
        .onClick(() => {
          this.path.clear();
        })
      Text(this.deviceName)
        .fontWeight(700)
        .fontSize(20)
        .fontColor(Color.White)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .layoutWeight(1)
        .visibility(this.showDeviceName ? Visibility.Visible : Visibility.Hidden)
      Row() {
        IconButton({ iconResource: $r('sys.symbol.reverse_order') })
          .margin({
            right: 8
          })
          .onClick(() => {
            try {
              let context = this.getUIContext().getHostContext() as common.Context;
              let avCastPicker = new avSession.AVCastPickerHelper(context);
              let avCastPickerOptions: avSession.AVCastPickerOptions = {
                sessionType: 'video',
              };
              avCastPicker.select(avCastPickerOptions);
            } catch (err) {
              const error: BusinessError = err as BusinessError;
              Logger.error(TAG, `avCastPicker.select failed. cause code: ${error.code}, message: ${error.message}`);
            }
          })
        IconButton({ iconResource: $r('sys.symbol.power') })
          .onClick(async () => {
            if (this.avCastPlayerController && this.avSessionController) {
              await this.avCastPlayerController.releaseAVCast();
              this.avCastPlayerController = undefined;
              await this.avSessionController.stopCasting();
            }
          })
      }

    }
    .width('100%')
    .height(56)
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}