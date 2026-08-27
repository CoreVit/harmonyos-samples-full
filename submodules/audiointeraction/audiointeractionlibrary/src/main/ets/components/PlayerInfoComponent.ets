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

import { effectKit } from '@kit.ArkGraphics2D';
import { display } from '@kit.ArkUI';
import { BusinessError, deviceInfo } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import { BreakpointConstants } from '../common/constants/BreakpointConstants';
import { KeyConstants } from '../common/constants/KeyConstants';
import { PlayerConstants } from '../common/constants/PlayerConstants';
import { StyleConstants } from '../common/constants/StyleConstants';
import { BreakpointTypeEnum } from '../common/utils/BreakpointSystem';
import { ColorConversion } from '../common/utils/ColorConversion';
import Logger from '../common/utils/Logger';
import { SongItem } from '../songdatacontroller/SongData';
import { ControlAreaComponent } from './ControlAreaComponent';
import { LyricsComponent } from './LyricsComponent';
import { MusicInfoComponent } from './MusicInfoComponent';
import { TopAreaComponent } from './TopAreaComponent';

const TAG: string = '[PlayerInfoComponent]';

@Component
export struct PlayerInfoComponent {
  @StorageProp(KeyConstants.KEY_BREAKPOINT) currentBreakpoint: string = BreakpointTypeEnum.SM;
  @StorageProp(KeyConstants.KEY_SELECT_INDEX) @Watch('getImageColor') selectIndex: number = 0;
  @StorageLink(KeyConstants.KEY_SONG_LIST) songList: SongItem[] = [];
  @StorageLink(KeyConstants.KEY_IMAGE_COLOR) imageColor: string = 'rgba(0, 0, 2, 1.00)';
  @StorageLink(KeyConstants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(KeyConstants.KEY_NAV_INDICATOR_HEIGHT) navIndicatorHeight: number = 0;
  @StorageLink(KeyConstants.KEY_PAGE_SHOW_TIME) pageShowTime: number = 0;
  @StorageLink(KeyConstants.KEY_IS_FOLD_FULL) isFoldFull: boolean = false;
  @State imageLabel: PixelMap | Resource = this.songList?.[this.selectIndex]?.label;
  @State isShowControl: boolean = true;
  @State isShowControlLg: boolean = false;
  @State isTablet: boolean = true;
  @State isTabletFalse: boolean = false;
  @State intervalID: number = 0;
  @Link isShowPlay: boolean;
  private callback: Callback<display.FoldDisplayMode> = (data: display.FoldDisplayMode) => {
    if (canIUse('SystemCapability.Window.SessionManager')) {
      if (data === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL) {
        this.isFoldFull = true;
      } else {
        this.isFoldFull = false;
      }
    }
  };

  aboutToAppear(): void {
    this.getImageColor();
    try {
      if (canIUse('SystemCapability.Window.SessionManager')) {
        const mode = display.getFoldDisplayMode();
        if (mode === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL) {
          this.isFoldFull = true;
        }
        display.on('foldDisplayModeChange', this.callback);
      }
    } catch (err) {
      Logger.error(TAG,
        `Failed to register callback. Code:${(err as BusinessError).code}, message:${(err as BusinessError).message}`);
    }
  }

  aboutToDisappear(): void {
    try {
      if (canIUse('SystemCapability.Window.SessionManager')) {
        display.off('foldDisplayModeChange', this.callback);
      }
    } catch (err) {
      Logger.error(TAG,
        `FoldDisplayModeChange catch err. Code:${(err as BusinessError).code}, message:${(err as BusinessError).message}`);
    }
  }

  build() {
    Stack() {
      Image(this.imageLabel)
        .size(this.currentBreakpoint === BreakpointTypeEnum.LG || this.currentBreakpoint === BreakpointTypeEnum.XL ?
          { width: PlayerConstants.BACK_IMAGE } : { height: PlayerConstants.BACK_IMAGE })
        .aspectRatio(1)
        .objectFit(ImageFit.Cover)
        .opacity(0.5)
      Row() {
        if (this.currentBreakpoint === BreakpointTypeEnum.MD) {
          Column() {
            TopAreaComponent()
              .margin({
                bottom: $r('app.float.music_info_margin_top'),
                left: $r('app.float.top_margin_left')
              })
            GridRow({
              columns: { md: BreakpointConstants.COLUMN_MD },
              gutter: BreakpointConstants.GUTTER_MUSIC_X
            }) {
              GridCol({
                span: { md: BreakpointConstants.SPAN_SM }
              }) {
                MusicInfoComponent()
              }
              .margin({
                left: $r('app.float.margin_small'),
                right: $r('app.float.margin_small')
              })

              GridCol({
                span: { md: BreakpointConstants.SPAN_SM }
              }) {
                LyricsComponent({ isShowControl: this.isShowControlLg, isTablet: this.isTabletFalse })
              }
              .padding({
                left: $r('app.float.twenty_four')
              })
            }
            .layoutWeight(1)
            .margin({
              bottom: $r('app.float.fold_margin_bottom')
            })
          }
          .layoutWeight(1)
          .padding({
            left: $r('app.float.common_padding'),
            right: $r('app.float.common_padding')
          })
        } else if (this.currentBreakpoint === BreakpointTypeEnum.LG ||
          this.currentBreakpoint === BreakpointTypeEnum.XL) {
          Column() {
            TopAreaComponent()
              .padding({
                left: $r('app.float.common_padding'),
                right: $r('app.float.common_padding')
              })
            GridRow({
              columns: { md: BreakpointConstants.COLUMN_MD, lg: BreakpointConstants.COLUMN_LG },
              gutter: BreakpointConstants.GUTTER_MUSIC_X
            }) {
              GridCol({
                span: { md: BreakpointConstants.SPAN_SM, lg: BreakpointConstants.SPAN_SM },
                offset: { lg: BreakpointConstants.OFFSET_MD }
              }) {
                Column() {
                  Image(this.songList[this.selectIndex].label)
                    .width(StyleConstants.FULL_WIDTH)
                    .aspectRatio(1)
                    .borderRadius($r('app.float.cover_radius'))
                  ControlAreaComponent()
                }
                .height(StyleConstants.FULL_HEIGHT)
                .justifyContent(FlexAlign.SpaceBetween)
                .margin({
                  bottom: $r('app.float.common_margin')
                })
              }

              GridCol({
                span: { md: BreakpointConstants.SPAN_SM, lg: BreakpointConstants.SPAN_MD },
                offset: { lg: BreakpointConstants.OFFSET_MD }
              }) {
                LyricsComponent({ isShowControl: this.isShowControlLg, isTablet: this.isTablet })
              }
            }
            .layoutWeight(1)
            .padding({
              left: $r('app.float.common_padding'),
              right: $r('app.float.common_padding'),
              top: $r('app.float.lg_music_top'),
              bottom: $r('app.float.lg_music_margin_bottom')
            })
          }
        } else if (this.currentBreakpoint === BreakpointTypeEnum.SM) {
          Stack({ alignContent: Alignment.TopStart }) {
            Swiper() {
              MusicInfoComponent()
                .margin({
                  top: (deviceInfo.productSeries === 'VDE' &&
                    this.getFoldStatus() === FoldStatus.FOLD_STATUS_EXPANDED) ?
                    $r('app.float.control_width') : $r('app.float.music_component_top'),
                  bottom: $r('app.float.music_component_bottom')
                })
                .padding({
                  left: $r('app.float.common_padding'),
                  right: $r('app.float.common_padding')
                })
              LyricsComponent({ isShowControl: this.isShowControl, isTablet: this.isTabletFalse })
                .margin({
                  top: $r('app.float.margin_lyric')
                })
                .padding({
                  left: $r('app.float.common_padding'),
                  right: $r('app.float.common_padding')
                })
            }
            .height(StyleConstants.FULL_HEIGHT)
            .indicator(
              new DotIndicator()
                .top($r('app.float.options_padding'))
                .selectedColor($r('app.color.select_swiper'))
                .color($r('app.color.slider_track'))
            )
            .clip(false)
            .loop(false)
            .onChange((index: number) => {
              if (index === 1) {
                this.isShowControl = true;
                this.intervalID = setInterval(() => {
                  this.pageShowTime += 1;
                  if (this.pageShowTime > 5) {
                    this.isShowControl = false;
                    clearInterval(this.intervalID);
                  }
                }, 1000);
              } else {
                this.pageShowTime = 0;
                clearInterval(this.intervalID);
              }
            })

            TopAreaComponent()
              .padding({
                left: $r('app.float.common_padding'),
                right: $r('app.float.common_padding')
              })
          }
          .height(StyleConstants.FULL_HEIGHT)
        }
      }
      .padding({
        bottom: this.navIndicatorHeight,
        top: this.statusBarHeight
      })
    }
    .height(StyleConstants.FULL_HEIGHT)
    .width(StyleConstants.FULL_WIDTH)
    .backgroundColor(this.imageColor)
  }

  /**
   * Get largest proportion color of an image.
   */
  getImageColor() {
    ColorConversion.setSysBarLightBackground(this.songList[this.selectIndex].isDarkBackground);
    this.getUIContext().getHostContext()!.resourceManager.getMediaContent(this.songList[this.selectIndex].label.id)
      .then(async (value: Uint8Array) => {
        const buffer = value.buffer as ArrayBuffer;
        const imageSource = image.createImageSource(buffer as ArrayBuffer);
        const createPixelMap: image.PixelMap = await imageSource.createPixelMap();
        effectKit.createColorPicker(createPixelMap, (error, colorPicker) => {
          if (error) {
            Logger.error(TAG, `Failed to create color picker. Code:${error.code}, message:${error.message}`);
          } else {
            const color = colorPicker.getLargestProportionColor();
            const colorArr = ColorConversion.dealColor(color.red, color.green, color.blue);
            this.imageColor = `rgba(${colorArr[0]}, ${colorArr[1]}, ${colorArr[2]}, 1)`;
          }
        })
        let headFilter = effectKit.createEffect(createPixelMap);
        if (headFilter !== null) {
          headFilter.blur(PlayerConstants.IMAGE_BLUR);
          headFilter.getEffectPixelMap().then((value) => {
            this.imageLabel = value;
          }).catch((error: BusinessError) => {
            Logger.error(TAG, `getEffectPixelMap failed. Code:${error.code}, message:${error.message}`);
          })
        }
        await imageSource.release();
        await createPixelMap.release();
      })
      .catch((error: BusinessError) => {
        Logger.error(TAG, `getImageColor failed. Code:${error.code}, message:${error.message}`);
      })
  }

  private getFoldStatus(): number {
    if (canIUse('SystemCapability.Window.SessionManager')) {
      try {
        return display.getFoldStatus();
      } catch (err) {
        Logger.error(TAG, `getFoldStatus failed. Code:${err.code}, message:${err.message}`);
      }
    }
    return FoldStatus.FOLD_STATUS_UNKNOWN;
  }
}