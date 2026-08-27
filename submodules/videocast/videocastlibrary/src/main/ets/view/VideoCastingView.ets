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

import { AVCastingControllerView } from './AVCastingControllerView';
import { BreakpointType, BreakpointTypeEnum } from '../common/utils/BreakpointSystem';
import { AVCastController } from '../controller/AVCastController';
import { VideoData } from '../model/VideoData';
import { VideoCastHeadView } from './VideoCastHeadView';
import { CommonConstants } from '../common/constants/CommonConstants';

@Component
export struct VideoCastingView {
  @StorageLink(CommonConstants.KEY_PREFIX + 'Breakpoint') currentWidthBreakpoint: string = 'sm';
  @StorageLink(CommonConstants.KEY_PREFIX + 'AvCastController') @Watch('avCastPlayerControllerChange') avCastPlayerController?: AVCastController = undefined;
  @StorageLink(CommonConstants.KEY_PREFIX + 'NaviIndicatorHeight') naviIndicatorHeight: number = 0;
  @StorageLink('deviceName') deviceName: string = '';
  @StorageLink('castingList') castingList: string[] = [];
  @Prop videoType: string;
  @Prop videoList: VideoData[];
  @Link @Watch('castIndexChange') castIndex: number;
  @Link videoPlayPathStack: NavPathStack;
  @State duration: number = this.videoList[this.castIndex].duration;

  castIndexChange() {
    if (this.castingList && this.castIndex >= 0 && this.castIndex < this.videoList.length) {
      this.avCastPlayerController?.setCastResource(this.castIndex, 0);
      this.duration = this.videoList[this.castIndex].duration;
    }
  }

  avCastPlayerControllerChange() {
    if (this.avCastPlayerController) {
      if (this.avCastPlayerController.castIndex >= 0) {
        this.castIndex = this.avCastPlayerController.castIndex;
      }
    }
  }

  build() {
    RelativeContainer() {
      VideoCastHeadView({
        showDeviceName: false, path: this.videoPlayPathStack
      })
        .padding({
          left: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.currentWidthBreakpoint),
          right: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.currentWidthBreakpoint)
        })
        .zIndex(2)

      Row() {
        SymbolGlyph($r('sys.symbol.wireless_projection'))
          .fontSize(24)
          .fontColor([Color.White])
          .margin({
            right: 12
          })
        Text($r('app.string.casting', this.deviceName))
          .fontColor(Color.White)
          .fontSize(20)
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .backgroundImage(this.videoList[this.castIndex].head)
      .backgroundImageSize(ImageSize.Cover)
      .backgroundBlurStyle(BlurStyle.Thin)
      .width('100%')
      .aspectRatio(1920 / 1080)
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
      })

      AVCastingControllerView({ durationTime: this.duration })
        .alignRules({
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
        })
        .padding({
          left: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.currentWidthBreakpoint),
          right: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.currentWidthBreakpoint),
          bottom: (this.currentWidthBreakpoint === BreakpointTypeEnum.LG ||
            this.currentWidthBreakpoint === BreakpointTypeEnum.XL) ?
            (this.naviIndicatorHeight !== 0 ? this.naviIndicatorHeight : 8) : 0
        })
    }
    .width('100%')
    .height('100%')
  }
}