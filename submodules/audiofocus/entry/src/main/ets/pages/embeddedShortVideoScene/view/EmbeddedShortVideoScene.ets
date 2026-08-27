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

import { display, window } from '@kit.ArkUI';
import { avSession } from '@kit.AVSessionKit';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { ConfigurationConstant, common } from '@kit.AbilityKit';
import Logger from '../../../common/util/Logger';
import { AppRouter } from '../../../common/util/AppRouter';
import { AvPlayerController } from '../../../common/util/AVPlayerController';
import { VideoDataSource } from '../viewModel/VideoDataSource';
import { AVPlayerState, Constants, VideoDataType, CommonConstants } from '../../../common/constants/CommonConstants';
import { VideoParams } from '../model/VideoParams';
import { VideoInfo } from '../model/VideoInfo';
import { AVSessionController } from '../../../common/util/AVSessionController';

@Builder
export function EmbeddedShortVideoScenePageBuilder() {
  EmbeddedShortVideoScene()
}

const TAG = 'EmbeddedShortVideoScene';

@Component
struct EmbeddedShortVideoScene {
  @State @Watch('onPageShowChange') isShow: boolean = true;
  @State playIdx: number = 0;
  @State pullRadio: number = 1.0;
  @State isMuted: boolean = true;
  @State isWide: boolean = false;
  @StorageLink(CommonConstants.KEY_IS_CHANGE_HEIGHT) isChangeHeight: boolean = false;
  @StorageLink(CommonConstants.KEY_IS_CHANGE_PADDING) isChangePadding: boolean = false;
  @State isLoading: boolean = false;
  @State isRefreshing: boolean = false;
  @State xWidth: number | string = '100%';
  @State xHeight: number | string = '100%';
  @StorageLink(CommonConstants.KEY_CURRENT_TIME) currentTime: number = 0;
  @StorageLink(CommonConstants.KEY_DURATION_TIME) durationTime: number = 0;
  @StorageLink(CommonConstants.KEY_START_RENDER) startRender: boolean = false;
  @StorageLink(CommonConstants.KEY_CURRENT_BREAK_POINT) curBp: string = '';
  private unloadID?: string;
  private init: boolean = true;
  private curIndex: number = 0;
  private frameWidth: number = 0;
  private frameHeight: number = 0;
  private listItemHeight: number = 0;
  private offsetting: boolean = false;
  private dataSource: VideoDataSource = new VideoDataSource();
  private avSessionController: AVSessionController = new AVSessionController();
  private avPlayerController: AvPlayerController = new AvPlayerController();
  windowStage: window.WindowStage = AppStorage.get(CommonConstants.KEY_WINDOW_STAGE) as window.WindowStage;
  mainWin: window.Window = this.windowStage.getMainWindowSync();

  setXComponentWH(vWidth: number, vHeight: number) {
    let radio = vWidth / vHeight;
    if (radio > 1) {
      // Horizontal video
      this.xWidth = this.frameWidth;
      this.xHeight = Math.floor(this.xWidth / radio);
      if (this.xHeight > this.frameHeight) {
        this.xHeight = this.frameHeight;
        this.xWidth = Math.floor(this.xHeight * radio);
      }
    } else {
      // Vertical video
      this.xHeight = this.frameHeight;
      this.xWidth = Math.floor(this.xHeight * radio);
      if (this.xWidth > this.frameWidth) {
        this.xWidth = this.frameWidth;
        this.xHeight = Math.floor(this.xWidth / radio);
      }
    }
  }

  onPageShowChange() {
    if (this.avPlayerController && AppRouter.getPageIndex() === -1) {
      if (this.isShow) {
        if (this.avPlayerController.getVideoState() === AVPlayerState.PAUSED) {
          this.play(this.curIndex)
        }
      } else {
        if (this.avPlayerController.getVideoState() === AVPlayerState.PLAYING) {
          this.avPlayerController.mediaStop();
        }
      }
    }
  }

  play(index: number) {
    Logger.info(TAG, 'start playing')
    this.startRender = false;
    // Reset AVPlayer
    this.avPlayerController.videoReset().then(() => {
      // [StartExclude play]
      if (index !== this.playIdx) {
        this.dataSource.getData(this.playIdx).stopTime = this.currentTime;
        this.playIdx = index;
      }
      if (this.dataSource.getData(index).surfaceID !== undefined) {
        this.unloadID = undefined;
        // Get video data params
        if (index === this.playIdx) {
          let stopTime: number = this.dataSource.getData(index).stopTime!;
          this.currentTime = stopTime;
          let surfaceID: string = this.dataSource.getData(index).xController!.getXComponentSurfaceId();
          // [EndExclude  play]
          this.isMuted = true;
          // Init AVPlayer
          this.avPlayerController.initAVPlayer({
            type: VideoDataType.RAW_FILE,
            videoSrc: this.dataSource.getData(index).src!,
            name: $r('app.string.audio_demo_title'),
            description: '',
            caption: '',
            index: 0,
            seekTime: stopTime,
            isMuted: this.isMuted,
            head: $r('app.media.preview1')
          }, surfaceID, this.avSessionController);
          // [StartExclude play]
        }
      } else {
        this.unloadID = this.dataSource.getData(index).id;
      }
      // [EndExclude  play]
    });
  }

  @Builder
  loadingBuilder() {
    Row() {
      LoadingProgress()
        .width(48)
        .height(32)
    }
    .height(Constants.FOOTER_HEIGHT)
    .justifyContent(FlexAlign.Center)
    .visibility(this.isLoading ? Visibility.Visible : Visibility.Hidden)
    .onVisibleAreaChange([0.0, 1.0], (isExpanding: boolean, currentRatio: number) => {
      if (!isExpanding && currentRatio <= 0.0 && this.init) {
        this.init = false;
        Logger.info(TAG, 'into play init')
        this.play(0);
      }
      if (!isExpanding && currentRatio <= 0.0 && this.offsetting) {
        this.offsetting = false;
        Logger.info(TAG, 'into play offsetting')
        this.play(0);
      }
    })
  }

  @Builder
  sliderBuilder() {
    // [Start slider]
    Slider({
      min: 0,
      max: this.durationTime,
      value: this.currentTime,
      style: SliderStyle.NONE,
      direction: Axis.Horizontal
    })
    // [End slider]
      .height(2)
      .width('100%')
      .trackThickness(2)
      .align(Alignment.End)
      .blockColor(Color.Transparent)
      .trackColor(Color.Transparent)
      .padding({ left: Constants.SLIDER_PADDING, right: Constants.SLIDER_PADDING })
      .alignRules({
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      })
      .visibility(this.avPlayerController.getVideoState() === AVPlayerState.PLAYING ? Visibility.Visible :
        Visibility.Hidden)
  }

  @Builder
  videoItemBuilder(info: VideoInfo, index: number) {
    Column() {
      Row() {
        Image($r('app.media.preview2'))
          .width(25)
          .height(25)
          .borderRadius(20)

        Text($r('app.string.user_name'))
          .fontSize(14)
          .fontWeight(500)
          .width('85%')
          .margin({ left: '15px' })
          .fontColor($r('sys.color.font_primary'))
      }
      .width('100%')
      .margin({ bottom: 10 })

      Stack({ alignContent: Alignment.Top }) {
        RelativeContainer() {
          // [Start x_component]
          XComponent({
            type: XComponentType.SURFACE,
            controller: info.xController
          })
          // [End x_component]
            .borderRadius(8)
            .width(this.xWidth)
            .height(this.xHeight)
            .backgroundColor($r('sys.color.background_secondary'))
            .alignRules({
              middle: { anchor: '__container__', align: HorizontalAlign.Center },
              center: { anchor: '__container__', align: VerticalAlign.Center }
            })
            // [Start x_component_onLoad]
            .onLoad(() => {
              let surfaceID = info.xController!.getXComponentSurfaceId();
              info.surfaceID = surfaceID;
              if (info.id === this.unloadID) {
                Logger.info(TAG, 'into play info.id')
                this.play(index);
              }
            })
            // [End x_component_onLoad]
            .onDestroy(() => {
              info.surfaceID = undefined;
            })
            // [Start x_component_onClick]
            .onClick(() => {
              // Save video data
              AppStorage.setOrCreate(Constants.SURFACE_ID_KEY, info.surfaceID);
              this.avPlayerController.mediaPause();

              info.stopTime = this.avPlayerController.currentTime;
              info.duration = this.avPlayerController.duration;
              // Jump video play detail
              AppRouter.pushByName(Constants.DETAIL_PAGE_NAME,
                new VideoParams(info, this.playIdx, index), () => {
                  let param: VideoParams = AppStorage.get(CommonConstants.KEY_BACK_PARAM) as VideoParams;
                  let _index = param.index;
                  this.dataSource.getData(_index).stopTime = param.videoInfo.stopTime;
                  this.play(param.playIdx);
                })
            })
          // [End x_component_onClick]
          this.sliderBuilder();

          Button({ type: ButtonType.Circle, stateEffect: false }) {
            Image(this.isMuted ? $r('app.media.speaker_close') : $r('app.media.speaker_open'))
              .padding(10)
              .fillColor(Color.White)
          }
          .width(40)
          .aspectRatio(1)
          .backgroundColor(Color.Transparent)
          .margin({ right: 8 })
          .onClick(async () => {
            // Set Muted
            await this.avPlayerController.videoMuted(!this.isMuted)
            this.isMuted = !this.isMuted;
            this.avPlayerController.activateAudioSession();

          })
          .alignRules({
            right: { anchor: '__container__', align: HorizontalAlign.End },
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          })
        }
        .width('100%')
        .height(this.frameHeight)
        .visibility((this.playIdx === index) ? Visibility.Visible : Visibility.Hidden)

        Column() {
          Image(info.pixelMap !== undefined ? info.pixelMap : info.preview)
            .borderRadius(8)
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .visibility((this.playIdx !== index) ? Visibility.Visible :
          Visibility.Hidden)
      }
      .width('100%')
      .height(this.listItemHeight - Constants.TITLE_HEIGHT - Constants.INFO_AREA_HEIGHT -
        Constants.LIST_ITEM_TOP_PADDING)

      RelativeContainer() {
        Column() {
          Row() {
            Text($r('app.string.title'))
              .fontSize(14)
              .lineHeight(22)
              .width('100%')
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
              .opacity(0.9)
          }

          Row() {
            Text(info.detail)
              .fontSize(14)
              .lineHeight(22)
              .fontWeight(FontWeight.Regular)
              .fontColor($r('sys.color.font_primary'))
              .opacity(0.6)
              .width('100%')
          }
        }
      }
      .width('100%')
      .height(Constants.INFO_AREA_HEIGHT)
      .padding({ top: 5, bottom: 13 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }

  onDidBuild(): void {
    this.dataSource.loadData();
    Logger.info(TAG, 'into play onDidBuild')
    this.play(this.playIdx);
  }

  onFoldStatusChange: (foldStatus: display.FoldStatus) => void = (foldStatus: display.FoldStatus) => {
    Logger.info(TAG, `[onFoldStatusChange] Succeeded: ${this.curBp}`);
    if (foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED) {
      this.isWide = false;
    } else if (foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED) {
      this.isWide = true;
    }
    if (this.curBp === 'lg' || this.curBp === 'xl') {
      this.isChangePadding = true;
    } else {
      this.isChangePadding = false
    }
  }

  async aboutToAppear() {
    try {
      // Calculated based on screen width RelativeContainer width
      let winWidth = this.getUIContext().px2vp(display.getDefaultDisplaySync().width);
      if (this.curBp === 'md' || this.curBp === 'lg' || this.curBp === 'xl') {
        if (winWidth > 1440) {
          winWidth = Math.floor(winWidth / 3);
        } else {
          winWidth = Math.floor(winWidth / 2);
        }
        this.isWide = true;
      }
      try {
        if (display.isFoldable()) {
          try {
            display.on('foldStatusChange', this.onFoldStatusChange);
          } catch (error) {
            let err = error as BusinessError;
            Logger.error('foldStatusChange Failed',
              `Code: ${err.code}, message: ${err.message}`);
          }
        }
      } catch (error) {
        let err = error as BusinessError;
        Logger.error('Failed',
          `Code: ${err.code}, message: ${err.message}`);
      }
      this.frameWidth = winWidth - Constants.LIST_ITEM_LEFT_PADDING - Constants.LIST_ITEM_RIGHT_PADDING;
      this.frameHeight = Math.floor(this.frameWidth / Constants.WH_RADIO);
      this.listItemHeight =
        this.frameHeight + Constants.TITLE_HEIGHT + Constants.LIST_ITEM_TOP_PADDING + Constants.INFO_AREA_HEIGHT;
      emitter.on('prepared', (eventData: emitter.EventData) => {
        let vWidth: number = eventData.data!.width;
        let vHeight: number = eventData.data!.height;
        let surfaceID: string = eventData.data!.surfaceID;
        if (this.playIdx < this.dataSource.totalCount()) {
          let playSurfaceID = this.dataSource.getData(this.playIdx).surfaceID;
          if (playSurfaceID === surfaceID) {
            this.setXComponentWH(vWidth, vHeight);
          }
        }
      });
      await this.avSessionController.registerSessionListener(this.avPlayerController);

    } catch (error) {
      if (error.code !== null && error.message !== null) {
        Logger.error(TAG, `aboutToAppear failed, code is ${error.code}, message is ${error.message}`);
      }
    }
  }

  build() {
    NavDestination() {
      Scroll() {
        GridRow({
          gutter: 12,
          columns: {
            xs: 1,
            sm: 1,
            md: 1,
            lg: 2,
            xl: 2
          },
          breakpoints: {
            value: ['320vp', '600vp', '840vp', '1440vp', '1600vp'],
            reference: BreakpointsReference.WindowSize
          }
        }) {
          LazyForEach(this.dataSource, (info: VideoInfo, index: number) => {
            GridCol({ span: 1 }) {
              this.videoItemBuilder(info, index)
            }
            // [StartExclude list]
            .width('100%')
            .height(this.curBp === 'lg' ? this.listItemHeight - 32 :
              this.isChangeHeight ? this.listItemHeight - 56 : this.listItemHeight - 28)
            .backgroundColor($r('sys.color.background_secondary'))
            .padding({
              top: Constants.LIST_ITEM_TOP_PADDING,
            })
            .onClick(() => {
              // Save video data
              if (index !== this.playIdx) {
                this.avPlayerController.mediaPause();
                // Jump video play detail
                AppRouter.pushByName(Constants.DETAIL_PAGE_NAME,
                  new VideoParams(info, this.playIdx, index), () => {
                    let param: VideoParams = AppStorage.get(CommonConstants.KEY_BACK_PARAM) as VideoParams;
                    let _index = param.index;
                    this.dataSource.getData(_index).stopTime = param.videoInfo.stopTime;
                    this.play(param.playIdx);
                  });
              }
            })

            // [EndExclude list]
          }, (info: VideoInfo) => info.id)
        }
      }
      .padding({
        left: this.isChangePadding ? 24 : 16,
        right: this.isChangePadding ? 24 : 16
      })
      .scrollBar(BarState.Off)
    }
    .onShown(() => {
      this.isShow = true;
    })
    .onHidden(() => {
      this.isShow = false;
    })
    .onWillHide(() => {
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      let colorMode: ConfigurationConstant.ColorMode | undefined = context.config.colorMode;
      if(colorMode){
        let sysBarProps: window.SystemBarProperties = {
          statusBarColor: '#F1F3F5',
          statusBarContentColor: '#000000'
        };
        this.mainWin?.setWindowSystemBarProperties(sysBarProps).then(() => {
          Logger.info(TAG, '[StaticUtils] Succeeded in setting the system bar properties.');
        }).catch((err: BusinessError) => {
          Logger.error(TAG, `setting system bar properties failed, code is ${err.code}, message is ${err.message}`);
        });
      }
      emitter.off('prepared');
      this.avPlayerController.videoRelease()
      this.avSessionController.avSessionRelease()
      this.avPlayerController.deactivateAudioSession();
    })
    .title($r('app.string.embedded_short_video_scene'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundColor($r('sys.color.background_secondary'))
  }
}