/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { image } from '@kit.ImageKit';
import { LengthMetrics } from '@kit.ArkUI';
import { effectKit } from '@kit.ArkGraphics2D';
import { CommonConstants } from '../common/constant/CommonConstants';
import { PixelMapManager } from '../pages/PixelMapManager';
import { BreakpointType, getValueByBreakpointSync } from '../utils/MultiDeviceUtil';
import { EditStateViewModel } from '../viewModel/EditStateViewModel';
import Logger from '../utils/Logger';

const TAG = 'ApplyFilterView';

interface filterDataType {
  title: string | Resource;
  key: string;
  color: string;
}

@Component
export default struct ApplyFilterView {
  pixelMapManager?: PixelMapManager;
  scroller: Scroller = new Scroller();
  @State filterData: Array<filterDataType> = [
    {
      title: $r('app.string.none'),
      key: 'null',
      color: '#fff1efef'
    },
    {
      title: $r('app.string.grayscale'),
      key: 'grayscale',
      color: '#ffeaeaea'
    },
    {
      title: $r('app.string.brightness'),
      key: 'brightness',
      color: '#ffc1bdbd'
    },
    {
      title: $r('app.string.invert'),
      key: 'invert',
      color: '#ff9f9c9c'
    },
    {
      title: $r('app.string.blur'),
      key: 'blur',
      color: '#7a000000'
    },
    {
      title: $r('app.string.customize'),
      key: 'customize',
      color: '#7a000000'
    }
  ];
  @State filterThumbnails: (image.PixelMap | undefined)[] = [];
  @Consume editState: EditStateViewModel;
  @StorageProp(CommonConstants.BREAKPOINT_KEY) currentBreakpoint: BreakpointType = 'sm';

  aboutToAppear(): void {
    this.generateFilterThumbnails();
  }

  private async generateFilterThumbnails(): Promise<void> {
    const originPixelMap = this.pixelMapManager?.getInitPixelMap();
    if (!originPixelMap) {
      return;
    }

    try {
      const imageInfo = originPixelMap.getImageInfoSync();
      const width = imageInfo.size.width;
      const height = imageInfo.size.height;
      const scale = CommonConstants.FILTER_THUMBNAIL_SIZE / Math.min(width, height);

      const thumbnails: (image.PixelMap | undefined)[] = [];
      for (let i = 0; i < this.filterData.length; i++) {
        let thumbnail = originPixelMap.cloneSync();
        await thumbnail.scale(scale, scale);

        const scaledInfo = thumbnail.getImageInfoSync();
        const scaledWidth = scaledInfo.size.width;
        const scaledHeight = scaledInfo.size.height;
        const cropX = Math.round((scaledWidth - CommonConstants.FILTER_THUMBNAIL_SIZE) / 2);
        const cropY = Math.round((scaledHeight - CommonConstants.FILTER_THUMBNAIL_SIZE) / 2);
        await thumbnail.crop({
          size: { width: CommonConstants.FILTER_THUMBNAIL_SIZE, height: CommonConstants.FILTER_THUMBNAIL_SIZE },
          x: cropX,
          y: cropY
        });

        switch (i) {
          case 0:
            break;
          case 1:
            const grayscaleFilter = effectKit.createEffect(thumbnail);
            thumbnail = await grayscaleFilter.grayscale().getEffectPixelMap();
            break;
          case 2:
            const brightnessFilter = effectKit.createEffect(thumbnail);
            thumbnail = await brightnessFilter.brightness(0.7).getEffectPixelMap();
            break;
          case 3:
            const invertFilter = effectKit.createEffect(thumbnail);
            thumbnail = await invertFilter.invert().getEffectPixelMap();
            break;
          case 4:
            const blurFilter = effectKit.createEffect(thumbnail);
            thumbnail = await blurFilter.blur(5).getEffectPixelMap();
            break;
          case 5:
            break;
          default:
            break;
        }
        thumbnails.push(thumbnail);
      }
      this.filterThumbnails = thumbnails;
    } catch (err) {
      Logger.error(TAG, `generateFilterThumbnails failed: ${JSON.stringify(err)}`);
    }
  }

  build() {
    Column() {
      Scroll(this.scroller) {
        Flex({
          direction: getValueByBreakpointSync({
            sm: FlexDirection.Row,
            lg: FlexDirection.Column
          }, this.currentBreakpoint),
          justifyContent: FlexAlign.Start,
          alignItems: ItemAlign.Start,
          space: { main: LengthMetrics.vp(4) }
        }) {
          ForEach(this.filterData, (item: filterDataType, index: number) => {
            Flex({
              direction: this.currentBreakpoint === 'lg' ? FlexDirection.Row : FlexDirection.Column,
              alignItems: ItemAlign.Center
            }) {
              Image(this.filterThumbnails[index])
                .width(CommonConstants.FILTER_THUMBNAIL_SIZE)
                .height(CommonConstants.FILTER_THUMBNAIL_SIZE)
                .borderRadius(8)
                .objectFit(ImageFit.Fill)
                .borderWidth(2)
                .borderColor(index === this.editState.currentFilterMode ? '#fff' : Color.Transparent)

              Text(item.title)
                .fontSize(12)
                .fontColor('#fff')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin(this.currentBreakpoint === 'lg'
                  ? { left: 4 }
                  : { top: 4 }
                )
            }
            .height(this.currentBreakpoint === 'lg'
              ? CommonConstants.FILTER_THUMBNAIL_SIZE
              : CommonConstants.FILTER_ITEM_HEIGHT_SM)
            .onClick(() => {
              this.pixelMapManager?.handleFilter(index);
              this.editState.currentFilterMode = index;
            })
          }, (item: filterDataType) => item.key)
        }
        .align(Alignment.Bottom)
      }
      .constraintSize({ maxHeight: this.currentBreakpoint === 'lg' ? 344 : '100%' })
      .padding({ top: 4, bottom: 4 })
      .scrollable(this.currentBreakpoint === 'lg' ? ScrollDirection.Vertical : ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .scrollBarColor('#ffeceaea')
      .scrollBarWidth(0)
      .friction(0)
      .edgeEffect(EdgeEffect.None)
    }
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding({ left: 16, right: 16 })
  }
}
