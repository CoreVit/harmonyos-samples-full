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
import { image } from '@kit.ImageKit';
import { media } from '@kit.MediaKit';
import { inputMethod } from '@kit.IMEKit';
import { KeyCode } from '@kit.InputKit';
import { BusinessError, settings } from '@kit.BasicServicesKit';
import { BulletCommentView } from './BulletCommentView';
import { BulletComment } from '../model/BulletCommentModel';
import { CaptionFontView } from './CaptionFontView';
import { CaptionFont, registerMyFont } from '../model/CaptionFontModel';
import { VolumeAndBrightnessView } from './VolumeAndBrightnessView';
import { VideoSnapshotDialog } from './VideoSnapshotDialog';
import { TimeUtil } from '../common/utils/TimeUtils';
import { CommonConstants, ScreenShotConstants } from '../common/constants/CommonConstants';
import { KeyConstants } from '../common/constants/KeyConstants';
import { WindowUtil } from '../common/utils/WindowUtil';
import { BreakpointType } from '../common/utils/BreakpointType';
import { DisplayUtil } from '../common/utils/DisplayUtil';
import { VideoData } from '../model/VideoData';
import { AvPlayerController } from '../controller/AvPlayerController';
import { PiPWindowController } from '../controller/PipWindowController';
import { SpeedDialog } from './SpeedDialog';
import { LanguageDialog } from './LanguageDialog';
import Logger from '../common/utils/Logger';

const TAG = '[AVPlayer]';

@Component
export struct AVPlayer {
  @Prop @Watch('onFullScreenChange') isFullLandscapeScreen: boolean =
    false; // Whether the video is played in full screen
  // [Start CreatePageShowChangeEvent]
  @Prop @Watch('onPageShowChange') isPageShow: boolean = false; // Whether the app is on the front end or back end
  // [End CreatePageShowChangeEvent]
  @Prop index: number = 0; // The index of each video
  @Prop curSource: VideoData; // Current video
  @Prop @Watch('onIndexChange') curIndex: number = CommonConstants.CURINDEX_DEFAULT_NUM; // The index of playing video
  @StorageLink(KeyConstants.KEY_IS_PIP_SHOW) @Watch('onPIPShowChange') isPIPShow: boolean = false; // Whether to show picture in picture
  @State showPopup: boolean = false; // Control pop-up display
  @State avPlayerController: AvPlayerController = new AvPlayerController(); // The instance of AvPlayer
  @State isSliderDragging: boolean = false; // Whether in the slider dragging state
  @State visible: boolean = false; // Whether to show slider/image
  @State volume: number = 5; // Set original video volume number
  @State screenBrightness: number = 0; // Screen luminance
  @State showBulletComment: boolean = true; // Whether to show bullet comments
  @State bulletComments: BulletComment[] = []; // Bullet comments storage array
  @State bulletCommentInput: string = ''; // User input bullet comment
  @State captionFont: CaptionFont = {
    family: 'Sans',
    size: 14,
    color: Color.White
  }; // Default font style
  @State isShowCaptionConfig: boolean = false; // Whether to show CaptionFontComponent
  @State imgWidth: number = 0; // The width of video snapshot image
  @State imgHeight: number = 0; // The height of video snapshot image
  @State screenshotTime: number = 0; // Video snapshot time
  @State pixmap: image.PixelMap | undefined = undefined; // Video snapshot image
  @State speedSelect: number = 0; // Speed Magnification Selection
  @State speedIndex: number = 0; // Index of the playback rate list.
  @State speedName: Resource = $r('app.string.video_speed_1_0X');
  @State isMuted: boolean = false; // Whether is sound off
  @State languageSelect: number = 0; // Index of the current selection
  @State currentLanguageType: number = 0; // Current language type
  private previousFrameTimerId?: number;
  private nextFrameTimerId?: number;
  private presetBulletCommentsTimerId: number = -1; // The timer of preset bullet comments
  private presetBulletComments =
    [$r('app.string.comment1'), $r('app.string.comment2'), $r('app.string.comment3')]; // Preset bullet comments
  private xComponentController = new XComponentController(); // The instance of XComponent
  onFullScreenClick: (isLandscape?: boolean) => void = () => {
  };
  @StorageProp(KeyConstants.KEY_DEVICE_WIDTH) screenWidth: number = 0; // Screen width
  @StorageProp(KeyConstants.KEY_DEVICE_HEIGHT) screenHeight: number = 0; // Screen height
  @StorageProp(KeyConstants.KEY_NAV_BAR_HEIGHT) navBarHeight: number = 0;
  @StorageProp(KeyConstants.KEY_WIDTH_BREAKPOINT) widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @StorageLink(KeyConstants.KEY_IS_HALF_FOLDED) isHalfFolded: boolean = false;
  @StorageLink(KeyConstants.KEY_CREASE_REGION) creaseRegion: number[] = [];
  private orgScreenBrightness: number = 0; //The original screen brightness
  private isInputtingBulletComment: boolean = false; // Whether is inputting bullet comment
  private pipWindowController: PiPWindowController =
    new PiPWindowController(this.avPlayerController, this.xComponentController); // The instance of picture in picture
  private speedDialogController: CustomDialogController = new CustomDialogController({
    builder: SpeedDialog({
      speedSelect: this.speedSelect,
      speedIndex: this.speedIndex,
      speedName: this.speedName,
      avPlayerController: this.avPlayerController
    }),
    alignment: DialogAlignment.Center,
    offset: { dx: $r('app.float.size_zero'), dy: $r('app.float.size_down_20') },
    enableHoverMode: true,
    hoverModeArea: HoverModeAreaType.BOTTOM_SCREEN
  });
  private languageDialogController: CustomDialogController = new CustomDialogController({
    builder: LanguageDialog({
      languageSelect: this.languageSelect,
      currentLanguageType: this.currentLanguageType,
      avPlayerController: this.avPlayerController
    }),
    alignment: DialogAlignment.Center,
    offset: { dx: $r('app.float.size_zero'), dy: $r('app.float.size_down_20') },
    enableHoverMode: true,
    hoverModeArea: HoverModeAreaType.BOTTOM_SCREEN
  });
  private videoSnapshotDialogController: CustomDialogController = new CustomDialogController({
    builder: VideoSnapshotDialog({
      imgWidth: this.imgWidth,
      imgHeight: this.imgHeight,
      pixmap: this.pixmap,
      onPreviousClick: () => {
        this.clickPreviousFrame();
      },
      onNextClick: () => {
        this.clickNextFrame();
      }
    }),
    alignment: DialogAlignment.Center,
    maskColor: $r('sys.color.mask_tertiary'),
    openAnimation: { duration: 500, iterations: 1, playMode: PlayMode.Normal },
    customStyle: true,
    onDidDisappear: () => {
      this.resumePlayback();
    },
    enableHoverMode: true,
    hoverModeArea: HoverModeAreaType.BOTTOM_SCREEN
  });

  private onFoldStatusChange: Callback<display.FoldStatus> = (data: display.FoldStatus) => {
    if (canIUse('SystemCapability.Window.SessionManager')) {
      if (data === display.FoldStatus.FOLD_STATUS_HALF_FOLDED) {
        try {
          let orientation: display.Orientation = display.getDefaultDisplaySync().orientation;
          if ((orientation === display.Orientation.LANDSCAPE ||
            orientation === display.Orientation.LANDSCAPE_INVERTED) &&
            this.widthBp === WidthBreakpoint.WIDTH_MD) {
            this.isHalfFolded = true;
            // Full-screen playback.
            if (!this.isFullLandscapeScreen) {
              this.isFullLandscapeScreen = true;
              this.onFullScreenClick?.(true);
            }
          }
        } catch (error) {
          let err = error as BusinessError;
          Logger.error(TAG, `getDefaultDisplaySync failed, errCode = ${err.code}, errMessage = ${err.message}.`)
        }
      } else {
        this.isHalfFolded = false;
      }
    }
  };

  aboutToAppear(): void {
    const context = this.getUIContext().getHostContext();
    registerMyFont(this.getUIContext());
    settings.getValue(context, settings.display.SCREEN_BRIGHTNESS_STATUS, settings.domainName.DEVICE_SHARED)
      .then((value) => {
        this.screenBrightness = Number(value) / 255;
        this.orgScreenBrightness = Number(value) / 255;
      });
    if (canIUse('SystemCapability.Window.SessionManager')) {
      try {
        display.on('foldStatusChange', this.onFoldStatusChange);
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `onFoldStatusChange failed, errCode = ${err.code}, errMessage = ${err.message}.`);
      }
      DisplayUtil.getFoldCreaseRegion(this.getUIContext());
    }
  }

  aboutToDisappear(): void {
    this.avPlayerController.videoRelease();
    if (this.presetBulletCommentsTimerId > 0) {
      clearInterval(this.presetBulletCommentsTimerId);
    }
    this.pixmap?.release();
    if (canIUse('SystemCapability.Window.SessionManager')) {
      try {
        display.off('foldStatusChange');
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `onFoldStatusChange failed, errCode = ${err.code}, errMessage = ${err.message}.`);
      }
    }
  }

  onFullScreenChange() {
    if (this.isFullLandscapeScreen && this.index === this.curIndex) {
      // Enter full screen mode, start to show preset bullet comment
      this.generatePresetBulletComments();
    } else if (!this.isFullLandscapeScreen && this.index === this.curIndex) {
      //exist full screen mode, set screen brightness back to original number
      this.setScreenBrightness(this.orgScreenBrightness);
      // Exist full screen mode, set CaptionFontView invisible
      this.isShowCaptionConfig = false;
      // Exist full screen mode, clear timer
      if (this.presetBulletCommentsTimerId > 0) {
        clearInterval(this.presetBulletCommentsTimerId);
      }
    }
  }

  // [Start OnPageShowChange]
  onPageShowChange() {
    if (!this.isPIPShow && this.curIndex === this.index) {
      this.isPageShow ? this.resumePlayback() : this.pausePlay();
    }
  }

  // [End OnPageShowChange]

  // Click videoList, switch video to play
  onIndexChange() {
    if (this.curIndex !== this.index) {
      this.avPlayerController.videoPause();
      this.pipWindowController.destroyPipController();
    } else {
      if (this.avPlayerController.isReady === true) {
        this.avPlayerController.videoPlay();
        this.onPIPShowChange();
      } else {
        let intervalFlag = setInterval(() => {
          if (this.curIndex !== this.index) {
            clearInterval(intervalFlag);
          }
          if (this.avPlayerController.isReady === true && this.isPageShow) {
            this.avPlayerController.videoPlay();
            clearInterval(intervalFlag);
          }
        }, 100);
      }
    }
  }

  onPIPShowChange() {
    if (this.isPIPShow && this.curIndex === this.index) {
      this.pipWindowController.createPipController();
    } else {
      this.pipWindowController.destroyPipController();
    }
  }

  getPlayControlPadding(): number {
    return new BreakpointType(16, 16, 24, 32, 32).getValue(this.widthBp);
  }

  getBottomMargin(): number | Resource {
    switch (this.widthBp) {
      case WidthBreakpoint.WIDTH_XS:
      case WidthBreakpoint.WIDTH_SM:
      case WidthBreakpoint.WIDTH_MD:
        return $r('app.float.margin_small');
      case WidthBreakpoint.WIDTH_XL:
        return 24;
      case WidthBreakpoint.WIDTH_LG:
        return WindowUtil.getInstance().isPhoneDevice() ? $r('app.float.margin_small') : 48;
    }
  }

  @Builder
  TimeControl() {
    Text(TimeUtil.millisecondsToTime(this.avPlayerController.currentTime))
      .fontSize($r('app.float.font_size_12'))
      .fontColor(Color.White)
      .opacity($r('app.float.opacity_9'))

    Slider({
      value: this.avPlayerController.currentTime,
      min: CommonConstants.SLIDER_MIN,
      max: this.avPlayerController.durationTime,
      step: CommonConstants.SLIDER_STEP,
      direction: Axis.Horizontal,
      style: SliderStyle.OutSet
    })
      .height($r('app.float.size_24'))
      .trackColor($r('app.color.white_opacity_1_color'))
      .showSteps(false)
      .blockSize({ width: 16, height: 16 })
      .blockColor(Color.White)
      .layoutWeight(1)
      .trackThickness(6)
      .trackBorderRadius(CommonConstants.TRACK_BORDER_RADIUS)
      .selectedBorderRadius(CommonConstants.TRACK_BORDER_RADIUS)
      .zIndex(CommonConstants.SLIDER_INDEX)
      .onChange((value: number, mode: SliderChangeMode) => {
        this.sliderOnchange(value, mode);
      })

    Text(TimeUtil.millisecondsToTime(this.avPlayerController.durationTime))
      .fontColor(Color.White)
      .fontSize(12)
      .opacity($r('app.float.opacity_9'))
  }

  // Normal mode: playControl
  @Builder
  playControl() {
    Column() {
      if (!this.isFullLandscapeScreen) {
        Row({ space: 5 }) {
          this.TimeControl()

          Image($r('app.media.ic_video_menu_landscape_fullscreen'))
            .fillColor($r('sys.color.white'))
            .width($r('app.float.size_24'))
            .height($r('app.float.size_24'))
            .onClick(() => {
              this.onFullScreenClick?.(true);
            })
            .margin({left: new BreakpointType(8, 8, 24, 24, 24).getValue(this.widthBp)})
        }
        .padding({ left: this.getPlayControlPadding(), right: this.getPlayControlPadding() })
        .width(CommonConstants.WIDTH_FULL_PERCENT)
      }
    }
    .margin({
      bottom: this.isFullLandscapeScreen ? this.navBarHeight : this.getBottomMargin()
    })
  }

  private sliderOnchange(seconds: number, mode: SliderChangeMode) {
    switch (mode) {
      case SliderChangeMode.Begin:
        break;
      case SliderChangeMode.Click:
        break;
      case SliderChangeMode.Moving:
        this.isSliderDragging = true;
        break;
      case SliderChangeMode.End:
        this.avPlayerController.videoSeek(seconds);
        this.isSliderDragging = false;
        break;
      default:
        break;
    }
  }

  async iconOnclick() {
    if (this.avPlayerController.isPlaying) {
      this.avPlayerController.videoPause();
      let context = this.getUIContext().getHostContext() as Context;
      try {
        let windowClass = await window.getLastWindow(context);
        await windowClass.setWindowKeepScreenOn(false);
      } catch (exception) {
        Logger.error(TAG, `setWindowKeepScreenOn failed: code: ${exception.code}, message: ${exception.message}`);
      }
    } else {
      if (this.avPlayerController.isReady === true) {
        this.avPlayerController.videoPlay();
      }
      let context = this.getUIContext().getHostContext() as Context;
      try {
        let windowClass = await window.getLastWindow(context);
        await windowClass.setWindowKeepScreenOn(true);
      } catch (exception) {
        Logger.error(TAG, `setWindowKeepScreenOn failed: code: ${exception.code}, message: ${exception.message}`);
      }
    }
  }

  @Builder
  FullScreenProgress() {
    Row({ space: 3 }) {
      this.TimeControl()

      Button(this.speedName, { type: ButtonType.Normal })
        .border({ width: $r('app.float.size_1'), color: Color.White })
        .width($r('app.float.size_56'))
        .height($r('app.float.size_25'))
        .fontSize($r('app.float.size_14'))
        .borderRadius($r('app.float.size_20'))
        .fontColor(Color.White)
        .backgroundColor('rgba(0, 0, 0, 0)')
        .opacity($r('app.float.size_1'))
        .padding({ left: $r('app.float.size_5'), right: $r('app.float.size_5') })
        .margin({ left: $r('app.float.size_5') })
        .id('Speed')
        .onClick(() => {
          if (!this.isInputtingBulletComment) {
            this.speedSelect = this.speedIndex;
            this.speedDialogController.open();
          }
        })

      Button() {
        Image(this.isMuted ? $r('app.media.ic_video_speaker_slash') : $r('app.media.ic_video_speaker'))
          .width($r('app.float.size_25'))
          .height($r('app.float.size_25'))
      }
      .type(ButtonType.Normal)
      .width($r('app.float.size_30'))
      .height($r('app.float.size_30'))
      .borderRadius($r('app.float.size_20'))
      .backgroundColor('rgba(0, 0, 0, 0)')
      .fontColor(Color.White)
      .onClick(() => {
        if (!this.isInputtingBulletComment) {
          this.isMuted = !this.isMuted;
          this.avPlayerController.videoMuted(this.isMuted)
        }
      })
    }
    .padding({ left: this.getPlayControlPadding(), right: this.getPlayControlPadding() })
    .width(CommonConstants.WIDTH_FULL_PERCENT)
    .backgroundColor($r('app.color.progress_background_color'))
  }

  @Builder
  SendComment() {
    TextInput({ text: this.bulletCommentInput, placeholder: $r('app.string.placeholder') })
      .backgroundColor('rgba(255, 255, 255, 0.1)')
      .placeholderColor($r('sys.color.font_on_primary'))
      .placeholderFont({ size: 14 })
      .padding({ top: 0, bottom: 0 })
      .fontColor($r('sys.color.font_on_primary'))
      .fontWeight(FontWeight.Regular)
      .onFocus(() => {
        this.pausePlay();
        this.isInputtingBulletComment = true;
      })
      .onBlur(() => {
        this.resumePlayback();
        this.isInputtingBulletComment = false;
      })
      .height(40)
      .layoutWeight(1)
      .onChange((value: string) => {
        this.bulletCommentInput = value;
      })

    Row() {
      SymbolGlyph($r('sys.symbol.paperplane'))
        .fontSize('22fp')
        .fontColor([Color.White])
    }
    .width(40)
    .height(40)
    .border({
      width: 0,
      radius: 20
    })
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      try {
        inputMethod.getController().stopInputSession().catch((err: BusinessError) => {
          Logger.error(TAG, `stopInputSession failed. Code:${err.code}, message:${err.message}`);
        });
      } catch (exception) {
        Logger.error(TAG, `getController failed: code: ${exception.code}, message: ${exception.message}`);
      }
      this.sendBulletComment();
    })
    .backgroundColor('rgba(255, 255, 255, 0.1)')
  }

  @Builder
  ControlButton(img: ResourceStr, size: ResourceStr, onClickFunc: () => void) {
    Button() {
      Image(img)
        .width(size)
        .height(size)
    }
    .backgroundColor(Color.Transparent)
    .onClick(() => {
      onClickFunc();
    })
  }

  @Builder
  FullScreenControlButton() {
    Row({ space: 8 }) {
      // Switch caption language
      this.ControlButton($r('app.media.ic_video_translate'), $r('app.float.size_25'), () => {
        if (!this.isInputtingBulletComment) {
          this.languageSelect = this.currentLanguageType;
          this.languageDialogController.open();
        }
      })

      // Set caption fontStyle
      this.ControlButton($r('app.media.character_viewfinder'), $r('app.float.size_24'), () => {
        if (!this.isInputtingBulletComment) {
          this.pausePlay();
          this.isShowCaptionConfig = true;
        }
      })

      // Video snapshot
      this.ControlButton($r('app.media.screenshot'), $r('app.float.size_24'), () => {
        if (!this.isInputtingBulletComment) {
          this.pausePlay();
          this.screenshotTime = this.avPlayerController.currentTime;
          this.screenshot();
          this.imgWidth = 375;
          this.imgHeight = 166;
          this.videoSnapshotDialogController.open();
        }
      })

      this.SendComment()
    }
    .height(!this.isHalfFolded ? '20%' : '40%')
    .margin({ top: 10, bottom: 14 })
    .padding({ left: this.getPlayControlPadding(), right: this.getPlayControlPadding() })
    .width(CommonConstants.WIDTH_FULL_PERCENT)
  }

  // Full screen mode: playControl and other control button
  @Builder
  fullLandscapeScreenControl() {
    Column() {
      // First row: caption
      Row() {
        Text(this.avPlayerController.currentCaption || '')
          .fontColor(this.captionFont.color)
          .fontSize(this.captionFont.size)
          .fontFamily(this.captionFont.family)
      }
      .height(10)
      .visibility(this.isHalfFolded ? Visibility.Hidden : Visibility.Visible)

      // Second row: progress
      this.FullScreenProgress()

      // Third row: button
      this.FullScreenControlButton()
    }
    .height(!this.isHalfFolded ? '40%' : '20%')
    .width('100%')
    .justifyContent(FlexAlign.End)
  }

  // [Start PausePlay]
  private pausePlay() {
    if (this.avPlayerController.isPlaying) {
      this.avPlayerController.videoPause();
    }
  }

  // [End PausePlay]

  // [Start Playback]
  private resumePlayback() {
    if (!this.avPlayerController.isPlaying) {
      this.avPlayerController.videoPlay();
    }
  }

  // [End Playback]

  // [Start SendBulletComment]
  private sendBulletComment() {
    if (this.bulletCommentInput.trim()) {
      this.bulletComments = [...this.bulletComments, new BulletComment(this.bulletCommentInput, true)];
      this.bulletCommentInput = '';
      if (this.bulletComments.length > 50) {
        this.bulletComments = this.bulletComments.slice(1);
      }
    }
    this.resumePlayback(); // Resume video playback after sending
  }

  // [End SendBulletComment]

  private generatePresetBulletComments() {
    if (this.presetBulletCommentsTimerId > 0) {
      clearInterval(this.presetBulletCommentsTimerId);
    }
    this.presetBulletCommentsTimerId = setInterval(() => {
      let randomIndex = Math.floor(Math.random() * 3);
      this.bulletComments = [...this.bulletComments, new BulletComment(this.presetBulletComments[randomIndex])];
    }, 2000)
  }

  private closeCaptionSetting(captionFont: CaptionFont | null) {
    this.isShowCaptionConfig = false;
    if (captionFont) {
      this.captionFont = captionFont;
    }
    this.resumePlayback();
  }

  // [Start VideoSnapshot]
  private async screenshot() {
    try {
      this.pixmap = await this.getUIContext().getComponentSnapshot().get(`videoXComponent_${this.curSource.index}`);
    } catch (exception) {
      Logger.error(TAG, `screenshot failed: code: ${exception.code}, message: ${exception.message}`);
    }
  }

  // [End VideoSnapshot]

  // [Start GetLastFrame]
  private async clickPreviousFrame() {
    this.avPlayerController?.videoSeek(this.screenshotTime - 1000 / ScreenShotConstants.FRAME_RATE);
    this.pausePlay();
    if (this.previousFrameTimerId) {
      clearTimeout(this.previousFrameTimerId);
    }
    this.previousFrameTimerId = setTimeout(() => {
      this.screenshot()
    }, 500)
    this.screenshotTime -= 1000 / ScreenShotConstants.FRAME_RATE;
    this.screenshotTime = Math.max(0, Math.min(this.screenshotTime, this.avPlayerController.durationTime));
  }

  // [End GetLastFrame]

  // [Start GetNextFrame]
  private async clickNextFrame() {
    this.avPlayerController?.videoSeek(this.screenshotTime + 1000 / ScreenShotConstants.FRAME_RATE);
    this.pausePlay();
    if (this.nextFrameTimerId) {
      clearTimeout(this.nextFrameTimerId);
    }
    this.nextFrameTimerId = setTimeout(() => {
      this.screenshot()
    }, 500)
    this.screenshotTime += 1000 / ScreenShotConstants.FRAME_RATE;
    this.screenshotTime = Math.max(0, Math.min(this.screenshotTime, this.avPlayerController.durationTime));
  }

  // [End GetNextFrame]

  private async setScreenBrightness(brightness: number) {
    let windowStage: window.WindowStage = AppStorage.get(KeyConstants.KEY_WINDOW_STAGE) as window.WindowStage;
    try {
      let mainWin: window.Window = windowStage.getMainWindowSync();
      await mainWin.setWindowBrightness(brightness);
    } catch (exception) {
      Logger.error(TAG, `getMainWindowSync failed: code: ${exception.code}, message: ${exception.message}`);
    }
  }

  private getValidValue(inputValue: number, minValue: number, maxValue: number): number {
    inputValue = inputValue >= maxValue ? maxValue : inputValue;
    inputValue = inputValue <= minValue ? minValue : inputValue;
    return inputValue;
  }

  // [Start ProcessGesture]
  private processGesture(event: GestureEvent) {
    if (event.fingerList.length === 0) {
      return;
    }
    // The area on the right side of the screen
    if (event.fingerList[0].globalX > (this.getUIContext().px2vp(this.screenWidth / 2))) {
      if (this.isInputtingBulletComment) {
        return; // When inputting bullet comment, disable screen brightness change
      }
      this.visible = true;
      let curBrightness = this.screenBrightness - this.getUIContext().vp2px(event.offsetY) / this.screenHeight;
      curBrightness = this.getValidValue(curBrightness, 0.0, 1.0);
      this.screenBrightness = curBrightness;
      this.setScreenBrightness(this.screenBrightness);
    } else {
      this.visible = false;
      let curVolume = this.volume - this.getUIContext().vp2px(event.offsetY) / this.screenHeight;
      curVolume = this.getValidValue(curVolume, 0.0, 15.0);
      this.volume = curVolume;
    }
  }
  // [End ProcessGesture]

  private processKeyEvent(event?: KeyEvent) {
    if (!event || event.type !== KeyType.Down) {
      return;
    }
    // Space key controls pause/play.
    if (event.keyCode === KeyCode.KEYCODE_SPACE) {
      this.iconOnclick();
    }
  }

  @Builder
  VideoPauseImage() {
    if (!this.avPlayerController.isPlaying) {
      Row() {
        // Video pause image
        Image($r('app.media.ic_video_menu_play'))
          .width(this.isFullLandscapeScreen ? $r('app.float.icon_size_large') : $r('app.float.size_36'))
          .aspectRatio(1)
      }
      .width(CommonConstants.WIDTH_FULL_PERCENT)
      .justifyContent(this.isFullLandscapeScreen ? FlexAlign.SpaceEvenly : FlexAlign.SpaceAround)
      .zIndex(CommonConstants.Z_INDEX_VIDEO_PLAY)
      .margin({ top: this.isHalfFolded ? this.getUIContext().px2vp(this.screenHeight / 2) : 0 })
    }
  }

  @Builder
  ControlView() {
    if (this.isFullLandscapeScreen) {
      BulletCommentView({
        bulletComments: this.bulletComments,
        showBulletComment: this.showBulletComment
      })
        .width('100%')
        .height(200)
        .position({ x: '0%', y: '5%' })

      VolumeAndBrightnessView({
        visible: this.visible,
        volume: this.volume,
        screenBrightness: this.screenBrightness
      });
    }
  }

  @Builder
  VideoPlay() {
    Column() {
      Stack() {
        XComponent({
          type: XComponentType.SURFACE,
          controller: this.xComponentController
        })
          .id(`videoXComponent_${this.curSource.index}`)
          .onLoad(async () => {
            try {
              const avPlayer = await media.createAVPlayer();
              this.avPlayerController.initAVPlayer(avPlayer, this.curSource,
                this.xComponentController.getXComponentSurfaceId());
            } catch (exception) {
              Logger.error(TAG, `createAVPlayer failed: code: ${exception.code}, message: ${exception.message}`);
            }
          })
          .aspectRatio(CommonConstants.ASPECT)

        this.ControlView()

        Row() {
          Text(this.avPlayerController.currentCaption || '')
            .fontColor(this.captionFont.color)
            .fontSize(this.captionFont.size)
            .fontFamily(this.captionFont.family)
        }
        .width('100%')
        .height(10)
        .justifyContent(FlexAlign.Center)
        .position({y: this.creaseRegion[0] - 20})
        .visibility(this.isHalfFolded && this.isFullLandscapeScreen ? Visibility.Visible : Visibility.None)
      }
      .height(this.isHalfFolded ? this.creaseRegion[0] : 'auto')

      Blank()
        .visibility(this.isHalfFolded && this.isFullLandscapeScreen ? Visibility.Visible : Visibility.None)
    }
    .justifyContent(FlexAlign.Center)
    .width(CommonConstants.WIDTH_FULL_PERCENT)
    .height(CommonConstants.HEIGHT_FULL_PERCENT)
    .zIndex(CommonConstants.Z_INDEX_BASE)
  }

  @Builder
  VideoPlayControl() {
    if (this.isFullLandscapeScreen) {
      this.fullLandscapeScreenControl();
    }
    this.playControl();
  }

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Stack({ alignContent: Alignment.Center }) {
        this.VideoPauseImage()
        this.VideoPlay()
      }
      .width(CommonConstants.WIDTH_FULL_PERCENT)
      .height(CommonConstants.HEIGHT_FULL_PERCENT)
      .onClick(() => {
        this.iconOnclick();
      })
      // [Start SetScreenBrightnessPanGesture]
      .gesture(
        // Sliding in the vertical direction
        PanGesture({ direction: PanDirection.Vertical })
          .onActionStart(() => {
          })
          .onActionUpdate((event: GestureEvent) => {
            this.processGesture(event);
          })
          .onActionEnd(() => {
            setTimeout(() => {
              this.visible = false;
            }, 3000)
          })
      )
      // [End SetScreenBrightnessPanGesture]

      this.VideoPlayControl();

      if (this.isShowCaptionConfig) {
        CaptionFontView({
          captionFont: this.captionFont,
          close: (captionFont: CaptionFont | null) => {
            this.closeCaptionSetting(captionFont);
          }
        })
      }
    }
    .width(CommonConstants.WIDTH_FULL_PERCENT)
    .height(CommonConstants.HEIGHT_FULL_PERCENT)
    .backgroundColor(Color.Black)
    .defaultFocus(true)
    .onKeyEvent((event?: KeyEvent) => {
      this.processKeyEvent(event);
    })
  }
}