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

import { emitter } from '@kit.BasicServicesKit';
import { display } from '@kit.ArkUI';
import VideoToolBar from './VideoToolBar';
import { CommonConstants } from '../../../common/constants/CommonConstants';
import { VideoData } from '../model/VideoData';
import { AvPlayerController } from '../../../common/util/AVPlayerController';
import { WindowUtil } from '../../../common/util/WindowUtil';
import { TimeUtil } from '../../../common/util/TimeUtils';
import Logger from '../../../common/util/Logger';
import { AVSessionController } from '../../../common/util/AVSessionController';

const PROPORTION = 0.99; // Screen Percentage
const SURFACE_W = 0.9; // Surface width ratio
const SURFACE_H = 1.78; // Surface height ratio

const TAG = '[VideoPlayer]';


@Component
export struct VideoPlayer {
  @State private surfaceW: number = 0;
  @State private surfaceH: number = 0;
  @State private percent: number = 1;
  @State toolBarBottomMargin: number = 20;
  private surfaceId: string = '';
  private componentWidth: number = 300;
  private componentHeight: number = 300;
  @State showPopup: boolean = false; // Control pop-up display
  private windowUtil: WindowUtil = WindowUtil.getInstance();
  //whether the video is played in full screen
  @StorageLink(CommonConstants.KEY_IS_FULL_LAND_SCAPE_SCREEN) isFullLandscapeScreen: boolean =
    AppStorage.get(CommonConstants.KEY_IS_FULL_LAND_SCAPE_SCREEN) as boolean;
  @State screenBrightness: number = 0; //screen luminance
  @State isSliding: boolean = false;
  curSource?: VideoData;
  @BuilderParam
  toolBarBuilder: () => void = this.defaultToolBarBuilder;
  @Prop @Watch('onIndexChange') curIndex: number = -1;
  index: number = 0;
  private xComponentController: XComponentController = new XComponentController();
  @Link avPlayerController: AvPlayerController;
  @Link avSessionController: AVSessionController;
  @StorageLink(CommonConstants.KEY_IS_W) isW: boolean = false;
  @State isHalfFolded: boolean = false;
  @StorageLink(CommonConstants.KEY_CURRENT_BREAK_POINT) curBp: string = '';
  onFoldStatusChange: (foldStatus: display.FoldStatus) => void = (foldStatus: display.FoldStatus) => {
    if (foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED && this.curBp === 'sm') {
      this.isHalfFolded = true;
    } else if (foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED) {
      this.isHalfFolded = false;
    }
  }

  async onIndexChange() {
    Logger.info(TAG, `curIndex:${this.curIndex},index:${this.index}`);
    this.avPlayerController.languageChange(AppStorage.get(CommonConstants.KEY_CURRENT_LANGUAGE_TYPE));
    this.play()
  }

  async play() {
    Logger.info(TAG,
      `onLoad curindex is ${this.curIndex},,index is ${this.index}, cur source is ${JSON.stringify(this.curSource)}`)
    if (this.curIndex === this.index) {
      this.initAVResource();
    } else {
      this.avPlayerController.mediaPause();
    }
  }

  @Builder
  defaultToolBarBuilder() {
    VideoToolBar({ avPlayerController: this.avPlayerController, isSliding: this.isSliding });
  }

  sizeChange() {
    this.setVideoWH();
  }

  async aboutToAppear() {
    this.surfaceW = this.componentWidth * SURFACE_W;
    this.surfaceH = this.surfaceW / SURFACE_H;
    emitter.on(CommonConstants.AVPLAYER_PREPARED, (res) => {
      if (res.data) {
        this.percent = res.data.percent;
        this.setVideoWH();
      }
    });
    try {
      if (display.isFoldable()) {
        try {
          display.on('foldStatusChange', this.onFoldStatusChange);
          let foldStatus = display.getFoldStatus();
          if (foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED && this.curBp === 'sm') {
            this.isHalfFolded = true;
          }
        } catch (error) {
          let err = error as BusinessError;
          Logger.error('foldStatusChange',
            `Failed to obtain fold status. Code: ${err.code}, message: ${err.message}`);
        }
      }
    } catch (error) {
      let err = error as BusinessError;
      Logger.error('Get isFoldable Failed',
        `Code: ${err.code}, message: ${err.message}`);
    }
  }

  setVideoWH(): void {
    if(this.componentHeight === 0) {
      return;
    }
    let componentPercent = this.componentWidth / this.componentHeight;

    if (componentPercent <= this.percent) {
      this.surfaceW = Math.round(this.componentWidth * PROPORTION);
      this.surfaceH = Math.round(this.surfaceW / this.percent);
    } else {
      this.surfaceH = Math.round(this.componentHeight * PROPORTION);
      this.surfaceW = Math.round(this.surfaceH * this.percent);
    }
  }

  async initAVResource() {
    Logger.info(TAG, `initAVResource cur index is ${this.curIndex}, cur source is ${JSON.stringify(this.curSource)}`)
    this.surfaceId = this.xComponentController.getXComponentSurfaceId();
    // Creates the avPlayer instance object.
    try {
      await this.avPlayerController.initAVPlayer(this.curSource!, this.surfaceId,
        this.avSessionController);
    } catch (error) {
      Logger.error(TAG, `createAVPlayer err: ${error.message}`);
    }
  }

  async releaseAVResource() {
    if (this.avPlayerController) {
      await this.avPlayerController.videoRelease();
    }
  }

  @Builder
  showFeatureIcon(src: ResourceStr, content?: ResourceStr) {
    Column() {
      Image(src)
        .width(30)
      if (content) {
        Text(content)
          .fontSize(14)
          .lineHeight(19)
          .fontColor(Color.White)
          .margin({ top: 5 })
      }
    }
  }

  @Builder
  CoverXComponent() {
    XComponent({
      // Loading the video container
      id: 'xComponent',
      type: XComponentType.SURFACE,
      controller: this.xComponentController
    })
      .onLoad(async () => {
        this.play();
      })
      .width('100%')
      .height(this.surfaceH)
  }

  build() {
    Stack() {
      Column() {
        Stack() {
          Column() {
            this.CoverXComponent()
          }
          .height('100%')
          .justifyContent(FlexAlign.Center)

          if (!this.avPlayerController.isPlaying) {
            Image($r('app.media.icon_pause'))
              .size({ width: 50, height: 50 })
          }

          Text()
            .height(this.surfaceH)
            .width(this.surfaceW)
            .backgroundColor('#EFEFEF')
            .opacity(0.5)
            .visibility(this.isSliding ? Visibility.Visible : Visibility.Hidden)

          Row() {
            Text(TimeUtil.millisecondsToTime(this.avPlayerController.currentTime))
              .id('currentTime')
              .fontSize(24)
              .opacity(1)
              .fontColor($r('app.color.default_select_color_show'))
            Text('/' + TimeUtil.millisecondsToTime(this.avPlayerController.durationTime))
              .id('durationTime')
              .fontSize(24)
              .opacity($r('app.float.size_1'))
              .fontColor(Color.White)
          }
          .visibility(this.isSliding ? Visibility.Visible : Visibility.Hidden)

          RelativeContainer() {
            Column({ space: 20 }) {
              Image($r('app.media.menu_icon_user_avatar')).width(44)
              this.showFeatureIcon($r('app.media.menu_icon_like'), '1557')
              this.showFeatureIcon($r('app.media.menu_icon_comment'), '566')
              this.showFeatureIcon($r('app.media.menu_icon_share'), '147')
              Image($r('app.media.menu_icon_music_cover')).width(32)
                .visibility(this.isHalfFolded ? Visibility.Hidden : Visibility.Visible)
            }
            .alignRules({
              right: { anchor: '__container__', align: HorizontalAlign.End },
              bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
            })
            .margin({ right: 8, bottom: 90, top: this.isHalfFolded ? 12 : 0 })
            .visibility(this.isFullLandscapeScreen ? Visibility.None : Visibility.Visible)
          }

          Column() {
            Blank()
            Column() {
              Stack({ alignContent: Alignment.Center }) {
                Text(this.avPlayerController.currentCaption || '')
                  .fontColor(Color.White)
                  .fontSize($r('app.float.size_20'))
                  .fontFamily('Sans')
              }
              .margin({ left: -20 })
              .zIndex(1)
              .width('80%')

              // Progress bar
              this.toolBarBuilder();
            }.margin({ bottom: this.toolBarBottomMargin })
          }.height('100%')
          .justifyContent(FlexAlign.End)

          Button({ type: ButtonType.Circle }) {
            Image($r('sys.media.ohos_ic_public_arrow_left'))
              .fillColor(Color.White)
              .width($r('app.float.size_25'))
              .height($r('app.float.size_25'))
          }
          .width($r('app.float.size_40'))
          .height($r('app.float.size_40'))
          .backgroundColor($r('app.color.white_opacity_1_color'))
          .position({
            x: $r('app.float.size_25'),
            y: $r('app.float.size_25')
          })
          .onClick(() => {
            this.windowUtil.handleFullScreenExit(false);
          })
          .visibility(this.isFullLandscapeScreen ? Visibility.Visible : Visibility.Hidden)
        }
        .onClick(() => {
          this.avPlayerController.isPlaying === true ? this.avPlayerController.mediaPause() :
            this.avPlayerController.mediaPlay()
        })
      }
      .backgroundColor(Color.Black)
      .height('auto')
      .width('auto')
      .position({ x: 0, y: 0 })
      .onSizeChange((_oldValue: SizeOptions, newValue: SizeOptions) => {
        this.componentWidth = newValue.width as number;
        this.componentHeight = newValue.height as number;
        this.setVideoWH();
      })
    }
    .height('100%')
    .width('100%')

  }
}
