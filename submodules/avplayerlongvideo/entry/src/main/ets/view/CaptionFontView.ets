/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { CaptionFont } from '../model/CaptionFontModel';
import { CaptionFontConstants } from '../common/constants/CommonConstants';
import { KeyConstants } from '../common/constants/KeyConstants';
import { BreakpointType } from '../common/utils/BreakpointType';

@Component
export struct CaptionFontView {
  @Prop captionFont: CaptionFont;
  close: (captionFont: CaptionFont | null) => void = () => {
  };
  @StorageProp(KeyConstants.KEY_WIDTH_BREAKPOINT) widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @StorageProp(KeyConstants.KEY_IS_HALF_FOLDED) isHalfFolded: boolean = false;
  @StorageProp(KeyConstants.KEY_CREASE_REGION) creaseRegion: number[] = [];

  @Builder
  FontFamily(text: ResourceStr) {
    Button(text)
      .fontSize(16)
      .fontColor(this.captionFont.family === text ? Color.Black : Color.White)
      .backgroundColor(this.captionFont.family === text ? 'rgba(255,255,255,0.9)' : 'rgba(255,255,255,0.1)')
      .onClick(() => {
        // Set fontFamily of caption
        this.captionFont.family = text;
      })
  }

  @Builder
  FontSize(text: ResourceStr) {
    Button(text)
      .fontSize(16)
      .fontColor(this.captionFont.size === Number(text) ? Color.Black : Color.White)
      .backgroundColor(this.captionFont.size === Number(text) ? 'rgba(255,255,255,0.9)' : 'rgba(255,255,255,0.1)')
      .onClick(() => {
        // Set fontSize of caption
        this.captionFont.size = Number(text);
      })
  }

  @Builder
  FontColor(captionFontColor: ResourceColor) {
    Column() {
      if (this.captionFont.color === captionFontColor) {
        Column() {
        }
        .width(12)
        .height(12)
        .borderRadius('50%')
        .border({ width: 1, color: Color.Gray })
      }
    }
    .width(24)
    .height(24)
    .borderRadius('50%')
    .backgroundColor(captionFontColor)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      // Set fontColor of caption
      this.captionFont.color = captionFontColor;
    })
  }

  @Builder
  RowFontTitle() {
    Row() {
      Text($r('app.string.caption_title'))
        .fontSize(18)
        .fontWeight(700)
        .fontColor(Color.White)

      Blank()
      Row({ space: 32 }) {
        Image($r('app.media.x_mark'))
          .width(20)
          .onClick(() => {
            this.close(null);
          })
        Image($r('app.media.checkmark'))
          .width(20)
          .onClick(() => {
            this.close(this.captionFont);
          })
      }
    }
    .width('100%')
    .margin({ bottom: 16 })
  }

  @Builder
  RowFontFamily() {
    Row({ space: 20 }) {
      Column() {
        Text($r('app.string.caption_family'))
          .fontColor(Color.White)
          .fontSize(16)
          .fontWeight(500)
      }

      Row({ space: 12 }) {
        ForEach(CaptionFontConstants.CAPTION_FONT_FAMILY, (captionFontFamily: ResourceStr) => {
          this.FontFamily(captionFontFamily)
        }, (captionFontFamily: ResourceStr, index: number) => `${captionFontFamily}_${index}`)
      }
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ top: 14, bottom: 14 })
  }

  @Builder
  RowFontSize() {
    Row() {
      Column() {
        Text($r('app.string.caption_size'))
          .fontColor(Color.White)
          .fontSize(16)
          .fontWeight(500)
      }

      Row({ space: 12 }) {
        ForEach(CaptionFontConstants.CAPTION_FONT_SIZE, (captionFontSize: ResourceStr) => {
          this.FontSize(captionFontSize)
        }, (captionFontSize: ResourceStr, index: number) => `${captionFontSize}_${index}`)
      }
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ top: 14, bottom: 14 })
  }

  @Builder
  RowFontColor() {
    Row() {
      Column() {
        Text($r('app.string.caption_color'))
          .fontColor(Color.White)
          .fontSize(16)
          .fontWeight(500)
      }

      Row({ space: 16 }) {
        ForEach(CaptionFontConstants.CAPTION_FONT_COLOR, (captionFontColor: ResourceColor) => {
          this.FontColor(captionFontColor)
        }, (captionFontColor: ResourceColor, index: number) => `${captionFontColor}_${index}`)
      }
      .padding({
        left: 10,
        right: 10,
        top: 8,
        bottom: 8
      })
      .borderRadius(20)
      .backgroundColor('rgba(255,255,255,0.9)')
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ top: 14, bottom: 14 })
  }

  build() {
    Column() {
      Column() {
        this.RowFontTitle()

        Divider()
          .color('rgba(255,255,255,0.2)')

        this.RowFontFamily()

        Divider()
          .color('rgba(255,255,255,0.2)')

        this.RowFontSize()

        Divider()
          .color('rgba(255,255,255,0.2)')

        this.RowFontColor()
      }
      .width('40%')
      .height('100%')
      .linearGradient({
        angle: 269.43,
        colors: [['rgba(0,0,0,0.6)', 0.0148], ['rgba(0,0,0,0)', 0.99597]]
      })
      .position({ right: 0 })
      .padding({
        top: this.isHalfFolded ? this.creaseRegion[0] + this.creaseRegion[1] : 40,
        left: 16,
        right: new BreakpointType(16, 16, 24, 32, 32).getValue(this.widthBp)
      })
      .onClick(() => {
      })
    }
    .width('100%')
    .height('100%')
    .onClick(() => {
      this.close(null);
    })
  }
}