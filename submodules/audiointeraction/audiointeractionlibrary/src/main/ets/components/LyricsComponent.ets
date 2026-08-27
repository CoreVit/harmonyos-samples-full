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

import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { BreakpointConstants } from '../common/constants/BreakpointConstants';
import { KeyConstants } from '../common/constants/KeyConstants';
import { PlayerConstants } from '../common/constants/PlayerConstants';
import { StyleConstants } from '../common/constants/StyleConstants';
import { BreakpointType, BreakpointTypeEnum } from '../common/utils/BreakpointSystem';
import Logger from '../common/utils/Logger';
import { LrcEntry } from '../lyric/LrcEntry';
import { parseKrcLyric, parseLrcLyric } from '../lyric/LrcUtils';
import LrcView from '../lyric/LrcView';
import { LyricFile, LyricScrollEffect, LyricTopPosition } from '../lyric/LyricConst';
import { SongItem } from '../songdatacontroller/SongData';
import { ControlAreaComponent } from './ControlAreaComponent';

const TAG: string = '[LyricsComponent]';

@Component
export struct LyricsComponent {
  @StorageProp(KeyConstants.KEY_BREAKPOINT) currentBreakpoint: BreakpointTypeEnum = BreakpointTypeEnum.SM;
  @StorageProp(KeyConstants.KEY_SELECT_INDEX) @Watch('getLrcEntryList') selectIndex: number = 0;
  @StorageLink(KeyConstants.KEY_PROGRESS) time: number = 0;
  @StorageLink(KeyConstants.KEY_SONG_LIST) songList: SongItem[] = [];
  @Link isShowControl: boolean;
  @Link isTablet: boolean;
  @State pageShowTime: number = 0;
  @State lyricScrollEffect: LyricScrollEffect = LyricScrollEffect.Line;
  @State mLrcEntryList: Array<LrcEntry> = [];

  aboutToAppear() {
    this.getLrcEntryList();
  }

  getLrcEntryList() {
    this.mLrcEntryList = [];
    if (!this.getUIContext().getHostContext()) {
      return;
    }
    this.getUIContext().getHostContext()!.resourceManager.getRawFileContent(this.songList[this.selectIndex].lyric)
      .then((value: Uint8Array) => {
        const textDecoder = util.TextDecoder.create(PlayerConstants.ENCODING, { ignoreBOM: true });
        const stringData = textDecoder.decodeToString(value, { stream: false });
        if (this.songList[this.selectIndex].lyric.endsWith(LyricFile.KRC)) {
          this.mLrcEntryList = parseKrcLyric(stringData);
        } else if (this.songList[this.selectIndex].lyric.endsWith(LyricFile.LRC)) {
          this.mLrcEntryList = parseLrcLyric(stringData);
        }
      })
      .catch((error: BusinessError) => {
        Logger.error(TAG, `stopBackgroundRunning failed. code: ${error.code}, message: ${error.message}`);
      });
  }

  build() {
    Column() {
      if (this.currentBreakpoint === BreakpointTypeEnum.SM) {
        Row() {
          if (!this.isTablet) {
            Image(this.songList[this.selectIndex].label)
              .width(this.currentBreakpoint === BreakpointTypeEnum.SM ?
                $r('app.float.label_width_sm') : $r('app.float.label_width'))
              .borderRadius($r('app.float.label_border'))
              .margin({
                right: $r('app.float.label_margin_right')
              })
          }
          Column() {
            Text(this.songList[this.selectIndex].title)
              .fontSize(new BreakpointType({
                sm: $r('app.float.title_font_sm'),
                md: $r('app.float.title_font_md'),
                lg: $r('app.float.title_font_lg')
              }).getValue(this.currentBreakpoint))
              .fontColor(Color.White)
              .fontWeight(PlayerConstants.FONT_WEIGHT_700)
              .fontFamily(PlayerConstants.FONT_FAMILY_BOLD)
            Text(this.songList[this.selectIndex].singer)
              .fontSize(new BreakpointType({
                sm: $r('app.float.singer_font_sm'),
                md: $r('app.float.singer_font_md'),
                lg: $r('app.float.singer_font_lg')
              }).getValue(this.currentBreakpoint))
              .fontColor($r('sys.color.ohos_id_color_text_hint_contrary'))
              .fontWeight(PlayerConstants.FONT_WEIGHT_500)
              .fontFamily(PlayerConstants.FONT_FAMILY_MEDIUM)
              .margin({
                top: $r('app.float.singer_margin_top')
              })
          }
          .alignItems(HorizontalAlign.Start)
        }
        .width(StyleConstants.FULL_WIDTH)
        .justifyContent(FlexAlign.Start)
        .margin({
          top: new BreakpointType({
            sm: $r('app.float.info_margin_top_sm'),
            md: $r('app.float.zero_margin'),
            lg: $r('app.float.zero_margin')
          }).getValue(this.currentBreakpoint),
          bottom: $r('app.float.info_margin_bottom')
        })
      }

      if (this.currentBreakpoint === BreakpointTypeEnum.LG || this.currentBreakpoint === BreakpointTypeEnum.XL) {
        Row() {
          GridRow({
            columns: { lg: BreakpointConstants.COLUMN_LYRIC_LG }
          }) {
            GridCol({
              span: { lg: BreakpointConstants.SPAN_LYRIC_LG },
              offset: BreakpointConstants.OFFSET_MD
            }) {
              Column() {
                Row() {
                  Column() {
                    Text(this.songList[this.selectIndex].title)
                      .fontSize(new BreakpointType({
                        sm: $r('app.float.title_font_sm'),
                        md: $r('app.float.title_font_md'),
                        lg: $r('app.float.title_font_lg')
                      }).getValue(this.currentBreakpoint))
                      .fontColor(Color.White)
                      .fontWeight(PlayerConstants.FONT_WEIGHT_700)
                      .fontFamily(PlayerConstants.FONT_FAMILY_BOLD)
                    Text(this.songList[this.selectIndex].singer)
                      .fontSize(new BreakpointType({
                        sm: $r('app.float.singer_font_sm'),
                        md: $r('app.float.singer_font_md'),
                        lg: $r('app.float.singer_font_lg')
                      }).getValue(this.currentBreakpoint))
                      .fontColor($r('sys.color.ohos_id_color_text_hint_contrary'))
                      .fontFamily(PlayerConstants.FONT_FAMILY_MEDIUM)
                      .margin({
                        top: $r('app.float.singer_margin_top')
                      })
                  }
                  .alignItems(HorizontalAlign.Start)
                }
                .width(StyleConstants.FULL_WIDTH)
                .justifyContent(FlexAlign.Start)
                .margin({
                  top: new BreakpointType({
                    sm: $r('app.float.info_margin_top_sm'),
                    md: $r('app.float.zero_margin'),
                    lg: $r('app.float.zero_margin')
                  }).getValue(this.currentBreakpoint),
                  bottom: $r('app.float.info_margin_bottom')
                })

                LrcView({
                  lyricMilliSecondsTime: this.time,
                  mLrcEntryList: this.mLrcEntryList,
                  lyricScrollEffect: this.lyricScrollEffect,
                  lyricTopPosition: LyricTopPosition.Middle
                })
                  .layoutWeight(1)
              }
            }
          }
        }
        .layoutWeight(1)
      } else {
        LrcView({
          lyricMilliSecondsTime: this.time,
          mLrcEntryList: this.mLrcEntryList,
          lyricScrollEffect: this.lyricScrollEffect,
          lyricTopPosition: LyricTopPosition.Middle
        })
          .layoutWeight(1)
      }

      Row() {
        Text($r('app.string.lyrics'))
          .textAlign(TextAlign.Center)
          .fontSize($r('app.float.lyric_font_size'))
          .fontColor(Color.White)
          .borderColor(Color.White)
          .borderRadius($r('sys.float.corner_radius_level4'))
          .borderWidth($r('sys.float.corner_radius_level1'))
          .height(new BreakpointType({
            sm: $r('app.float.lyrics_width_sm'),
            md: $r('app.float.lyrics_width_md'),
            lg: $r('app.float.lyrics_width_lg')
          }).getValue(this.currentBreakpoint))
          .padding({ left: $r('sys.float.padding_level1'), right: $r('sys.float.padding_level1') })
      }
      .width(StyleConstants.FULL_WIDTH)
      .height($r('app.float.control_icon_height'))
      .justifyContent(FlexAlign.End)
      .margin({
        top: $r('app.float.lyric_margin_top'),
        bottom: new BreakpointType({
          sm: $r('app.float.lyric_margin_bottom_sm'),
          md: $r('app.float.lyric_margin_bottom_md'),
          lg: $r('app.float.lyric_margin_bottom_lg')
        }).getValue(this.currentBreakpoint),
        right: new BreakpointType({
          sm: $r('app.float.lyric_margin_right_sm'),
          md: $r('app.float.lyric_margin_right_md'),
          lg: $r('app.float.lyric_margin_right_lg')
        }).getValue(this.currentBreakpoint)
      })

      if (this.isShowControl) {
        ControlAreaComponent()
          .margin({
            top: $r('app.float.control_lyric_margin'),
            bottom: $r('app.float.music_component_bottom')
          })
      }
    }
    .onClick(() => {
      this.pageShowTime = 0;
    })
  }
}