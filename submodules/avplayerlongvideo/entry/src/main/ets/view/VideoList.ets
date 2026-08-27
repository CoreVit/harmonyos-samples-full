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

import { image } from '@kit.ImageKit';
import { deviceInfo } from '@kit.BasicServicesKit';
import { CommonConstants } from '../common/constants/CommonConstants';
import { KeyConstants } from '../common/constants/KeyConstants';
import { VideoData } from '../model/VideoData';
import { ImageUtil } from '../common/utils/ImageUtil';
import { WindowUtil } from '../common/utils/WindowUtil';
import { VideoDataType } from '../common/constants/CommonConstants';

@Component({ freezeWhenInactive: true })
export struct VideoList {
  @Link currentIndex: number; // The index of playing video
  @Prop sources: VideoData[];
  onItemClick?: (index: number) => void = () => {
  };
  @State pixelMaps: image.PixelMap | undefined[] = [];
  @StorageProp(KeyConstants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(KeyConstants.KEY_TITLE_BTN_HEIGHT) titleHeight: number = 0;
  @StorageProp(KeyConstants.KEY_NAV_BAR_HEIGHT) navBarHeight: number = 0;
  @StorageProp(KeyConstants.KEY_WIDTH_BREAKPOINT) widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @StorageProp(KeyConstants.KEY_HEIGHT_BREAKPOINT) heightBp: HeightBreakpoint = HeightBreakpoint.HEIGHT_LG;
  @StorageProp(KeyConstants.KEY_DEVICE_WIDTH) screenWidth: number = 0; // Screen width
  @StorageProp(KeyConstants.KEY_DEVICE_HEIGHT) screenHeight: number = 0; // Screen height

  async aboutToAppear(): Promise<void> {
    for (let index = 1; index < this.sources.length; index++) {
      let url: string = this.sources[index].videoSrc;
      let pixelMap = await ImageUtil.getThumbnailFromVideo(url, 500); // Get first frame image from each video
      this.pixelMaps[index] = pixelMap;
    }
  }

  getLanes(): number {
    return this.widthBp === WidthBreakpoint.WIDTH_MD ? 3 :
      ((this.widthBp === WidthBreakpoint.WIDTH_LG &&
        (WindowUtil.getInstance().isPhoneDevice() || this.heightBp === HeightBreakpoint.HEIGHT_LG)) ? 4 : 2);
  }

  getGutter(): number {
    switch (this.widthBp) {
      case WidthBreakpoint.WIDTH_XS:
      case WidthBreakpoint.WIDTH_SM:
        return 8;
      case WidthBreakpoint.WIDTH_MD:
      case WidthBreakpoint.WIDTH_XL:
        return 12;
      case WidthBreakpoint.WIDTH_LG:
        return this.getLanes() === 2 ? 12 : 16;
    }
  }

  getPadding(): number {
    switch (this.widthBp) {
      case WidthBreakpoint.WIDTH_XS:
      case WidthBreakpoint.WIDTH_SM:
      case WidthBreakpoint.WIDTH_XL:
        return 16;
      case WidthBreakpoint.WIDTH_MD:
        return 24;
      case WidthBreakpoint.WIDTH_LG:
        return this.getLanes() === 2 ? 16 : 32;
    }
  }

  getTopMargin(): number {
    switch (this.widthBp) {
      case WidthBreakpoint.WIDTH_XS:
      case WidthBreakpoint.WIDTH_SM:
      case WidthBreakpoint.WIDTH_MD:
        return 0;
      case WidthBreakpoint.WIDTH_LG:
      case WidthBreakpoint.WIDTH_XL:
        let deviceType: string = deviceInfo.deviceType;
        if (deviceType === deviceInfo.DeviceTypes.TYPE_PHONE || this.heightBp === HeightBreakpoint.HEIGHT_LG) {
          return 0;
        } else if (deviceType === deviceInfo.DeviceTypes.TYPE_TABLET) {
          return this.statusBarHeight;
        } else if (deviceType === deviceInfo.DeviceTypes.TYPE_2IN1) {
          return this.titleHeight;
        }
    }
    return 0;
  }

  @Builder
  ScrollList() {
    Scroll() {
      List({ space: CommonConstants.LIST_SPACE }) {
        ForEach(this.sources, (item: VideoData, index: number) => {
          ListItem() {
            Flex({ direction: FlexDirection.Column }) {
              Image(this.pixelMaps[index] || $r('app.media.preview1'))
                .objectFit(ImageFit.Cover)
                .borderRadius($r('app.float.list_img_radius'))
              Column() {
                Text() {
                  if (index === this.currentIndex) {
                    SymbolSpan($r('sys.symbol.play_round_rectangle_fill'))
                      .width($r('app.float.size_20'))
                      .height($r('app.float.size_20'))
                  } // Whether is the current playing video
                  Span((index + 1) + '.')
                  Span(
                    (item.type === VideoDataType.RAW_FILE ? $r('app.string.local_video') :
                      $r('app.string.online_video'))) // Video type
                  Span(item.description) // Video description
                }
                .fontSize($r('sys.float.Subtitle_S'))
                .fontWeight(FontWeight.Regular)
                .width(CommonConstants.WIDTH_FULL_PERCENT)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .fontColor(index === this.currentIndex ? $r('sys.color.brand') : $r('sys.color.font_on_primary'))
              }
              .margin({ top: 8 })
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.SpaceBetween)
            }
            .width(CommonConstants.WIDTH_FULL_PERCENT)
            .onClick(() => {
              this.onItemClick?.(index);
            })
          }
        }, (item: VideoData, index: number) => index + JSON.stringify(item))
      }
      .height(CommonConstants.HEIGHT_FULL_PERCENT)
      .width(CommonConstants.WIDTH_FULL_PERCENT)
      .listDirection(Axis.Vertical)
      .margin({
        bottom: this.navBarHeight + CommonConstants.SPACE_16
      })
      .scrollBar(BarState.Off)
      .lanes(this.getLanes(), this.getGutter())
    }
    .scrollBar(BarState.Off)
  }

  build() {
    Column() {
      Text($r('app.string.videoList'))
        .fontSize($r('sys.float.Subtitle_L'))
        .fontColor($r('sys.color.font_on_primary'))
        .alignSelf(ItemAlign.Start)
        .padding({ top: $r('app.float.padding_24'), bottom: $r('app.float.padding_8') })
        .fontWeight(FontWeight.Bold)
        .margin({ top: this.getTopMargin() })
      this.ScrollList()
    }
    .padding({ left: this.getPadding(), right: this.getPadding() })
    .backgroundColor(this.widthBp < WidthBreakpoint.WIDTH_LG || WindowUtil.getInstance().isPhoneDevice() ||
      this.screenWidth < this.screenHeight ? '#00000000' : '#ff202224')
  }
}