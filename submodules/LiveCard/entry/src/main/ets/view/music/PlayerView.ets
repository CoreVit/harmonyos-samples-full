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

import { ColorConstants } from '../../common/ColorConstants';
import { Constants } from '../../common/CommonConstants';
import { SongItem } from '../../model/music/SongItem';
import ImageUtils from '../../utils/ImageUtils';
import { Logger } from '../../utils/Logger';
import { WindowInfo } from '../../utils/WindowUtil';
import { HeaderSection } from '../common/HeaderSection';
import { MusicInfo } from './MusicInfo';
import { PlayerLyrics } from './PlayerLyrics';

@Component
export struct PlayerView {
  @StorageProp(Constants.KEY_CURRENT_SONG) @Watch('getImageColor') currentSong: SongItem = new SongItem();
  @ObjectLink mainWindowInfo: WindowInfo;
  @Link imageColor: string;
  @State imageLabel?: PixelMap = undefined;

  getImageColor(): void {
    let context = this.getUIContext().getHostContext();
    if (context) {
      ImageUtils.getImageDealData(context, this.currentSong.label).then((data) => {
        this.imageColor = data.imageColor;
        this.imageLabel = data.blurPixelMap;
      }).catch((error: Error) => {
        Logger.error('PlayerView', `getImageDealData failed, error: ${error.name}, message: ${error.message}`);
      });
    }
  }

  private getPadding(): Padding {
    let width = 16;
    if (this.mainWindowInfo) {
      if (this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG) {
        width = 32;
      } else if (this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_MD) {
        width = 24;
      }
    }

    return { left: width, right: width };
  }

  aboutToAppear(): void {
    this.getImageColor();
  }

  aboutToDisappear(): void {
    this.imageLabel?.release();
  }

  build() {
    Stack() {
      Row() {
        Stack({ alignContent: Alignment.TopStart }) {
          Image(this.imageLabel)
            .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
            .width('100%')
            .height('100%')
            .objectFit(ImageFit.Cover)
            .opacity(0.5);
          Swiper() {
            MusicInfo({ mainWindowInfo: this.mainWindowInfo });
            PlayerLyrics({ mainWindowInfo: this.mainWindowInfo });
          }
          .displayCount(this.mainWindowInfo.widthBp > WidthBreakpoint.WIDTH_SM ? 2 : 1)
          .height('100%')
          .indicator(this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM ?
            new DotIndicator()
              .top(10)
              .selectedColor($r('app.color.select_swiper'))
              .color($r('app.color.slider_track')) : false
          )
          .clip(false)
          .loop(false);
          Row() {
            HeaderSection(undefined, undefined, true, false, ColorConstants.TAB_TEXT_WHITE);
          }
          .padding(this.getPadding())
          .width('100%');
        }
        .height('100%');
      };
    }
    .height('100%')
    .width('100%')
    .backgroundColor(this.imageColor);
  }
}