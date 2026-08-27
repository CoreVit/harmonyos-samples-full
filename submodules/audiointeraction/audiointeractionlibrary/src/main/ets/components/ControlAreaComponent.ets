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

import { Prompt } from '@kit.ArkUI';
import { AudioRendererController } from '../audiohelper/AudioRendererController';
import { AVSessionController } from '../audiohelper/AVSessionController';
import { ContentConstants } from '../common/constants/ContentConstants';
import { KeyConstants } from '../common/constants/KeyConstants';
import { PlayerConstants } from '../common/constants/PlayerConstants';
import { StyleConstants } from '../common/constants/StyleConstants';
import { BreakpointType, BreakpointTypeEnum } from '../common/utils/BreakpointSystem';
import Logger from '../common/utils/Logger';
import { ResourceConversion } from '../common/utils/ResourceConversion';
import { SongDataSource } from '../datasource/SongDataSource';
import { MusicPlayMode, playModeSwitchList as playModeSwitchList } from '../songdatacontroller/PlayerData';
import { SongItem } from '../songdatacontroller/SongData';

const TAG: string = '[ControlAreaComponent]'

@Component
export struct ControlAreaComponent {
  @StorageProp(KeyConstants.KEY_BREAKPOINT) currentBreakpoint: string = BreakpointTypeEnum.SM;
  @StorageLink(KeyConstants.KEY_IS_PLAY) isPlay: boolean = false;
  @StorageLink(KeyConstants.KEY_CURRENT_TIME) currentTime: string = '00:00';
  @StorageLink(KeyConstants.KEY_TOTAL_TIME) totalTime: string = '00:00';
  @StorageLink(KeyConstants.KEY_PROGRESS) value: number = 0;
  @StorageLink(KeyConstants.KEY_PROGRESS_MAX) max: number = 0;
  @StorageLink(KeyConstants.KEY_PAGE_SHOW_TIME) pageShowTime: number = 0;
  @StorageLink(KeyConstants.KEY_SONG_LIST) songList: SongItem[] = [];
  @StorageLink(KeyConstants.KEY_SELECT_INDEX) selectIndex: number = 0;
  @StorageLink(KeyConstants.KEY_IS_FAVORITE) isFavorite: boolean = false;
  @StorageLink(KeyConstants.KEY_IS_SILENT_MODE) isSilentMode: boolean = false;
  @State isShowPlayList: boolean = false;
  @State playModeIndex: number = 0;
  @StorageLink(KeyConstants.KEY_PLAY_MODE) playMode: MusicPlayMode = playModeSwitchList[this.playModeIndex];
  private scroller: Scroller = new Scroller();
  private resourceConversion: ResourceConversion = new ResourceConversion();

  switchPlayMode() {
    if (this.playModeIndex === playModeSwitchList.length - 1) {
      this.playModeIndex = 0;
    } else {
      this.playModeIndex++;
    }
    this.playMode = playModeSwitchList[this.playModeIndex];
    Logger.info(TAG, 'playModeIndex is' + this.playModeIndex);
    Prompt.showToast({
      message: `${this.playMode === MusicPlayMode.ORDER ?
        this.resourceConversion.getStringValueFromResource($r('app.string.sequential_playback')) :
        this.playMode === MusicPlayMode.RANDOM ?
          this.resourceConversion.getStringValueFromResource($r('app.string.random_playback')) :
          this.resourceConversion.getStringValueFromResource($r('app.string.single_playback'))}`
    });
    AudioRendererController.getInstance().setPlayModel(this.playMode);
  }

  build() {
    Column() {
      Row() {
        Image(this.playMode === MusicPlayMode.ORDER ? $r('app.media.order_play') :
          this.playMode === MusicPlayMode.RANDOM ? $r('app.media.shuffle') : $r('app.media.repeat_1'))
          .fillColor(Color.White)
          .controlImageBuilder()
          .width(new BreakpointType({
            sm: $r('app.float.twenty_four'),
            md: $r('app.float.twenty_four'),
            lg: $r('app.float.control_image_lg')
          }).getValue(this.currentBreakpoint))
          .onClick(() => {
            this.switchPlayMode()
          })
        Image($r('app.media.ic_music_list'))
          .fillColor(Color.White)
          .controlImageBuilder()
          .width(new BreakpointType({
            sm: $r('app.float.twenty_four'),
            md: $r('app.float.twenty_four'),
            lg: $r('app.float.control_image_lg')
          }).getValue(this.currentBreakpoint))
          .onClick(() => {
            this.isShowPlayList = true;
          })
          .bindSheet($$this.isShowPlayList, this.musicListBuilder(), {
            backgroundColor: $r('sys.color.background_tertiary'),
            detents: [SheetSize.MEDIUM],
            dragBar: false,
            showClose: false,
            preferType: SheetType.CENTER,
            onWillAppear: () => {
              Logger.info(TAG, 'musicListBuilder');
              this.scroller.scrollToIndex(this.selectIndex, false, ScrollAlign.CENTER);
            }
          })
        Image(this.isSilentMode ? $r('app.media.silence') : $r('app.media.ic_ring'))
          .controlImageBuilder()
          .width(new BreakpointType({
            sm: $r('app.float.twenty_four'),
            md: $r('app.float.twenty_four'),
            lg: $r('app.float.control_image_lg')
          }).getValue(this.currentBreakpoint))
          .onClick(() => {
            this.isSilentMode = !this.isSilentMode;
            AudioRendererController.getInstance().setSilentModeAndMixWithOthers(this.isSilentMode)
          })
        Image(this.isFavorite ? $r('app.media.heart_fill') : $r('app.media.heart'))
          .fillColor(this.isFavorite ? Color.Red : Color.White)
          .controlImageBuilder()
          .animation({
            duration: 500
          })
          .width(new BreakpointType({
            sm: $r('app.float.twenty_four'),
            md: $r('app.float.twenty_four'),
            lg: $r('app.float.control_image_lg')
          }).getValue(this.currentBreakpoint))
          .onClick(() => {
            AVSessionController.getInstance().updateFavoriteState(this.selectIndex.toString(), this.isFavorite)
          })
      }
      .width(StyleConstants.FULL_WIDTH)
      .justifyContent(FlexAlign.SpaceBetween)

      Column() {
        Slider({
          min: 0,
          max: this.max,
          step: 1,
          style: SliderStyle.OutSet,
          value: this.value
        })
          .selectedColor($r('app.color.slider_select'))
          .trackColor($r('app.color.slider_track'))
          .onChange((value: number, mode: SliderChangeMode) => {
            if (mode === SliderChangeMode.End || mode === SliderChangeMode.Begin) {
              AudioRendererController.getInstance().seek(value);
            }
            this.pageShowTime = 0;
          })
          .height($r('app.float.slider_height'))
          .margin({
            left: new BreakpointType({
              sm: $r('app.float.slider_margin_sm'),
              md: $r('app.float.slider_margin_md'),
              lg: $r('app.float.slider_margin_lg')
            }).getValue(this.currentBreakpoint),
            right: new BreakpointType({
              sm: $r('app.float.slider_margin_sm'),
              md: $r('app.float.slider_margin_md'),
              lg: $r('app.float.slider_margin_lg')
            }).getValue(this.currentBreakpoint)
          })
          .hitTestBehavior(HitTestMode.Block)
        Row() {
          Text(this.currentTime)
            .fontColor($r('app.color.play_text_color'))
            .fontSize($r('app.float.singer_title_sm'))
            .fontFamily(PlayerConstants.FONT_FAMILY_BLACK)
            .lineHeight('14vp')
          Text(this.totalTime)
            .fontColor($r('app.color.play_text_color'))
            .fontSize($r('app.float.singer_title_sm'))
            .fontFamily(PlayerConstants.FONT_FAMILY_BLACK)
            .lineHeight('14vp')
        }
        .width(StyleConstants.FULL_WIDTH)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .margin({
        top: $r('app.float.slider_margin_top'),
        bottom: this.currentBreakpoint === BreakpointTypeEnum.LG || this.currentBreakpoint === BreakpointTypeEnum.XL ?
          $r('app.float.slider_margin_bottom_lg') : $r('app.float.slider_margin_bottom')
      })

      Row() {
        Image($r('app.media.ic_public_forward'))
          .controlImageBuilder()
          .width(this.currentBreakpoint === BreakpointTypeEnum.LG || this.currentBreakpoint === BreakpointTypeEnum.XL ?
            $r('app.float.control_width_lg') : $r('app.float.control_width'))
          .onClick(() => {
            AudioRendererController.getInstance().playPrevious();
            this.pageShowTime = 0;
          })
        Image(this.isPlay ? $r('app.media.ic_public_play') : $r('app.media.ic_public_pause'))
          .controlImageBuilder()
          .width(new BreakpointType({
            sm: $r('app.float.image_play_width'),
            md: $r('app.float.image_play_width'),
            lg: $r('app.float.image_play_width_lg')
          }).getValue(this.currentBreakpoint))
          .onClick(() => {
            if (this.isPlay) {
              AudioRendererController.getInstance().pause();
            } else {
              if (AudioRendererController.getInstance().getFirst()) {
                AudioRendererController.getInstance().play(0);
              } else {
                AudioRendererController.getInstance().start();
              }
            }
            this.pageShowTime = 0;
          })
        Image($r('app.media.ic_public_next'))
          .controlImageBuilder()
          .width(this.currentBreakpoint === BreakpointTypeEnum.LG || this.currentBreakpoint === BreakpointTypeEnum.XL ?
            $r('app.float.control_width_lg') : $r('app.float.control_width'))
          .onClick(() => {
            AudioRendererController.getInstance().playNext();
            this.pageShowTime = 0;
          })
      }
      .width(StyleConstants.FULL_WIDTH)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: $r('app.float.control_padding'),
        right: $r('app.float.control_padding')
      })
    }
  }

  @Builder
  musicListBuilder() {
    Column() {
      this.playListTitle();
      List({ scroller: this.scroller }) {
        LazyForEach(new SongDataSource(this.songList), (item: SongItem, index: number) => {
          ListItem() {
            MusicListContainer({ item: item, index: index }).reuseId(item.title);
          }
        }, (item: SongItem, index: number) => item.toString() + index.toString())
      }
      .height(StyleConstants.FULL_HEIGHT)
      .width(StyleConstants.FULL_WIDTH)
      .margin({ top: $r('app.float.list_area_margin_top') })
      .lanes(new BreakpointType({
        sm: ContentConstants.COL_ONE,
        md: ContentConstants.COL_TWO,
        lg: ContentConstants.COL_TWO
      }).getValue(this.currentBreakpoint))
      .layoutWeight(1)
      .divider({
        color: $r('sys.color.comp_divider'),
        strokeWidth: $r('app.float.stroke_width'),
        startMargin: $r('app.float.list_item_padding'),
        endMargin: $r('app.float.list_item_padding')
      })
    }
    .backgroundColor($r('sys.color.background_tertiary'))
  }

  @Builder
  playListTitle() {
    Row() {
      SymbolGlyph($r('sys.symbol.list_bullet'))
        .fontSize($r('app.float.play_all_icon_size'))
        .fontColor([$r('sys.color.font_primary')])
      Text($r('app.string.play_list', this.songList.length))
        .maxLines(ContentConstants.PLAY_ALL_MAX_LINES)
        .padding({ left: $r('app.float.play_all_text_padding') })
        .fontColor($r('sys.color.font_primary'))
        .fontSize(new BreakpointType({
          sm: $r('app.float.play_font_sm'),
          md: $r('app.float.play_font_md'),
          lg: $r('app.float.play_font_lg')
        }).getValue(this.currentBreakpoint))
    }
    .height($r('app.float.play_all_area_height'))
    .width(StyleConstants.FULL_WIDTH)
    .backgroundColor($r('sys.color.background_tertiary'))
    .padding({
      left: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.currentBreakpoint),
      right: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.currentBreakpoint)
    })
    .borderRadius({
      topRight: $r('app.float.play_all_border_radius'),
      topLeft: $r('app.float.play_all_border_radius')
    })
    .position({
      x: 0,
      y: 0
    })
  }
}

@Extend(Image)
function controlImageBuilder() {
  .aspectRatio(1)
  .opacity(0.86)
  .objectFit(ImageFit.Contain)
}

@Reusable
@Component
struct MusicListContainer {
  @StorageLink(KeyConstants.KEY_IS_PLAY) isPlay: boolean = false;
  @StorageProp(KeyConstants.KEY_BREAKPOINT) currentBreakpoint: string = BreakpointTypeEnum.SM;
  @StorageLink(KeyConstants.KEY_SELECT_INDEX) selectIndex: number = 0;
  item: SongItem | undefined = undefined;
  index: number | undefined = undefined;

  build() {
    Column() {
      Row() {
        Column() {
          Text(this.item ? this.item!.title : '')
            .fontColor(this.selectIndex === this.index && this.isPlay ? Color.Red : $r('sys.color.font_primary'))
            .fontSize(new BreakpointType({
              sm: $r('app.float.item_font_sm'),
              md: $r('app.float.item_font_md'),
              lg: $r('app.float.item_font_lg')
            }).getValue(this.currentBreakpoint))
            .margin({ bottom: $r('app.float.list_item_title_margin') })
          Row() {
            Image(this.item ? this.item!.mark : '')
              .width($r('app.float.list_item_image_size'))
              .height($r('app.float.list_item_image_size'))
              .margin({ right: $r('app.float.list_item_image_margin') })
            Text(this.item ? this.item!.singer : '')
              .fontColor(this.selectIndex === this.index && this.isPlay ? Color.Red : $r('sys.color.font_primary'))
              .fontSize(new BreakpointType({
                sm: $r('app.float.singer_title_sm'),
                md: $r('app.float.singer_title_md'),
                lg: $r('app.float.singer_title_lg')
              }).getValue(this.currentBreakpoint))
          }
        }
        .backgroundColor($r('sys.color.background_tertiary'))
        .alignItems(HorizontalAlign.Start)
      }
      .onClick(() => {
        if (this.selectIndex === this.index) {
          if (!this.isPlay) {
            AudioRendererController.getInstance().play(this.index)
          }
        } else {
          AudioRendererController.getInstance().play(this.index)
        }
      })
      .height($r('app.float.list_item_height'))
      .width(StyleConstants.FULL_WIDTH)
    }
    .backgroundColor($r('sys.color.background_tertiary'))
    .padding({
      left: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.currentBreakpoint),
      right: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.currentBreakpoint)
    })
  }
}