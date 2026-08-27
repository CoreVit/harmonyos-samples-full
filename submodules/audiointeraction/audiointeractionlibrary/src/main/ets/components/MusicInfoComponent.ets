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
import { deviceInfo } from '@kit.BasicServicesKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { BreakpointConstants } from '../common/constants/BreakpointConstants';
import { KeyConstants } from '../common/constants/KeyConstants';
import { PlayerConstants } from '../common/constants/PlayerConstants';
import { StyleConstants } from '../common/constants/StyleConstants';
import { BreakpointTypeEnum } from '../common/utils/BreakpointSystem';
import Logger from '../common/utils/Logger';
import { SongItem } from '../songdatacontroller/SongData';
import { ControlAreaComponent } from './ControlAreaComponent';

const TAG: string = '[MusicInfoComponent]';

@Component
export struct MusicInfoComponent {
  @StorageProp(KeyConstants.KEY_BREAKPOINT) currentBreakpoint: string = BreakpointTypeEnum.SM;
  @StorageProp(KeyConstants.KEY_SELECT_INDEX) selectIndex: number = 0;
  @StorageLink(KeyConstants.KEY_SONG_LIST) songList: SongItem[] = [];

  build() {
    GridRow({
      columns: {
        xs: BreakpointConstants.COLUMN_SM,
        sm: BreakpointConstants.COLUMN_SM,
        md: BreakpointConstants.COLUMN_MD
      },
      gutter: BreakpointConstants.GUTTER_MUSIC_X,
      breakpoints: { reference: BreakpointsReference.ComponentSize }
    }) {
      GridCol({
        span: {
          xs: BreakpointConstants.SPAN_SM,
          sm: BreakpointConstants.SPAN_SM,
          md: BreakpointConstants.SPAN_MD
        },
        offset: { md: BreakpointConstants.OFFSET_MD }
      }) {
        Column() {
          this.CoverInfo()
          this.MusicInfo()
          Blank()
          ControlAreaComponent()
        }
        .height(StyleConstants.FULL_HEIGHT)
        .width(StyleConstants.FULL_HEIGHT)
        .clip(false)
      }
    }
  }

  @Builder
  CoverInfo() {
    Row() {
      Image(this.songList[this.selectIndex].label)
        .width(StyleConstants.FULL_WIDTH)
        .constraintSize({
          maxWidth: this.currentBreakpoint === BreakpointTypeEnum.SM ? StyleConstants.IMAGE_SIZE_SM_MAX :
            StyleConstants.FULL_WIDTH
        })
        .aspectRatio(1)
        .borderRadius($r('app.float.cover_radius_label'))
        .shadow({
          radius: $r('app.float.shadow_radius'),
          color: $r('app.color.shadow_color'),
          offsetX: 0,
          offsetY: 8
        })
        .margin((deviceInfo.productSeries === 'VDE' && this.getFoldStatus() === FoldStatus.FOLD_STATUS_EXPANDED) ?
          $r('app.float.cover_image_margin') : $r('app.float.lyric_margin_right_sm'))
    }
    .layoutWeight(1)
  }

  @Builder
  MusicInfo() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text(this.songList[this.selectIndex].title)
          .fontSize($r('app.float.title_font_play'))
          .fontColor(Color.White)
          .opacity(0.86)
          .fontWeight(FontWeight.Bold)
          .fontFamily(PlayerConstants.FONT_FAMILY_BOLD)
      }

      Text(this.songList[this.selectIndex].singer)
        .textAlign(TextAlign.Start)
        .fontSize($r('app.float.font_fourteen'))
        .fontColor($r('app.color.play_text_color'))
        .fontFamily(PlayerConstants.FONT_FAMILY_BLACK)
        .margin({ top: $r('app.float.music_text_margin_top') })
        .width(StyleConstants.FULL_WIDTH)
        .fontWeight(FontWeight.Regular)
    }
    .margin({ top: $r('app.float.music_info_margin_top') })
  }

  private getFoldStatus(): number {
    if (canIUse('SystemCapability.Window.SessionManager')) {
      try {
        return display.getFoldStatus();
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        Logger.error(TAG, `getFoldStatus failed: cause the code ${err.code}, the message is ${err.message}`);
      }
    }
    return FoldStatus.FOLD_STATUS_UNKNOWN;
  }
}