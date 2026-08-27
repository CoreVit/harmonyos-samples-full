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

import { ConfigurationConstant, common } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import { media } from '@kit.MediaKit';
import { display } from '@kit.ArkUI';
import {
  AVPlayerState,
  CommonConstants,
  Constants,
  VideoDataType
} from '../../../common/constants/CommonConstants';
import { TimeUtil } from '../../../common/util/TimeUtils';
import { VideoInfo } from '../model/VideoInfo';
import { VideoParams } from '../model/VideoParams';
import { AppRouter } from '../../../common/util/AppRouter';
import { CaptionFontView } from './CaptionFontView';
import { captionFont, CaptionFont } from '../model/CaptionFont';
import { BulletComment } from '../model/BulletComment';
import { BulletCommentView } from './BulletCommentView';
import { SpeedDialog } from './SpeedDialog';
import { ScaleDialog } from './ScaleDialog';
import { GlobalContext } from '../../../common/util/GlobalContext';
import { PiPWindowController } from '../../../common/util/PiPWindowController';
import { LanguageDialog } from './LanguageDialog';
import { AVVolumePanelView } from './AVVolumePanelView';
import { ScreenBrightnessView } from './ScreenBrightnessView';
import { AvPlayerController } from '../../../common/util/AVPlayerController';
import { AVSessionController } from '../../../common/util/AVSessionController';
import Logger from '../../../common/util/Logger';

const TAG = 'VideoDetail';
const PROPORTION = 0.99; // Screen Percentage
const SURFACE_WIDTH = 0.9; // Surface width ratio
const SURFACE_HEIGHT = 1.78; // Surface height ratio

@Builder
export function detailPageBuilder() {
  DetailPage()
}

@Component
export struct DetailPage {
  @State playIdx: number = 0;
  @State index: number = 0;
  @State src: string = '';
  @State surfaceId: string = '';
  @State isMuted: boolean = false;
  @State speedSelect: number = 0;
  @State iconShown: boolean = false;
  @State currentTime: number = 0;
  @State duration: number = 0;
  @State windowScaleSelect: number = 0;
  @State surfaceW: number = 0;
  @State surfaceH: number = 0;
  @State windowWidth: number = 300;
  @State windowHeight: number = 300;
  @State percent: number = 0;
  @State isCalcWHFinished: boolean = false;
  @State volume: number = 0;
  @State orientation: Orientation = window.Orientation.AUTO_ROTATION_UNSPECIFIED;
  @StorageLink(CommonConstants.KEY_CURRENT_LANGUAGE_TYPE) currentLanguageType: number = 0;
  @State showPopup: boolean = false; // Control pop-up display
  @State currentCaption: ResourceStr = $r('app.string.currentCaption');
  @State showBulletComment: boolean = true; //whether to show bullet comments
  @State bulletComments: BulletComment[] = []; //bullet comments storage array
  @State screenshotTime: number = 0; //video snapshot time
  @State imgWidth: number = 0; //the width of video snapshot image
  @State imgHeight: number = 0; //the height of video snapshot image
  @State bulletCommentInput: string = ''; //user input bullet comment
  @State showImg: boolean = false; //whether to show video snapshot image
  @State pixmap: image.PixelMap | undefined = undefined; //video snapshot image
  @State info: VideoInfo | undefined = undefined;
  @State isShowCaptionConfig: boolean = false; //whether to show CaptionFontComponent
  @State visible: boolean = false; //whether to show slider/image
  @State screenBrightness: number = 0; //screen luminance
  // Default font style
  @State captionFont: CaptionFont = captionFont;
  @Prop @Watch('onLanguageChange') languageSelect: number = 0;
  @Prop @Watch('onFullScreenChange') isLayoutFullScreen: boolean = false;
  @StorageLink(CommonConstants.KEY_DURATION_TIME) durationTime: number = 0;
  @StorageLink(CommonConstants.KEY_SPEED_INDEX) speedIndex: number = 0; // Index of the playback rate list.
  @StorageLink(CommonConstants.KEY_SPEED_NAME) speedName: Resource = $r('app.string.video_speed_1_0X');
  @StorageLink(CommonConstants.KEY_VIDEO_SCALE_TYPE) videoScaleType: number = media.VideoScaleType.VIDEO_SCALE_TYPE_FIT;
  @StorageProp('isPlaying') isPlaying: boolean = true;
  @StorageLink(CommonConstants.KEY_IS_PIP_SHOW) @Watch('onPIPShowChange') isPIPShow: boolean = false;
  //whether to show picture in picture
  private presetBulletCommentsTimerId: number = -1; //the timer of preset bullet comments
  private screenHeight: number = 0; //screen height
  private presetBulletComments =
    [$r('app.string.comment1'), $r('app.string.comment2'), $r('app.string.comment3')]; //preset bullet comments
  //whether is inputting bullet comment
  private isInputtingBulletComment: boolean = false;
  private windowStage: window.WindowStage = AppStorage.get(CommonConstants.KEY_WINDOW_STAGE) as window.WindowStage;
  private mainWin: window.Window | undefined = undefined;
  // [Start init_player]
  private avPlayerController: AvPlayerController = new AvPlayerController();
  // [End init_player]
  private xComponentController: XComponentController = new XComponentController();
  private timer: number = 0;
  private textInputController: TextInputController = new TextInputController();
  private pipWindowController: PiPWindowController =
    new PiPWindowController(this.avPlayerController, this.xComponentController); //the instance of picture in picture
  // [Start set_window_direction]
  context = this.getUIContext()?.getHostContext() as common.UIAbilityContext;
  private windowClass: window.Window | undefined = undefined;
  private avSessionController: AVSessionController = new AVSessionController();

  /*
   * Set window direction
   */
  setWindowDirection(orientation: number): void {
    // Set full screen
    if (orientation === window.Orientation.LANDSCAPE_INVERTED || orientation === window.Orientation.LANDSCAPE) {
      // [StartExclude set_window_direction]
      try {
        // [EndExclude set_window_direction]
        this.windowClass?.setWindowLayoutFullScreen(true).catch((error: BusinessError) => {
          Logger.error(TAG,
            `setWindowLayoutFullScreen failed, code is ${error.code}, message is ${error.message}`);
        });
        this.windowClass?.setWindowSystemBarEnable([]).catch((error: BusinessError) => {
          Logger.error(TAG,
            `setWindowSystemBarEnable failed, code is ${error.code}, message is ${error.message}`);
        });
        // [StartExclude set_window_direction]
      } catch (error) {
        if (error.code !== null && error.message !== null) {
          Logger.error(TAG,
            `setWindowLayoutFullScreen failed, code is ${error.code}, message is ${error.message}`);
        }
      }
      // [EndExclude set_window_direction]
    } else {
      // [StartExclude set_window_direction]
      try {
        // [EndExclude set_window_direction]
        // Cancel full screen
        this.windowClass?.setWindowLayoutFullScreen(false).catch((error: BusinessError) => {
          Logger.error(TAG,
            `setWindowLayoutFullScreen: Failed. code: ${error.code} ;message: ${error.message}`);
        });
        this.windowClass?.setWindowSystemBarEnable(['status', 'navigation']).catch((error: BusinessError) => {
          Logger.error(TAG,
            `setWindowSystemBarEnable: Failed. code: ${error.code} ;message: ${error.message}`);
        });
        // [StartExclude set_window_direction]
      } catch (error) {
        if (error.code !== null && error.message !== null) {
          Logger.error(TAG,
            `setWindowLayoutFullScreen failed, code is ${error.code}, message is ${error.message}`);
        }
      }
      // [EndExclude set_window_direction]
    }
    // [StartExclude set_window_direction]
    window.getLastWindow(this.context).then((win) => {
      win.setPreferredOrientation(orientation).then(() => {
        if (this.isLayoutFullScreen) {
          this.windowScaleSelect = 1;
          this.videoScaleType = 1;
        } else {
          this.windowScaleSelect = 0;
          this.videoScaleType = 0;
        }
      }).catch((error: BusinessError) => {
        Logger.error(TAG,
          `setPreferredOrientation: Failed. code: ${error.code} ;message: ${error.message}`);
      });
    }).catch((error: BusinessError) => {
      Logger.error(TAG, `getLastWindow: Failed. code: ${error.code} ;message: ${error.message}`);
    });
    // [EndExclude set_window_direction]
  }

  // [End set_window_direction]

  /*
   * Customize the return logic to ensure seamless transitions between videos.
   */
  // [Start handle_back_action]
  handleBackAction(): void {
    if (this.isLayoutFullScreen) {
      // Cancel full screen
      this.isLayoutFullScreen = false;
      this.setWindowDirection(window.Orientation.PORTRAIT);
    }
    this.isPIPShow = false;

    this.avPlayerController.mediaPause();
    this.isPlaying = false;
    // Save params
    if (this.info !== undefined) {
      this.info.stopTime = this.avPlayerController.currentTime;
    }
    let param: VideoParams = new VideoParams(
      this.info as VideoInfo,
      this.playIdx,
      this.index
    )
    AppStorage.setOrCreate(CommonConstants.KEY_BACK_PARAM, param);
    AppRouter.popWithParam(Object({ result: true }));
  }

  // [End handle_back_action]

  private closeCaptionSetting(captionFont: CaptionFont | null): void {
    this.isShowCaptionConfig = false;
    if (captionFont) {
      this.captionFont = captionFont;
    }
    if (this.avPlayerController.getVideoState() === AVPlayerState.PAUSED) {
      this.avPlayerController.mediaPlay();
      this.isPlaying = true;
    }
  }

  // [Start VideoSnapshot]
  private async screenshot(): Promise<void> {
    try {
      this.pixmap = await this.getUIContext().getComponentSnapshot().get(`videoXComponent_${this.info?.id}`);
      AppStorage.setOrCreate(CommonConstants.KEY_IMG, this.pixmap);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `screenshot error,code:${err.code},message:${err.message}`);
    }
  }

  // [End VideoSnapshot]

  // [Start SendBulletComment]
  private sendBulletComment(): void {
    if (this.bulletCommentInput.trim()) {
      this.bulletComments = [...this.bulletComments, new BulletComment(this.bulletCommentInput, true)];
      this.bulletCommentInput = '';
      if (this.bulletComments.length > 50) {
        this.bulletComments = this.bulletComments.slice(1);
      }
    }
    this.textInputController.stopEditing();
    this.resumePlayback(); //resume video playback after sending
  }

  // [End SendBulletComment]

  private async clickNextFrame(): Promise<void> {
    this.avPlayerController?.videoSeek(this.screenshotTime + 1000 / CommonConstants.FRAME_RATE);
    setTimeout(() => {
      this.screenshot()
    }, 500)
    this.screenshotTime += 1000 / CommonConstants.FRAME_RATE
  }

  private async clickPreviousFrame(): Promise<void> {
    this.avPlayerController?.videoSeek(this.screenshotTime - 1000 / CommonConstants.FRAME_RATE);
    setTimeout(() => {
      this.screenshot()
    }, 500)
    this.screenshotTime -= 1000 / CommonConstants.FRAME_RATE
  }

  private resumePlayback(): void {
    if (!this.avPlayerController.isPlaying) {
      this.avPlayerController.mediaPlay();
      this.isPlaying = true;
    }
  }

  private generatePresetBulletComments(): void {
    clearInterval(this.presetBulletCommentsTimerId);
    this.presetBulletCommentsTimerId = setInterval(() => {
      let randomIndex = Math.floor(Math.random() * 3);
      this.bulletComments = [...this.bulletComments, new BulletComment(this.presetBulletComments[randomIndex])];
    }, 1000)
  }

  private dialogController: CustomDialogController = new CustomDialogController({
    builder: SpeedDialog({ speedSelect: $speedSelect, avPlayerController: this.avPlayerController }),
    alignment: DialogAlignment.Center,
    offset: { dx: $r('app.float.size_zero'), dy: -20 }
  });
  private scaleDialogController: CustomDialogController = new CustomDialogController({
    builder: ScaleDialog({ windowScaleSelect: $windowScaleSelect, avPlayerController: this.avPlayerController }),
    alignment: DialogAlignment.Center,
    offset: { dx: $r('app.float.size_zero'), dy: -20 }
  });
  private languageDialogController: CustomDialogController = new CustomDialogController({
    builder: LanguageDialog({ languageSelect: $languageSelect }),
    alignment: DialogAlignment.Center,
    offset: { dx: $r('app.float.size_zero'), dy: $r('app.float.size_down_20') }
  });

  setVideoWH(): void {
    if (this.percent >= 1) { // Horizontal video
      this.surfaceW = Math.round(this.windowWidth * PROPORTION);
      this.surfaceH = Math.round(this.surfaceW / this.percent);
    } else { // Vertical video
      this.surfaceH = Math.round(this.windowHeight * PROPORTION);
      this.surfaceW = Math.round(this.surfaceH * this.percent);
    }
  }

  onPIPShowChange(): void {
    if (this.isPIPShow) {
      this.pipWindowController.createPipController();
    } else {
      this.pipWindowController.destroyPipController();
    }
  }

  onFullScreenChange(): void {
    this.generatePresetBulletComments();
  }

  async onLanguageChange(): Promise<void> {
    if (this.avPlayerController !== undefined) {
      await this.avPlayerController.videoReset();
      if (this.languageSelect === 0) {
        this.avPlayerController.initAVPlayer({
          type: VideoDataType.RAW_FILE,
          videoSrc: this.src,
          name: $r('app.string.audio_demo_title'),
          description: '',
          caption: 'captions.srt',
          index: 0,
          seekTime: this.currentTime,
          head: $r('app.media.preview1')
        }, this.surfaceId, this.avSessionController);
      } else if (this.languageSelect === 1) {
        this.avPlayerController.initAVPlayer({
          type: VideoDataType.RAW_FILE,
          videoSrc: this.src,
          name: $r('app.string.audio_demo_title'),
          description: '',
          caption: 'captions_en.srt',
          index: 0,
          seekTime: this.currentTime,
          head: $r('app.media.preview1')
        }, this.surfaceId, this.avSessionController);
      }
    }
  }

  // [Start set_orientation]
  setOrientation(): void {
    window.getLastWindow(this.context, (err, data) => {
      // [StartExclude set_orientation]
      if (err.code) {
        Logger.error(TAG,
          `getLastWindow error Code:${err.code}, message:${err.message}`);
        return;
      }
      // [EndExclude set_orientation]
      let windowClass = data;
      let orientation = window.Orientation.AUTO_ROTATION_UNSPECIFIED;
      windowClass.setPreferredOrientation(orientation).catch((error: BusinessError) => {
        Logger.error(TAG,
          `setPreferredOrientation error code: ${error.code};message: ${error.message}`);
      });
    });

    // Monitor the horizontal and vertical screen changes to obtain the current orientation of the device

    this.windowClass?.on('windowSizeChange', () => {
      try {
        const DEFAULT_DISPLAY = display.getDefaultDisplaySync();
        this.orientation = DEFAULT_DISPLAY.orientation;

        if (this.orientation === window.Orientation.UNSPECIFIED) {
          this.isLayoutFullScreen = false;
        } else if (this.orientation === window.Orientation.PORTRAIT ||
          this.orientation === window.Orientation.PORTRAIT_INVERTED) {
          this.isLayoutFullScreen = true;
        }
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `screenshot error code: ${err.code};message: ${err.message}`);
      }
    });
  }

  // [End set_orientation]

  @Builder
  navTitleBuilder() {
    Row() {
      Button() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(30)
          .fontColor([Color.White])
      }
      .height(40)
      .width(40)
      .borderRadius(20)
      .backgroundColor('rgba(255,255,255,0.1)')
      .margin({ left: 10 })
      .onClick(() => {
        this.handleBackAction();
      })

      // [Start window_scale_button]
      // Window scale
      Row() {
        Button() {
          Image($r('app.media.ic_video_window_scale'))
            .width($r('app.float.size_25'))
            .height($r('app.float.size_25'))
        }
        .type(ButtonType.Normal)
        .height(40)
        .width(40)
        .padding($r('app.float.size_8'))
        .borderRadius($r('app.float.size_20'))
        .backgroundColor('rgba(255,255,255,0.1)')
        .margin({ left: this.isLayoutFullScreen ? 670 : 220 })
        .fontColor(Color.White)
        .onClick(() => {
          this.windowScaleSelect = this.videoScaleType;
          this.scaleDialogController.open();
        })
      }

      // [End window_scale_button]

      // picture-in-picture
      Row() {
        Text() {
          SymbolSpan($r('sys.symbol.dot_grid_2x2'))
            .fontSize($r('app.float.size_25'))
            .fontColor([Color.White])
            .height(20)
            .width(20)
        }
        .padding($r('app.float.size_8'))
        .borderRadius($r('app.float.size_20'))
        .backgroundColor('rgba(255,255,255,0.1)')
        .onClick(() => {
          this.showPopup = !this.showPopup; // Click the button to switch the pop-up status
        })
        .bindSheet(this.showPopup, this.popupContent(), {
          height: '200vp',
          showClose: false,
          backgroundColor: '#1A1A1A',
          title: this.titleBuilder,
          onDisappear: () => {
            this.showPopup = false;
          }
        })
      }
    }
    .margin({ top: 4 })
    .height('100%')
    .width('98%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  videoSnapshotView() {
    Row() {
      Column({ space: 12 }) {
        Image($r('app.media.previousFrame'))
          .width(45)
        Text($r('app.string.previousFrame'))
          .fontSize(14)
          .fontColor(Color.White)
      }
      .onClick(() => {
        this.clickPreviousFrame();
      })

      Image(this.pixmap)
        .width(this.imgWidth)
        .height(this.imgHeight)
        .margin({ right: 10, left: 10 })
        .visibility(this.showImg ? Visibility.Visible : Visibility.None)
        .onClick(() => {
          this.showImg = false;
          if (this.avPlayerController.getVideoState() === AVPlayerState.PAUSED) {
            this.avPlayerController.mediaPlay();
            this.isPlaying = true;
          }
        })

      Column({ space: 12 }) {
        Image($r('app.media.nextFrame'))
          .width(45)
        Text($r('app.string.nextFrame'))
          .fontSize(14)
          .fontColor(Color.White)
      }
      .onClick(() => {
        this.clickNextFrame();
      })
    }
    .height(CommonConstants.HEIGHT_FULL_PERCENT)
    .width(CommonConstants.WIDTH_FULL_PERCENT)
    .justifyContent(FlexAlign.Center)
    .margin({ bottom: 300 })
  }

  // Define pop-up content
  @Builder
  popupContent() {
    Column() {
      // set picture in picture
      Row() {
        Text($r('app.string.pip_start'))
          .width(160)
          .fontSize($r('app.float.size_15'))
          .fontWeight(FontWeight.Bold)
          .padding({ left: $r('app.float.size_10') })
          .fontColor('#E6FFFFFF')
        Toggle({ type: ToggleType.Switch, isOn: AppStorage.get(CommonConstants.KEY_IS_PIP_SHOW) })
          .onChange((isOn: boolean) => {
            AppStorage.set(CommonConstants.KEY_IS_PIP_SHOW, isOn); // Update the status of the toggle
            Logger.info(TAG, `PIPWindow status: + ${isOn}`);
          })
          .height($r('app.float.size_20'))
          .margin({ right: $r('app.float.size_10') })
      }
      .margin({ bottom: 200 })
      .width('95%')
      .height($r('app.float.size_44'))
      .borderRadius($r('app.float.size_20'))
      .justifyContent(FlexAlign.SpaceBetween)
    }
  }

  @Builder
  titleBuilder() {
    Row() {
      Text($r('app.string.more'))
        .fontColor('#E6FFFFFF')

      Image($r('app.media.x_mark'))
        .width(24)
        .height(24)
        .align(Alignment.Center)
        .onClick(() => {
          this.showPopup = false;
        })
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  // [Start about_to_appear]
  async aboutToAppear(): Promise<void> {
    this.setOrientation();
    // [StartExclude about_to_appear]
    this.generatePresetBulletComments();
    try {
      this.windowWidth = display.getDefaultDisplaySync().width;
      this.windowHeight = display.getDefaultDisplaySync().height;
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getDefaultDisplaySync error, code: ${err.code};message: ${err.message};`);
    }

    this.surfaceW = (GlobalContext.getContext().getObject('windowWidth') as number) * SURFACE_WIDTH;
    this.surfaceH = this.surfaceW / SURFACE_HEIGHT;
    emitter.on(CommonConstants.AVPLAYER_PREPARED, (res) => {
      if (res.data) {
        this.percent = res.data.percent;
        this.setVideoWH();
        this.isCalcWHFinished = true;
      }
    });
    // [EndExclude about_to_appear]

    // Get params
    let params = AppRouter.getLastParams() as VideoParams;
    this.info = params.videoInfo;
    this.playIdx = params.playIdx;
    this.index = params.index;
    this.src = params.videoInfo.src as string;
    this.currentTime = this.info.stopTime as number;
    this.duration = this.info.duration;
    this.avPlayerController.videoMuted(false);
    // [StartExclude about_to_appear]
    emitter.on(CommonConstants.SUBTITLE_UPDATE, (eventData: emitter.EventData) => {
      this.currentCaption = eventData.data!.currentCaption;
    });

    setInterval(() => {
      this.currentTime = this.avPlayerController.currentTime;
    }, Constants.PROGRESS_REFRESH_INTERVAL);

    let windowClass: window.Window | undefined = undefined;
    try {
      window.getLastWindow(this.getUIContext().getHostContext(), (err: BusinessError, data: window.Window) => {
        if (err) {
          Logger.error(TAG,
            `Failed to obtain the top window. Cause code: ${err.code}, message: ${err.message}`);
          return;
        }
        windowClass = data;
        this.screenHeight = windowClass.getWindowProperties().windowRect.height;
      })
    } catch (exception) {
      Logger.error(TAG,
        `Failed to obtain the top window. Cause code: ${exception.code}, message: ${exception.message}`);
    }
    await this.avSessionController.registerSessionListener(this.avPlayerController);
    // [EndExclude about_to_appear]
  }

  aboutToDisappear(): void {
    this.avPlayerController.videoRelease();
    this.avSessionController.avSessionRelease();
    clearInterval(this.presetBulletCommentsTimerId);
  }

  // [End about_to_appear]

  build() {
    NavDestination() {
      Column() {
        Column() {
          Stack() {
            Column() {
              Stack() {
                // [Start x_component]
                XComponent({
                  type: XComponentType.SURFACE,
                  controller: this.xComponentController
                })
                  .id(`videoXComponent_${this.info?.id}`)
                  // [End x_component]
                  .height(this.videoScaleType === 0 ? (this.isCalcWHFinished ? `${this.surfaceH}px` : '100%') : null)
                  .width(this.videoScaleType === 0 ? (this.isCalcWHFinished ? `${this.surfaceW}px` : '100%') : null)
                  .align(Alignment.Center)
                  // [Start on_load]
                  .onLoad(() => {
                    // Init AVPlayer
                    this.surfaceId = this.xComponentController.getXComponentSurfaceId();
                    if (this.avPlayerController !== undefined) {
                      this.avPlayerController.initAVPlayer({
                        type: VideoDataType.RAW_FILE,
                        videoSrc: this.src,
                        name: $r('app.string.audio_demo_title'),
                        description: '',
                        caption: 'captions.srt',
                        index: 0,
                        seekTime: this.currentTime,
                        head: $r('app.media.preview1')
                      }, this.surfaceId, this.avSessionController);
                    }
                  })
                // [End on_load]
              }

              BulletCommentView({
                bulletComments: $bulletComments,
                showBulletComment: $showBulletComment
              })
                .width('100%')
                .height(200)
                .position({ x: '0%', y: '5%' })
                .visibility(this.isLayoutFullScreen ? Visibility.Visible : Visibility.None)
            }
            .height('100%')
            .id('Video')
            .justifyContent(FlexAlign.Center)

            Column() {
              Row() {
                AVVolumePanelView({ volume: this.volume });
                ScreenBrightnessView({ screenBrightness: this.screenBrightness, visible: this.visible });
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .visibility(this.isLayoutFullScreen ? Visibility.Visible : Visibility.None)
            }

            Column() {
              Blank()
              Column() {
                Row() {
                  if (this.showImg) {
                    this.videoSnapshotView();
                  }
                }
                .visibility(this.isLayoutFullScreen ? Visibility.Visible : Visibility.Hidden)

                Row() {
                  if (this.isShowCaptionConfig) {
                    CaptionFontView({
                      captionFont: this.captionFont,
                      close: (captionFont: CaptionFont | null) => {
                        this.closeCaptionSetting(captionFont);
                      }
                    })
                  }
                }
                .visibility(this.isLayoutFullScreen ? Visibility.Visible : Visibility.Hidden)

                // subtitles
                Row() {
                  Stack({ alignContent: Alignment.Center }) {
                    Text(this.currentCaption)
                      .fontColor(this.captionFont.color)
                      .fontSize(this.captionFont.size)
                      .fontFamily(this.captionFont.family)
                      .margin({ bottom: this.isLayoutFullScreen ? 0 : 10 })
                  }
                }

                Row() {
                  // play or pause
                  Row() {
                    Image(this.isPlaying ? $r('app.media.ic_pause') : $r('app.media.ic_play'))
                      .width(24)
                      .height(24)
                      .margin(this.isLayoutFullScreen ? { left: 20, right: 8 } : { left: 12, right: 8 })
                      .opacity(0.5)
                      .onClick(() => {
                        if (this.avPlayerController.getVideoState() === AVPlayerState.PLAYING) {
                          this.avPlayerController.mediaPause();
                          this.isPlaying = false;
                        } else {
                          this.avPlayerController.mediaPlay();
                          this.isPlaying = true;
                        }
                      })
                  }

                  // slider
                  Row() {
                    Text(TimeUtil.millisecondsToTime(this.currentTime))
                      .fontSize(12)
                      .fontColor($r('app.color.current_time_text'))
                    Slider({
                      value: this.currentTime,
                      min: 0,
                      max: this.durationTime,
                      style: SliderStyle.OutSet
                    })
                      .width(this.isLayoutFullScreen ? '64%' : 130)
                      .trackColor('rgba(255,255,255,0.5)')
                      .onChange((value: number) => {
                        this.avPlayerController.videoSeek(value);
                      })
                      .visibility(this.avPlayerController.getVideoState() === AVPlayerState.PLAYING ||
                        this.avPlayerController.getVideoState() === AVPlayerState.PAUSED ?
                        Visibility.Visible :
                        Visibility.Hidden)

                    Text(TimeUtil.millisecondsToTime(this.durationTime))
                      .fontSize(12)
                      .fontColor($r('app.color.duration_time_text'))
                      .margin(8)
                  }

                  // [Start video_speed_button]
                  // speed
                  Row() {
                    Button(this.speedName, { type: ButtonType.Normal })
                      .border({ width: 1, color: Color.White })
                      .width(45)
                      .height(20)
                      .fontSize(12)
                      .borderRadius(20)
                      .fontColor(Color.White)
                      .backgroundColor('rgba(0, 0, 0, 0)')
                      .opacity(1)
                      .padding({ left: 5, right: 5 })
                      .margin({ right: 5 })
                      .id('Speed')
                      .onClick(() => {
                        this.speedSelect = this.speedIndex;
                        this.dialogController.open();
                      })
                  }

                  // [End video_speed_button]

                  // mute
                  Row() {
                    Button({ type: ButtonType.Circle, stateEffect: false }) {
                      Image(this.isMuted ? $r('app.media.speaker_close') : $r('app.media.speaker_open'))
                        .fillColor(Color.White)
                    }
                    .width(25)
                    .height(25)
                    .margin({ left: 5, right: 5 })
                    .aspectRatio(1)
                    .backgroundColor(Color.Transparent)
                    .visibility(this.isLayoutFullScreen ? Visibility.Visible : Visibility.None)
                    .onClick(() => {
                      this.avPlayerController.videoMuted(!this.isMuted).then(() => {
                        this.isMuted = !this.isMuted;
                      });
                    })
                  }

                  // full screen
                  Row() {
                    Image(this.isLayoutFullScreen ? $r('app.media.ic_fullscreen_lined') :
                      $r('app.media.ic_exit_full_screen_lined'))
                      .width(24)
                      .height(24)
                      .margin(this.isLayoutFullScreen ? { bottom: 0, right: 16 } : { bottom: 0, right: 3 })
                      .onClick(() => {
                        this.isLayoutFullScreen = !this.isLayoutFullScreen;
                        this.setWindowDirection(this.isLayoutFullScreen ? window.Orientation.LANDSCAPE_INVERTED :
                          window.Orientation.PORTRAIT);

                        if (!this.isLayoutFullScreen) {
                          this.setOrientation();
                        }
                      })
                  }
                }
                .width('100%')
                .height(32)
                .backgroundColor($r('app.color.detail_control_background_color'))

                Row() {
                  //third row:button
                  Stack() {
                    Row({ space: 7 }) {
                      Button() {
                        Image($r('app.media.ic_video_translate'))
                          .width($r('app.float.size_25'))
                          .height($r('app.float.size_25'))
                      }
                      .type(ButtonType.Normal)
                      .width($r('app.float.size_25'))
                      .height($r('app.float.size_25'))
                      .backgroundColor('rgba(0, 0, 0, 0)')
                      .fontColor(Color.White)
                      .onClick(() => {
                        this.languageSelect = this.currentLanguageType;
                        this.languageDialogController.open();
                      })

                      //caption fontStyle set
                      Image($r('app.media.character_viewfinder'))
                        .width('26vp')
                        .height('26vp')
                        .onClick(() => {
                          if (!this.isInputtingBulletComment) {
                            this.avPlayerController.mediaPause();
                            this.isPlaying = false;
                            this.isShowCaptionConfig = true;
                          }
                        })
                        .backgroundColor(Color.Transparent)

                      //video snapshot
                      Image($r('app.media.screenshot'))
                        .width('26vp')
                        .height('26vp')
                        .onClick(async () => {
                          if (!this.isInputtingBulletComment) {
                            this.showImg = true;
                            this.screenshotTime = this.avPlayerController.currentTime;
                            this.avPlayerController.mediaPause();
                            this.isPlaying = false;
                            this.screenshot();
                            this.getUIContext().animateTo({
                              duration: 500,
                              iterations: 1,
                              playMode: PlayMode.Normal,
                            }, () => {
                              this.imgWidth = 375;
                              this.imgHeight = 166;
                            })
                          }
                        })

                      TextInput({
                        text: this.bulletCommentInput,
                        placeholder: $r('app.string.placeholder'),
                        controller: this.textInputController
                      })
                        .backgroundColor('rgba(255,255,255,0.3)')
                        .placeholderColor('rgba(255,255,255,0.7)')
                        .placeholderFont({ size: 14 })
                        .padding({ top: 0, bottom: 0 })
                        .margin({ right: 40 })
                        .fontColor(Color.White)
                        .onFocus(() => {
                          this.isInputtingBulletComment = true;
                        })
                        .onBlur(() => {
                          this.isInputtingBulletComment = false;
                        })
                        .height(24)
                        .layoutWeight(1)
                        .onChange((value: string) => {
                          this.bulletCommentInput = value;
                        })
                    }
                    .height('20%')
                    .padding({ left: 22, right: 22 })
                    .width(CommonConstants.WIDTH_FULL_PERCENT)

                    Image($r('app.media.arrow_up_circle_fill'))
                      .width('26vp')
                      .height('26vp')
                      .onClick(() => {
                        this.sendBulletComment();
                      })
                      .margin({ right: 27 })
                      .backgroundColor(Color.Transparent)
                  }
                  .alignContent(Alignment.End)
                }
                .height(32)
                .margin({ bottom: 16, top: 2 })
                .visibility(this.isLayoutFullScreen ? Visibility.Visible : Visibility.Hidden)
              }
            }
            .visibility(this.iconShown ? Visibility.Visible : Visibility.None)
            .margin({ top: this.isLayoutFullScreen ? 280 : 720 })
            .justifyContent(FlexAlign.End)
          }
          .onClick(() => {
            this.iconShown = !this.iconShown;
            if (this.iconShown === true) {
              this.timer = setTimeout(() => {
                this.iconShown = false;
              }, Constants.PROGRESS_SHOWN_DURATION);
            } else {
              clearTimeout(this.timer);
            }
          })
          .backgroundColor(Color.Black)
        }
        .height('auto')
        .width('auto')
      }
      .gesture(
        //sliding in the vertical direction
        PanGesture({ direction: PanDirection.Vertical })
          .onActionStart(() => {
          })
          .onActionUpdate((event: GestureEvent) => {
            if (this.isLayoutFullScreen) {
              //the area on the right side of the screen
              if (event.fingerList[0].globalX > (820 / 2)) {
                this.visible = true;
                let curBrightness = this.screenBrightness -
                  this.getUIContext().vp2px(event.offsetY) / this.getUIContext().vp2px(this.screenHeight);
                curBrightness = curBrightness >= 1.0 ? 1.0 : curBrightness;
                curBrightness = curBrightness <= 0.0 ? 0.0 : curBrightness;
                this.screenBrightness = curBrightness;
                Logger.info(TAG, 'this brightness is: ' + this.screenBrightness);

                try {
                  this.mainWin?.setWindowBrightness(this.screenBrightness, (err: BusinessError) => {
                    if (err.code) {
                      Logger.error(TAG,
                        `Failed to set the brightness. code is ${err.code}, message is ${err.message},
                        current brightness is ${this.screenBrightness}`);
                      return;
                    }
                    Logger.info(TAG, 'Succeeded in setting the brightness.');
                  });
                } catch (exception) {
                  Logger.error(TAG,
                    `Failed to set the brightness. code is ${exception.code}, message is ${exception.message}, other`);
                }
              } else {
                this.visible = false;
                let curVolume = this.volume - this.getUIContext().vp2px(event.offsetY) / this.screenHeight;
                curVolume = curVolume >= 15.0 ? 15.0 : curVolume;
                curVolume = curVolume <= 0.0 ? 0.0 : curVolume;
                this.volume = curVolume;
                Logger.info(TAG, 'this volume is: ' + this.volume);
              }
            }
          })
          .onActionEnd(() => {
            setTimeout(() => {
              this.visible = false;
            }, 3000)
          })
      )
    }
    .title({ height: 50, builder: this.navTitleBuilder() }, {
      backgroundColor: '#00ffffff',
      barStyle: BarStyle.STACK,
    })
    .backgroundColor(Color.Black)
    .hideBackButton(true)
    .hideToolBar(true)
    .onShown(() => {
      if (this.avPlayerController) {
        if (this.avPlayerController.getVideoState() === AVPlayerState.PAUSED) {
          this.avPlayerController.mediaPlay();
          this.isPlaying = true;
        } else if (this.avPlayerController.getVideoState() === AVPlayerState.PLAYING) {
          if (!this.isPlaying) {
            this.isPlaying = true;
          }
        }
      }
    })
    .onWillShow(() => {
      this.mainWin = this.windowStage.getMainWindowSync();
      this.windowClass = this.context.windowStage.getMainWindowSync();
      let sysBarProps: window.SystemBarProperties = {
        statusBarColor: '#000000',
        statusBarContentColor: '#FFFFFF'
      };
      this.mainWin?.setWindowSystemBarProperties(sysBarProps).then(() => {
        Logger.info(TAG, '[StaticUtils] Succeeded in setting the system bar properties.');
      }).catch((err: BusinessError) => {
        Logger.error(TAG, `setting system bar properties failed, code is ${err.code}, message is ${err.message}`);
      });
    })
    .onHidden(()=>{
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
    })
    .onBackPressed(() => {
      this.handleBackAction();
      return true;
    })
  }
}